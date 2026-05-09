from django.views.decorators.csrf import csrf_exempt
from django.views.decorators.http import require_GET, require_POST
from django.http import JsonResponse
from . import Courses
from . import Interests
from . import Recommend

# Create your views here.

@csrf_exempt
@require_GET
def getAvailableCourses(request):
    print("getAvailableCourses called")
    
    courseList = Courses.Courses().getAvailableCourses()
    return JsonResponse({
        "courses": courseList
    })

@csrf_exempt
@require_GET
def getAvailableInterests(request):
    print("getAvailableInterests called")
    
    interestsList = Interests.Interests().getAvailableInterests()
    print(interestsList)
    return JsonResponse({
        "interests": interestsList
    })

@csrf_exempt
@require_POST
def recommend(request):
    print("recommend called")
    
    recommendationsList = Recommend.Recommend().recommend(request)
    
    return JsonResponse({
        "recommendations": recommendationsList
    })