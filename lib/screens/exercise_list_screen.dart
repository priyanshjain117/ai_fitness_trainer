import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ai_trainer/screens/pose_detection_screen.dart'; // To start the workout

// Mock data for the exercise lists
// In a real app, this would come from your UserData model or a database
const Map<String, List<Map<String, dynamic>>> exerciseCategoryData = {
  'Strength': [
    {'name': 'Squats', 'icon': Icons.accessibility_new, 'duration': '5 min'},
    {'name': 'Push-ups', 'icon': Icons.directions_run, 'duration': '3 min'},
    {'name': 'Lunges', 'icon': Icons.airline_seat_legroom_normal, 'duration': '4 min'},
    {'name': 'Plank', 'icon': Icons.horizontal_rule, 'duration': '2 min'},
  ],
  'Yoga': [
    {'name': 'Tree Pose', 'icon': Icons.self_improvement, 'duration': '3 min'},
    {'name': 'Warrior II', 'icon': Icons.self_improvement, 'duration': '5 min'},
    {'name': 'Downward Dog', 'icon': Icons.self_improvement, 'duration': '2 min'},
  ],
};

class ExerciseListScreen extends StatelessWidget {
  final String categoryName;

  const ExerciseListScreen({super.key, required this.categoryName});

  @override
  Widget build(BuildContext context) {
    // Get the list of exercises for the selected category
    final List<Map<String, dynamic>> exercises = 
        exerciseCategoryData[categoryName] ?? [];

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E1E1E),
        elevation: 0,
        centerTitle: true,
        title: Text(
          '$categoryName Exercises',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(15.w),
        itemCount: exercises.length,
        itemBuilder: (context, index) {
          final exercise = exercises[index];
          return _buildExerciseTile(
            context: context,
            name: exercise['name'],
            duration: exercise['duration'],
            icon: exercise['icon'],
          );
        },
      ),
    );
  }

  /// Builds a single clickable exercise tile
  Widget _buildExerciseTile({
    required BuildContext context,
    required String name,
    required String duration,
    required IconData icon,
  }) {
    return Card(
      color: const Color(0xFF1E1E1E),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.r),
      ),
      margin: EdgeInsets.only(bottom: 15.h),
      child: ListTile(
        contentPadding: EdgeInsets.all(15.w),
        leading: Icon(
          icon,
          color: const Color(0xFF00FF88),
          size: 30.sp,
        ),
        title: Text(
          name,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          "Est. $duration",
          style: TextStyle(
            color: Colors.white70,
            fontSize: 14.sp,
          ),
        ),
        trailing: Icon(
          Icons.play_circle_fill,
          color: const Color(0xFF00FF88),
          size: 35.sp,
        ),
        onTap: () {
          // Navigate to the AI Pose Detection Screen with the *specific* exercise
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PoseDetectionScreen(exerciseName: name),
            ),
          );
        },
      ),
    );
  }
}
