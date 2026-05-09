import csv
import re
import os

class KBCreator:
    
    BASE_DIR = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
    INPUT_FILE = os.path.join(BASE_DIR, 'prolog', 'knowledge_base.csv')
    OUTPUT_FILE = os.path.join(BASE_DIR, 'prolog', 'knowledgeBase.pl')
    
    create = True
    
    def adjustString(self, string):
        string = string.lower().strip()
        string = re.sub(r'[^a-z0-9\s]', '', string)
        string = re.sub(r'\s+', '_', string)
        return string
    
    def mapDifficulty(self, difficulty):
        difficulty = self.adjustString(difficulty)
        
        difficultiesLevels = {'easy': 1, 'medium': 2, 'hard': 3}
        
        return difficultiesLevels.get(difficulty, 1)
        
    def initializeKnowledgeBase(self):
        if(not self.create): return
        
        with open(self.INPUT_FILE, newline='', encoding='utf-8') as infile:
            reader = csv.DictReader(infile)
            rows = list(reader)
            
        with open(self.OUTPUT_FILE, 'w') as outfile:
            outfile.write('% === Course Knowledge ===\n\n')
            
            # setting dynamic variables
            
            outfile.write(':- dynamic student_completed/1.\n')
            outfile.write(':- dynamic student_interest/1.\n')
                    
            colNames = rows[0].keys()

            # CSV Layout
            # course_name,difficulty,prerequisite,preference,year_of_study,department
            
            for col in colNames:
                outfile.write(f"% {col} Rules\n")
                for row in rows:
                    var = self.adjustString(row[col])
                    courseName = self.adjustString(row['course_name'])
                    
                    if(col == 'course_name'):
                        outfile.write(f"course({var}).\n")
                        
                    elif(col == 'difficulty'):
                        diff = self.mapDifficulty(var)
                        outfile.write(f"difficulty({courseName}, {diff}).\n")
                        
                    elif(col == 'prerequisite'):
                        if var != "none":
                            outfile.write(f"prerequisite({courseName}, {var}).\n")
                        
                    elif(col == 'preference'):
                        outfile.write(f"interest_match({var}, {courseName}).\n")
                        
                    else: break
                
                outfile.write("\n\n")
                
            # setting rules for querries
            
            outfile.write('% ===== RULES =====\n')

            outfile.write('can_take(Course) :-\n')
            outfile.write('\tprerequisite(Course, Pre),\n')
            outfile.write('\tstudent_completed(Pre).\n')     

            outfile.write('can_take(Course) :-\n')
            outfile.write('\tcourse(Course),\n')
            outfile.write('\t\\+ prerequisite(Course, _).\n')

            outfile.write('recommend(Course) :-\n')
            outfile.write('\tstudent_interest(Interest),\n')
            outfile.write('\tinterest_match(Interest, Course),\n')
            outfile.write('\tcan_take(Course),\n')
            outfile.write('\t\\+ student_completed(Course).\n')

            outfile.write('recommend_by_difficulty(Course, Difficulty):-\n')
            outfile.write('\trecommend(Course),\n')
            outfile.write('\tdifficulty(Course, Diff),\n')
            outfile.write('\tDiff =< Difficulty.\n')
            
if __name__ == '__main__':
    KBCreator().initializeKnowledgeBase()