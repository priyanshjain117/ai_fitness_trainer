import 'package:flutter/material.dart';

class UserData {
  String name;
  String currentFocus;
  String focusDetail;
  int formConsistencyDays;
  double overallFormScore;
  Map<String, ExerciseData> exercises;

  UserData({
    required this.name,
    required this.currentFocus,
    required this.focusDetail,
    required this.formConsistencyDays,
    required this.overallFormScore,
    required this.exercises,
  });
}

class ExerciseData {
  String category;
  double formScore; // 0.0 to 1.0 (Form Classification)
  String level;
  int perfectReps; // Repetition Counter
  String nextGoal;
  IconData icon;
  Color color;

  ExerciseData({
    required this.category,
    required this.formScore,
    required this.level,
    required this.perfectReps,
    required this.nextGoal,
    required this.icon,
    required this.color,
  });
}
