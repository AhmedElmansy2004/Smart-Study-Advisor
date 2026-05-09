from django.shortcuts import render
from django.http import HttpResponse
from django.views.decorators.csrf import csrf_exempt
from django.http import JsonResponse
from . import logic

# Create your views here.

@csrf_exempt
def getAvailableCourses(request):
    
    courseList = logic.PrologAdvisorLogic().getAvailableCourses()
    return JsonResponse({
        "availableCourses": courseList
    })

@csrf_exempt
def recommend(request):
    
    recommendationsList = logic.PrologAdvisorLogic().recommend(request)
    
    return JsonResponse({
        "recommendations": recommendationsList
    })
    

# @csrf_exempt
# def getAvailableCourses(request):
    
#     BASE_DIR = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
#     PROLOG_FILE = os.path.join(BASE_DIR, 'prolog', 'knowledgeBase.pl')
    
    
#     prolog = Prolog()
#     prolog.consult(PROLOG_FILE)
    
#     availableCourses = list(prolog.query(f"course(X)"))
#     courseList = [course['X'] for course in availableCourses]
    
#     return JsonResponse({
#         "availableCourses": courseList
#     })

# @csrf_exempt
# def recommend(request):
    
#     BASE_DIR = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
#     PROLOG_FILE = os.path.join(BASE_DIR, 'prolog', 'knowledgeBase.pl')
    
#     data = json.loads(request.body)
#     completedCourses = data['completed_courses']
#     interests = data['interests']
#     difficulty = data['difficulty']
    
#     prolog = Prolog()
#     prolog.consult(PROLOG_FILE)
    
#     # insert student completed courses
#     for course in completedCourses:
#         fact = f"student_completed({course})"
#         if not list(prolog.query(fact)):
#             prolog.assertz(fact)
     
#     # insert student intersets
#     for interest in interests:
#         fact = f"student_interest({interest})"
#         if not list(prolog.query(fact)):
#             prolog.assertz(fact)  
        
#     recommendations = list(prolog.query(f"recommend_by_difficulty(X, {difficulty})"))
    
#     recommendationsList = [rec['X'] for rec in recommendations]
    
#     return JsonResponse({
#         "recommendations": recommendationsList
#     })
    