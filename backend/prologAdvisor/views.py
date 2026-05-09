from django.shortcuts import render
from django.http import HttpResponse
from pyswip import Prolog
import os
import json

# Create your views here.

'''
requests are expected to be on that format

{
    student_name:           --> string
    completed_courses: [],  --> list of strings
    interests:               --> list of strings
    difficulty:             --> integer
}
'''
def recommend(request):
    
    BASE_DIR = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
    PROLOG_FILE = os.path.join(BASE_DIR, 'prolog', 'knowledgeBase.pl')
    
    data = json.loads(request.body)
    studentName = data['student_name']
    completedCourses = data['completed_courses']
    interests = data['interests']
    difficulty = data['difficulty']
    
    prolog = Prolog()
    prolog.consult(PROLOG_FILE)
    
    # insert student completed courses
    for course in completedCourses:
        prolog.assertz(f"student_completed({studentName}, {course}).")
     
    # insert student intersets
    for interest in interests:
        prolog.assertz(f"student_interest({studentName}, {interest}).")  
        
    recommendations = list(prolog.query(f"recommend({studentName}, X, {difficulty})"))
    
    recommendationsList = [rec['X'] for rec in recommendations]
    
    return render(request, 'prologAdvisor.html', {'recommendations': recommendationsList})
    