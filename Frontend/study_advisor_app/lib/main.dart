// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const StudyAdvisorApp());
}

class StudyAdvisorApp extends StatelessWidget {
  const StudyAdvisorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Study Advisor',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0F172A),
        colorScheme: const ColorScheme.dark(
          primary: Colors.indigoAccent,
          secondary: Colors.cyanAccent,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        cardTheme: CardThemeData(
          color: const Color(0xFF1E293B).withOpacity(0.8),
          elevation: 10,
          shadowColor: Colors.black54,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFF334155),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: const BorderSide(
              color: Colors.cyanAccent,
              width: 2,
            ),
          ),
          labelStyle: const TextStyle(color: Colors.white70),
        ),
      ),
      home: const AdvisorScreen(),
    );
  }
}

class AdvisorScreen extends StatefulWidget {
  const AdvisorScreen({super.key});

  @override
  State<AdvisorScreen> createState() => _AdvisorScreenState();
}

class _AdvisorScreenState extends State<AdvisorScreen> {
  // Mode selection
  String _selectedMode = 'inference'; // 'ai' or 'inference'

  @override
  void initState() {
    super.initState();
    _fetchAvailableCourses();
    _fetchAvailableInterests();
  }

  // API configuration - CHANGE THIS for your setup
  final String _apiBaseUrl = 'http://localhost:8000'; // Web
  // final String _apiBaseUrl = 'http://10.0.2.2:8000'; // Android emulator
  // final String _apiBaseUrl = 'http://192.168.1.5:8000'; // Physical device

  // Dropdown controllers removed - now using UniqueKey() for clean rebuilds (this was a bug)

  // Available courses for prerequisites dropdown
  // DONE: get the available courses from the backend by the endpoint /prologAdvisor/getCourses/ and store it in _availableCourses
  List<String> _availableCourses = [];

  Future<void> _fetchAvailableCourses() async {
    try {
      final url = Uri.parse('$_apiBaseUrl/prologAdvisor/getCourses/');
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _availableCourses = List<String>.from(data['courses'] ?? []);
        });
      }
    } catch (e) {
      print('Error fetching courses: $e');
    }
  }


  // NEW: Separate list for Difficulty levels only
  final List<String> _availableDifficulties = [
    'easy',
    'medium',
    'hard',
  ];

  // NEW: Separate list for Interests only (no difficulty mixed in)
  // DONE: get the available interests from the backend by the endpoint /prologAdvisor/getInterests/ and store it in _availableInterests
  List<String> _availableInterests = [];

  Future<void> _fetchAvailableInterests() async {
    try {
      final url = Uri.parse('$_apiBaseUrl/prologAdvisor/getInterests/');
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _availableInterests = List<String>.from(data['interests'] ?? []);
        });
      }
    } catch (e) {
      print('Error fetching interests: $e');
    }
  }


  // User selections
  final List<String> _selectedPrerequisites = [];
  final List<String> _selectedDifficulties = [];
  final List<String> _selectedInterests = [];

  // Output
  String _aiResponse = '';
  List<String> _inferenceRecommendations = [];
  bool _isLoading = false;
  String _errorMessage = '';
  bool _hasResponse = false;

  // --- PREREQUISITE HELPERS ---
  void _addPrerequisite(String course) {
    if (course.isNotEmpty && !_selectedPrerequisites.contains(course)) {
      setState(() {
        _selectedPrerequisites.add(course);
      });
    }
  }

  void _removePrerequisite(String course) {
    setState(() {
      _selectedPrerequisites.remove(course);
    });
  }

  // --- NEW: DIFFICULTY HELPERS ---
  void _addDifficulty(String difficulty) {
    if (difficulty.isNotEmpty && !_selectedDifficulties.contains(difficulty)) {
      setState(() {
        _selectedDifficulties.add(difficulty);
      });
    }
  }

  void _removeDifficulty(String difficulty) {
    setState(() {
      _selectedDifficulties.remove(difficulty);
    });
  }

  // --- INTEREST HELPERS ---
  void _addInterest(String interest) {
    if (interest.isNotEmpty && !_selectedInterests.contains(interest)) {
      setState(() {
        _selectedInterests.add(interest);
      });
    }
  }

  void _removeInterest(String interest) {
    setState(() {
      _selectedInterests.remove(interest);
    });
  }

  Future<void> _submitRequest() async {
    // NEW: Validate all three sections independently
    if (_selectedPrerequisites.isEmpty) {
      setState(() {
        _errorMessage = 'Please select at least one prerequisite course.';
      });
      return;
    }
    if (_selectedDifficulties.isEmpty) {
      setState(() {
        _errorMessage = 'Please select at least one difficulty level.';
      });
      return;
    }
    if (_selectedInterests.isEmpty) {
      setState(() {
        _errorMessage = 'Please select at least one interest.';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = '';
      _aiResponse = '';
      _inferenceRecommendations = [];
      _hasResponse = false;
    });

    try {
      final endpoint = _selectedMode == 'ai'
          ? '/AI/chatbot/'
          : '/prologAdvisor/recommend/';
      final url = Uri.parse('$_apiBaseUrl$endpoint');

      // NEW: Send difficulties and interests as separate JSON fields
      final body = jsonEncode({
        'completed_courses': _selectedPrerequisites,
        'difficulty': _selectedDifficulties,   // NEW
        'interests': _selectedInterests,
        'mode': _selectedMode,
      });

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: body,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        setState(() {
          _hasResponse = true;
          if (_selectedMode == 'ai') {
            _aiResponse = data['recommendation'] ??
                data['response'] ??
                'No response from AI.';
          } else {
            _inferenceRecommendations =
                List<String>.from(data['recommendations'] ?? []);
          }
        });
      } else {
        setState(() {
          _errorMessage =
              'Server error: ${response.statusCode}\n${response.body}';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage =
            'Connection failed: $e\n\nMake sure Django is running at $_apiBaseUrl';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Widget _buildResultsCard() {
    if (!_hasResponse) {
      return const SizedBox.shrink(key: ValueKey('empty'));
    }

    final isAiMode = _selectedMode == 'ai';

    Widget content;
    if (isAiMode) {
      content = Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.12),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.white.withOpacity(0.12),
          ),
        ),
        child: Text(
          _aiResponse,
          style: const TextStyle(
            fontSize: 15,
            height: 1.6,
            color: Colors.white,
          ),
        ),
      );
    } else if (_inferenceRecommendations.isEmpty) {
      content = const Text(
        'No courses satisfy the queries.',
        style: TextStyle(
          fontStyle: FontStyle.italic,
          color: Colors.white70,
        ),
      );
    } else {
      content = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Recommended Courses:',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          ..._inferenceRecommendations.asMap().entries.map((entry) {
            final index = entry.key;
            final course = entry.value;
            return Container(
              margin: const EdgeInsets.only(bottom: 14),
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.green.shade400,
                    Colors.teal.shade500,
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.green.withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.18),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '${index + 1}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      course,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: Colors.white,
                  ),
                ],
              ),
            );
          }),
        ],
      );
    }

    return Container(
      key: const ValueKey('results'),
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isAiMode
              ? [
                  Colors.indigo.shade700,
                  Colors.cyan.shade600,
                ]
              : [
                  Colors.green.shade400,
                  Colors.teal.shade500,
                ],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: (isAiMode ? Colors.cyan : Colors.green).withOpacity(0.3),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                isAiMode ? Icons.auto_awesome : Icons.check_circle,
                color: Colors.white,
              ),
              const SizedBox(width: 8),
              Text(
                isAiMode ? 'AI Recommendation' : 'Inference Results',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          content,
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final prerequisiteItems = _availableCourses
        .where((course) => !_selectedPrerequisites.contains(course))
        .map((course) => DropdownMenuItem<String?>(
              value: course,
              child: Text(course),
            ))
        .toList();

    final difficultyItems = _availableDifficulties
        .where((difficulty) => !_selectedDifficulties.contains(difficulty))
        .map((difficulty) => DropdownMenuItem<String?>(
              value: difficulty,
              child: Text(difficulty),
            ))
        .toList();

    final interestItems = _availableInterests
        .where((interest) => !_selectedInterests.contains(interest))
        .map((interest) => DropdownMenuItem<String?>(
              value: interest,
              child: Text(interest),
            ))
        .toList();

    const sectionTitleStyle = TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    );

    final subduedTextStyle = TextStyle(
      color: Colors.white.withOpacity(0.7),
    );

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.auto_awesome, color: Colors.cyanAccent),
            SizedBox(width: 10),
            Text('Smart Study Advisor'),
          ],
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF0F172A),
              Color(0xFF1E1B4B),
              Color(0xFF312E81),
            ],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 120, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(28),
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF4F46E5),
                      Color(0xFF06B6D4),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.cyanAccent.withOpacity(0.25),
                      blurRadius: 24,
                      offset: const Offset(0, 12),
                    ),
                  ],
                ),
                child: const Column(
                  children: [
                    Icon(
                      Icons.school_rounded,
                      size: 70,
                      color: Colors.white,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Your Intelligent Study Companion',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Get personalized course recommendations using AI and inference systems.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 15,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Select Mode', style: sectionTitleStyle),
                        const SizedBox(height: 8),
                        Text(
                          'Choose the engine that fits your workflow.',
                          style: subduedTextStyle,
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: ChoiceChip(
                                selectedColor: Colors.indigoAccent,
                                backgroundColor: const Color(0xFF334155),
                                labelStyle: TextStyle(
                                  color: _selectedMode == 'inference'
                                      ? Colors.white
                                      : Colors.white70,
                                  fontWeight: FontWeight.w600,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                label: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.memory, size: 18),
                                    SizedBox(width: 8),
                                    Text('Inference Engine'),
                                  ],
                                ),
                                selected: _selectedMode == 'inference',
                                onSelected: (selected) {
                                  if (selected) {
                                    setState(() {
                                      _selectedMode = 'inference';
                                      _aiResponse = '';
                                      _inferenceRecommendations = [];
                                    });
                                  }
                                },
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: ChoiceChip(
                                selectedColor: Colors.indigoAccent,
                                backgroundColor: const Color(0xFF334155),
                                labelStyle: TextStyle(
                                  color: _selectedMode == 'ai'
                                      ? Colors.white
                                      : Colors.white70,
                                  fontWeight: FontWeight.w600,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                label: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.auto_awesome, size: 18),
                                    SizedBox(width: 8),
                                    Text('AI Engine'),
                                  ],
                                ),
                                selected: _selectedMode == 'ai',
                                onSelected: (selected) {
                                  if (selected) {
                                    setState(() {
                                      _selectedMode = 'ai';
                                      _aiResponse = '';
                                      _inferenceRecommendations = [];
                                    });
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Prerequisites (Courses Taken)',
                          style: sectionTitleStyle,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Select courses you have already completed.',
                          style: subduedTextStyle,
                        ),
                        const SizedBox(height: 16),
                        DropdownButtonFormField<String?>(
                          key: UniqueKey(),
                          value: null,
                          decoration: const InputDecoration(
                            labelText: 'Add a course',
                            prefixIcon: Icon(Icons.school),
                          ),
                          items: prerequisiteItems.isEmpty
                              ? [
                                  const DropdownMenuItem<String?>(
                                    value: null,
                                    enabled: false,
                                    child: Text('All courses selected'),
                                  ),
                                ]
                              : prerequisiteItems,
                          onChanged: prerequisiteItems.isEmpty
                              ? null
                              : (value) {
                                  if (value != null) {
                                    _addPrerequisite(value);
                                  }
                                },
                          hint: const Text('Select course'),
                        ),
                        const SizedBox(height: 14),
                        Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: _selectedPrerequisites.map((course) {
                            return Chip(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 8,
                              ),
                              backgroundColor: const Color(0xFF4F46E5),
                              labelStyle: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                              deleteIconColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              label: Text(course),
                              deleteIcon: const Icon(Icons.close, size: 18),
                              onDeleted: () => _removePrerequisite(course),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Preferred Difficulty',
                          style: sectionTitleStyle,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Select one or more difficulty levels.',
                          style: subduedTextStyle,
                        ),
                        const SizedBox(height: 16),
                        DropdownButtonFormField<String?>(
                          key: UniqueKey(),
                          value: null,
                          decoration: const InputDecoration(
                            labelText: 'Add difficulty',
                            prefixIcon: Icon(Icons.signal_cellular_alt),
                          ),
                          items: difficultyItems.isEmpty
                              ? [
                                  const DropdownMenuItem<String?>(
                                    value: null,
                                    enabled: false,
                                    child: Text('All difficulties selected'),
                                  ),
                                ]
                              : difficultyItems,
                          onChanged: difficultyItems.isEmpty
                              ? null
                              : (value) {
                                  if (value != null) {
                                    _addDifficulty(value);
                                  }
                                },
                          hint: const Text('Select difficulty'),
                        ),
                        const SizedBox(height: 14),
                        Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: _selectedDifficulties.map((difficulty) {
                            return Chip(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 8,
                              ),
                              backgroundColor: Colors.red.shade600,
                              labelStyle: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                              deleteIconColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              label: Text(difficulty),
                              deleteIcon: const Icon(Icons.close, size: 18),
                              onDeleted: () => _removeDifficulty(difficulty),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Interests',
                          style: sectionTitleStyle,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Select topics or styles you are interested in.',
                          style: subduedTextStyle,
                        ),
                        const SizedBox(height: 16),
                        DropdownButtonFormField<String?>(
                          key: UniqueKey(),
                          value: null,
                          decoration: const InputDecoration(
                            labelText: 'Add interest',
                            prefixIcon: Icon(Icons.interests),
                          ),
                          items: interestItems.isEmpty
                              ? [
                                  const DropdownMenuItem<String?>(
                                    value: null,
                                    enabled: false,
                                    child: Text('All interests selected'),
                                  ),
                                ]
                              : interestItems,
                          onChanged: interestItems.isEmpty
                              ? null
                              : (value) {
                                  if (value != null) {
                                    _addInterest(value);
                                  }
                                },
                          hint: const Text('Select interest'),
                        ),
                        const SizedBox(height: 14),
                        Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: _selectedInterests.map((interest) {
                            return Chip(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 8,
                              ),
                              backgroundColor: Colors.orange.shade600,
                              labelStyle: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                              deleteIconColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              label: Text(interest),
                              deleteIcon: const Icon(Icons.close, size: 18),
                              onDeleted: () => _removeInterest(interest),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Container(
                height: 60,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Colors.indigoAccent,
                      Colors.cyanAccent,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.cyanAccent.withOpacity(0.4),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: ElevatedButton.icon(
                  onPressed: _isLoading ? null : _submitRequest,
                  icon: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.send),
                  label: Text(
                    _isLoading ? 'Processing...' : 'Get Recommendations',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              if (_errorMessage.isNotEmpty)
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.red.withOpacity(0.35)),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.error_outline, color: Colors.red.shade200),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _errorMessage,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 400),
                child: _buildResultsCard(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}