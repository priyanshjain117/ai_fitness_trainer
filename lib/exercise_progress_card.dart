import 'package:ai_trainer/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class ExerciseProgressCard extends StatelessWidget {
  final WorkoutData data;

  const ExerciseProgressCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey.shade800, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // Placeholder Image/Icon
          Container(
            height: 60,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(data.icon, color: data.color, size: 40),
          ),
          const SizedBox(height: 10),
          Text(
            data.title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          Row(
            children: <Widget>[
              // Circular Progress Indicator for Form Score
              CircularPercentIndicator(
                radius: 20.0,
                lineWidth: 4.0,
                percent: data.formScore,
                center: Text(
                  "${(data.formScore * 100).toInt()}%",
                  style: const TextStyle(color: Colors.white, fontSize: 10),
                ),
                progressColor: data.color,
                backgroundColor: Colors.grey.shade700,
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data.levelDetail, // Lv: Beginner/Intermediate
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    data.subTitle.split('|')[1].trim(), // e.g., 15 Perfect Reps
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}