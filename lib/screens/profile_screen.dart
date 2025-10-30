import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ai_trainer/screens/settings_screen.dart'; // To link to settings
import 'package:percent_indicator/percent_indicator.dart'; // For the form score gauge

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  final String userName = "Alex";
  final String joinDate = "Joined Oct 2025";
  final int totalWorkouts = 84;
  final int totalReps = 10250;
  final double avgFormScore = 0.82; // 82%
  final int formStreak = 14; // days
  
  // Mock list of achievements unlocked by the AI
  final List<Map<String, dynamic>> achievements = const [
    {"icon": Icons.star, "label": "Perfect Squat"},
    {"icon": Icons.shield, "label": "Form Streak: 7 Days"},
    {"icon": Icons.local_fire_department, "label": "100 Workouts"},
    {"icon": Icons.military_tech, "label": "10,000 Rep Club"},
    {"icon": Icons.spa, "label": "Yoga Master"},
  ];

  // Mock personal bests
  final List<Map<String, String>> personalBests = const [
    {"exercise": "Squats", "record": "50 Reps (Perfect Form)"},
    {"exercise": "Push-ups", "record": "25 Reps (Perfect Form)"},
    {"exercise": "Plank", "record": "120 Seconds"},
  ];
  // ---------------------------------------------------------


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E1E1E),
        elevation: 0,
        centerTitle: true,
        title: Text(
          'My Profile',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          // Link to the Settings Screen
          IconButton(
            icon: Icon(Icons.settings, color: Colors.white70, size: 24.sp),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SettingsScreen()),
            ),
          ),
          SizedBox(width: 10.w),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 20.h),
        child: Column(
          children: [
            // --- 1. User Header ---
            _buildUserHeader(),
            SizedBox(height: 25.h),
            
            // --- 2. AI Form Score Gauge (Performance Dashboard) ---
            _buildFormScoreGauge(),
            SizedBox(height: 25.h),
            
            // --- 3. Key AI Stats (Rep Counter, Progress Analytics) ---
            _buildKeyStats(),
            SizedBox(height: 30.h),

            // --- 4. Achievements (Form Classification) ---
            _buildSectionHeader("My Achievements"),
            _buildAchievementsList(),
            SizedBox(height: 30.h),

            // --- 5. Personal Bests ---
            _buildSectionHeader("Personal Bests"),
            _buildPersonalBestsList(),
          ],
        ),
      ),
    );
  }

  Widget _buildUserHeader() {
    return Column(
      children: [
        CircleAvatar(
          radius: 50.r,
          backgroundColor: const Color(0xFF00FF88),
          child: Icon(
            Icons.person,
            size: 60.r,
            color: Colors.black,
          ),
          // TODO: Add backgroundImage: NetworkImage(user.avatarUrl)
        ),
        SizedBox(height: 10.h),
        Text(
          userName,
          style: TextStyle(
            color: Colors.white,
            fontSize: 24.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          joinDate,
          style: TextStyle(
            color: Colors.white70,
            fontSize: 14.sp,
          ),
        ),
      ],
    );
  }

  Widget _buildFormScoreGauge() {
    return CircularPercentIndicator(
      radius: 80.r,
      lineWidth: 10.w,
      percent: avgFormScore,
      center: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "${(avgFormScore * 100).toInt()}%",
            style: TextStyle(
              color: const Color(0xFF00FF88),
              fontSize: 32.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            "Avg. Form Score",
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14.sp,
            ),
          ),
        ],
      ),
      progressColor: const Color(0xFF00FF88),
      backgroundColor: const Color(0xFF1E1E1E),
      circularStrokeCap: CircularStrokeCap.round,
      animation: true,
      animationDuration: 1200,
    );
  }

  Widget _buildKeyStats() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildStatItem(totalWorkouts.toString(), "Workouts"),
        _buildStatItem(totalReps.toString(), "Total Reps"),
        _buildStatItem("$formStreak Days", "Form Streak"),
      ],
    );
  }

  Widget _buildStatItem(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          label,
          style: TextStyle(
            color: Colors.white70,
            fontSize: 14.sp,
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          color: Colors.white70,
          fontSize: 14.sp,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.1,
        ),
      ),
    );
  }

  Widget _buildAchievementsList() {
    return Container(
      height: 100.h,
      margin: EdgeInsets.only(top: 15.h),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        itemCount: achievements.length,
        itemBuilder: (context, index) {
          final achievement = achievements[index];
          return Container(
            width: 90.w,
            margin: EdgeInsets.only(right: 10.w),
            decoration: BoxDecoration(
              color: const Color(0xFF1E1E1E),
              borderRadius: BorderRadius.circular(15.r),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  achievement['icon'],
                  color: const Color(0xFF00FF88),
                  size: 30.sp,
                ),
                SizedBox(height: 8.h),
                Text(
                  achievement['label'],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12.sp,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildPersonalBestsList() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E1E),
          borderRadius: BorderRadius.circular(15.r),
        ),
        child: Column(
          children: personalBests.map((pb) {
            return ListTile(
              leading: Icon(
                Icons.emoji_events,
                color: Colors.amber,
                size: 24.sp,
              ),
              title: Text(
                pb['exercise']!,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              subtitle: Text(
                pb['record']!,
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14.sp,
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
