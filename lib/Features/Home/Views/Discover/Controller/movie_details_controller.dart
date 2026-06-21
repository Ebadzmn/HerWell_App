import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uremz100/Config/routes.dart';
import 'package:uremz100/Data/Models/content_details_model.dart';
import 'package:uremz100/Data/Repositories/content_details_repository.dart';
import 'package:uremz100/Features/Home/Views/Shorts/Model/shorts_model.dart';
import 'package:uremz100/Features/Home/Views/Shorts/Controller/Shorts_Controller.dart';

class MovieDetailsController extends GetxController {
  final ContentDetailsRepository _repository = Get.find<ContentDetailsRepository>();

  final String contentId;
  MovieDetailsController({required this.contentId});

  var isLoading = false.obs;
  var hasError = false.obs;
  var errorMessage = ''.obs;
  var movieDetails = Rxn<ContentDetailsModel>();

  var isLoadingPlayback = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchDetails();
  }

  Future<void> fetchDetails() async {
    isLoading.value = true;
    hasError.value = false;
    errorMessage.value = '';

    final response = await _repository.getContentDetails(contentId);

    if (response.isSuccess && response.data != null) {
      movieDetails.value = response.data;
    } else {
      hasError.value = true;
      errorMessage.value = response.message;
    }
    isLoading.value = false;
  }

  Future<void> playMovie() async {
    if (isLoadingPlayback.value) return;

    isLoadingPlayback.value = true;
    final response = await _repository.getPlaybackUrl(contentId);

    if (response.isSuccess && response.data != null) {
      final playbackUrl = response.data!.url;
      final details = movieDetails.value;
      
      // We navigate the user to ShortsFullSeriesScreen to play this video.
      // We'll pass the playback URL and other metadata as arguments.
      Get.toNamed(
        Routes.shortsFullSeriesOverlay,
        arguments: {
          'contentId': contentId,
          'playbackUrl': playbackUrl,
          'title': details?.title ?? 'Movie Playback',
          'description': details?.description ?? '',
          'posterUrl': details?.posterUrl ?? '',
        },
      );
    } else {
      Get.snackbar(
        "Playback Error",
        response.message,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    }
    isLoadingPlayback.value = false;
  }
}
