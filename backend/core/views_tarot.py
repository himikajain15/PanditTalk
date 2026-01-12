from rest_framework.decorators import api_view, permission_classes
from rest_framework.response import Response
from rest_framework import permissions, status
from google import genai
from google.genai import types
from dotenv import load_dotenv
from pathlib import Path
from django.conf import settings
import os
import logging

logger = logging.getLogger(__name__)

@api_view(['POST'])
@permission_classes([permissions.IsAuthenticated])
def interpret_tarot(request):
    """
    Interpret tarot cards using Google Gemini API
    Expects: {
        'spread_type': 'single' | 'three_card' | 'celtic_cross',
        'cards': [
            {
                'name': 'The Fool',
                'suit': 'Major Arcana',
                'number': None,
                'is_reversed': False,
                'meaning': '...'
            },
            ...
        ]
    }
    """
    try:
        spread_type = request.data.get('spread_type', 'single')
        cards = request.data.get('cards', [])
        
        if not cards:
            return Response(
                {'error': 'No cards provided'},
                status=status.HTTP_400_BAD_REQUEST
            )

        # Ensure .env is loaded
        base_dir = Path(__file__).resolve().parents[1]
        env_path = base_dir / '.env'
        if env_path.exists():
            load_dotenv(env_path)

        # Get Gemini API key
        gemini_api_key = os.getenv('GEMINI_API_KEY')
        if not gemini_api_key:
            return Response(
                {'error': 'Gemini API key not configured. Please set GEMINI_API_KEY in your .env file'},
                status=status.HTTP_503_SERVICE_UNAVAILABLE
            )

        # Initialize Gemini client
        client = genai.Client(api_key=gemini_api_key)

        # Build prompt based on spread type
        if spread_type == 'single':
            prompt = f"""You are an expert tarot card reader. Provide a detailed, insightful interpretation for this single card reading:

**Card Drawn:** {cards[0]['name']} {'(Reversed)' if cards[0].get('is_reversed') else ''}
**Suit:** {cards[0].get('suit', 'Unknown')}
**Basic Meaning:** {cards[0].get('meaning', '')}

Provide a comprehensive interpretation that includes:
1. **Overall Message** - What this card is telling the querent right now
2. **Current Situation** - How this card reflects their current circumstances
3. **Guidance** - Practical advice and what actions to take
4. **Timing** - When this energy is most active
5. **Personal Reflection** - Questions to ponder or areas to focus on

Write in a warm, spiritual, and encouraging tone. Make it personal and actionable. Keep it between 200-300 words."""
        
        elif spread_type == 'three_card':
            prompt = f"""You are an expert tarot card reader. Provide a detailed, insightful interpretation for this three-card spread (Past, Present, Future):

**Past Card:** {cards[0]['name']} {'(Reversed)' if cards[0].get('is_reversed') else ''}
- Meaning: {cards[0].get('meaning', '')}

**Present Card:** {cards[1]['name']} {'(Reversed)' if cards[1].get('is_reversed') else ''}
- Meaning: {cards[1].get('meaning', '')}

**Future Card:** {cards[2]['name']} {'(Reversed)' if cards[2].get('is_reversed') else ''}
- Meaning: {cards[2].get('meaning', '')}

Provide a comprehensive interpretation that:
1. **Analyzes Each Position** - What each card means in its position
2. **Connects the Story** - How the cards flow from past through present to future
3. **Identifies Patterns** - Common themes or energies across the cards
4. **Offers Guidance** - What the querent should focus on or be aware of
5. **Timeline Insights** - How these energies manifest over time

Write in a warm, spiritual, and encouraging tone. Make it personal and actionable. Keep it between 400-500 words."""
        
        else:  # celtic_cross
            # Build a human-readable summary of the first 10 cards
            positions_lines = []
            for i, card in enumerate(cards[:10]):
                name = card.get('name', 'Unknown')
                is_reversed = card.get('is_reversed')
                meaning = card.get('meaning', '')
                pos_num = i + 1
                reversed_text = '(Reversed)' if is_reversed else ''
                positions_lines.append(
                    f"Position {pos_num}: {name} {reversed_text} - {meaning}"
                )
            positions_text = "\n".join(positions_lines)

            prompt = (
                "You are an expert tarot card reader. Provide a detailed, insightful "
                "interpretation for this Celtic Cross spread:\n\n"
                f"{positions_text}\n\n"
                "Provide a comprehensive interpretation that:\n"
                "1. **Overall Theme** - The central message of this reading\n"
                "2. **Card Relationships** - How the cards interact and influence each other\n"
                "3. **Current Situation** - What's happening in the querent's life right now\n"
                "4. **Challenges & Opportunities** - Obstacles to overcome and paths forward\n"
                "5. **Outcome** - Where this situation is heading\n"
                "6. **Actionable Guidance** - Specific steps the querent should take\n\n"
                "Write in a warm, spiritual, and encouraging tone. Make it personal and actionable. "
                "Keep it between 600-800 words."
            )

        # Generate interpretation using Gemini
        model_name = 'gemini-2.0-flash'
        
        response = client.models.generate_content(
            model=model_name,
            contents=[prompt],
            config=types.GenerateContentConfig(
                temperature=0.8,
                top_p=0.9,
                top_k=40,
                max_output_tokens=2000,
            )
        )

        interpretation = response.text

        return Response({
            'success': True,
            'interpretation': interpretation,
            'spread_type': spread_type,
            'cards_count': len(cards)
        })

    except Exception as e:
        import traceback
        logger.error(f"Tarot interpretation error: {type(e).__name__}: {e}")
        logger.error(f"Traceback: {traceback.format_exc()}")
        error_msg = str(e)
        error_type = type(e).__name__
        
        # Check for quota/billing errors
        if any(keyword in error_msg.lower() for keyword in ['quota', 'billing', '429', 'resource_exhausted', 'permission_denied', '403']):
            return Response(
                {
                    'error': 'Gemini API quota exceeded or API key invalid. Please check your API key.',
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
                'error': f'Tarot interpretation failed: {error_msg}',
                'error_type': error_type,
                'debug_info': f'{error_type}: {error_msg}' if settings.DEBUG else None
            },
            status=status.HTTP_500_INTERNAL_SERVER_ERROR
        )

