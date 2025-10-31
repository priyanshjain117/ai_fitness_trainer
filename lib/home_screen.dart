// import 'package:ai_trainer/screens/dashboard_screen.dart';
// import 'package:ai_trainer/screens/diet_planner_screen.dart';
// import 'package:ai_trainer/screens/exercise_list_screen.dart';
// import 'package:ai_trainer/screens/pose_detection_screen.dart';
// import 'package:ai_trainer/screens/profile_screen.dart';
// import 'package:ai_trainer/screens/settings_screen.dart';
// import 'package:ai_trainer/secret/api_key.dart';
// import 'package:ai_trainer/widgets/exercise_progress_card.dart';
// import 'package:ai_trainer/widgets/workout_category_card.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import '../models/user_data.dart';

// // --- ADDED: Imports for Voice Assistant ---
// import 'package:google_generative_ai/google_generative_ai.dart';
// import 'package:speech_to_text/speech_to_text.dart';
// import 'package:speech_to_text/speech_recognition_result.dart';
// import 'package:flutter_tts/flutter_tts.dart';

// // --- ADDED: API Key ---
// // 1. Get your API key from Google AI Studio (https://aistudio.google.com/)
// // 2. For production, use flutter_dotenv to protect this key
// String ApiKey = apiKey; // 👈 PASTE YOUR KEY HERE
// // Placeholder/Simulated User Data
// UserData _mockUserData = UserData(
//   name: 'Alex',
//   overallFormScore: 0.78,
//   formConsistencyDays: 7,
//   currentFocus: 'Improve Squat Depth',
//   focusDetail: 'Start 30-min Form Session',
//   exercises: {
//     'Strength': ExerciseData(
//       category: 'Strength',
//       formScore: 0.75,
//       level: 'Advanced Beginner',
//       perfectReps: 0,
//       nextGoal: 'Next Badge: Level Up!',
//       icon: Icons.fitness_center,
//       color: Colors.blueAccent,
//     ),
//     'Yoga': ExerciseData(
//       category: 'Yoga',
//       formScore: 0.85,
//       level: 'Intermediate',
//       perfectReps: 0,
//       nextGoal: 'Next Badge: Unlock Tree Pose',
//       icon: Icons.self_improvement,
//       color: Colors.pinkAccent,
//     ),
//     'Squats': ExerciseData(
//       category: 'Squats',
//       formScore: 0.80,
//       level: 'Intermediate',
//       perfectReps: 15,
//       nextGoal: 'Perfect: 15 \n Needs Practice: 3',
//       icon: Icons.accessibility_new,
//       color: const Color(0xFF673AB7), // Dark Purple
//     ),
//     'PushUps': ExerciseData(
//       category: 'PushUps',
//       formScore: 0.50,
//       level: 'Beginner',
//       perfectReps: 5,
//       nextGoal: 'Perfect: 5 \nNeeds Practice: 10',
//       icon: Icons.directions_run,
//       color: const Color(0xFF4CAF50), // Green
//     ),
//   },
// );

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   late UserData userData;

//   @override
//   void initState() {
//     super.initState();
//     userData = _mockUserData;
//     _simulateDataUpdate(); 
//   }

//   // A method to simulate dynamic updates from your AI backend/service
//   void _simulateDataUpdate() {
//     Future.delayed(const Duration(seconds: 5), () {
//       if (!mounted) return;
//       setState(() {
//         userData.formConsistencyDays = 8;
//         userData.overallFormScore = 0.82;
//         userData.currentFocus = 'Perfect Push-up Form';
//         userData.focusDetail = 'Recommended: 20-min Upper Body Session';
        
//         userData.exercises['PushUps']!.formScore = 0.70;
//         userData.exercises['PushUps']!.level = 'Intermediate';
//         userData.exercises['PushUps']!.perfectReps = 15;
//         userData.exercises['PushUps']!.nextGoal = 'Perfect: 15 \n Needs Practice: 2';
//       });
//       print('UI Updated Dynamically!');
//     });
//   }

//   // Navigation handler
//   void _navigateToWorkout(String exerciseName) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => PoseDetectionScreen(exerciseName: exerciseName),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     List<ExerciseData> primaryWorkouts = [
//       userData.exercises['Strength']!,
//       userData.exercises['Yoga']!,
//     ];
//     List<ExerciseData> specificWorkouts = [
//       userData.exercises['Squats']!,
//       userData.exercises['PushUps']!,
//     ];

//     return Scaffold(
//       backgroundColor: const Color(0xFF121212),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: EdgeInsets.all(20.w),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: <Widget>[
//               _buildHeader(userData.name),
//               SizedBox(height: 25.h),

//               // CLICKABLE: Focus Card navigates to the core feature
//               GestureDetector(
//                 onTap: () => _navigateToWorkout(userData.currentFocus),
//                 child: _buildFocusCard(userData),
//               ),
//               SizedBox(height: 30.h),

//               Text(
//                 'Choose Your Workout',
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 24.sp,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               SizedBox(height: 20.h),

//               // Primary Workout Cards Grid (CLICKABLE)
//               _buildPrimaryWorkoutGrid(primaryWorkouts),
//               SizedBox(height: 20.h),

//               // Specific Exercise Cards Grid (CLICKABLE)
//               _buildSpecificWorkoutGrid(specificWorkouts),
//             ],
//           ),
//         ),
//       ),
//       bottomNavigationBar: _buildBottomBar(context),
//     );
//   }
  
//   Widget _buildHeader(String userName) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: <Widget>[
//         Text(
//           'Hello, $userName!',
//           style: TextStyle(
//             color: Colors.white,
//             fontSize: 26.sp,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         // User Avatar Placeholder (CLICKABLE to Dashboard)
//         GestureDetector(
//           onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfileScreen())),
//           child: Container(
//             width: 45.w,
//             height: 45.w,
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(10.r),
//             ),
//             child: const Icon(Icons.person, color: Colors.black),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildFocusCard(UserData data) {
//     return Container(
//       padding: EdgeInsets.all(18.w),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(15.r),
//         gradient: const LinearGradient(
//           colors: [Color(0xFF673AB7), Color(0xFF9C27B0)], 
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//         ),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.purple.withOpacity(0.3),
//             blurRadius: 10.r,
//             offset: const Offset(0, 5),
//           ),
//         ],
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   "Today's AI Focus",
//                   style: TextStyle(color: Colors.white70, fontSize: 16.sp),
//                 ),
//                 SizedBox(height: 5.h),
//                 Text(
//                   '${data.currentFocus} - ${data.focusDetail}',
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 18.sp,
//                     fontWeight: FontWeight.w600,
//                   ),
//                   maxLines: 2,
//                   overflow: TextOverflow.ellipsis,
//                 ),
//               ],
//             ),
//           ),
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.end,
//             children: [
//               Text(
//                 'Form Streak:',
//                 style: TextStyle(color: Colors.white70, fontSize: 12.sp),
//               ),
//               Text(
//                 '${data.formConsistencyDays} Days',
//                 style: TextStyle(
//                   color: const Color(0xFF00FF88), 
//                   fontSize: 16.sp,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildPrimaryWorkoutGrid(List<ExerciseData> workouts) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: workouts
//           .map((data) => Expanded(
//                 child: Padding(
//                   padding: EdgeInsets.only(
//                       right: data.category == 'Strength' ? 10.w : 0.w),
//                   // CLICKABLE: Workout Category Card
//                   child: GestureDetector(
//                     onTap:() {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => 
//                             ExerciseListScreen(categoryName: data.category),
//                         ),
//                       );
//                     },
//                     // () => _navigateToWorkout(data.category),
//                     child: WorkoutCategoryCard(data: data),
//                   ),
//                 ),
//               ))
//           .toList(),
//     );
//   }

//   Widget _buildSpecificWorkoutGrid(List<ExerciseData> workouts) {
//     return GridView.builder(
//       physics: const NeverScrollableScrollPhysics(),
//       shrinkWrap: true,
//       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//         crossAxisCount: 2,
//         crossAxisSpacing: 10.w,
//         mainAxisSpacing: 10.h, // Adjusted for responsiveness
//         childAspectRatio: 0.85, // Adjusted for responsiveness
//       ),
//       itemCount: workouts.length,
//       itemBuilder: (context, index) {
//         // CLICKABLE: Specific Exercise Card
//         return GestureDetector(
//           onTap: () => _navigateToWorkout(workouts[index].category),
//           child: ExerciseProgressCard(data: workouts[index]), 
//         );
//       },
//     );
//   }

//   Widget _buildBottomBar(BuildContext context) {
//     return Container(
//       decoration: const BoxDecoration(
//         color: Color(0xFF1E1E1E),
//         boxShadow: [
//           BoxShadow(color: Colors.black45, blurRadius: 10),
//         ],
//       ),
//       padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceAround,
//         children: <Widget>[
//           // Home Button
//           Icon(Icons.home, color: const Color(0xFF00FF88), size: 30.sp),
          
//           // Dashboard Button (Trending Up)
//           GestureDetector(
//             onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const DashboardScreen())),
//             child: Icon(Icons.trending_up, color: Colors.grey, size: 30.sp),
//           ),
          
//           // --- Start Workout CTA ---
//           SizedBox(
//             height: 60.h,
//             child: FloatingActionButton.extended(
//               onPressed: () => _navigateToWorkout(userData.currentFocus), // Navigates to the core feature
//               backgroundColor: const Color(0xFF00FF88), 
//               icon: Icon(Icons.videocam, color: Colors.black, size: 24.sp),
//               label: Text(
//                 'Start Workout',
//                 style: TextStyle(
//                   color: Colors.black,
//                   fontWeight: FontWeight.bold,
//                   fontSize: 16.sp,
//                 ),
//               ),
//             ),
//           ),
//           // Profile (Person Icon) - already handled by the header icon
//           // Icon(Icons.person, color: Colors.grey, size: 30.sp),
//           GestureDetector(
//           // Update the builder to point to your new screen
//             onTap: () => Navigator.push(
//               context, 
//               MaterialPageRoute(builder: (context) => const DietPlannerScreen())
//             ),
//             child: Icon(Icons.restaurant_menu, color: Colors.grey, size: 30.sp),
//           ),
          
//           // Settings Button
//           GestureDetector(
//             onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingsScreen())),
//             child: Icon(Icons.settings, color: Colors.grey, size: 30.sp),
//           ),
//         ],
//       ),
//     );
//   }
// }






// import 'package:http/http.dart' as http;
// import 'dart:convert';

// import 'package:ai_trainer/screens/dashboard_screen.dart';
// import 'package:ai_trainer/screens/diet_planner_screen.dart';
// import 'package:ai_trainer/screens/exercise_list_screen.dart';
// import 'package:ai_trainer/screens/pose_detection_screen.dart';
// import 'package:ai_trainer/screens/profile_screen.dart';
// import 'package:ai_trainer/screens/settings_screen.dart';
// import 'package:ai_trainer/secret/api_key.dart';
// import 'package:ai_trainer/widgets/exercise_progress_card.dart';
// import 'package:ai_trainer/widgets/workout_category_card.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import '../models/user_data.dart';

// // --- ADDED: Imports for Voice Assistant ---
// import 'package:speech_to_text/speech_to_text.dart';
// import 'package:speech_to_text/speech_recognition_result.dart';
// import 'package:flutter_tts/flutter_tts.dart';

// // --- ADDED: API Key ---
// // 1. Get your API key from Google AI Studio (https://aistudio.google.com/)
// // 2. For production, use flutter_dotenv to protect this key
// String YOUR_API_KEY = ApiKey; // 👈 PASTE YOUR KEY HERE

// // (Your existing mock data)
// UserData _mockUserData = UserData(
//   name: 'Alex',
//   overallFormScore: 0.78,
//   formConsistencyDays: 7,
//   currentFocus: 'Improve Squat Depth',
//   focusDetail: 'Start 30-min Form Session',
//   exercises: {
//     'Strength': ExerciseData(
//       category: 'Strength',
//       formScore: 0.75,
//       level: 'Advanced Beginner',
//       perfectReps: 0,
//       nextGoal: 'Next Badge: Level Up!',
//       icon: Icons.fitness_center,
//       color: Colors.blueAccent,
//     ),
//     'Yoga': ExerciseData(
//       category: 'Yoga',
//       formScore: 0.85,
//       level: 'Intermediate',
//       perfectReps: 0,
//       nextGoal: 'Next Badge: Unlock Tree Pose',
//       icon: Icons.self_improvement,
//       color: Colors.pinkAccent,
//     ),
//     'Squats': ExerciseData(
//       category: 'Squats',
//       formScore: 0.80,
//       level: 'Intermediate',
//       perfectReps: 15,
//       nextGoal: 'Perfect: 15 \n Needs Practice: 3',
//       icon: Icons.accessibility_new,
//       color: const Color(0xFF673AB7), // Dark Purple
//     ),
//     'PushUps': ExerciseData(
//       category: 'PushUps',
//       formScore: 0.50,
//       level: 'Beginner',
//       perfectReps: 5,
//       nextGoal: 'Perfect: 5 \nNeeds Practice: 10',
//       icon: Icons.directions_run,
//       color: const Color(0xFF4CAF50), // Green
//     ),
//   },
// );

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   late UserData userData;

//   // --- ADDED: State variables for Voice Assistant ---
//   final SpeechToText _speechToText = SpeechToText();
//   final FlutterTts _flutterTts = FlutterTts();

//   bool _isListening = false;
//   bool _isProcessing = false; // To show a loading indicator on the FAB

//   @override
//   void initState() {
//     super.initState();
//     userData = _mockUserData;
//     _simulateDataUpdate();

//     // --- MODIFIED: Initialize Voice Assistant services ---
//     // _geminiModel = GenerativeModel(
//     //   model: 'gemini-1.5-flash',
//     //   apiKey: YOUR_API_KEY,
//     // );
//     _initSpeechToText();
//     _initTextToSpeech();
//   }

//   // --- ADDED: Dispose method ---
//   @override
//   void dispose() {
//     _speechToText.cancel();
//     _flutterTts.stop();
//     super.dispose();
//   }

//   // (Your existing _simulateDataUpdate method)
//   void _simulateDataUpdate() {
//     Future.delayed(const Duration(seconds: 5), () {
//       if (!mounted) return;
//       setState(() {
//         userData.formConsistencyDays = 8;
//         userData.overallFormScore = 0.82;
//         userData.currentFocus = 'Perfect Push-up Form';
//         userData.focusDetail = 'Recommended: 20-min Upper Body Session';
        
//         userData.exercises['PushUps']!.formScore = 0.70;
//         userData.exercises['PushUps']!.level = 'Intermediate';
//         userData.exercises['PushUps']!.perfectReps = 15;
//         userData.exercises['PushUps']!.nextGoal = 'Perfect: 15 \n Needs Practice: 2';
//       });
//       print('UI Updated Dynamically!');
//     });
//   }

//   // (Your existing _navigateToWorkout method)
//   void _navigateToWorkout(String exerciseName) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => PoseDetectionScreen(exerciseName: exerciseName),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     List<ExerciseData> primaryWorkouts = [
//       userData.exercises['Strength']!,
//       userData.exercises['Yoga']!,
//     ];
//     List<ExerciseData> specificWorkouts = [
//       userData.exercises['Squats']!,
//       userData.exercises['PushUps']!,
//     ];

//     return Scaffold(
//       backgroundColor: const Color(0xFF121212),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: EdgeInsets.all(20.w),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: <Widget>[
//               _buildHeader(userData.name),
//               SizedBox(height: 25.h),
//               GestureDetector(
//                 onTap: () => _navigateToWorkout(userData.currentFocus),
//                 child: _buildFocusCard(userData),
//               ),
//               SizedBox(height: 30.h),
//               Text(
//                 'Choose Your Workout',
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 24.sp,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               SizedBox(height: 20.h),
//               _buildPrimaryWorkoutGrid(primaryWorkouts),
//               SizedBox(height: 20.h),
//               _buildSpecificWorkoutGrid(specificWorkouts),
//             ],
//           ),
//         ),
//       ),
//       bottomNavigationBar: _buildBottomBar(context),

//       // --- MODIFIED: Added floatingActionButton and location ---
//       floatingActionButton: FloatingActionButton(
//         onPressed: _isProcessing ? null : (_isListening ? _stopListening : _startListening),
//         tooltip: 'AI Assistant',
//         backgroundColor: _isListening ? Colors.redAccent : const Color(0xFF673AB7), // Match theme
//         child: _isProcessing
//             ? const Padding(
//                 padding: EdgeInsets.all(8.0),
//                 child: CircularProgressIndicator(color: Colors.white),
//               )
//             : Icon(_isListening ? Icons.mic_off : Icons.mic, color: Colors.white),
//       ),
//       floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
//     );
//   }
  
//   // (Your existing _buildHeader method)
//   Widget _buildHeader(String userName) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: <Widget>[
//         Text(
//           'Hello, $userName!',
//           style: TextStyle(
//             color: Colors.white,
//             fontSize: 26.sp,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         GestureDetector(
//           onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfileScreen())),
//           child: Container(
//             width: 45.w,
//             height: 45.w,
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(10.r),
//             ),
//             child: const Icon(Icons.person, color: Colors.black),
//           ),
//         ),
//       ],
//     );
//   }

//   // (Your existing _buildFocusCard method)
//   Widget _buildFocusCard(UserData data) {
//     return Container(
//       padding: EdgeInsets.all(18.w),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(15.r),
//         gradient: const LinearGradient(
//           colors: [Color(0xFF673AB7), Color(0xFF9C27B0)], 
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//         ),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.purple.withOpacity(0.3),
//             blurRadius: 10.r,
//             offset: const Offset(0, 5),
//           ),
//         ],
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   "Today's AI Focus",
//                   style: TextStyle(color: Colors.white70, fontSize: 16.sp),
//                 ),
//                 SizedBox(height: 5.h),
//                 Text(
//                   '${data.currentFocus} - ${data.focusDetail}',
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 18.sp,
//                     fontWeight: FontWeight.w600,
//                   ),
//                   maxLines: 2,
//                   overflow: TextOverflow.ellipsis,
//                 ),
//               ],
//             ),
//           ),
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.end,
//             children: [
//               Text(
//                 'Form Streak:',
//                 style: TextStyle(color: Colors.white70, fontSize: 12.sp),
//               ),
//               Text(
//                 '${data.formConsistencyDays} Days',
//                 style: TextStyle(
//                   color: const Color(0xFF00FF88), 
//                   fontSize: 16.sp,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   // (Your existing _buildPrimaryWorkoutGrid method)
//   Widget _buildPrimaryWorkoutGrid(List<ExerciseData> workouts) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: workouts
//           .map((data) => Expanded(
//                 child: Padding(
//                   padding: EdgeInsets.only(
//                       right: data.category == 'Strength' ? 10.w : 0.w),
//                   child: GestureDetector(
//                     onTap:() {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => 
//                             ExerciseListScreen(categoryName: data.category),
//                         ),
//                       );
//                     },
//                     child: WorkoutCategoryCard(data: data),
//                   ),
//                 ),
//               ))
//           .toList(),
//     );
//   }

//   // (Your existing _buildSpecificWorkoutGrid method)
//   Widget _buildSpecificWorkoutGrid(List<ExerciseData> workouts) {
//     return GridView.builder(
//       physics: const NeverScrollableScrollPhysics(),
//       shrinkWrap: true,
//       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//         crossAxisCount: 2,
//         crossAxisSpacing: 10.w,
//         mainAxisSpacing: 10.h,
//         childAspectRatio: 0.85,
//       ),
//       itemCount: workouts.length,
//       itemBuilder: (context, index) {
//         return GestureDetector(
//           onTap: () => _navigateToWorkout(workouts[index].category),
//           child: ExerciseProgressCard(data: workouts[index]), 
//         );
//       },
//     );
//   }

//   // (Your existing _buildBottomBar method)
//   Widget _buildBottomBar(BuildContext context) {
//     return Container(
//       decoration: const BoxDecoration(
//         color: Color(0xFF1E1E1E),
//         boxShadow: [
//           BoxShadow(color: Colors.black45, blurRadius: 10),
//         ],
//       ),
//       padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceAround,
//         children: <Widget>[
//           Icon(Icons.home, color: const Color(0xFF00FF88), size: 30.sp),
//           GestureDetector(
//             onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const DashboardScreen())),
//             child: Icon(Icons.trending_up, color: Colors.grey, size: 30.sp),
//           ),
//           SizedBox(
//             height: 60.h,
//             child: FloatingActionButton.extended(
//               onPressed: () => _navigateToWorkout(userData.currentFocus),
//               backgroundColor: const Color(0xFF00FF88), 
//               icon: Icon(Icons.videocam, color: Colors.black, size: 24.sp),
//               label: Text(
//                 'Start Workout',
//                 style: TextStyle(
//                   color: Colors.black,
//                   fontWeight: FontWeight.bold,
//                   fontSize: 16.sp,
//                 ),
//               ),
//             ),
//           ),
//           GestureDetector(
//             onTap: () => Navigator.push(
//               context, 
//               MaterialPageRoute(builder: (context) => const DietPlannerScreen())
//             ),
//             child: Icon(Icons.restaurant_menu, color: Colors.grey, size: 30.sp),
//           ),
//           GestureDetector(
//             onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingsScreen())),
//             child: Icon(Icons.settings, color: Colors.grey, size: 30.sp),
//           ),
//         ],
//       ),
//     );
//   }

//   // --- START: ALL NEW METHODS FOR GEMINI VOICE ASSISTANT ---

//   /// Initializes the Speech-to-Text service.
//   Future<void> _initSpeechToText() async {
//     try {
//       await _speechToText.initialize(
//         onError: (error) => print("STT Error: $error"),
//         onStatus: (status) => _handleSpeechStatus(status),
//       );
//     } catch (e) {
//       print("Could not initialize SpeechToText: $e");
//     }
//   }

//   /// Initializes the Text-to-Speech service.
//   Future<void> _initTextToSpeech() async {
//     await _flutterTts.setLanguage("en-US");
//     await _flutterTts.setPitch(1.0);
//     await _flutterTts.setSpeechRate(0.5);
//   }

//   /// Handles the status of the speech recognition.
//   void _handleSpeechStatus(String status) {
//     if (status == 'notListening' && _isListening) {
//       // Automatically stop listening when speech ends
//       _stopListening();
//     }
//   }

//   /// Starts listening to the user's voice.
//   Future<void> _startListening() async {
//     if (!_speechToText.isAvailable) {
//       print("Speech recognition not available.");
//       return;
//     }

//     setState(() {
//       _isListening = true;
//     });

//     // Show a snackbar to indicate listening
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(
//         content: Text("Listening..."),
//         duration: Duration(seconds: 30), // Will be hidden by _stopListening
//       ),
//     );

//     await _speechToText.listen(
//       onResult: _onSpeechResult,
//       listenFor: const Duration(seconds: 30), // Max listen duration
//       pauseFor: const Duration(seconds: 5), // Time to wait after speech ends
//       localeId: "en_US",
//     );
//   }

//   /// Callback for speech recognition results.
//   void _onSpeechResult(SpeechRecognitionResult result) {
//     // When speech is final, send to Gemini
//     if (result.finalResult) {
//       ScaffoldMessenger.of(context).hideCurrentSnackBar(); // Hide "Listening..."
//       _sendToGemini(result.recognizedWords);
//     }
//   }

//   /// Stops the speech recognition.
//   Future<void> _stopListening() async {
//     await _speechToText.stop();
//     ScaffoldMessenger.of(context).hideCurrentSnackBar(); // Hide "Listening..."
//     setState(() {
//       _isListening = false;
//     });
//   }

// // Put your API key here (or use secure storage/dotenv for production)
// final String apiKey = ApiKey; // keep this as you already have

// /// Calls the models list endpoint and returns the parsed JSON.
// Future<Map<String, dynamic>?> _listModels() async {
//   try {
//     final url = Uri.parse('https://generativelanguage.googleapis.com/v1beta/models?key=$apiKey');
//     final res = await http.get(url, headers: {'Content-Type': 'application/json'});

//     if (res.statusCode == 200) {
//       return json.decode(res.body) as Map<String, dynamic>;
//     } else {
//       print('ListModels failed: ${res.statusCode} ${res.body}');
//       return null;
//     }
//   } catch (e) {
//     print('ListModels exception: $e');
//     return null;
//   }
// }

// /// Returns the first model name that supports generateContent (fallbackOrder used if none reported)
// String _chooseModelFromList(Map<String, dynamic>? modelsJson) {
//   final fallbackOrder = [
//     'gemini-2.5-flash',
//     'gemini-2.5-flash-lite',
//     'gemini-2.5-pro',
//     // add other reasonable fallbacks you expect to have access to
//   ];

//   if (modelsJson == null) return fallbackOrder.first;

//   final List items = (modelsJson['models'] ?? []) as List;
//   // Try to find a model entry that explicitly lists generateContent or content generation capability
//   for (var item in items) {
//     try {
//       final id = item['name'] as String?; // like "models/gemini-2.5-flash"
//       final capabilities = item['supportedMethods'] ?? item['capabilities'] ?? [];
//       // some APIs use supportedMethods, check both
//       final nameOnly = id != null ? id.split('/').last : null;
//       if (capabilities is List && capabilities.contains('generateContent')) {
//         if (nameOnly != null) return nameOnly;
//       }
//       // fallback: if id contains gemini-2.5, prefer it
//       if (nameOnly != null && nameOnly.startsWith('gemini-2.5')) return nameOnly;
//     } catch (_) { /* ignore and continue */ }
//   }

//   // If nothing found, return first fallback choice
//   return fallbackOrder.first;
// }

// /// Replaces your existing _sendToGemini. Will list models first if a 404 occurs,
// /// and fall back to a safer model choice.
// Future<void> _sendToGemini(String prompt) async {
//   if (prompt.isEmpty) return;
//   setState(() { _isProcessing = true; });

//   // initial model you tried
//   String modelName = "gemini-1.5-flash";
//   Uri buildUri(String model) => Uri.parse(
//     'https://generativelanguage.googleapis.com/v1beta/models/$model:generateContent?key=$apiKey'
//   );

//   final body = json.encode({
//     'contents': [
//       {
//         'parts': [
//           {'text': prompt}
//         ]
//       }
//     ]
//   });

//   Future<http.Response> postTo(String model) =>
//       http.post(buildUri(model), headers: {'Content-Type': 'application/json'}, body: body);

//   String newResponse = "Sorry, I couldn't understand that.";

//   try {
//     http.Response response = await postTo(modelName);

//     // If model not found (404), query ListModels and pick a supported model
//     if (response.statusCode == 404) {
//       print('Model $modelName not found. Will call ListModels to pick a model.');
//       final modelsJson = await _listModels();
//       final chosen = _chooseModelFromList(modelsJson);
//       print('Switching to model: $chosen');

//       // Try chosen model
//       response = await postTo(chosen);
//       modelName = chosen;
//     }

//     if (response.statusCode == 200) {
//       final responseBody = json.decode(response.body);
//       // defensive navigation of response format
//       try {
//         newResponse = responseBody['candidates']?[0]?['content']?['parts']?[0]?['text']
//             ?? responseBody['candidates']?[0]?['text']
//             ?? responseBody['text']
//             ?? responseBody.toString();
//       } catch (e) {
//         newResponse = responseBody.toString();
//       }
//     } else {
//       print("Error ${response.statusCode}: ${response.body}");
//       newResponse = "Error: Failed to get response. ${response.body}";
//     }
//   } catch (e) {
//     print('Exception sending to Gemini: $e');
//     newResponse = "Error: $e";
//   }

//   // Speak and show dialog (your existing helpers)
//   await _speak(newResponse);
//   if (mounted) _showResponseDialog(prompt, newResponse);

//   setState(() { _isProcessing = false; });
// }

//   /// Sends the user's prompt to the Gemini API using HTTP.
//   // Future<void> _sendToGemini(String prompt) async {
//   //   if (prompt.isEmpty) {
//   //     setState(() => _isProcessing = false);
//   //     return;
//   //   }

//   //   setState(() {
//   //     _isProcessing = true;
//   //   });

//   //   // --- ⚠️ PASTE YOUR API KEY HERE ---
//   //    String apiKey = ApiKey;
    
//   //   // We use gemini-1.5-flash, a fast and capable model
//   //   final String modelName = "gemini-1.5-flash"; 
    
//   //   final url = Uri.parse(
//   //       'https://generativelanguage.googleapis.com/v1beta/models/$modelName:generateContent?key=$apiKey');

//   //   final headers = {
//   //     'Content-Type': 'application/json',
//   //   };

//   //   final body = json.encode({
//   //     'contents': [
//   //       {
//   //         'parts': [
//   //           {'text': prompt}
//   //         ]
//   //       }
//   //     ]
//   //   });

//   //   String newResponse = "Sorry, I couldn't understand that.";

//   //   try {
//   //     final response = await http.post(
//   //       url,
//   //       headers: headers,
//   //       body: body,
//   //     );

//   //     if (response.statusCode == 200) {
//   //       // Successfully got a response
//   //       final responseBody = json.decode(response.body);
        
//   //       // Navigate through the JSON to find the text
//   //       newResponse = responseBody['candidates'][0]['content']['parts'][0]['text'];

//   //     } else {
//   //       // API returned an error
//   //       print("Error: ${response.statusCode}");
//   //       print("Error Body: ${response.body}");
//   //       newResponse = "Error: Failed to get response. ${response.body}";
//   //     }

//   //   } catch (e) {
//   //     // Network or other error
//   //     print("Exception: $e");
//   //     newResponse = "Error: $e";
//   //   }

//   //   // --- (The rest of the function is the same) ---
    
//   //   // Speak the response
//   //   _speak(newResponse);

//   //   // Show the result in a dialog
//   //   if (mounted) {
//   //     _showResponseDialog(prompt, newResponse);
//   //   }

//   //   setState(() {
//   //     _isProcessing = false; // Hide loading spinner
//   //   });
//   // }

//   /// Uses Text-to-Speech to speak the given text.
//   Future<void> _speak(String text) async {
//     await _flutterTts.speak(text);
//   }

//   /// Shows the conversation in an alert dialog.
//   void _showResponseDialog(String userQuery, String geminiResponse) {
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           // Optional: Theme the dialog to match your app
//           // backgroundColor: const Color(0xFF1E1E1E),
//           // titleTextStyle: const TextStyle(color: Colors.white),
//           // contentTextStyle: const TextStyle(color: Colors.white70),
//           title: const Text("AI Assistant"),
//           content: SingleChildScrollView(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Text(
//                   "You said:",
//                   style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
//                 ),
//                 Text(userQuery),
//                 const SizedBox(height: 16),
//                 Text(
//                   "Gemini says:",
//                   style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
//                 ),
//                 Text(geminiResponse),
//               ],
//             ),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 _flutterTts.stop(); // Stop speaking if user closes dialog
//                 Navigator.of(context).pop();
//               },
//               child: const Text("Close"),
//             ),
//           ],
//         );
//       },
//     );
//   }
  
// } 


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
