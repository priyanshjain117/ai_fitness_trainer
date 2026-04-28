# AI Trainer

## 🚀 Smart AI Gym Trainer

**AI Trainer** is a Flutter-based workout companion that brings live pose detection, form feedback, and fitness planning into a single mobile experience. It helps users track exercise quality, choose workouts, and follow tailored diet guidance while providing an intuitive dark-themed interface.

## 📝 Description

This project exists to showcase a practical AI-driven workout assistant built with Flutter. It is designed to provide developers with an example of how live camera-based pose detection can be combined with voice feedback and workout tracking to deliver a modern fitness app.

The app is centered around a home dashboard, personalized goals, a diet planner, and real-time pose analysis using Google ML Kit. It is ideal for a developer prototype or a starting point for a production-ready training companion.

## ✨ Key Features

- Live pose detection for exercise form monitoring using the device camera
- Repetition counting and corrective feedback for workouts like squats and push-ups
- Voice interaction via speech-to-text and text-to-speech
- Workout category browser and exercise selection
- Sample diet planning with macros and meal recommendations
- Settings toggles for audio feedback, camera selection, and pose model precision
- Responsive UI scaling with `flutter_screenutil`

## 🛠️ Tech Stack

- Language: Dart
- Framework: Flutter
- State management: GetX
- Camera: `camera`
- ML pose detection: `google_mlkit_pose_detection`, `google_mlkit_commons`
- Voice: `speech_to_text`, `flutter_tts`
- Charts/UI: `fl_chart`, `percent_indicator`
- Layout: `flutter_screenutil`
- Permissions: `permission_handler`
- HTTP: `http`

## ⚙️ Getting Started

### Prerequisites

- Flutter SDK installed: https://docs.flutter.dev/get-started/install
- Android Studio, Xcode, or supported desktop tooling for your target platform
- A connected device or running simulator/emulator

### Setup

```bash
cd /Volumes/Extreme_SSD/flutter_projects/mujhackx/ai_trainer
flutter pub get
```

### Run locally

```bash
flutter run
```

If you want to target a specific device or platform:

```bash
flutter run -d <device_id>
```

### iOS / macOS

```bash
flutter run -d macos
flutter run -d ios
```

### Android

```bash
flutter run -d android
```

## 📖 Usage

The app entrypoint is `lib/main.dart`, which initializes the `SettingsController` and launches `HomeScreen`.

Use the home screen to:

1. View daily form score and workout focus
2. Select workout categories like strength or yoga
3. Open exercise pages and start live pose analysis
4. Visit settings to toggle audio feedback, camera direction, and model accuracy

Example navigation flow:

- `lib/home_screen.dart` → dashboard and workout selection
- `lib/screens/exercise_list_screen.dart` → exercise list for a category
- `lib/screens/pose_detection_screen.dart` → live camera pose tracking
- `lib/screens/diet_planner_screen.dart` → sample diet plan recommendations

## 🤝 Contributing

Contributions are welcome! To contribute:

1. Fork the repository
2. Create a new branch: `git checkout -b feature/your-feature`
3. Install dependencies: `flutter pub get`
4. Make your changes and test on your target platform
5. Submit a pull request with a clear description of your work

Helpful contribution ideas:

- Add real workout data persistence
- Replace mock user progress with backend API integration
- Improve pose analysis and exercise coverage
- Add unit tests and widget tests in `test/`

## 📄 License

This repository does not currently include a license file. Add a `LICENSE` in the project root to specify your preferred open source terms.

---

### Relevant files

- `pubspec.yaml`
- `lib/main.dart`
- `lib/home_screen.dart`
- `lib/screens/pose_detection_screen.dart`
- `lib/screens/diet_planner_screen.dart`
- `lib/screens/exercise_list_screen.dart`
- `lib/screens/settings_screen.dart`
- `lib/controllers/settings_controller.dart`
- `lib/secret/api_key.dart`
