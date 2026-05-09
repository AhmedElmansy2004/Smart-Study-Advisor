from pyswip import Prolog
import os
import json

class PrologAdvisorLogic:
    
    BASE_DIR = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
    PROLOG_FILE = os.path.join(BASE_DIR, 'prolog', 'knowledgeBase.pl')


    def getAvailableInterests(self):
        
        prolog = Prolog()
        prolog.consult(self.PROLOG_FILE)
        
        # interest_match(math_science, mth211).
        
        availableInterests = list(prolog.query(f"interest_match(X, _)"))
        interestList = list(map(lambda interest: interest['X'], availableInterests))
        
        return interestList
    
    
    def getAvailableCourses(self):
        
        prolog = Prolog()
        prolog.consult(self.PROLOG_FILE)
        
        availableCourses = list(prolog.query(f"course(X)"))
        courseList = list(map(lambda cor: cor['X'], availableCourses))
        
        return courseList

    def recommend(self, request):
        
        data = json.loads(request.body)
        completedCourses = data['completed_courses']
        interests = data['interests']
        difficulties = data['difficulty']
        
        prolog = Prolog()
        prolog.consult(self.PROLOG_FILE)
        
        # insert student completed courses
        for course in completedCourses:
            fact = f"student_completed({course})"
            if not list(prolog.query(fact)):
                prolog.assertz(fact)
        
        # insert student intersets
        for interest in interests:
            fact = f"student_interest({interest})"
            if not list(prolog.query(fact)):
                prolog.assertz(fact)  
                
                
        difficulties = map(self.mapDifficulty, difficulties)
        
        maxDifficulty = 1
                
        for difficulty in difficulties:
            if(difficulty > maxDifficulty):
                maxDifficulty = difficulty
            
        recommendations = list(prolog.query(f"recommend_by_difficulty(X, {maxDifficulty})"))
        
        # recommendationsList = [rec['X'] for rec in recommendations]
        recommendationsList = list(map(lambda rec: rec['X'], recommendations))
        
        prolog.retractall("student_completed(_)")
        prolog.retractall("student_interest(_)")
        
        return recommendationsList
    
    def mapDifficulty(self, difficulty):
        if difficulty == 'easy':
            return 1
        elif difficulty == 'medium':
            return 2
        elif difficulty == 'hard':
            return 3