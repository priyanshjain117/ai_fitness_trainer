import 'package:ai_trainer/screens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart'; 
import 'package:ai_trainer/controllers/settings_controller.dart'; 

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final SettingsController settings = Get.find();

    return Scaffold(
      backgroundColor: const Color(0xFF121212), 
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E1E1E), 
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Settings',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader("AI Trainer"),
            SizedBox(height: 10.h),
            
            Obx(() => _buildSettingsGroup(
              children: [
                _buildSwitchTile(
                  title: "Real-time Audio Feedback",
                  subtitle: "Get voice corrections during exercise",
                  icon: Icons.mic,
                  value: settings.audioFeedbackEnabled.value,
                  onChanged: (val) => settings.toggleAudioFeedback(val),
                ),
                _buildDivider(),
                _buildSwitchTile(
                  title: "Use Front Camera",
                  subtitle: "Mirrors video for easier self-correction",
                  icon: Icons.camera_front,
                  value: settings.useFrontCamera.value,
                  onChanged: (val) => settings.toggleFrontCamera(val),
                ),
                _buildDivider(),
                _buildSwitchTile(
                  title: "Use Accurate Model",
                  subtitle: "Slower, but more precise form analysis",
                  icon: Icons.model_training,
                  value: settings.useAccurateModel.value,
                  onChanged: (val) => settings.toggleAccurateModel(val),
                ),
              ],
            )),
            SizedBox(height: 30.h),
            _buildSectionHeader("Account & Data"),
            SizedBox(height: 10.h),
            _buildSettingsGroup(
              children: [
                _buildActionTile(
                  title: "Manage Profile",
                  icon: Icons.person,
                  onTap: () {
                    Get.to(() => ProfileScreen());
                  },
                ),
                _buildDivider(),
                // (Performance Dashboard)
                _buildActionTile(
                  title: "Manage Data Sync",
                  subtitle: "Sync progress with the cloud",
                  icon: Icons.cloud_sync,
                  onTap: () {
                    // TODO: Navigate to Data Sync Screen
                  },
                ),
                _buildDivider(),
                _buildActionTile(
                  title: "Log Out",
                  icon: Icons.logout,
                  color: Colors.redAccent, // Destructive action
                  onTap: () {
                    // TODO: Show confirmation and log user out
                  },
                ),
              ],
            ),
             SizedBox(height: 30.h),

            // --- Section 3: General ---
            _buildSectionHeader("General"),
            SizedBox(height: 10.h),
            _buildSettingsGroup(
              children: [
                _buildActionTile(
                  title: "Privacy Policy",
                  icon: Icons.security,
                  onTap: () {},
                ),
                _buildDivider(),
                _buildActionTile(
                  title: "Terms of Service",
                  icon: Icons.article,
                  onTap: () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Helper for building section titles (e.g., "AI Trainer")
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

  /// Helper for creating the dark card container for a group of settings
  Widget _buildSettingsGroup({required List<Widget> children}) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E), // Dark card color
        borderRadius: BorderRadius.circular(15.r),
      ),
      // Use ClipRRect to make sure the ListTiles' corners are also rounded
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15.r),
        child: Column(
          children: children,
        ),
      ),
    );
  }

  /// A custom SwitchListTile that matches the app's theme
  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return SwitchListTile(
      title: Text(
        title,
        style: TextStyle(color: Colors.white, fontSize: 16.sp),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(color: Colors.white70, fontSize: 12.sp),
      ),
      secondary: Icon(
        icon,
        color: const Color(0xFF00FF88), // Accent color
      ),
      activeColor: const Color(0xFF00FF88),
      value: value,
      onChanged: onChanged,
    );
  }

  /// A custom ListTile for navigation actions
  Widget _buildActionTile({
    required String title,
    String? subtitle,
    required IconData icon,
    required VoidCallback onTap,
    Color? color,
  }) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(color: color ?? Colors.white, fontSize: 16.sp),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle,
              style: TextStyle(color: Colors.white70, fontSize: 12.sp),
            )
          : null,
      leading: Icon(
        icon,
        color: color ?? const Color(0xFF00FF88), // Accent color
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        color: Colors.white38,
        size: 16.sp,
      ),
      onTap: onTap,
    );
  }

  /// A simple divider line to separate items in a group
  Widget _buildDivider() {
    return Divider(
      color: Colors.grey.shade800,
      height: 1.h,
      indent: 60.w, // Indent to align with text
    );
  }
}

