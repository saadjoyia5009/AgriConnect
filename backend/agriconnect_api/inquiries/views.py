from rest_framework import status, viewsets
from rest_framework.decorators import action
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response

from crops.models import Crop
from notifications_app.models import Notification
from .models import Inquiry
from .serializers import InquirySerializer


class InquiryViewSet(viewsets.ModelViewSet):
    serializer_class = InquirySerializer
    permission_classes = [IsAuthenticated]

    def get_queryset(self):
        user = self.request.user

        if hasattr(user, 'profile') and user.profile.role == 'farmer':
            return Inquiry.objects.filter(farmer=user)

        if hasattr(user, 'profile') and user.profile.role == 'buyer':
            return Inquiry.objects.filter(buyer=user)

        return Inquiry.objects.none()

    def create(self, request, *args, **kwargs):
        if not hasattr(request.user, 'profile') or request.user.profile.role != 'buyer':
            return Response(
                {"error": "Only buyers can send inquiries"},
                status=status.HTTP_403_FORBIDDEN
            )

        crop_id = request.data.get('crop')

        try:
            crop = Crop.objects.get(id=crop_id, status='active')
        except Crop.DoesNotExist:
            return Response(
                {"error": "Crop not found or not active"},
                status=status.HTTP_404_NOT_FOUND
            )

        serializer = self.get_serializer(data=request.data)

        if serializer.is_valid():
            inquiry = serializer.save(
                buyer=request.user,
                farmer=crop.farmer,
                crop=crop
            )

            Notification.objects.create(
                user=crop.farmer,
                title="New Inquiry Received",
                message=f"{request.user.username} sent an inquiry for {crop.name}."
            )

            return Response(
                {
                    "message": "Inquiry sent successfully",
                    "data": self.get_serializer(inquiry).data
                },
                status=status.HTTP_201_CREATED
            )

        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    @action(detail=True, methods=['patch'], url_path='accept')
    def accept_inquiry(self, request, pk=None):
        inquiry = self.get_object()

        if request.user != inquiry.farmer:
            return Response(
                {"error": "Only crop farmer can accept this inquiry"},
                status=status.HTTP_403_FORBIDDEN
            )

        inquiry.status = 'accepted'
        inquiry.save()

        Notification.objects.create(
            user=inquiry.buyer,
            title="Inquiry Accepted",
            message=f"Your inquiry for {inquiry.crop.name} was accepted."
        )

        serializer = self.get_serializer(inquiry)

        return Response(
            {
                "message": "Inquiry accepted successfully",
                "data": serializer.data
            },
            status=status.HTTP_200_OK
        )

    @action(detail=True, methods=['patch'], url_path='reject')
    def reject_inquiry(self, request, pk=None):
        inquiry = self.get_object()

        if request.user != inquiry.farmer:
            return Response(
                {"error": "Only crop farmer can reject this inquiry"},
                status=status.HTTP_403_FORBIDDEN
            )

        inquiry.status = 'rejected'
        inquiry.save()

        Notification.objects.create(
            user=inquiry.buyer,
            title="Inquiry Rejected",
            message=f"Your inquiry for {inquiry.crop.name} was rejected."
        )

        serializer = self.get_serializer(inquiry)

        return Response(
            {
                "message": "Inquiry rejected successfully",
                "data": serializer.data
            },
            status=status.HTTP_200_OK
        )