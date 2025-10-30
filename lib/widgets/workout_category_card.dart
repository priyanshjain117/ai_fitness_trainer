import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../models/user_data.dart';

// --- 1. WorkoutCategoryCard (Large Card for Strength/Yoga) ---
class WorkoutCategoryCard extends StatelessWidget {
  final ExerciseData data;

  const WorkoutCategoryCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final Color accentColor = data.color;

    return Container(
      height: 180.h,
      padding: EdgeInsets.all(15.w),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E), 
        borderRadius: BorderRadius.circular(15.r),
        border: Border.all(color: accentColor, width: 2.w), 
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Icon(data.icon, color: accentColor, size: 30.sp),
          SizedBox(height: 8.h),

          Text(
            data.category,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(), 

          // Linear Progress Bar (Form Classification)
          LinearProgressIndicator(
            value: data.formScore,
            backgroundColor: Colors.grey.shade800,
            valueColor: AlwaysStoppedAnimation<Color>(accentColor),
          ),
          SizedBox(height: 5.h),

          // Subtitle showing the form average
          Text(
            '${(data.formScore * 100).toInt()}% Perfect Form Average',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 12.sp,
            ),
          ),

          // Next Goal/Badge Detail
          Text(
            data.nextGoal, 
            style: TextStyle(
              color: accentColor.withOpacity(0.8),
              fontSize: 11.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}