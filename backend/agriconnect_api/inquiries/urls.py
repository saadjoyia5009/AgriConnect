from django.urls import path, include
from rest_framework.routers import DefaultRouter

from .views import InquiryViewSet

router = DefaultRouter()
router.register('', InquiryViewSet, basename='inquiries')

urlpatterns = [
    path('', include(router.urls)),
]