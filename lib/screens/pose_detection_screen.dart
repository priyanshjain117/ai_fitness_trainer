import 'dart:io'; 
import 'package:ai_trainer/screens/pose_painter.dart';
import 'package:ai_trainer/models/exercise_state.dart'; 
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_mlkit_commons/google_mlkit_commons.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import 'dart:math' as math; 
import 'package:get/get.dart'; 
import 'package:ai_trainer/controllers/settings_controller.dart'; 

class PoseDetectionScreen extends StatefulWidget {
  final String exerciseName;
  const PoseDetectionScreen({super.key, required this.exerciseName});

  @override
  State<PoseDetectionScreen> createState() => _PoseDetectionScreenState();
}

class _PoseDetectionScreenState extends State<PoseDetectionScreen> {
  final SettingsController settings = Get.find();

  CameraController? _controller;
  late PoseDetector _poseDetector;
  bool _isDetectorBusy = false;

  List<Pose> _poses = [];
  Size? _imageSize;
  ExerciseState _currentState = ExerciseState.ready;
  int _reps = 0;
  String _feedback = "Place yourself in the frame to begin.";
  
  bool _isInDownPosition = false;
  int _framesSinceLastRep = 0;
  static const int _minFramesBetweenReps = 15;

  @override
  void initState() {
    super.initState();
    _poseDetector = PoseDetector(
      options: PoseDetectorOptions(
        mode: PoseDetectionMode.stream,
        model: settings.useAccurateModel.value 
                ? PoseDetectionModel.accurate 
                : PoseDetectionModel.base,
      ),
    );
    _initializeCamera();
  }

  @override
  void dispose() {
    _isDetectorBusy = true;
    _controller?.stopImageStream();
    _controller?.dispose();
    _poseDetector.close();
    super.dispose();
  }

  Future<void> _initializeCamera() async {
    try {
      final cameras = await availableCameras();
      
      int cameraIndex;
      if (settings.useFrontCamera.value) {
        cameraIndex = cameras.indexWhere(
          (c) => c.lensDirection == CameraLensDirection.front
        );
      } else {
        cameraIndex = cameras.indexWhere(
          (c) => c.lensDirection == CameraLensDirection.back
        );
      }
      
      if (cameraIndex == -1) {
        debugPrint("Selected camera not available, defaulting to first camera.");
        cameraIndex = 0; 
      }

      _controller = CameraController(
        cameras[cameraIndex], 
        ResolutionPreset.high, 
        enableAudio: false,
        imageFormatGroup: Platform.isAndroid
            ? ImageFormatGroup.nv21 
            : ImageFormatGroup.bgra8888,
      );
      
      await _controller!.initialize();
      if (!mounted) return;

      await _controller!.startImageStream(_processCameraImage);
      setState(() {});
      
    } catch (e) {
      debugPrint("Error initializing camera: $e");
      if (mounted) {
        setState(() {
          _feedback = "Camera error: $e";
        });
      }
    }
  }

  Future<void> _processCameraImage(CameraImage image) async {
    if (_isDetectorBusy || !mounted) return;
    _isDetectorBusy = true;

    try {
      final inputImage = _inputImageFromCameraImage(image);
      if (inputImage == null) {
        _isDetectorBusy = false;
        return;
      }

      final poses = await _poseDetector.processImage(inputImage);
      
      _framesSinceLastRep++;
      _analyzePoses(poses); 
      
      if (mounted) {
        setState(() {
          _poses = poses;
          _imageSize = Size(image.width.toDouble(), image.height.toDouble());
        });
      }
    } catch (e) {
      debugPrint("Error processing image: $e");
    }

    _isDetectorBusy = false;
  }
  
  void _analyzePoses(List<Pose> poses) {
    if (poses.isEmpty) {
      if (_currentState != ExerciseState.ready) {
        setState(() {
          _feedback = "Place yourself in the frame.";
          _currentState = ExerciseState.ready;
        });
      }
      return;
    }

    final pose = poses.first;
    final landmarks = pose.landmarks;

    final leftHip = landmarks[PoseLandmarkType.leftHip];
    final rightHip = landmarks[PoseLandmarkType.rightHip];
    final leftKnee = landmarks[PoseLandmarkType.leftKnee];
    final rightKnee = landmarks[PoseLandmarkType.rightKnee];
    final leftAnkle = landmarks[PoseLandmarkType.leftAnkle];
    final rightAnkle = landmarks[PoseLandmarkType.rightAnkle];
    final leftShoulder = landmarks[PoseLandmarkType.leftShoulder];
    
    if (leftHip == null || rightHip == null || leftKnee == null || 
        rightKnee == null || leftAnkle == null || rightAnkle == null ||
        leftShoulder == null) { 
      return;
    }

    final leftKneeAngle = _getAngle(leftHip, leftKnee, leftAnkle);
    final rightKneeAngle = _getAngle(rightHip, rightKnee, rightAnkle);
    final avgKneeAngle = (leftKneeAngle + rightKneeAngle) / 2;

    double? backAngle;
    if (leftShoulder != null && leftHip != null && leftKnee != null) {
      backAngle = _getAngle(leftShoulder, leftHip, leftKnee);
    }

    if (avgKneeAngle < 110 && !_isInDownPosition && 
        _framesSinceLastRep > _minFramesBetweenReps) {
      _isInDownPosition = true;
      
      if (backAngle != null && backAngle < 160) {
        setState(() {
          _feedback = "⚠️ Needs More Practice : Keep your back straight!";
          _currentState = ExerciseState.needsCorrection;
        });
      } else {
        setState(() {
          _feedback = "Good depth! Now push up!";
          _currentState = ExerciseState.performing;
        });
      }
    } else if (avgKneeAngle > 160 && _isInDownPosition) {
      _isInDownPosition = false;
      _framesSinceLastRep = 0;
      
      setState(() {
        _reps++;
        _feedback = "✓ Perfect Rep $_reps completed!";
        _currentState = ExerciseState.performing;
      });
    } else if (_isInDownPosition && avgKneeAngle >= 110 && avgKneeAngle <= 160) {
      setState(() {
        _feedback = "Almost There Keep going...";
        _currentState = ExerciseState.performing;
      });
    } else if (!_isInDownPosition && _currentState == ExerciseState.ready) {
      setState(() {
        _feedback = "Ready! Start your ${widget.exerciseName}";
        _currentState = ExerciseState.performing;
      });
    }
  }

  double _getAngle(PoseLandmark? a, PoseLandmark? b, PoseLandmark? c) {
    if (a == null || b == null || c == null) return 180.0;

    final radians = math.atan2(c.y - b.y, c.x - b.x) - 
                    math.atan2(a.y - b.y, a.x - b.x);
    var angle = radians.abs() * 180.0 / math.pi;
    
    if (angle > 180.0) {
      angle = 360.0 - angle;
    }
    
    return angle;
  }

  InputImage? _inputImageFromCameraImage(CameraImage image) {
    if (_controller == null) return null;

    final camera = _controller!.description;
    final sensorOrientation = camera.sensorOrientation;
    
    InputImageRotation? rotation;
    if (Platform.isIOS) {
      rotation = InputImageRotationValue.fromRawValue(sensorOrientation);
    } else if (Platform.isAndroid) {
      var rotationCompensation = sensorOrientation;
      if (camera.lensDirection == CameraLensDirection.front) {
         rotationCompensation = (sensorOrientation + 90) % 360;
      } else {
         rotationCompensation = (sensorOrientation - 90 + 360) % 360;
      }
      rotation = InputImageRotationValue.fromRawValue(rotationCompensation);
    }
    
    if (rotation == null) return null;

    final format = Platform.isAndroid
        ? InputImageFormat.nv21
        : InputImageFormat.bgra8888;
    
    final WriteBuffer allBytes = WriteBuffer();
    for (final plane in image.planes) {
      allBytes.putUint8List(plane.bytes);
    }
    final bytes = allBytes.done().buffer.asUint8List();

    return InputImage.fromBytes(
      bytes: bytes,
      metadata: InputImageMetadata(
        size: Size(image.width.toDouble(), image.height.toDouble()),
        rotation: rotation,
        format: format,
        bytesPerRow: image.planes.first.bytesPerRow,
      ),
    );
  }

  Color _getFeedbackColor() {
    switch (_currentState) {
      case ExerciseState.ready:
        return Colors.blueGrey;
      case ExerciseState.performing:
        return const Color(0xFF00FF88);
      case ExerciseState.needsCorrection:
        return Colors.redAccent;
    }
  }

  // --- YOUR UI (Unchanged) ---
  @override
  Widget build(BuildContext context) {
    if (_controller == null || !_controller!.value.isInitialized) {
      return Scaffold(
        backgroundColor: const Color(0xFF121212),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: const Color(0xFF00FF88)),
              SizedBox(height: 20.h),
              Text(
                'Initializing camera...',
                style: TextStyle(color: Colors.white, fontSize: 16.sp),
              ),
            ],
          ),
        ),
      );
    }
    
    final size = MediaQuery.of(context).size;
    final scale = size.aspectRatio * _controller!.value.aspectRatio;
    final cameraScale = scale > 1 ? scale : 1 / scale;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Positioned.fill(
            child: Transform.scale(
              scale: cameraScale,
              child: Center(
                child: CameraPreview(_controller!),
              ),
            ),
          ),
          
          if (_imageSize != null)
            Positioned.fill(
              child: CustomPaint(
                painter: PosePainter(
                  _poses,
                  _imageSize!,
                  _controller!.description.lensDirection,
                  _currentState,
                ),
              ),
            ),

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
                    color: Colors.black87,
                    borderRadius: BorderRadius.circular(10.r),
                    border: Border.all(color: const Color(0xFF00FF88), width: 2),
                  ),
                  child: Text(
                    'REPS: $_reps',
                    style: TextStyle(
                      color: const Color(0xFF00FF88),
                      fontSize: 24.sp,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.black87,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: IconButton(
                    icon: Icon(Icons.close, color: Colors.white, size: 28.sp),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ],
            ),
          ),

          Positioned(
            bottom: 30.h,
            left: 20.w,
            right: 20.w,
            child: Container(
              padding: EdgeInsets.all(15.w),
              decoration: BoxDecoration(
                color: _getFeedbackColor().withOpacity(0.9),
                borderRadius: BorderRadius.circular(15.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black45,
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.exerciseName.toUpperCase(),
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.1,
                    ),
                  ),
                  SizedBox(height: 5.h),
                  Text(
                    _feedback,
                    style: TextStyle(
                      color: Colors.black87,
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

