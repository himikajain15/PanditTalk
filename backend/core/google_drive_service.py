import os
import io
import json
import base64
import logging
from typing import Optional, Dict

from django.conf import settings

logger = logging.getLogger(__name__)

try:
    from google.oauth2.service_account import Credentials
    from googleapiclient.discovery import build
    from googleapiclient.http import MediaIoBaseUpload
    GOOGLE_DRIVE_AVAILABLE = True
except ImportError:
    GOOGLE_DRIVE_AVAILABLE = False
    logger.warning("google-api-python-client not installed. Drive upload disabled.")


def _load_drive_credentials(scopes):
    credentials_json = getattr(settings, 'GOOGLE_CREDENTIALS_JSON', None) or os.getenv('GOOGLE_CREDENTIALS_JSON', '')
    if not credentials_json:
        return None

    if os.path.exists(credentials_json):
        with open(credentials_json, 'r') as f:
            creds_dict = json.load(f)
    else:
        creds_dict = json.loads(credentials_json)

    return Credentials.from_service_account_info(creds_dict, scopes=scopes)


def _ensure_folder(service, folder_id: str, folder_name: str) -> Optional[str]:
    """
    Verify folder exists and is accessible.
    Note: Service accounts can't create folders in their own Drive.
    You must create a folder in your personal Drive and share it with the service account.
    """
    if folder_id:
        # Verify the folder exists and is accessible
        try:
            folder = service.files().get(fileId=folder_id, fields='id, name').execute()
            return folder_id
        except Exception as e:
            logger.error(f"Folder {folder_id} not accessible: {e}")
            return None
    
    # Try to find existing folder (only works if folder is shared with service account)
    query = f"mimeType='application/vnd.google-apps.folder' and trashed=false and name='{folder_name}'"
    try:
        results = service.files().list(q=query, spaces='drive', fields='files(id, name)', pageSize=1).execute()
        folders = results.get('files', [])
        if folders:
            return folders[0]['id']
    except Exception as e:
        logger.warning(f"Could not search for folder: {e}")
    
    # Cannot create folder - service accounts don't have storage quota
    logger.error(f"Folder ID not provided and folder '{folder_name}' not found. Please create a folder in your personal Drive and share it with the service account.")
    return None


def upload_base64_to_drive(filename: str, base64_string: str, folder_name: str = 'PanditTalk Uploads') -> Optional[Dict]:
    """
    Upload a base64 encoded file to Google Drive and return shareable links.
    """
    if not GOOGLE_DRIVE_AVAILABLE:
        return None

    try:
        scopes = ['https://www.googleapis.com/auth/drive']
        creds = _load_drive_credentials(scopes)
        if not creds:
            logger.warning("Drive credentials not configured.")
            return None

        service = build('drive', 'v3', credentials=creds, cache_discovery=False)

        if ',' in base64_string:
            header, encoded = base64_string.split(',', 1)
            mime_type = header.split(';')[0].split(':')[1]
        else:
            encoded = base64_string
            mime_type = None

        file_bytes = base64.b64decode(encoded)
        buffer = io.BytesIO(file_bytes)
        media = MediaIoBaseUpload(buffer, mimetype=mime_type or 'application/octet-stream', resumable=False)

        folder_id = getattr(settings, 'GOOGLE_DRIVE_FOLDER_ID', None) or os.getenv('GOOGLE_DRIVE_FOLDER_ID', '')
        folder_id = _ensure_folder(service, folder_id, folder_name)

        file_metadata = {'name': filename}
        if folder_id:
            file_metadata['parents'] = [folder_id]

        file = service.files().create(
            body=file_metadata,
            media_body=media,
            fields='id, webViewLink, webContentLink',
        ).execute()

        file_id = file.get('id')

        # Make the file accessible via link
        try:
            service.permissions().create(
                fileId=file_id,
                body={'type': 'anyone', 'role': 'reader'},
                fields='id'
            ).execute()
        except Exception as perm_error:
            logger.warning(f"Failed to set Drive file permission: {perm_error}")

        view_url = f"https://drive.google.com/uc?export=view&id={file_id}"
        download_url = f"https://drive.google.com/uc?export=download&id={file_id}"

        return {
            'file_id': file_id,
            'view_url': view_url,
            'download_url': download_url,
            'web_view_link': file.get('webViewLink'),
            'web_content_link': file.get('webContentLink'),
            'mime_type': mime_type or 'application/octet-stream',
        }
    except Exception as e:
        logger.error(f"Failed to upload file to Google Drive: {e}")
        return None

