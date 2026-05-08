:- dynamic student_completed/2.
:- dynamic student_interest/2.

% ===== COURSES =====
course(mth111).
course(phy111).
course(cse121).
course(cse122).
course(cse131).
course(mth211).
course(cse221).
course(cse222).
course(cse225).
course(cse231).
course(cse241).
course(cse261).
course(cse321).
course(cse322).
course(cse323).
course(cse331).
course(cse341).
course(cse351).
course(cse361_control).
course(cse361_os2).
course(cse421).
course(cse441).
course(cse451).
course(cse452).
course(cse453).
course(cse431).
course(cse461).
course(cse442).

% ===== DIFFICULTY =====
difficulty(mth111, 8).
difficulty(phy111, 7).
difficulty(cse121, 5).
difficulty(cse122, 6).
difficulty(cse131, 6).
difficulty(mth211, 7).
difficulty(cse221, 8).
difficulty(cse222, 9).
difficulty(cse225, 7).
difficulty(cse231, 8).
difficulty(cse241, 6).
difficulty(cse261, 8).
difficulty(cse321, 8).
difficulty(cse322, 6).
difficulty(cse323, 7).
difficulty(cse331, 9).
difficulty(cse341, 7).
difficulty(cse351, 8).
difficulty(cse361_control, 9).
difficulty(cse361_os2, 10).
difficulty(cse421, 9).
difficulty(cse441, 8).
difficulty(cse451, 9).
difficulty(cse452, 8).
difficulty(cse453, 8).
difficulty(cse431, 9).
difficulty(cse461, 8).
difficulty(cse442, 7).

% ===== PREREQUISITES =====
prerequisite(cse122, cse121).
prerequisite(mth211, mth111).
prerequisite(cse221, cse122).
prerequisite(cse222, cse221).
prerequisite(cse225, cse121).
prerequisite(cse231, cse131).
prerequisite(cse241, mth111).
prerequisite(cse261, mth111).
prerequisite(cse321, cse221).
prerequisite(cse322, cse222).
prerequisite(cse323, cse221).
prerequisite(cse331, cse231).
prerequisite(cse341, cse241).
prerequisite(cse351, cse221).
prerequisite(cse361_control, cse261).
prerequisite(cse361_os2, cse321).
prerequisite(cse421, cse225).
prerequisite(cse441, cse341).
prerequisite(cse451, cse351).
prerequisite(cse452, cse351).
prerequisite(cse453, cse351).
prerequisite(cse431, cse331).
prerequisite(cse461, cse361_control).
prerequisite(cse442, cse341).

% ===== INTEREST CATEGORIES =====
interest_match(math_science, mth111).
interest_match(math_science, phy111).
interest_match(math_science, mth211).

interest_match(software_programming, cse121).
interest_match(software_programming, cse122).
interest_match(software_programming, cse221).
interest_match(software_programming, cse222).
interest_match(software_programming, cse225).
interest_match(software_programming, cse321).
interest_match(software_programming, cse322).
interest_match(software_programming, cse323).
interest_match(software_programming, cse361_os2).
interest_match(software_programming, cse421).

interest_match(hardware_architecture, cse131).
interest_match(hardware_architecture, cse231).
interest_match(hardware_architecture, cse331).
interest_match(hardware_architecture, cse431).

interest_match(networks_security, cse241).
interest_match(networks_security, cse341).
interest_match(networks_security, cse441).
interest_match(networks_security, cse442).

interest_match(ai_data_science, cse351).
interest_match(ai_data_science, cse451).
interest_match(ai_data_science, cse452).
interest_match(ai_data_science, cse453).

interest_match(control_systems, cse261).
interest_match(control_systems, cse361_control).
interest_match(control_systems, cse461).

% ===== STUDENTS =====
% ahmed - software focused, completed year 1 + some year 2
student_completed(ahmed, mth111).
student_completed(ahmed, phy111).
student_completed(ahmed, cse121).
student_completed(ahmed, cse122).
student_completed(ahmed, cse131).


% mansi - math focused, completed year 1
student_completed(mansi, mth111).
student_completed(mansi, phy111).
student_completed(mansi, cse121).
student_completed(mansi, cse122).
student_completed(mansi, cse131).


% mohamed - hardware focused, completed year 1 + year 2
student_completed(mohamed, mth111).
student_completed(mohamed, phy111).
student_completed(mohamed, cse121).
student_completed(mohamed, cse122).
student_completed(mohamed, cse131).
student_completed(mohamed, cse221).
student_completed(mohamed, cse231).


% sakr - networks focused, completed year 1 + year 2
student_completed(sakr, mth111).
student_completed(sakr, phy111).
student_completed(sakr, cse121).
student_completed(sakr, cse122).
student_completed(sakr, cse131).
student_completed(sakr, cse241).


% radwan - ai focused, completed years 1+2
student_completed(radwan, mth111).
student_completed(radwan, phy111).
student_completed(radwan, cse121).
student_completed(radwan, cse122).
student_completed(radwan, cse131).
student_completed(radwan, cse221).
student_completed(radwan, cse351).


% abdelrahman - control focused, completed years 1+2
student_completed(abdelrahman, mth111).
student_completed(abdelrahman, phy111).
student_completed(abdelrahman, cse121).
student_completed(abdelrahman, cse122).
student_completed(abdelrahman, cse131).
student_completed(abdelrahman, cse261).


% youssef - all rounder, completed year 1 only
student_completed(youssef, mth111).
student_completed(youssef, phy111).
student_completed(youssef, cse121).
student_completed(youssef, cse122).
student_completed(youssef, cse131).

% interests
student_interest(ahmed, software_programming).
student_interest(ahmed, ai_data_science).
student_interest(mansi, math_science).
student_interest(mansi, software_programming).
student_interest(mohamed, hardware_architecture).
student_interest(sakr, networks_security).
student_interest(radwan, ai_data_science).
student_interest(abdelrahman, control_systems).
student_interest(youssef, software_programming).
student_interest(youssef, networks_security).

% ===== RULES =====

% Available if prerequisite completed
can_take(Student, Course) :-
    prerequisite(Course, Pre),
    student_completed(Student, Pre).

% Available if no prerequisites
can_take(Student, Course) :-
    course(Course),
    \+ prerequisite(Course, _).

% Recommend based on interest + availability + not completed
recommend(Student, Course) :-
    student_interest(Student, Interest),
    interest_match(Interest, Course),
    can_take(Student, Course),
    \+ student_completed(Student, Course).

recommend_by_difficulty(Student, Course, Difficulty):-
    recommend(Student, Course),
    difficulty(Course, Diff),
    Diff =< Difficulty.
