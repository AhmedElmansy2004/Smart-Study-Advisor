from django.shortcuts import render
from django.http import HttpResponse
from django.http import JsonResponse

    

def index(request):
    return JsonResponse({
        'student_name': 'John Doe',
        'recommended_courses': ['AI', 'Operation Research', 'DSA']
    })