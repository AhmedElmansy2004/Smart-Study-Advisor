from pyswip import Prolog
import os
import json
import threading

# Global lock to prevent concurrent Prolog queries (required for pyswip)
prolog_lock = threading.Lock()
# Shared prolog instance
_prolog = Prolog()
_consulted = False

class Courses:
    
    BASE_DIR = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
    PROLOG_FILE = os.path.join(BASE_DIR, 'prolog', 'knowledgeBase.pl').replace('\\', '/')
    
    def getAvailableCourses(self):
        global _consulted
        with prolog_lock:
            if not _consulted:
                _prolog.consult(self.PROLOG_FILE)
                _consulted = True
            
            availableCourses = list(_prolog.query("course(X)"))
            courseList = list(set(map(lambda cor: cor['X'], availableCourses)))
            return courseList