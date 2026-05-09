from django.views.decorators.csrf import csrf_exempt
from django.views.decorators.http import require_POST
from django.http import JsonResponse
import json

@csrf_exempt
@require_POST
def ai_recommend(request):
    try:
        data = json.loads(request.body or b'{}')
    except json.JSONDecodeError:
        return JsonResponse({'error': 'Invalid JSON payload.'}, status=400)

    # TODO: Call Gemini API with prerequisites and interests
    prompt = generatePrompt(data.get('completed_courses'), data.get('interests'))
    # For now, return mock response
    return JsonResponse({
        'recommendation': f'Based on your prerequisites {data.get("completed_courses")} and interests {data.get("interests")}, I recommend focusing on advanced courses...'
    })

@csrf_exempt
@require_POST
def inference_recommend(request):
    try:
        data = json.loads(request.body or b'{}')
    except json.JSONDecodeError:
        return JsonResponse({'error': 'Invalid JSON payload.'}, status=400)

    
    # TODO: Call Prolog engine
    # For now, return mock response
    return JsonResponse({
        'recommendations': ['Advanced Algorithms', 'Distributed Systems', 'Computer Security']
    })



def generatePrompt(prerequisites, interests):
    prompt = "You are a study advisor. Based on the following prerequisites and interests, recommend a study path:\n"
    prompt += f"Prerequisites: {', '.join(prerequisites)}\n"
    prompt += f"Interests: {', '.join(interests)}\n"
    prompt += "Provide a recommendation for the next steps in their learning journey.\n Limit the response to 2-3 sentences."
    return prompt