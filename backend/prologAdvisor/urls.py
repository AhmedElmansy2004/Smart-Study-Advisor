from django.urls import path
from . import views

# URLConfig
urlpatterns = [
    path('recommend/', views.recommend)
]