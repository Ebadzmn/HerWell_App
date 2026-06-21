import 'package:get/get.dart';
import '../../Shorts/Controller/Shorts_Controller.dart';

class NavigationController extends GetxController {
  var currentIndex = 0.obs;
  var showBottomNav = true.obs;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments is int) {
      currentIndex.value = Get.arguments;
    } else if (Get.arguments is Map &&
        Get.arguments.containsKey('bottomIndex')) {
      currentIndex.value = Get.arguments['bottomIndex'];
    }
  }

  void changeIndex(int index) {
    if (currentIndex.value == 1 && index != 1) {
      // If leaving Shorts tab, pause the video
      try {
        final shortsController = Get.find<ShortsController>();
        shortsController.pauseCurrentVideo();
      } catch (e) {}
    }
    currentIndex.value = index;
  }

  void toggleBottomNav(bool show) {
    showBottomNav.value = show;
  }
}