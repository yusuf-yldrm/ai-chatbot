import 'package:get/get.dart';
import 'bottom_bar_controller.dart';
import 'package:use/pages/chatgpt/chatgpt_controller.dart';
import 'package:use/pages/dalle/dalle_controller.dart';
import 'package:use/pages/settings/settings_controller.dart';

import 'bottom_bar_controller.dart';

class BottomBarBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BottomBarController>(() => BottomBarController());
    Get.lazyPut<ChatGPTController>(() => ChatGPTController());
    Get.lazyPut<DalleController>(() => DalleController());
    Get.lazyPut<SettingsController>(() => SettingsController());
  }
}
