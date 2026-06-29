from rest_framework import serializers
from .models import Crop


class CropSerializer(serializers.ModelSerializer):

    farmer_name = serializers.CharField(
        source='farmer.username',
        read_only=True
    )

    class Meta:
        model = Crop

        fields = [
            'id',
            'farmer',
            'farmer_name',

            'name',
            'category',
            'description',

            'quantity',
            'unit',
            'price_per_unit',

            'farm_location',
            'estimated_harvest_date',

            'image',

            'status',

            'is_organic',
            'is_delivery_available',
            'is_premium_grade',

            'created_at',
            'updated_at',
        ]

        read_only_fields = [
            'id',
            'farmer',
            'created_at',
            'updated_at',
        ]