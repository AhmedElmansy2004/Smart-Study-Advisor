:- dynamic student_completed/1.
:- dynamic student_interest/1.

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
difficulty(mth111, 2).
difficulty(phy111, 2).
difficulty(cse121, 1).
difficulty(cse122, 1).
difficulty(cse131, 1).
difficulty(mth211, 2).
difficulty(cse221, 2).
difficulty(cse222, 3).
difficulty(cse225, 2).
difficulty(cse231, 2).
difficulty(cse241, 1).
difficulty(cse261, 2).
difficulty(cse321, 2).
difficulty(cse322, 1).
difficulty(cse323, 2).
difficulty(cse331, 3).
difficulty(cse341, 2).
difficulty(cse351, 2).
difficulty(cse361_control, 3).
difficulty(cse361_os2, 3).
difficulty(cse421, 3).
difficulty(cse441, 2).
difficulty(cse451, 3).
difficulty(cse452, 2).
difficulty(cse453, 2).
difficulty(cse431, 3).
difficulty(cse461, 2).
difficulty(cse442, 2).

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

% ===== RULES =====

can_take(Course) :-
    prerequisite(Course, Pre),
    student_completed(Pre).

can_take(Course) :-
    course(Course),
    \+ prerequisite(Course, _).

recommend(Course) :-
    student_interest(Interest),
    interest_match(Interest, Course),
    can_take(Course),
    \+ student_completed(Course).

recommend_by_difficulty(Course, Difficulty):-
    recommend(Course),
    difficulty(Course, Diff),
    Diff =< Difficulty.
