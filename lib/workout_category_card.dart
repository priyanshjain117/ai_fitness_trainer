// For Strength/Yoga cards
import 'package:ai_trainer/home_screen.dart';
import 'package:flutter/material.dart';

class WorkoutCategoryCard extends StatelessWidget {
  final WorkoutData data;

  const WorkoutCategoryCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: data.color, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Icon(data.icon, color: data.color, size: 30),
          const SizedBox(height: 8),
          Text(
            data.title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          // Linear Progress Bar (PS #12: Performance Dashboard)
          LinearProgressIndicator(
            value: data.formScore,
            backgroundColor: Colors.grey.shade800,
            valueColor: AlwaysStoppedAnimation<Color>(data.color),
          ),
          const SizedBox(height: 5),
          Text(
            data.subTitle, // e.g., "75% Perfect Form Average"
            style: TextStyle(
              color: Colors.white70,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}