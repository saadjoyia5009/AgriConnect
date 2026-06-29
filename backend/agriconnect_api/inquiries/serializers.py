from rest_framework import serializers
from .models import Inquiry


class InquirySerializer(serializers.ModelSerializer):

    crop_name = serializers.CharField(
        source='crop.name',
        read_only=True
    )

    buyer_name = serializers.CharField(
        source='buyer.username',
        read_only=True
    )

    farmer_name = serializers.CharField(
        source='farmer.username',
        read_only=True
    )

    class Meta:
        model = Inquiry

        fields = [
            'id',

            'crop',
            'crop_name',

            'buyer',
            'buyer_name',

            'farmer',
            'farmer_name',

            'message',
            'offered_price',
            'quantity_requested',
            'status',

            'created_at',
            'updated_at',
        ]

        read_only_fields = [
            'id',
            'buyer',
            'farmer',
            'status',
            'created_at',
            'updated_at',
        ]