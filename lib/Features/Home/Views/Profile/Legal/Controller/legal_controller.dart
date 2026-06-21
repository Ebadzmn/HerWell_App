import 'package:get/get.dart';
import 'package:uremz100/Data/Repositories/user_profile_repository.dart';

class LegalController extends GetxController {
  final _userProfileRepo = Get.find<UserProfileRepo>();

  final isLoading = true.obs;
  final content = "".obs;
  final title = "".obs;
  final errorMessage = "".obs;

  void fetchLegalPage(String slug) async {
    isLoading.value = true;
    errorMessage.value = "";
    
    try {
      final response = await _userProfileRepo.getLegalPageBySlug(slug);
      
      if (response.isSuccess) {
        final data = response.data;
        if (data is Map && data['data'] != null) {
          content.value = data['data']['content'] ?? "";
          title.value = data['data']['title'] ?? "";
        }
      } else {
        errorMessage.value = response.message ?? "Failed to load page";
      }
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
}
