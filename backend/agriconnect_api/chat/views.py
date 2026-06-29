from rest_framework import status, viewsets
from rest_framework.decorators import action
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response

from inquiries.models import Inquiry
from notifications_app.models import Notification
from .models import Conversation, Message
from .serializers import ConversationSerializer, MessageSerializer


class ConversationViewSet(viewsets.ModelViewSet):
    serializer_class = ConversationSerializer
    permission_classes = [IsAuthenticated]

    def get_queryset(self):
        user = self.request.user

        return Conversation.objects.filter(
            buyer=user
        ) | Conversation.objects.filter(
            farmer=user
        )

    def create(self, request, *args, **kwargs):
        inquiry_id = request.data.get('inquiry')

        try:
            inquiry = Inquiry.objects.get(
                id=inquiry_id,
                status='accepted'
            )
        except Inquiry.DoesNotExist:
            return Response(
                {"error": "Accepted inquiry not found"},
                status=status.HTTP_404_NOT_FOUND
            )

        if request.user not in [inquiry.buyer, inquiry.farmer]:
            return Response(
                {"error": "You are not allowed to create chat for this inquiry"},
                status=status.HTTP_403_FORBIDDEN
            )

        conversation, created = Conversation.objects.get_or_create(
            inquiry=inquiry,
            defaults={
                'buyer': inquiry.buyer,
                'farmer': inquiry.farmer,
            }
        )

        serializer = self.get_serializer(conversation)

        return Response(
            {
                "message": "Conversation created successfully"
                if created else
                "Conversation already exists",
                "data": serializer.data
            },
            status=status.HTTP_201_CREATED if created else status.HTTP_200_OK
        )

    @action(detail=True, methods=['get', 'post'], url_path='messages')
    def messages(self, request, pk=None):
        conversation = self.get_object()

        if request.user not in [conversation.buyer, conversation.farmer]:
            return Response(
                {"error": "You are not allowed to access this chat"},
                status=status.HTTP_403_FORBIDDEN
            )

        # GET ALL MESSAGES
        if request.method == 'GET':
            messages = conversation.messages.all()
            serializer = MessageSerializer(
                messages,
                many=True
            )

            return Response(
                serializer.data,
                status=status.HTTP_200_OK
            )

        # SEND MESSAGE
        text = request.data.get('text')

        if not text:
            return Response(
                {"error": "Message text is required"},
                status=status.HTTP_400_BAD_REQUEST
            )

        message = Message.objects.create(
            conversation=conversation,
            sender=request.user,
            text=text
        )

        receiver = (
            conversation.farmer
            if request.user == conversation.buyer
            else conversation.buyer
        )

        Notification.objects.create(
            user=receiver,
            title="New Chat Message",
            message=f"{request.user.username} sent you a message."
        )

        serializer = MessageSerializer(message)

        return Response(
            {
                "message": "Message sent successfully",
                "data": serializer.data
            },
            status=status.HTTP_201_CREATED
        )