from rest_framework import serializers

from .models import Conversation, Message


class MessageSerializer(serializers.ModelSerializer):
    sender_name = serializers.CharField(
        source='sender.username',
        read_only=True
    )

    class Meta:
        model = Message
        fields = [
            'id',
            'sender',
            'sender_name',
            'text',
            'is_read',
            'created_at'
        ]
        read_only_fields = [
            'sender',
            'is_read',
            'created_at'
        ]


class ConversationSerializer(serializers.ModelSerializer):
    buyer_name = serializers.CharField(
        source='buyer.username',
        read_only=True
    )

    farmer_name = serializers.CharField(
        source='farmer.username',
        read_only=True
    )

    messages = MessageSerializer(
        many=True,
        read_only=True
    )

    class Meta:
        model = Conversation
        fields = [
            'id',
            'inquiry',
            'buyer',
            'buyer_name',
            'farmer',
            'farmer_name',
            'created_at',
            'messages'
        ]