from .Courses import prolog_lock, _prolog
import os

class Interests:
    
    BASE_DIR = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
    PROLOG_FILE = os.path.join(BASE_DIR, 'prolog', 'knowledgeBase.pl').replace('\\', '/')

    def getAvailableInterests(self):
        with prolog_lock:
            try:
                # We assume Courses already consulted it, but safety check:
                # Actually consulting it multiple times is slow but safe if locked.
                _prolog.consult(self.PROLOG_FILE)
                results = list(_prolog.query("interest_match(X, _)"))
                interest_set = set()
                for r in results:
                    if 'X' in r:
                        interest_set.add(str(r['X']))
                
                interest_list = sorted(list(interest_set))
                return interest_list
            except Exception as e:
                print(f"Error in getAvailableInterests: {e}")
                return []
        