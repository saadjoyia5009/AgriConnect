from django.contrib import admin
from .models import Crop


@admin.register(Crop)
class CropAdmin(admin.ModelAdmin):
    list_display = (
        'id',
        'name',
        'farmer',
        'category',
        'quantity',
        'unit',
        'price_per_unit',
        'status',
        'created_at',
    )

    list_filter = (
        'category',
        'status',
        'is_organic',
        'is_delivery_available',
        'is_premium_grade',
    )

    search_fields = (
        'name',
        'farmer__username',
        'farmer__email',
        'farm_location',
    )