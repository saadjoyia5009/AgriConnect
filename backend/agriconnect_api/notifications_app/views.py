from rest_framework import status, viewsets
from rest_framework.permissions import IsAuthenticated
from rest_framework.decorators import action
from rest_framework.response import Response

from .models import Notification
from .serializers import NotificationSerializer


class NotificationViewSet(viewsets.ReadOnlyModelViewSet):
    serializer_class = NotificationSerializer
    permission_classes = [IsAuthenticated]

    def get_queryset(self):
        return Notification.objects.filter(
            user=self.request.user
        ).order_by('-created_at')

    @action(detail=True, methods=['patch'])
    def read(self, request, pk=None):
        notification = self.get_object()

        notification.is_read = True
        notification.save()

        return Response(
            {
                "message": "Notification marked as read",
                "data": NotificationSerializer(notification).data
            },
            status=status.HTTP_200_OK
        )