import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:ai_trainer/screens/dashboard_screen.dart';
import 'package:ai_trainer/screens/diet_planner_screen.dart';
import 'package:ai_trainer/screens/exercise_list_screen.dart';
import 'package:ai_trainer/screens/pose_detection_screen.dart';
import 'package:ai_trainer/screens/profile_screen.dart';
import 'package:ai_trainer/screens/settings_screen.dart';
import 'package:ai_trainer/secret/api_key.dart';
import 'package:ai_trainer/widgets/exercise_progress_card.dart';
import 'package:ai_trainer/widgets/workout_category_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../models/user_data.dart';

import 'package:speech_to_text/speech_to_text.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:flutter_tts/flutter_tts.dart';

String YOUR_API_KEY = ApiKey; 

UserData _mockUserData = UserData(
  name: 'Alex',
  overallFormScore: 0.78,
  formConsistencyDays: 7,
  currentFocus: 'Improve Squat Depth',
  focusDetail: 'Start 30-min Form Session',
  exercises: {
    'Strength': ExerciseData(
      category: 'Strength',
      formScore: 0.75,
      level: 'Advanced Beginner',
      perfectReps: 0,
      nextGoal: 'Next Badge: Level Up!',
      icon: Icons.fitness_center,
      color: Colors.blueAccent,
    ),
    'Yoga': ExerciseData(
      category: 'Yoga',
      formScore: 0.85,
      level: 'Intermediate',
      perfectReps: 0,
      nextGoal: 'Next Badge: Unlock Tree Pose',
      icon: Icons.self_improvement,
      color: Colors.pinkAccent,
    ),
    'Squats': ExerciseData(
      category: 'Squats',
      formScore: 0.80,
      level: 'Intermediate',
      perfectReps: 15,
      nextGoal: 'Perfect: 15 \n Needs Practice: 3',
      icon: Icons.accessibility_new,
      color: const Color(0xFF673AB7), 
    ),
    'PushUps': ExerciseData(
      category: 'PushUps',
      formScore: 0.50,
      level: 'Beginner',
      perfectReps: 5,
      nextGoal: 'Perfect: 5 \nNeeds Practice: 10',
      icon: Icons.directions_run,
      color: const Color(0xFF4CAF50),
    ),
  },
);

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late UserData userData;

  final SpeechToText _speechToText = SpeechToText();
  final FlutterTts _flutterTts = FlutterTts();

  bool _isListening = false;
  bool _isProcessing = false; 

  @override
  void initState() {
    super.initState();
    userData = _mockUserData;
    _simulateDataUpdate();

    _initSpeechToText();
    _initTextToSpeech();
  }

  @override
  void dispose() {
    _speechToText.cancel();
    _flutterTts.stop();
    super.dispose();
  }

  // (Your existing _simulateDataUpdate method)
  void _simulateDataUpdate() {
    Future.delayed(const Duration(seconds: 5), () {
      if (!mounted) return;
      setState(() {
        userData.formConsistencyDays = 8;
        userData.overallFormScore = 0.82;
        userData.currentFocus = 'Perfect Push-up Form';
        userData.focusDetail = 'Recommended: 20-min Upper Body Session';
        
        userData.exercises['PushUps']!.formScore = 0.70;
        userData.exercises['PushUps']!.level = 'Intermediate';
        userData.exercises['PushUps']!.perfectReps = 15;
        userData.exercises['PushUps']!.nextGoal = 'Perfect: 15 \n Needs Practice: 2';
      });
      print('UI Updated Dynamically!');
    });
  }

  // (Your existing _navigateToWorkout method)
  void _navigateToWorkout(String exerciseName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PoseDetectionScreen(exerciseName: exerciseName),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<ExerciseData> primaryWorkouts = [
      userData.exercises['Strength']!,
      userData.exercises['Yoga']!,
    ];
    List<ExerciseData> specificWorkouts = [
      userData.exercises['Squats']!,
      userData.exercises['PushUps']!,
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _buildHeader(userData.name),
              SizedBox(height: 25.h),
              GestureDetector(
                onTap: () => _navigateToWorkout(userData.currentFocus),
                child: _buildFocusCard(userData),
              ),
              SizedBox(height: 30.h),
              Text(
                'Choose Your Workout',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20.h),
              _buildPrimaryWorkoutGrid(primaryWorkouts),
              SizedBox(height: 20.h),
              _buildSpecificWorkoutGrid(specificWorkouts),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomBar(context),

      // --- MODIFIED: Added floatingActionButton and location ---
      floatingActionButton: FloatingActionButton(
        onPressed: _isProcessing ? null : (_isListening ? _stopListening : _startListening),
        tooltip: 'AI Assistant',
        backgroundColor: _isListening ? Colors.redAccent : const Color(0xFF673AB7), // Match theme
        child: _isProcessing
            ? const Padding(
                padding: EdgeInsets.all(8.0),
                child: CircularProgressIndicator(color: Colors.white),
              )
            : Icon(_isListening ? Icons.mic_off : Icons.mic, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
  
  // (Your existing _buildHeader method)
  Widget _buildHeader(String userName) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          'Hello, $userName!',
          style: TextStyle(
            color: Colors.white,
            fontSize: 26.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        GestureDetector(
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfileScreen())),
          child: Container(
            width: 45.w,
            height: 45.w,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: const Icon(Icons.person, color: Colors.black),
          ),
        ),
      ],
    );
  }

  // (Your existing _buildFocusCard method)
  Widget _buildFocusCard(UserData data) {
    return Container(
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.r),
        gradient: const LinearGradient(
          colors: [Color(0xFF673AB7), Color(0xFF9C27B0)], 
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.purple.withOpacity(0.3),
            blurRadius: 10.r,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Today's AI Focus",
                  style: TextStyle(color: Colors.white70, fontSize: 16.sp),
                ),
                SizedBox(height: 5.h),
                Text(
                  '${data.currentFocus} - ${data.focusDetail}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'Form Streak:',
                style: TextStyle(color: Colors.white70, fontSize: 12.sp),
              ),
              Text(
                '${data.formConsistencyDays} Days',
                style: TextStyle(
                  color: const Color(0xFF00FF88), 
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPrimaryWorkoutGrid(List<ExerciseData> workouts) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: workouts
          .map((data) => Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                      right: data.category == 'Strength' ? 10.w : 0.w),
                  child: GestureDetector(
                    onTap:() {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => 
                            ExerciseListScreen(categoryName: data.category),
                        ),
                      );
                    },
                    child: WorkoutCategoryCard(data: data),
                  ),
                ),
              ))
          .toList(),
    );
  }

  Widget _buildSpecificWorkoutGrid(List<ExerciseData> workouts) {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10.w,
        mainAxisSpacing: 10.h,
        childAspectRatio: 0.85,
      ),
      itemCount: workouts.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () => _navigateToWorkout(workouts[index].category),
          child: ExerciseProgressCard(data: workouts[index]), 
        );
      },
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF1E1E1E),
        boxShadow: [
          BoxShadow(color: Colors.black45, blurRadius: 10),
        ],
      ),
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Icon(Icons.home, color: const Color(0xFF00FF88), size: 30.sp),
          GestureDetector(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const DashboardScreen())),
            child: Icon(Icons.trending_up, color: Colors.grey, size: 30.sp),
          ),
          SizedBox(
            height: 60.h,
            child: FloatingActionButton.extended(
              onPressed: () => _navigateToWorkout(userData.currentFocus),
              backgroundColor: const Color(0xFF00FF88), 
              icon: Icon(Icons.videocam, color: Colors.black, size: 24.sp),
              label: Text(
                'Start Workout',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 16.sp,
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () => Navigator.push(
              context, 
              MaterialPageRoute(builder: (context) => const DietPlannerScreen())
            ),
            child: Icon(Icons.restaurant_menu, color: Colors.grey, size: 30.sp),
          ),
          GestureDetector(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingsScreen())),
            child: Icon(Icons.settings, color: Colors.grey, size: 30.sp),
          ),
        ],
      ),
    );
  }

  Future<void> _initSpeechToText() async {
    try {
      await _speechToText.initialize(
        onError: (error) => print("STT Error: $error"),
        onStatus: (status) => _handleSpeechStatus(status),
      );
    } catch (e) {
      print("Could not initialize SpeechToText: $e");
    }
  }

  Future<void> _initTextToSpeech() async {
    await _flutterTts.setLanguage("en-US");
    await _flutterTts.setPitch(1.0);
    await _flutterTts.setSpeechRate(0.5);
  }

  void _handleSpeechStatus(String status) {
    if (status == 'notListening' && _isListening) {
      _stopListening();
    }
  }

  Future<void> _startListening() async {
    if (!_speechToText.isAvailable) {
      print("Speech recognition not available.");
      return;
    }

    setState(() {
      _isListening = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Listening..."),
        duration: Duration(seconds: 30), 
      ),
    );

    await _speechToText.listen(
      onResult: _onSpeechResult,
      listenFor: const Duration(seconds: 30), 
      pauseFor: const Duration(seconds: 5), 
      localeId: "en_US",
    );
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    if (result.finalResult && !_isProcessing) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      _sendToGemini(result.recognizedWords);
    }
  }

  Future<void> _stopListening() async {
    await _speechToText.stop();
    ScaffoldMessenger.of(context).hideCurrentSnackBar(); 
    setState(() {
      _isListening = false;
    });
  }

  Future<void> _sendToGemini(String prompt) async {
    if (prompt.isEmpty) {
      setState(() => _isProcessing = false);
      return;
    }

    setState(() {
      _isProcessing = true;
    });
    String apiKey = ApiKey; 
    
    final String modelName = "gemini-1.5-flash"; 
    
    final url = Uri.parse(
        'https://generativelanguage.googleapis.com/v1beta/models/$modelName:generateContent?key=$apiKey');

    final headers = {
      'Content-Type': 'application/json',
    };

    final body = json.encode({
      'contents': [
        {
          'parts': [
            {'text': "You are a fitness assistant. Keep your answer concise. $prompt"}
          ]
        }
      ]
    });

    String newResponse = "Sorry, I couldn't understand that.";

    try {
      final response = await http.post(
        url,
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        
        newResponse = responseBody['candidates'][0]['content']['parts'][0]['text'];

      } else {
        print("Error: ${response.statusCode}");
        print("Error Body: ${response.body}");
        newResponse = "Error: Failed to get response. ${response.body}";
      }

    } catch (e) {
      print("Exception: $e");
      newResponse = "Error: $e";
    }

    _speak(newResponse);

    if (mounted) {
      _showResponseDialog(prompt, newResponse);
    }

    setState(() {
      _isProcessing = false;
    });
  }
  Future<void> _speak(String text) async {
    await _flutterTts.speak(text);
  }

  void _showResponseDialog(String userQuery, String geminiResponse) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          // Optional: Theme the dialog to match your app
          // backgroundColor: const Color(0xFF1E1E1E),
          // titleTextStyle: const TextStyle(color: Colors.white),
          // contentTextStyle: const TextStyle(color: Colors.white70),
          title: const Text("AI Assistant"),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "You said:",
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                ),
                Text(userQuery),
                const SizedBox(height: 16),
                Text(
                  "Gemini says:",
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                ),
                Text(geminiResponse),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                _flutterTts.stop(); // Stop speaking if user closes dialog
                Navigator.of(context).pop();
              },
              child: const Text("Close"),
            ),
          ],
        );
      },
    );
  }
  
} // (End of _HomeScreenState)
