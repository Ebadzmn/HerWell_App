import 'package:get/get.dart';
import 'package:uremz100/core/network/network_caller.dart';
import '../Modet/more_model.dart';

class MoreController extends GetxController {
  final NetworkCaller _networkCaller = NetworkCaller();

  var isLoading = true.obs;
  var errorMessage = ''.obs;
  MovieDetailsModel? movieDetails;
  String? _currentMovieId;

  Future<void> fetchMovieDetails(String movieId) async {
    if (_currentMovieId == movieId) return;
    _currentMovieId = movieId;

    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await _networkCaller.getRequest(
        '/contents/movies/$movieId',
      );

      if (response.isSuccess && response.data != null) {
        final responseData = response.data as Map<String, dynamic>;
        final movieJson = responseData.containsKey('data')
            ? responseData['data']
            : responseData;
        movieDetails = MovieDetailsModel.fromJson(movieJson);
      } else {
        errorMessage.value = response.message ?? 'Failed to load movie details';
      }
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  String formatViews(int views) {
    if (views >= 1000000) {
      return '${(views / 1000000).toStringAsFixed(1)}M Views';
    } else if (views >= 1000) {
      return '${(views / 1000).toStringAsFixed(1)}K Views';
    } else {
      return '$views Views';
    }
  }
}
