"""
URL configuration for the advisor app.
"""

from django.urls import path

from . import views

app_name = 'advisor'
''' routes '''
urlpatterns = [
    path('hello-world', views.index, name='index'),
]