from django.db import models

class Horoscope(models.Model):
    zodiac_sign = models.CharField(max_length=30)
    date = models.DateField()
    prediction = models.TextField()

    def __str__(self):
        return f"{self.zodiac_sign} - {self.date}"
