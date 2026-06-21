import 'package:get/get.dart';
import 'package:uremz100/Features/Home/Views/Shorts/Model/shorts_model.dart';
import 'package:video_player/video_player.dart';

class PipController extends GetxController {
  static PipController get to => Get.find();

  final RxBool isPipVisible = false.obs;
  final Rx<ShortsModel?> currentShort = Rx<ShortsModel?>(null);
  final RxString returnRoute = ''.obs;

  VideoPlayerController? videoController;
  final RxBool isPlaying = false.obs;
  final RxBool isVideoInitialized = false.obs;

  void showPip(ShortsModel short, {Duration? startPosition, String route = ''}) {
    currentShort.value = short;
    returnRoute.value = route;
    isPipVisible.value = true;

    // Initialize Video Player for the mini popup
    _initController(short.videoUrl, startPosition: startPosition);
  }

  Future<void> _initController(String url, {Duration? startPosition}) async {
    await videoController?.dispose();
    isVideoInitialized.value = false;
    isPlaying.value = false;
    
    final finalUrl = url.replaceFirst('http://', 'https://');
    final controller = VideoPlayerController.networkUrl(Uri.parse(finalUrl));
    videoController = controller;

    try {
      await controller.initialize();
      if (videoController == controller) {
        controller.setLooping(true);
        if (startPosition != null) {
          await controller.seekTo(startPosition);
        }
        await controller.play();
        isPlaying.value = true;
        isVideoInitialized.value = true;
      }
    } catch (e) {
      print("Error initializing PIP video: $e");
    }
  }

  void togglePlay() {
    if (videoController != null) {
      if (videoController!.value.isPlaying) {
        videoController!.pause();
        isPlaying.value = false;
      } else {
        videoController!.play();
        isPlaying.value = true;
      }
    }
  }

  void closePip() {
    isPipVisible.value = false;
    currentShort.value = null;
    videoController?.pause();
    videoController?.dispose();
    videoController = null;
    isPlaying.value = false;
    isVideoInitialized.value = false;
  }

  @override
  void onClose() {
    videoController?.dispose();
    super.onClose();
  }
}
