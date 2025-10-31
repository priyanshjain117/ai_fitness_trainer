import 'dart:ui'; 
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';

import '../models/exercise_state.dart';

class PosePainter extends CustomPainter {
  PosePainter(
    this.poses,
    this.imageSize,
    this.cameraLensDirection,
    this.formState, 
  );

  final List<Pose> poses;
  final Size imageSize;
  final CameraLensDirection cameraLensDirection;
  final ExerciseState formState; 

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paintPerfect = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0
      ..color = const Color(0xFF00FF88); // "Perfect Form" color

    final Paint paintNeedsCorrection = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0
      ..color = Colors.redAccent; // "Needs Correction" color

    final Paint paintReady = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0
      ..color = Colors.blueGrey; // "Ready" color

    final Paint paintDots = Paint()
      ..style = PaintingStyle.fill
      ..strokeWidth = 4.0
      ..color = Colors.white.withOpacity(0.8);

    Paint linePaint;
    switch (formState) {
      case ExerciseState.performing:
        linePaint = paintPerfect;
        break;
      case ExerciseState.needsCorrection:
        linePaint = paintNeedsCorrection;
        break;
      case ExerciseState.ready:
      default:
        linePaint = paintReady;
    }


    void paintLine(
        PoseLandmarkType type1, PoseLandmarkType type2, Paint paint) {
      final PoseLandmark landmark1 = poses.first.landmarks[type1]!;
      final PoseLandmark landmark2 = poses.first.landmarks[type2]!;

      canvas.drawLine(
        _scalePoint(landmark1, size),
        _scalePoint(landmark2, size), 
        paint,
      );
    }

    for (final pose in poses) {
      pose.landmarks.forEach((_, landmark) {
        canvas.drawCircle(
          _scalePoint(landmark, size),
          2.0, 
          paintDots,
        );
      });

      paintLine(
          PoseLandmarkType.leftShoulder, PoseLandmarkType.leftElbow, linePaint);
      paintLine(
          PoseLandmarkType.leftElbow, PoseLandmarkType.leftWrist, linePaint);
      paintLine(PoseLandmarkType.rightShoulder, PoseLandmarkType.rightElbow,
          linePaint);
      paintLine(
          PoseLandmarkType.rightElbow, PoseLandmarkType.rightWrist, linePaint);


      paintLine(PoseLandmarkType.leftShoulder, PoseLandmarkType.rightShoulder,
          linePaint);
      paintLine(PoseLandmarkType.leftHip, PoseLandmarkType.rightHip, linePaint);
      paintLine(
          PoseLandmarkType.leftShoulder, PoseLandmarkType.leftHip, linePaint);
      paintLine(
          PoseLandmarkType.rightShoulder, PoseLandmarkType.rightHip, linePaint);


      paintLine(PoseLandmarkType.leftHip, PoseLandmarkType.leftKnee, linePaint);
      paintLine(
          PoseLandmarkType.leftKnee, PoseLandmarkType.leftAnkle, linePaint);
      paintLine(
          PoseLandmarkType.rightHip, PoseLandmarkType.rightKnee, linePaint);
      paintLine(
          PoseLandmarkType.rightKnee, PoseLandmarkType.rightAnkle, linePaint);
    }
  }

  Offset _scalePoint(PoseLandmark landmark, Size size) {
    double x = landmark.x;
    double y = landmark.y;

    final double scaleX = size.width / imageSize.width;
    final double scaleY = size.height / imageSize.height;

    if (cameraLensDirection == CameraLensDirection.front) {
      x = imageSize.width - x;
    }

    return Offset(x * scaleX, y * scaleY);
  }

  @override
  bool shouldRepaint(covariant PosePainter oldDelegate) {
    return oldDelegate.poses != poses ||
        oldDelegate.imageSize != imageSize ||
        oldDelegate.formState != formState;
  }
}

