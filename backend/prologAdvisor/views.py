from django.views.decorators.csrf import csrf_exempt
from django.views.decorators.http import require_GET, require_POST
from django.http import JsonResponse
from . import logic

# Create your views here.

@csrf_exempt
@require_GET
def getAvailableCourses(request):
    
    courseList = logic.PrologAdvisorLogic().getAvailableCourses()
    return JsonResponse({
        "courses": courseList
    })

@csrf_exempt
@require_GET
def getAvailableInterests(request):
    
    interestsList = logic.PrologAdvisorLogic().getAvailableInterests()
    print(interestsList)
    return JsonResponse({
        "interests": interestsList
    })

@csrf_exempt
@require_POST
def recommend(request):
    
    recommendationsList = logic.PrologAdvisorLogic().recommend(request)
    print(recommendationsList)
    return JsonResponse({
        "recommendations": recommendationsList
    })