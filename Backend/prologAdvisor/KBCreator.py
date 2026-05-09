import csv
import re
import os

class KBCreator:
    
    BASE_DIR = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
    INPUT_FILE = os.path.join(BASE_DIR, 'prolog', 'knowledgeBase.pl')
    OUTPUT_FILE = os.path.join(BASE_DIR, 'prolog', 'knowledge_base.pl')
    
    create = True
    
    def adjustString(self, string):
        string = string.lower().strip()
        string = re.sub(r'[^a-z0-9\s]', '', string)
        string = re.sub(r'\s+', '_', string)
        return string
    
    def mapDifficulty(self, difficulty):
        difficulty = self.adjustString(difficulty)
        
        difficultiesLevels = {'easy': 1, 'medium': 2, 'hard': 3}
        
        return difficultiesLevels.get(difficulty)
        
        if difficulty == 'easy':
            return 1
        elif difficulty == 'medium':
            return 2
        elif difficulty == 'hard':
            return 3