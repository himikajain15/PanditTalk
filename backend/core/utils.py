"""
Utility functions used by core app.
Keep these stateless and safe to import anywhere.
"""

from decimal import Decimal

def calculate_booking_amount(duration_minutes: int, fee_per_minute) -> Decimal:
    """
    Returns total amount for a booking.
    fee_per_minute can be Decimal, float or string; result is Decimal with 2 decimal places.
    """
    fee = Decimal(str(fee_per_minute))
    total = fee * Decimal(duration_minutes)
    # Normalize to 2 decimal places
    return total.quantize(Decimal('0.01'))
