from django.urls import path
from . import views

# URLConfig
urlpatterns = [
    path('chatbot/', views.Chatbot_view)
]