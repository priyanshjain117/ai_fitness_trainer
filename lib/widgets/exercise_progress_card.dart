import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:percent_indicator/percent_indicator.dart';
import '../models/user_data.dart';

class ExerciseProgressCard extends StatelessWidget {
  final ExerciseData data;

  const ExerciseProgressCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.w),
      decoration: BoxDecoration( 
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(15.r),
        border: Border.all(color: Colors.grey.shade800, width: 1.w),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // Placeholder Icon/Image
          Container(
            height: 85.h,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(data.icon, color: data.color, size: 40.sp),
          ),
          SizedBox(height: 10.h),
          Text(
            data.category, 
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          // const Spacer(), 
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              // Circular Progress Indicator for Form Score
              CircularPercentIndicator(
                radius: 20.r,
                lineWidth: 4.w,
                percent: data.formScore,
                center: Text(
                  "${(data.formScore * 100).toInt()}%",
                  style: TextStyle(color: Colors.white, fontSize: 10.sp),
                ),
                progressColor: data.color,
                backgroundColor: Colors.grey.shade700,
              ),
              SizedBox(width: 8.w),
              
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Lv: ${data.level}', 
                      style: TextStyle(color: Colors.white70, fontSize: 12.sp),
                    ),
                    Text(
                      data.nextGoal, 
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
