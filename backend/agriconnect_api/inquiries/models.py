from django.db import models
from django.contrib.auth.models import User

from crops.models import Crop


class Inquiry(models.Model):

    STATUS_CHOICES = (
        ('pending', 'Pending'),
        ('accepted', 'Accepted'),
        ('rejected', 'Rejected'),
        ('completed', 'Completed'),
    )

    crop = models.ForeignKey(
        Crop,
        on_delete=models.CASCADE,
        related_name='inquiries'
    )

    buyer = models.ForeignKey(
        User,
        on_delete=models.CASCADE,
        related_name='buyer_inquiries'
    )

    farmer = models.ForeignKey(
        User,
        on_delete=models.CASCADE,
        related_name='farmer_inquiries'
    )

    message = models.TextField()

    offered_price = models.DecimalField(
        max_digits=10,
        decimal_places=2,
        blank=True,
        null=True
    )

    quantity_requested = models.DecimalField(
        max_digits=10,
        decimal_places=2,
        blank=True,
        null=True
    )

    status = models.CharField(
        max_length=20,
        choices=STATUS_CHOICES,
        default='pending'
    )

    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        ordering = ['-created_at']

    def __str__(self):
        return f"{self.buyer.username} -> {self.crop.name}"