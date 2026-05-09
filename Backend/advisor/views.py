# from django.views.decorators.csrf import csrf_exempt
# from django.views.decorators.http import require_POST
# from django.http import JsonResponse
# import json

# @csrf_exempt
# @require_POST
# def ai_recommend(request):
#     try:
#         data = json.loads(request.body or b'{}')
#     except json.JSONDecodeError:
#         return JsonResponse({'error': 'Invalid JSON payload.'}, status=400)

#     # DONE: Call Gemini API with prerequisites and interests
#     prompt = generatePrompt(data.get('completed_courses'), data.get('difficulty'), data.get('interests'))

#     response = ask_gemini(prompt)
#     # For now, return mock response
#     return JsonResponse({
#         'recommendation': response
#     })

# @csrf_exempt
# @require_POST
# def inference_recommend(request):
#     try:
#         data = json.loads(request.body or b'{}')
#     except json.JSONDecodeError:
#         return JsonResponse({'error': 'Invalid JSON payload.'}, status=400)


#     recommendationsList = logic.PrologAdvisorLogic().recommend(request)
    
#     return JsonResponse({
#         "recommendations": recommendationsList
#     })
    
#     # TODO: Call Prolog engine
#     # For now, return mock response
#     return JsonResponse({
#         'recommendations': ['Advanced Algorithms', 'Distributed Systems', 'Computer Security']
#     })

# @csrf_exempt
# def getAvailableCourses(request):
    
#     courseList = logic.PrologAdvisorLogic().getAvailableCourses()
#     return JsonResponse({
#         "availableCourses": courseList
#     })
