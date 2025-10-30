import 'package:ai_trainer/exercise_progress_card.dart';
import 'package:ai_trainer/workout_category_card.dart';
import 'package:flutter/material.dart';

// --- DATA MODEL (Simplified for UI) ---
class WorkoutData {
  final String title;
  final String subTitle;
  final double formScore; // 0.0 to 1.0
  final IconData icon;
  final Color color;
  final String levelDetail;

  WorkoutData({
    required this.title,
    required this.subTitle,
    required this.formScore,
    required this.icon,
    required this.color,
    required this.levelDetail,
  });
}

// --- MAIN SCREEN WIDGET ---
class HomeScreen extends StatelessWidget {
  // Mock data to populate the cards
  final List<WorkoutData> primaryWorkouts = [
    WorkoutData(
      title: 'Strength',
      subTitle: '75% Perfect Form Average',
      formScore: 0.75,
      icon: Icons.fitness_center,
      color: Colors.blueAccent,
      levelDetail: 'Next Badge: Level Up!',
    ),
    WorkoutData(
      title: 'Yoga',
      subTitle: 'Focus on Balance & Stability',
      formScore: 0.85,
      icon: Icons.self_improvement,
      color: Colors.pinkAccent,
      levelDetail: 'Next Badge: Unlock Tree Pose',
    ),
  ];

  final List<WorkoutData> specificWorkouts = [
    WorkoutData(
      title: 'Squats',
      subTitle: '80% Form Score | 15 Perfect Reps',
      formScore: 0.80,
      icon: Icons.accessibility_new,
      color: const Color(0xFF673AB7), // Dark Purple
      levelDetail: 'Lv: Intermediate',
    ),
    WorkoutData(
      title: 'Push-ups',
      subTitle: '50% Form Score | Needs Practice',
      formScore: 0.50,
      icon: Icons.directions_run,
      color: const Color(0xFF4CAF50), // Green
      levelDetail: 'Lv: Beginner',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212), // Dark Background
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // --- Header ---
              _buildHeader(),
              const SizedBox(height: 25),

              // --- Today's Focus Card (Personalization) ---
              _buildFocusCard(),
              const SizedBox(height: 30),

              // --- Choose Your Workout ---
              const Text(
                'Choose Your Workout',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),

              // --- Primary Workout Cards (Strength/Yoga) ---
              _buildPrimaryWorkoutGrid(),
              const SizedBox(height: 20),

              // --- Specific Exercise Cards (Squats/Push-ups) ---
              _buildSpecificWorkoutGrid(),
            ],
          ),
        ),
      ),
      // --- Bottom Navigation and CTA ---
      bottomNavigationBar: _buildBottomBar(context),
    );
  }
  
  // --- Header Widget ---
  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        const Text(
          'AI Gym Trainer',
          style: TextStyle(
            color: Colors.white,
            fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
        ),
        // User Avatar
        Container(
          width: 45,
          height: 45,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.0),
            image: const DecorationImage(
              image: AssetImage('assets/trainer_avatar.png'), // Placeholder
              fit: BoxFit.cover,
            ),
          ),
        ),
      ],
    );
  }

  // --- Focus Card Widget (PS #12: Personalized Progress Analytics) ---
  Widget _buildFocusCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        gradient: const LinearGradient(
          colors: [Color(0xFF673AB7), Color(0xFF9C27B0)], // Purple Gradient
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.purple.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Today's AI Focus",
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 5),
              const Text(
                'Improve Squat Depth - 30-min Session',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const Icon(
            Icons.arrow_forward_ios,
            color: Colors.white70,
            size: 18,
          ),
        ],
      ),
    );
  }

  // --- Primary Workout Grid ---
  Widget _buildPrimaryWorkoutGrid() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: primaryWorkouts
          .map((data) => Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                      right: data.title == 'Strength' ? 10.0 : 0.0),
                  child: WorkoutCategoryCard(data: data),
                ),
              ))
          .toList(),
    );
  }

  // --- Specific Workout Grid ---
  Widget _buildSpecificWorkoutGrid() {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(), // Important for nested scrolling
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10.0,
        mainAxisSpacing: 10.0,
        childAspectRatio: 0.9,
      ),
      itemCount: specificWorkouts.length,
      itemBuilder: (context, index) {
        return ExerciseProgressCard(data: specificWorkouts[index]);
      },
    );
  }

  // --- Bottom Navigation Bar ---
  Widget _buildBottomBar(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF1E1E1E), // Slightly lighter dark color
        boxShadow: [
          BoxShadow(
            color: Colors.black45,
            blurRadius: 10,
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          const Icon(Icons.home, color: Colors.greenAccent, size: 30),
          const Icon(Icons.trending_up, color: Colors.grey, size: 30),
          // --- Start Workout CTA (Form Correction/Audio Feedback) ---
          SizedBox(
            height: 60,
            child: FloatingActionButton.extended(
              onPressed: () {
                // TODO: Navigate to Camera/Form Detection Screen
                print('Starting workout...');
              },
              backgroundColor: const Color(0xFF00FF88), // Bright Green
              icon: const Icon(Icons.videocam, color: Colors.black),
              label: const Text(
                'Start Workout',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          const Icon(Icons.person, color: Colors.grey, size: 30),
          const Icon(Icons.settings, color: Colors.grey, size: 30),
        ],
      ),
    );
  }
}