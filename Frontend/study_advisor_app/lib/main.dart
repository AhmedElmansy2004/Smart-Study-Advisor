import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const StudyAdvisorApp());
}

class StudyAdvisorApp extends StatelessWidget {
  const StudyAdvisorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Study Advisor',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const RecommendationScreen(),
    );
  }
}

class RecommendationScreen extends StatefulWidget {
  const RecommendationScreen({super.key});

  @override
  State<RecommendationScreen> createState() => _RecommendationScreenState();
}

class _RecommendationScreenState extends State<RecommendationScreen> {
  String _result = 'Tap the button to get recommendations';
  bool _loading = false;

  // CHANGE THIS based on your target device
  final String apiUrl = 'http://localhost:8000/advisor/hello-world';

  Future<void> fetchRecommendations() async {
    setState(() {
      _loading = true;
    });

    try {
      final response = await http.get(Uri.parse(apiUrl));
      
      if (response.statusCode == 200) {
        setState(() {
          _result = response.body; // Your HTML or JSON response
        });
      } else {
        setState(() {
          _result = 'Error: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        _result = 'Failed to connect: $e';
      });
    }

    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Study Advisor')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_result, textAlign: TextAlign.center),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _loading ? null : fetchRecommendations,
              child: _loading 
                ? const CircularProgressIndicator() 
                : const Text('Get Recommendations'),
            ),
          ],
        ),
      ),
    );
  }
}