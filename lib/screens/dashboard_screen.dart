import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:percent_indicator/circular_percent_indicator.dart'; 

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: Text(
          'Performance Dashboard',
          style: TextStyle(
            fontSize: 22.sp, 
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF1E1E1E),
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- 1. Form Progress Chart ---
            _buildSectionHeader("Form Score Over Time"),
            SizedBox(height: 15.h),
            _buildProgressChart(),
            SizedBox(height: 30.h),

            // --- 2. Key AI Insights ---
            _buildSectionHeader("Key AI Insights"),
            SizedBox(height: 15.h),
            _buildMetricCard(
              title: 'Overall Form Score',
              value: '82%',
              detail: 'Up 4% since last week. Keep it up!',
              color: const Color(0xFF00FF88),
            ),
            _buildMetricCard(
              title: 'Injury Prevention Tip',
              value: 'Minor Hip Shift',
              detail: 'AI detected minor hip shift in 5% of squats. Focus on core engagement.',
              color: Colors.pinkAccent,
            ),
            
            // --- 3. Form Classification Breakdown ---
            _buildSectionHeader("Exercise Form Breakdown"),
            SizedBox(height: 15.h),
            _buildExerciseFormCard(
              exercise: "Squats",
              formScore: 0.85, // 85%
              classification: "Almost Perfect",
              tip: "Good depth, watch for minor knee wobble.",
            ),
            _buildExerciseFormCard(
              exercise: "Push-ups",
              formScore: 0.70, // 70%
              classification: "Needs Practice",
              tip: "Back is arching. Engage your core.",
            ),
            _buildExerciseFormCard(
              exercise: "Plank",
              formScore: 0.95, // 95%
              classification: "Perfect",
              tip: "Excellent stability and form.",
            ),
          ],
        ),
      ),
    );
  }

  /// Builds the section headers (e.g., "Key AI Insights")
  Widget _buildSectionHeader(String title) {
    return Text(
      title.toUpperCase(),
      style: TextStyle(
        color: Colors.white70,
        fontSize: 14.sp,
        fontWeight: FontWeight.bold,
        letterSpacing: 1.1,
      ),
    );
  }

  /// Builds the main line chart for progress
  Widget _buildProgressChart() {
    return Container(
      height: 200.h,
      padding: EdgeInsets.all(15.w),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(15.r),
      ),
      child: LineChart(
        LineChartData(
          backgroundColor: const Color(0xFF1E1E1E),
          gridData: FlGridData(
            show: true,
            drawVerticalLine: true,
            getDrawingHorizontalLine: (value) {
              return FlLine(color: Colors.white.withOpacity(0.1), strokeWidth: 1);
            },
            getDrawingVerticalLine: (value) {
              return FlLine(color: Colors.white.withOpacity(0.1), strokeWidth: 1);
            },
          ),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40.w,
                getTitlesWidget: (value, meta) {
                  return Text(
                    "${value.toInt()}%",
                    style: TextStyle(color: Colors.white70, fontSize: 10.sp),
                  );
                },
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 30.h,
                getTitlesWidget: (value, meta) {
                  String text = '';
                  switch (value.toInt()) {
                    case 0: text = 'Mon'; break;
                    case 2: text = 'Wed'; break;
                    case 4: text = 'Fri'; break;
                    case 6: text = 'Sun'; break;
                  }
                  return Padding(
                    padding: EdgeInsets.only(top: 8.h),
                    child: Text(
                      text,
                      style: TextStyle(color: Colors.white70, fontSize: 10.sp),
                    ),
                  );
                },
              ),
            ),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          borderData: FlBorderData(show: false),
          minX: 0,
          maxX: 6,
          minY: 50, // Min form score
          maxY: 100, // Max form score
          lineBarsData: [
            LineChartBarData(
              spots: const [
                FlSpot(0, 75), // Mon
                FlSpot(1, 78), // Tue
                FlSpot(2, 77), // Wed
                FlSpot(3, 80), // Thu
                FlSpot(4, 85), // Fri
                FlSpot(5, 84), // Sat
                FlSpot(6, 88), // Sun
              ],
              isCurved: true,
              color: const Color(0xFF00FF88),
              barWidth: 4.w,
              isStrokeCapRound: true,
              dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                color: const Color(0xFF00FF88).withOpacity(0.2),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds the summary metric cards
  Widget _buildMetricCard({required String title, required String value, required String detail, required Color color}) {
    return Container(
      margin: EdgeInsets.only(bottom: 15.h),
      padding: EdgeInsets.all(15.w),
      width: double.infinity,
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

  /// Builds a card for individual exercise form scores
  Widget _buildExerciseFormCard({
    required String exercise,
    required double formScore,
    required String classification,
    required String tip,
  }) {
    Color scoreColor;
    if (formScore > 0.9) {
      scoreColor = const Color(0xFF00FF88); // Perfect
    } else if (formScore > 0.75) {
      scoreColor = Colors.amber; // Almost There
    } else {
      scoreColor = Colors.redAccent; // Needs Practice
    }

    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      padding: EdgeInsets.all(15.w),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(15.r),
      ),
      child: Row(
        children: [
          CircularPercentIndicator(
            radius: 30.r,
            lineWidth: 5.w,
            percent: formScore,
            center: Text(
              "${(formScore * 100).toInt()}%",
              style: TextStyle(
                color: Colors.white,
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            progressColor: scoreColor,
            backgroundColor: Colors.grey.shade800,
          ),
          SizedBox(width: 15.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  exercise,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  classification.toUpperCase(),
                  style: TextStyle(
                    color: scoreColor,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 5.h),
                Text(
                  "AI Tip: $tip",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 13.sp,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

