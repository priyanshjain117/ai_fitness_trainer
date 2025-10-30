import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: Text(
          'Performance Dashboard',
          style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF1E1E1E),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Goal: Continuous Form Improvement (AI-Driven)',
              style: TextStyle(color: Colors.white70, fontSize: 18.sp),
            ),
            SizedBox(height: 20.h),
            _buildMetricCard(
              title: 'Overall Form Score',
              value: '82%',
              detail: 'Up 4% since last week. Keep it up!',
              color: const Color(0xFF00FF88),
            ),
            _buildMetricCard(
              title: 'Repetition Counter Trend',
              value: '+10 Total Reps',
              detail: 'Push-ups saw the biggest increase (15 perfect reps).',
              color: Colors.blueAccent,
            ),
            _buildMetricCard(
              title: 'Injury Prevention Insights',
              value: 'Stable',
              detail: 'AI detected minor hip shift in 5% of squats. Focus on core engagement.',
              color: Colors.pinkAccent,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricCard({required String title, required String value, required String detail, required Color color}) {
    return Container(
      margin: EdgeInsets.only(bottom: 15.h),
      padding: EdgeInsets.all(15.w),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(15.r),
        border: Border.all(color: color.withOpacity(0.5), width: 1.w),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(color: Colors.white, fontSize: 18.sp, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 5.h),
          Text(
            value,
            style: TextStyle(color: color, fontSize: 32.sp, fontWeight: FontWeight.w900),
          ),
          SizedBox(height: 10.h),
          Text(
            detail,
            style: TextStyle(color: Colors.white70, fontSize: 14.sp),
          ),
        ],
      ),
    );
  }
}
