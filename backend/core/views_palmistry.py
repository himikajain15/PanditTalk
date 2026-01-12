from rest_framework.decorators import api_view, permission_classes
from rest_framework.response import Response
from rest_framework import permissions, status
from google import genai
from google.genai import types
from dotenv import load_dotenv
from pathlib import Path
from django.conf import settings
import os
import base64
import logging

logger = logging.getLogger(__name__)

@api_view(['POST'])
@permission_classes([permissions.IsAuthenticated])
def analyze_palmistry(request):
    """
    Analyze palm photos using Google Gemini Vision API
    Expects: {'images': [{'hand': 'left', 'image': 'base64...'}, ...]}
    """
    try:
        images = request.data.get('images', [])
        if not images:
            return Response(
                {'error': 'No images provided'},
                status=status.HTTP_400_BAD_REQUEST
            )

        # Ensure .env is loaded (defensive, in case settings.py didn't run load_dotenv)
        base_dir = Path(__file__).resolve().parents[1]
        env_path = base_dir / '.env'
        if env_path.exists():
            load_dotenv(env_path)

        # Get Gemini API key from environment (after attempting to load .env)
        gemini_api_key = os.getenv('GEMINI_API_KEY')
        if not gemini_api_key:
            return Response(
                {'error': 'Gemini API key not configured. Please set GEMINI_API_KEY in your .env file'},
                status=status.HTTP_503_SERVICE_UNAVAILABLE
            )

        # Initialize Gemini client
        client = genai.Client(api_key=gemini_api_key)

        # Prepare prompt for palmistry analysis
        prompt = """You are an expert palmistry (Samudrik Shastra) reader. Analyze the palm photos provided and give a detailed reading covering:

1. **Life Line** - Length, depth, breaks, branches
2. **Heart Line** - Emotional nature, relationships, love life
3. **Head Line** - Intelligence, thinking pattern, mental abilities
4. **Fate Line** - Career, destiny, life path
5. **Mounts** - Jupiter, Saturn, Sun, Mercury, Venus, Mars, Moon
6. **Fingers** - Length, shape, phalanges analysis
7. **Overall Personality** - Strengths, weaknesses, character traits
8. **Future Predictions** - Career prospects, relationships, health, wealth

Provide a comprehensive, detailed analysis in a friendly, spiritual tone. If both hands are provided, analyze the dominant hand (right for right-handed, left for left-handed) for future predictions and the other hand for inherited traits.

Format the response in clear sections with headings."""

        # Prepare content parts for Gemini using proper types
        # Format: List of parts (text string and image Part objects)
        parts = [prompt]
        
        for img_data in images:
            hand_type = img_data.get('hand', 'unknown')
            image_base64 = img_data.get('image', '')
            
            # Remove data URL prefix if present
            if ',' in image_base64:
                image_base64 = image_base64.split(',')[1]
            
            # Decode base64 string to bytes for Blob
            try:
                image_bytes = base64.b64decode(image_base64)
            except Exception as e:
                logger.error(f"Failed to decode base64 image: {e}")
                return Response(
                    {'error': f'Invalid image format: {str(e)}'},
                    status=status.HTTP_400_BAD_REQUEST
                )
            
            # Create image part using types.Part with camelCase parameter names
            image_part = types.Part(
                inlineData=types.Blob(
                    mimeType="image/jpeg",
                    data=image_bytes
                )
            )
            parts.append(image_part)

        # Use Gemini Flash model (supports images, faster and cheaper)
        # Using gemini-2.0-flash (stable and supports vision)
        model_name = 'gemini-2.0-flash'
        
        # Generate content with images and prompt
        # Using the correct API format for google-genai
        response = client.models.generate_content(
            model=model_name,
            contents=parts,
            config=types.GenerateContentConfig(
                temperature=0.7,
                top_p=0.8,
                top_k=40,
                max_output_tokens=2000,
            )
        )

        analysis = response.text

        return Response({
            'success': True,
            'analysis': analysis,
            'hands_analyzed': [img.get('hand') for img in images]
        })

    except Exception as e:
        # Log full exception details for debugging
        import traceback
        logger.error(f"Gemini API error: {type(e).__name__}: {e}")
        logger.error(f"Traceback: {traceback.format_exc()}")
        error_msg = str(e)
        error_type = type(e).__name__
        
        # Check for quota/billing errors
        if any(keyword in error_msg.lower() for keyword in ['quota', 'billing', '429', 'resource_exhausted', 'permission_denied', '403']):
            return Response(
                {
                    'error': 'Gemini API quota exceeded or API key invalid. Please check your API key at https://aistudio.google.com/app/apikey',
                    'error_type': 'quota_exceeded',
                    'error_code': 429,
                    'debug_info': f'{error_type}: {error_msg}' if settings.DEBUG else None
                },
                status=status.HTTP_503_SERVICE_UNAVAILABLE
            )
        
        # Check for API key errors
        if 'api_key' in error_msg.lower() or 'authentication' in error_msg.lower() or '401' in error_msg or 'unauthorized' in error_msg.lower():
            return Response(
                {
                    'error': 'Invalid Gemini API key. Please set a valid GEMINI_API_KEY in your .env file',
                    'error_type': 'authentication_error',
                    'error_code': 401,
                    'debug_info': f'{error_type}: {error_msg}' if settings.DEBUG else None
                },
                status=status.HTTP_401_UNAUTHORIZED
            )
        
        return Response(
            {
                'error': f'Palmistry analysis failed: {error_msg}',
                'error_type': error_type,
                'debug_info': f'{error_type}: {error_msg}' if settings.DEBUG else None
            },
            status=status.HTTP_500_INTERNAL_SERVER_ERROR
        )

