import 'package:get/get.dart';

/// A GetX controller to manage all global app settings.
class SettingsController extends GetxController {
  // .obs makes these variables "observable" or "reactive"
  var audioFeedbackEnabled = true.obs;
  var useFrontCamera = true.obs;
  var useAccurateModel = false.obs;

  // Methods to update the values
  void toggleAudioFeedback(bool val) {
    audioFeedbackEnabled.value = val;
    // TODO: Save this value to local storage (like GetStorage)
  }

  void toggleFrontCamera(bool val) {
    useFrontCamera.value = val;
    // TODO: Save this value
  }

  void toggleAccurateModel(bool val) {
    useAccurateModel.value = val;
    // TODO: Save this value
  }
}
