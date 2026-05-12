from .Courses import prolog_lock, _prolog
import os
import json

class Recommend:
    
    BASE_DIR = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
    PROLOG_FILE = os.path.join(BASE_DIR, 'prolog', 'knowledgeBase.pl').replace('\\', '/')

    def recommend(self, request):
        data = json.loads(request.body)
        completedCourses = data['completed_courses']
        interests = data['interests']
        difficulties = data['difficulty']
        
        with prolog_lock:
            _prolog.consult(self.PROLOG_FILE)
            
            # clear previous student data
            _prolog.retractall("student_completed(_)")
            _prolog.retractall("student_interest(_)")
            
            # insert student completed courses
            for course in completedCourses:
                _prolog.assertz(f"student_completed({course})")
            
            # insert student intersets
            for interest in interests:
                _prolog.assertz(f"student_interest({interest})")
                    
            difficulties_mapped = list(map(self.mapDifficulty, difficulties))
            maxDifficulty = max(difficulties_mapped) if difficulties_mapped else 1
                
            recommendations = list(_prolog.query(f"recommend_by_difficulty(X, {maxDifficulty})"))
            recommendationsList = [rec['X'] for rec in recommendations]
            
            # clean up
            _prolog.retractall("student_completed(_)")
            _prolog.retractall("student_interest(_)")
            
            return recommendationsList
    
    def mapDifficulty(self, difficulty):
        if difficulty == 'easy': return 1
        elif difficulty == 'medium': return 2
        elif difficulty == 'hard': return 3
        else: return 1