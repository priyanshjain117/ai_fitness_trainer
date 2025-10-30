import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:camera/camera.dart';

// Mock Exercise Data
enum ExerciseState { ready, performing, needsCorrection }

class PoseDetectionScreen extends StatefulWidget {
  final String exerciseName;
  const PoseDetectionScreen({super.key, required this.exerciseName});

  @override
  State<PoseDetectionScreen> createState() => _PoseDetectionScreenState();
}

class _PoseDetectionScreenState extends State<PoseDetectionScreen> {
  CameraController? _controller;
  List<CameraDescription>? _cameras;
  ExerciseState _currentState = ExerciseState.ready;
  int _reps = 0;
  String _feedback = "Place yourself in the frame to begin.";

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    _startMockDetection();
  }

  Future<void> _initializeCamera() async {
    try {
      _cameras = await availableCameras();
      if (_cameras != null && _cameras!.isNotEmpty) {
        _controller = CameraController(_cameras![0], ResolutionPreset.low);
        await _controller!.initialize();
        if (mounted) {
          setState(() {});
        }
      }
    } catch (e) {
      print("Error initializing camera: $e");
    }
  }

  // MOCK: Simulates the AI model providing real-time feedback
  void _startMockDetection() {
    Future.delayed(const Duration(seconds: 3), () {
      if (!mounted) return;
      setState(() {
        _currentState = ExerciseState.performing;
        _feedback = "Perfect form! Keep going.";
      });
      _startRepCounter();
    });
  }

  void _startRepCounter() {
    // MOCK: Simulates Repetition Counter and Form Classification
    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted) return;
      
      if (_reps < 5) {
        setState(() {
          _reps++;
          if (_reps == 3) {
             _currentState = ExerciseState.needsCorrection;
             _feedback = "Correction: Back is too arched! Engage core."; // Real-time audio feedback!
          } else {
             _currentState = ExerciseState.performing;
          }
        });
        _startRepCounter(); // Loop the counter
      } else {
        setState(() {
          _currentState = ExerciseState.ready;
          _feedback = "Workout complete! Form Score: 85%";
        });
      }
    });
  }

  Color _getFeedbackColor() {
    switch (_currentState) {
      case ExerciseState.ready:
        return Colors.blueGrey;
      case ExerciseState.performing:
        return const Color(0xFF00FF88);
      case ExerciseState.needsCorrection:
        return Colors.redAccent;
      default:
        return Colors.blueGrey;
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null || !_controller!.value.isInitialized) {
      return Scaffold(
        backgroundColor: const Color(0xFF121212),
        body: Center(
          child: CircularProgressIndicator(color: const Color(0xFF00FF88)),
        ),
      );
    }

    // Calculate scaling to ensure camera preview fills the screen width
    final size = MediaQuery.of(context).size;
    final scale = size.aspectRatio * _controller!.value.aspectRatio;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // 1. Camera Preview (Simulating AI Analysis Input)
          Positioned.fill(
            child: Transform.scale(
              scale: scale > 1 ? scale : 1 / scale, // Ensures fill width
              child: Center(
                child: CameraPreview(_controller!),
              ),
            ),
          ),
          
          // 2. Pose Overlay (Mock Skeleton & Feedback)
          Positioned.fill(
            child: Container(
              color: Colors.transparent,
              child: CustomPaint(
                painter: MockPosePainter(color: _getFeedbackColor()), // Mock skeleton overlay
              ),
            ),
          ),

          // 3. Top UI (Reps Counter)
          Positioned(
            top: 50.h,
            left: 20.w,
            right: 20.w,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 8.h),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Text(
                    'REPS: $_reps',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.close, color: Colors.white, size: 30.sp),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),

          // 4. Bottom Feedback Box (Real-time Audio/Text Feedback)
          Positioned(
            bottom: 30.h,
            left: 20.w,
            right: 20.w,
            child: Container(
              padding: EdgeInsets.all(15.w),
              decoration: BoxDecoration(
                color: _getFeedbackColor().withOpacity(0.9),
                borderRadius: BorderRadius.circular(15.r),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.exerciseName,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(height: 5.h),
                  Text(
                    _feedback, // Dynamic AI Feedback
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// MOCK: Draws a simple red skeleton to indicate the detection is active
class MockPosePainter extends CustomPainter {
  final Color color;
  MockPosePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withOpacity(0.6)
      ..strokeWidth = 5.w
      ..style = PaintingStyle.stroke;

    // Draw a mock torso line for visual feedback
    canvas.drawLine(
      Offset(size.width * 0.5, size.height * 0.4),
      Offset(size.width * 0.5, size.height * 0.7),
      paint,
    );
    // Draw circles for hips (mock keypoints)
    canvas.drawCircle(Offset(size.width * 0.45, size.height * 0.7), 10.r, paint);
    canvas.drawCircle(Offset(size.width * 0.55, size.height * 0.7), 10.r, paint);
  }

  @override
  bool shouldRepaint(covariant MockPosePainter oldDelegate) {
    return oldDelegate.color != color;
  }
}
