import 'dart:ui'; // Required for Offset
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';

import '../models/exercise_state.dart';

class PosePainter extends CustomPainter {
  PosePainter(
    this.poses,
    this.imageSize,
    this.cameraLensDirection,
    this.formState, // Added to control paint color
  );

  final List<Pose> poses;
  final Size imageSize;
  final CameraLensDirection cameraLensDirection;
  final ExerciseState formState; // e.g., ready, performing, needsCorrection

  @override
  void paint(Canvas canvas, Size size) {
    // --- Define Paint Styles ---
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

    // Determine which paint to use based on the current form state
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

    // --- Helper function to draw lines between two landmarks ---
    void paintLine(
        PoseLandmarkType type1, PoseLandmarkType type2, Paint paint) {
      final PoseLandmark landmark1 = poses.first.landmarks[type1]!;
      final PoseLandmark landmark2 = poses.first.landmarks[type2]!;

      // We scale the points from the image coordinate system to the
      // screen (canvas) coordinate system.
      canvas.drawLine(
        _scalePoint(landmark1, size),
        _scalePoint(landmark2, size), // <-- This was the corrected line
        paint,
      );
    }

    // --- Iterate through poses (usually just one) ---
    for (final pose in poses) {
      // Draw all 33 landmark points
      pose.landmarks.forEach((_, landmark) {
        canvas.drawCircle(
          _scalePoint(landmark, size),
          2.0, // Dot radius
          paintDots,
        );
      });

      // --- Draw Arms ---
      paintLine(
          PoseLandmarkType.leftShoulder, PoseLandmarkType.leftElbow, linePaint);
      paintLine(
          PoseLandmarkType.leftElbow, PoseLandmarkType.leftWrist, linePaint);
      paintLine(PoseLandmarkType.rightShoulder, PoseLandmarkType.rightElbow,
          linePaint);
      paintLine(
          PoseLandmarkType.rightElbow, PoseLandmarkType.rightWrist, linePaint);

      // --- Draw Torso ---
      paintLine(PoseLandmarkType.leftShoulder, PoseLandmarkType.rightShoulder,
          linePaint);
      paintLine(PoseLandmarkType.leftHip, PoseLandmarkType.rightHip, linePaint);
      paintLine(
          PoseLandmarkType.leftShoulder, PoseLandmarkType.leftHip, linePaint);
      paintLine(
          PoseLandmarkType.rightShoulder, PoseLandmarkType.rightHip, linePaint);

      // --- Draw Legs ---
      paintLine(PoseLandmarkType.leftHip, PoseLandmarkType.leftKnee, linePaint);
      paintLine(
          PoseLandmarkType.leftKnee, PoseLandmarkType.leftAnkle, linePaint);
      paintLine(
          PoseLandmarkType.rightHip, PoseLandmarkType.rightKnee, linePaint);
      paintLine(
          PoseLandmarkType.rightKnee, PoseLandmarkType.rightAnkle, linePaint);
    }
  }

  /// Scales a landmark point from the ML Kit image coordinate system
  /// to the screen's coordinate system (where the canvas is).
  Offset _scalePoint(PoseLandmark landmark, Size size) {
    // Get the coordinates from the ML Kit model
    double x = landmark.x;
    double y = landmark.y;

    // ML Kit's coordinates are based on the *image* size.
    // We need to scale them to the *screen* size.
    final double scaleX = size.width / imageSize.width;
    final double scaleY = size.height / imageSize.height;

    // When using the front camera, the image is mirrored horizontally.
    // We need to "flip" the X-coordinate to match what the user sees.
    if (cameraLensDirection == CameraLensDirection.front) {
      x = imageSize.width - x;
    }

    // Apply the scaling
    return Offset(x * scaleX, y * scaleY);
  }

  @override
  bool shouldRepaint(covariant PosePainter oldDelegate) {
    // Repaint if the poses, image size, or form state have changed
    return oldDelegate.poses != poses ||
        oldDelegate.imageSize != imageSize ||
        oldDelegate.formState != formState;
  }
}


// In lib/screens/pose_detection_screen.dart, inside the build method:

// ...
// if (_imageSize != null)
//   Positioned.fill(
//     child: CustomPaint(
//       painter: PosePainter(
//         _poses,
//         _imageSize!,
//         _controller!.description.lensDirection,
//         _currentState, // <-- Pass the current state here
//       ),
//     ),
//   ),
// ...
