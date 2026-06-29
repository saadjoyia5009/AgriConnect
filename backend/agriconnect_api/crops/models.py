from django.db import models
from django.contrib.auth.models import User


class Crop(models.Model):
    STATUS_CHOICES = (
        ('active', 'Active'),
        ('sold_out', 'Sold Out'),
        ('draft', 'Draft'),
    )

    CATEGORY_CHOICES = (
        ('vegetables', 'Vegetables'),
        ('fruits', 'Fruits'),
        ('grains', 'Grains'),
        ('pulses', 'Pulses'),
        ('cotton', 'Cotton'),
        ('sugarcane', 'Sugarcane'),
        ('other', 'Other'),
    )

    UNIT_CHOICES = (
        ('kg', 'Kg'),
        ('ton', 'Ton'),
        ('box', 'Box'),
        ('bundle', 'Bundle'),
        ('bag', 'Bag'),
    )

    farmer = models.ForeignKey(
        User,
        on_delete=models.CASCADE,
        related_name='crops'
    )

    name = models.CharField(max_length=120)
    category = models.CharField(max_length=30, choices=CATEGORY_CHOICES)
    description = models.TextField(blank=True, null=True)

    quantity = models.DecimalField(max_digits=10, decimal_places=2)
    unit = models.CharField(max_length=20, choices=UNIT_CHOICES, default='kg')
    price_per_unit = models.DecimalField(max_digits=10, decimal_places=2)

    farm_location = models.CharField(max_length=255)
    estimated_harvest_date = models.DateField(blank=True, null=True)

    image = models.ImageField(upload_to='crops/', blank=True, null=True)

    status = models.CharField(max_length=20, choices=STATUS_CHOICES, default='active')

    is_organic = models.BooleanField(default=False)
    is_delivery_available = models.BooleanField(default=False)
    is_premium_grade = models.BooleanField(default=False)

    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        ordering = ['-created_at']

    def __str__(self):
        return f"{self.name} - {self.farmer.username}"