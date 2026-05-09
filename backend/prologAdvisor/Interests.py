from pyswip import Prolog
import os

class Interests:
    
    BASE_DIR = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
    PROLOG_FILE = os.path.join(BASE_DIR, 'prolog', 'knowledgeBase.pl')


    def getAvailableInterests(self):
        
        prolog = Prolog()
        prolog.consult(self.PROLOG_FILE)
        
        # interest_match(math_science, mth211).
        
        availableInterests = list(prolog.query(f"interest_match(X, _)"))
        interestList = list(set(map(lambda interest: interest['X'], availableInterests)))
        
        return interestList