import 'package:get/get.dart';
import 'package:uremz100/Data/Models/ranking_response_model.dart';
import 'package:uremz100/Data/Repositories/ranking_repository.dart';

class RankingController extends GetxController {
  final RankingRepository _repository = Get.put(RankingRepository());

  var isLoading = false.obs;
  var hasError = false.obs;
  var errorMessage = ''.obs;
  var selectedRankingTab = 'Popular'.obs;

  var rankingItems = <RankingItem>[].obs;
  var sectionTitle = ''.obs;

  // Cache to store loaded data per filter
  final Map<String, List<RankingItem>> _cache = {};
  final Map<String, String> _titleCache = {};

  @override
  void onInit() {
    super.onInit();
    getRankingContent(filter: 'popular');
  }

  void changeRankingTab(String label) {
    if (selectedRankingTab.value == label) return;
    selectedRankingTab.value = label;

    String filter = 'popular';
    switch (label) {
      case 'Popular':
        filter = 'popular';
        break;
      case 'Daily Top':
        filter = 'daily';
        break;
      case 'Weekly Top':
        filter = 'weekly';
        break;
      case 'Monthly Top':
        filter = 'monthly';
        break;
    }

    getRankingContent(filter: filter);
  }

  Future<void> getRankingContent({required String filter}) async {
    if (_cache.containsKey(filter)) {
      rankingItems.value = _cache[filter]!;
      sectionTitle.value = _titleCache[filter] ?? '';
      return;
    }

    isLoading.value = true;
    hasError.value = false;
    errorMessage.value = '';

    try {
      final response = await _repository.getRankingContent(filter: filter);

      if (response.success && response.data != null && response.data!.sections.isNotEmpty) {
        final section = response.data!.sections.first;
        rankingItems.value = section.items;
        sectionTitle.value = section.title;
        
        _cache[filter] = section.items;
        _titleCache[filter] = section.title;
      } else {
        hasError.value = true;
        errorMessage.value = response.message.isNotEmpty ? response.message : 'Failed to load ranking';
      }
    } catch (e) {
      hasError.value = true;
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  void retry() {
    String filter = 'popular';
    switch (selectedRankingTab.value) {
      case 'Popular': filter = 'popular'; break;
      case 'Daily Top': filter = 'daily'; break;
      case 'Weekly Top': filter = 'weekly'; break;
      case 'Monthly Top': filter = 'monthly'; break;
    }
    getRankingContent(filter: filter);
  }
}
