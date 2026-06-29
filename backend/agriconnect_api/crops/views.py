from rest_framework import status, viewsets
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response
from rest_framework.parsers import MultiPartParser, FormParser, JSONParser
from rest_framework.decorators import action

from .models import Crop
from .serializers import CropSerializer


class CropViewSet(viewsets.ModelViewSet):
    serializer_class = CropSerializer
    permission_classes = [IsAuthenticated]
    parser_classes = [MultiPartParser, FormParser, JSONParser]

    def get_queryset(self):
        user = self.request.user

        if hasattr(user, 'profile') and user.profile.role == 'farmer':
            return Crop.objects.filter(farmer=user)

        return Crop.objects.none()

    def create(self, request, *args, **kwargs):
        if not hasattr(request.user, 'profile') or request.user.profile.role != 'farmer':
            return Response(
                {"error": "Only farmers can add crops"},
                status=status.HTTP_403_FORBIDDEN
            )

        serializer = self.get_serializer(data=request.data)

        if serializer.is_valid():
            serializer.save(farmer=request.user)
            return Response(
                {
                    "message": "Crop added successfully",
                    "data": serializer.data
                },
                status=status.HTTP_201_CREATED
            )

        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    def update(self, request, *args, **kwargs):
        if not hasattr(request.user, 'profile') or request.user.profile.role != 'farmer':
            return Response(
                {"error": "Only farmers can update crops"},
                status=status.HTTP_403_FORBIDDEN
            )

        partial = kwargs.pop('partial', False)
        instance = self.get_object()

        serializer = self.get_serializer(
            instance,
            data=request.data,
            partial=partial
        )

        if serializer.is_valid():
            serializer.save(farmer=request.user)
            return Response(
                {
                    "message": "Crop updated successfully",
                    "data": serializer.data
                },
                status=status.HTTP_200_OK
            )

        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    def destroy(self, request, *args, **kwargs):
        if not hasattr(request.user, 'profile') or request.user.profile.role != 'farmer':
            return Response(
                {"error": "Only farmers can delete crops"},
                status=status.HTTP_403_FORBIDDEN
            )

        crop = self.get_object()
        crop.delete()

        return Response(
            {"message": "Crop deleted successfully"},
            status=status.HTTP_200_OK
        )

    @action(detail=False, methods=['get'], url_path='marketplace')
    def marketplace(self, request):
        crops = Crop.objects.filter(status='active').order_by('-created_at')
        serializer = self.get_serializer(crops, many=True)

        return Response(
            {
                "message": "Marketplace crops fetched successfully",
                "data": serializer.data
            },
            status=status.HTTP_200_OK
        )