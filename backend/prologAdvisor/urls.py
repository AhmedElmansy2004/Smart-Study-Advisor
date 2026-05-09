from django.urls import path
from . import views

# URLConfig
urlpatterns = [
    path('getCourses/', views.getAvailableCourses),
    path('recommend/', views.recommend),
    path('getInterests/', views.getAvailableInterests)
]