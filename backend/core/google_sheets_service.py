"""
Google Sheets integration service to sync Pandit data from Google Sheets.
This service reads Pandit information from a Google Sheet and syncs it to the database.
"""
import os
import logging
from typing import List, Dict, Optional
from django.conf import settings

logger = logging.getLogger(__name__)

try:
    import gspread
    from google.oauth2.service_account import Credentials
    GSPREAD_AVAILABLE = True
except ImportError:
    GSPREAD_AVAILABLE = False
    logger.warning("gspread not available. Google Sheets integration will be disabled.")


class GoogleSheetsService:
    """Service to fetch and sync Pandit data from Google Sheets"""
    
    def __init__(self):
        from django.conf import settings
        # Extract sheet ID from URL or use direct ID
        sheet_id_env = getattr(settings, 'GOOGLE_SHEET_ID', None) or os.getenv('GOOGLE_SHEET_ID', '')
        if '/spreadsheets/d/' in sheet_id_env:
            # Extract ID from full URL
            self.sheet_id = sheet_id_env.split('/spreadsheets/d/')[1].split('/')[0]
        else:
            self.sheet_id = sheet_id_env or '1L06nvUh8LT6yvDqrX1HGN6-a62KzrRBKzHoal-LdZqY'  # Default to provided sheet
        self.worksheet_name = getattr(settings, 'GOOGLE_WORKSHEET_NAME', None) or os.getenv('GOOGLE_WORKSHEET_NAME', 'Sheet1')
        self.credentials_json = getattr(settings, 'GOOGLE_CREDENTIALS_JSON', None) or os.getenv('GOOGLE_CREDENTIALS_JSON', '')
        self.client = None
        
        if GSPREAD_AVAILABLE and self.sheet_id:
            self._initialize_client()
    
    def _initialize_client(self):
        """Initialize Google Sheets client using service account credentials"""
        try:
            if self.credentials_json:
                # Parse JSON string or file path
                import json
                if os.path.exists(self.credentials_json):
                    with open(self.credentials_json, 'r') as f:
                        creds_dict = json.load(f)
                else:
                    creds_dict = json.loads(self.credentials_json)
                
                scopes = ['https://www.googleapis.com/auth/spreadsheets.readonly']
                creds = Credentials.from_service_account_info(creds_dict, scopes=scopes)
                self.client = gspread.authorize(creds)
                logger.info("Google Sheets client initialized successfully")
            else:
                logger.warning("GOOGLE_CREDENTIALS_JSON not set. Google Sheets integration disabled.")
        except Exception as e:
            logger.error(f"Failed to initialize Google Sheets client: {e}")
            self.client = None
    
    def fetch_pandits_from_sheet(self) -> List[Dict]:
        """
        Fetch all Pandit data from Google Sheet.
        Expected columns: Name, Phone, Email, Languages, Expertise, Experience Years, Fee Per Minute, Rating
        
        Returns:
            List of dictionaries with Pandit data
        """
        if not self.client or not self.sheet_id:
            logger.warning("Google Sheets client not initialized")
            return []
        
        try:
            spreadsheet = self.client.open_by_key(self.sheet_id)
            try:
                worksheet = spreadsheet.worksheet(self.worksheet_name)
            except gspread.exceptions.WorksheetNotFound:
                # Try first sheet if named sheet doesn't exist
                worksheet = spreadsheet.sheet1
            
            # Get all records (assuming first row is header)
            records = worksheet.get_all_records()
            
            pandits = []
            for row in records:
                try:
                    # Flexible column name matching (case-insensitive, handles variations)
                    def get_value(key_variations, default=''):
                        for key in key_variations:
                            for col_key in row.keys():
                                if col_key.lower().strip() == key.lower().strip():
                                    value = row.get(col_key, default)
                                    return value if value is not None else default
                        return default
                    
                    pandit_data = {
                        'name': str(get_value(['Name', 'name', 'Full Name', 'full name', 'Pandit Name'], '')).strip(),
                        'phone': str(get_value(['Phone', 'phone', 'Phone Number', 'Mobile', 'mobile', 'Contact'], '')).strip(),
                        'email': str(get_value(['Email', 'email', 'E-mail', 'Email Address'], '')).strip(),
                        'languages': self._parse_languages(get_value(['Languages', 'languages', 'Language', 'language', 'Known Languages'], '')),
                        'expertise': str(get_value(['Expertise', 'expertise', 'Specialization', 'Skills', 'Services'], '')).strip(),
                        'experience_years': self._parse_int(get_value(['Experience Years', 'experience years', 'Experience', 'Years of Experience', 'YOE'], 0)),
                        'fee_per_minute': self._parse_float(get_value(['Fee Per Minute', 'fee per minute', 'Fee/Min', 'Rate', 'Price Per Minute'], 0)),
                        'rating': self._parse_float(get_value(['Rating', 'rating', 'Star Rating', 'Stars'], 0)),
                        'is_online': str(get_value(['Is Online', 'is online', 'Online', 'online', 'Status'], '')).lower() in ('true', 'yes', '1', 'online', 'available'),
                    }
                    
                    # Only add if has at least name or phone or email
                    if pandit_data['name'] or pandit_data['phone'] or pandit_data['email']:
                        pandits.append(pandit_data)
                except Exception as e:
                    logger.error(f"Error parsing row {row}: {e}")
                    continue
            
            logger.info(f"Fetched {len(pandits)} pandits from Google Sheet")
            return pandits
            
        except Exception as e:
            logger.error(f"Error fetching data from Google Sheet: {e}")
            return []
    
    def _parse_languages(self, languages_str: str) -> List[str]:
        """Parse languages string (comma-separated) into list"""
        if not languages_str:
            return []
        return [lang.strip() for lang in str(languages_str).split(',') if lang.strip()]
    
    def _parse_int(self, value) -> int:
        """Parse value to integer"""
        try:
            if isinstance(value, str):
                return int(float(value))
            return int(value)
        except (ValueError, TypeError):
            return 0
    
    def _parse_float(self, value) -> float:
        """Parse value to float"""
        try:
            if isinstance(value, str):
                return float(value.replace(',', '').replace('₹', '').replace('$', '').strip())
            return float(value)
        except (ValueError, TypeError):
            return 0.0
    
    @property
    def sheet_name(self) -> str:
        """Get worksheet name"""
        return self.worksheet_name
    
    def is_available(self) -> bool:
        """Check if Google Sheets integration is available"""
        return self.client is not None and bool(self.sheet_id)

