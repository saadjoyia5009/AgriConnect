from django.db import models
from django.contrib.auth.models import User

from inquiries.models import Inquiry


class Conversation(models.Model):
    inquiry = models.OneToOneField(
        Inquiry,
        on_delete=models.CASCADE,
        related_name='conversation'
    )

    buyer = models.ForeignKey(
        User,
        on_delete=models.CASCADE,
        related_name='buyer_conversations'
    )

    farmer = models.ForeignKey(
        User,
        on_delete=models.CASCADE,
        related_name='farmer_conversations'
    )

    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        ordering = ['-created_at']

    def __str__(self):
        return f"Chat: {self.buyer.username} ↔ {self.farmer.username}"


class Message(models.Model):
    conversation = models.ForeignKey(
        Conversation,
        on_delete=models.CASCADE,
        related_name='messages'
    )

    sender = models.ForeignKey(
        User,
        on_delete=models.CASCADE,
        related_name='sent_messages'
    )

    text = models.TextField()

    is_read = models.BooleanField(default=False)

    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        ordering = ['created_at']

    def __str__(self):
        return f"{self.sender.username}: {self.text[:30]}"