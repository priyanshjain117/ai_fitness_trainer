// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

// class SettingsScreen extends StatefulWidget {
//   const SettingsScreen({super.key});

//   @override
//   State<SettingsScreen> createState() => _SettingsScreenState();
// }

// class _SettingsScreenState extends State<SettingsScreen> {
//   // --- State for the AI toggles ---
//   bool _audioFeedbackEnabled = true;
//   bool _useFrontCamera = true;
//   bool _useAccurateModel = false;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFF121212), // Main dark background
//       appBar: AppBar(
//         backgroundColor: const Color(0xFF1E1E1E), // Card background
//         elevation: 0,
//         centerTitle: true,
//         title: Text(
//           'Settings',
//           style: TextStyle(
//             color: Colors.white,
//             fontSize: 20.sp,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ),
//       body: SingleChildScrollView(
//         padding: EdgeInsets.all(20.w),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // --- Section 1: AI Trainer Settings ---
//             _buildSectionHeader("AI Trainer"),
//             SizedBox(height: 10.h),
//             _buildSettingsGroup(
//               children: [
//                 // (Bonus Creativity: Real-time audio feedback)
//                 _buildSwitchTile(
//                   title: "Real-time Audio Feedback",
//                   subtitle: "Get voice corrections during exercise",
//                   icon: Icons.mic,
//                   value: _audioFeedbackEnabled,
//                   onChanged: (val) {
//                     setState(() => _audioFeedbackEnabled = val);
//                     // TODO: Save this preference
//                   },
//                 ),
//                 _buildDivider(),
//                 // (Pose Detection)
//                 _buildSwitchTile(
//                   title: "Use Front Camera",
//                   subtitle: "Mirrors video for easier self-correction",
//                   icon: Icons.camera_front,
//                   value: _useFrontCamera,
//                   onChanged: (val) {
//                     setState(() => _useFrontCamera = val);
//                     // TODO: Save and update camera controller
//                   },
//                 ),
//                 _buildDivider(),
//                 // (Form Classification)
//                 _buildSwitchTile(
//                   title: "Use Accurate Model",
//                   subtitle: "Slower, but more precise form analysis",
//                   icon: Icons.model_training,
//                   value: _useAccurateModel,
//                   onChanged: (val) {
//                     setState(() => _useAccurateModel = val);
//                     // TODO: This would trigger re-loading the pose detector
//                   },
//                 ),
//               ],
//             ),
//             SizedBox(height: 30.h),

//             // --- Section 2: Account & Data ---
//             _buildSectionHeader("Account & Data"),
//             SizedBox(height: 10.h),
//             _buildSettingsGroup(
//               children: [
//                 // (Cloud Integration)
//                 _buildActionTile(
//                   title: "Manage Profile",
//                   icon: Icons.person,
//                   onTap: () {
//                     // TODO: Navigate to Profile Screen
//                   },
//                 ),
//                 _buildDivider(),
//                 // (Performance Dashboard)
//                 _buildActionTile(
//                   title: "Manage Data Sync",
//                   subtitle: "Sync progress with the cloud",
//                   icon: Icons.cloud_sync,
//                   onTap: () {
//                     // TODO: Navigate to Data Sync Screen
//                   },
//                 ),
//                 _buildDivider(),
//                 _buildActionTile(
//                   title: "Log Out",
//                   icon: Icons.logout,
//                   color: Colors.redAccent, // Destructive action
//                   onTap: () {
//                     // TODO: Show confirmation and log user out
//                   },
//                 ),
//               ],
//             ),
//              SizedBox(height: 30.h),

//             // --- Section 3: General ---
//             _buildSectionHeader("General"),
//             SizedBox(height: 10.h),
//             _buildSettingsGroup(
//               children: [
//                 _buildActionTile(
//                   title: "Privacy Policy",
//                   icon: Icons.security,
//                   onTap: () {},
//                 ),
//                 _buildDivider(),
//                 _buildActionTile(
//                   title: "Terms of Service",
//                   icon: Icons.article,
//                   onTap: () {},
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   /// Helper for building section titles (e.g., "AI Trainer")
//   Widget _buildSectionHeader(String title) {
//     return Text(
//       title.toUpperCase(),
//       style: TextStyle(
//         color: Colors.white70,
//         fontSize: 14.sp,
//         fontWeight: FontWeight.bold,
//         letterSpacing: 1.1,
//       ),
//     );
//   }

//   /// Helper for creating the dark card container for a group of settings
//   Widget _buildSettingsGroup({required List<Widget> children}) {
//     return Container(
//       decoration: BoxDecoration(
//         color: const Color(0xFF1E1E1E), // Dark card color
//         borderRadius: BorderRadius.circular(15.r),
//       ),
//       // Use ClipRRect to make sure the ListTiles' corners are also rounded
//       child: ClipRRect(
//         borderRadius: BorderRadius.circular(15.r),
//         child: Column(
//           children: children,
//         ),
//       ),
//     );
//   }

//   /// A custom SwitchListTile that matches the app's theme
//   Widget _buildSwitchTile({
//     required String title,
//     required String subtitle,
//     required IconData icon,
//     required bool value,
//     required Function(bool) onChanged,
//   }) {
//     return SwitchListTile(
//       title: Text(
//         title,
//         style: TextStyle(color: Colors.white, fontSize: 16.sp),
//       ),
//       subtitle: Text(
//         subtitle,
//         style: TextStyle(color: Colors.white70, fontSize: 12.sp),
//       ),
//       secondary: Icon(
//         icon,
//         color: const Color(0xFF00FF88), // Accent color
//       ),
//       activeColor: const Color(0xFF00FF88),
//       value: value,
//       onChanged: onChanged,
//     );
//   }

//   /// A custom ListTile for navigation actions
//   Widget _buildActionTile({
//     required String title,
//     String? subtitle,
//     required IconData icon,
//     required VoidCallback onTap,
//     Color? color,
//   }) {
//     return ListTile(
//       title: Text(
//         title,
//         style: TextStyle(color: color ?? Colors.white, fontSize: 16.sp),
//       ),
//       subtitle: subtitle != null
//           ? Text(
//               subtitle,
//               style: TextStyle(color: Colors.white70, fontSize: 12.sp),
//             )
//           : null,
//       leading: Icon(
//         icon,
//         color: color ?? const Color(0xFF00FF88), // Accent color
//       ),
//       trailing: Icon(
//         Icons.arrow_forward_ios,
//         color: Colors.white38,
//         size: 16.sp,
//       ),
//       onTap: onTap,
//     );
//   }

//   /// A simple divider line to separate items in a group
//   Widget _buildDivider() {
//     return Divider(
//       color: Colors.grey.shade800,
//       height: 1.h,
//       indent: 60.w, // Indent to align with text
//     );
//   }
// }

import 'package:ai_trainer/screens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart'; // Import GetX
import 'package:ai_trainer/controllers/settings_controller.dart'; // Import your controller

// --- THIS IS THE CHANGE (Step 4) ---
// It's now a StatelessWidget
class SettingsScreen extends StatelessWidget {
// --- END OF CHANGE ---
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // "Find" the instance of the controller that main.dart created
    final SettingsController settings = Get.find();

    return Scaffold(
      backgroundColor: const Color(0xFF121212), // Main dark background
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E1E1E), // Card background
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
            // --- Section 1: AI Trainer Settings ---
            _buildSectionHeader("AI Trainer"),
            SizedBox(height: 10.h),
            
            // --- THIS IS THE CHANGE ---
            // Wrap the settings group in Obx(() => ...) to make 
            // the widgets inside it "reactive" to changes in the controller.
            Obx(() => _buildSettingsGroup(
              children: [
                // (Bonus Creativity: Real-time audio feedback)
                _buildSwitchTile(
                  title: "Real-time Audio Feedback",
                  subtitle: "Get voice corrections during exercise",
                  icon: Icons.mic,
                  // Read the .value from the controller
                  value: settings.audioFeedbackEnabled.value,
                  // Call the controller's method on change
                  onChanged: (val) => settings.toggleAudioFeedback(val),
                ),
                _buildDivider(),
                // (Pose Detection)
                _buildSwitchTile(
                  title: "Use Front Camera",
                  subtitle: "Mirrors video for easier self-correction",
                  icon: Icons.camera_front,
                  // Read the .value from the controller
                  value: settings.useFrontCamera.value,
                  // Call the controller's method on change
                  onChanged: (val) => settings.toggleFrontCamera(val),
                ),
                _buildDivider(),
                // (Form Classification)
                _buildSwitchTile(
                  title: "Use Accurate Model",
                  subtitle: "Slower, but more precise form analysis",
                  icon: Icons.model_training,
                  // Read the .value from the controller
                  value: settings.useAccurateModel.value,
                  // Call the controller's method on change
                  onChanged: (val) => settings.toggleAccurateModel(val),
                ),
              ],
            )),
            // --- END OF CHANGE ---

            SizedBox(height: 30.h),

            // --- Section 2: Account & Data ---
            _buildSectionHeader("Account & Data"),
            SizedBox(height: 10.h),
            _buildSettingsGroup(
              children: [
                // (Cloud Integration)
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

