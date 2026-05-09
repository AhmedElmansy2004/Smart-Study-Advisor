"""
URL configuration for the advisor app.
"""

from django.urls import path

from . import views

app_name = 'advisor'
''' routes '''

urlpatterns = [
    path('ai-recommend/', views.ai_recommend, name='ai_recommend'),
    path('inference-recommend/', views.inference_recommend, name='inference_recommend'),
]