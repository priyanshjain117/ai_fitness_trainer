import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: Text(
          'Settings',
          style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF1E1E1E),
        elevation: 0,
      ),
      body: Center(
        child: Text(
          'Manage Voice Feedback & Model Preferences Here.',
          style: TextStyle(color: Colors.white70, fontSize: 18.sp),
        ),
      ),
    );
  }
}
