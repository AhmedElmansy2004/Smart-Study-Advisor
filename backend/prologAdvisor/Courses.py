from pyswip import Prolog
import os
import json

class Courses:
    
    BASE_DIR = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
    PROLOG_FILE = os.path.join(BASE_DIR, 'prolog', 'knowledgeBase.pl')
    
    def getAvailableCourses(self):
        
        prolog = Prolog()
        prolog.consult(self.PROLOG_FILE)
        
        availableCourses = list(prolog.query(f"course(X)"))
        courseList = list(map(lambda cor: cor['X'], availableCourses))
        
        return courseList