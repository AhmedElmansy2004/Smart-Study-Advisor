from django.shortcuts import render
from django.views.decorators.csrf import csrf_exempt
from django.views.decorators.http import require_POST
from django.http import JsonResponse
import json
from .service import ask_gemini

@csrf_exempt
@require_POST
def Chatbot_view(request):
    try:
        data = json.loads(request.body or b'{}')
    except json.JSONDecodeError:
        return JsonResponse({'error': 'Invalid JSON payload.'}, status=400)

    # DONE: Call Gemini API with prerequisites and interests
    prompt = generatePrompt(data.get('completed_courses'), data.get('difficulty'), data.get('interests'))

    response = ask_gemini(prompt)
    # For now, return mock response
    return JsonResponse({
        'recommendation': response
    })

def generatePrompt(prerequisites, difficulty, interests):
    prompt = "You are a study advisor. Based on the following prerequisites and difficulty level and interests, recommend a study path:\n"
    prompt += f"Prerequisites: {', '.join(prerequisites)}\n"
    prompt += f"Difficulty: {difficulty}\n"
    prompt += f"Interests: {', '.join(interests)}\n"
    prompt += "Provide a recommendation for the next steps in their learning journey.\n Limit the response to 2-3 sentences."
    return prompt