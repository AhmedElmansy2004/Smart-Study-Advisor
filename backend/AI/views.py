from django.shortcuts import render
from .service import ask_gemini

def Chatbot_view(request):
    response = None
    
    if request.method == "POST":
        user_input = request.POST.get('user_input')
        response = ask_gemini(user_input)
        
    return render(request, 'chatbot.html', {'response' : response})
    
    