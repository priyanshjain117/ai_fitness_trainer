import 'package:ai_trainer/screens/dashboard_screen.dart';
import 'package:ai_trainer/screens/diet_planner_screen.dart';
import 'package:ai_trainer/screens/exercise_list_screen.dart';
import 'package:ai_trainer/screens/pose_detection_screen.dart';
import 'package:ai_trainer/screens/profile_screen.dart';
import 'package:ai_trainer/screens/settings_screen.dart';
import 'package:ai_trainer/widgets/exercise_progress_card.dart';
import 'package:ai_trainer/widgets/workout_category_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../models/user_data.dart';
// Placeholder/Simulated User Data
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
      color: const Color(0xFF673AB7), // Dark Purple
    ),
    'PushUps': ExerciseData(
      category: 'PushUps',
      formScore: 0.50,
      level: 'Beginner',
      perfectReps: 5,
      nextGoal: 'Perfect: 5 \nNeeds Practice: 10',
      icon: Icons.directions_run,
      color: const Color(0xFF4CAF50), // Green
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

  @override
  void initState() {
    super.initState();
    userData = _mockUserData;
    _simulateDataUpdate(); 
  }

  // A method to simulate dynamic updates from your AI backend/service
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

  // Navigation handler
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

              // CLICKABLE: Focus Card navigates to the core feature
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

              // Primary Workout Cards Grid (CLICKABLE)
              _buildPrimaryWorkoutGrid(primaryWorkouts),
              SizedBox(height: 20.h),

              // Specific Exercise Cards Grid (CLICKABLE)
              _buildSpecificWorkoutGrid(specificWorkouts),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomBar(context),
    );
  }
  
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
        // User Avatar Placeholder (CLICKABLE to Dashboard)
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
                  // CLICKABLE: Workout Category Card
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
                    // () => _navigateToWorkout(data.category),
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
        mainAxisSpacing: 10.h, // Adjusted for responsiveness
        childAspectRatio: 0.85, // Adjusted for responsiveness
      ),
      itemCount: workouts.length,
      itemBuilder: (context, index) {
        // CLICKABLE: Specific Exercise Card
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
          // Home Button
          Icon(Icons.home, color: const Color(0xFF00FF88), size: 30.sp),
          
          // Dashboard Button (Trending Up)
          GestureDetector(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const DashboardScreen())),
            child: Icon(Icons.trending_up, color: Colors.grey, size: 30.sp),
          ),
          
          // --- Start Workout CTA ---
          SizedBox(
            height: 60.h,
            child: FloatingActionButton.extended(
              onPressed: () => _navigateToWorkout(userData.currentFocus), // Navigates to the core feature
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
          // Profile (Person Icon) - already handled by the header icon
          // Icon(Icons.person, color: Colors.grey, size: 30.sp),
          GestureDetector(
          // Update the builder to point to your new screen
            onTap: () => Navigator.push(
              context, 
              MaterialPageRoute(builder: (context) => const DietPlannerScreen())
            ),
            child: Icon(Icons.restaurant_menu, color: Colors.grey, size: 30.sp),
          ),
          
          // Settings Button
          GestureDetector(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingsScreen())),
            child: Icon(Icons.settings, color: Colors.grey, size: 30.sp),
          ),
        ],
      ),
    );
  }
}
