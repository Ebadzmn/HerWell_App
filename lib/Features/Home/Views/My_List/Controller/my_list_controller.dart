import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get.dart';
import 'package:uremz100/Data/Datasources/Remote/my_list_remote_datasource.dart';
import 'package:uremz100/Data/Models/my_collection_model.dart';
import 'package:uremz100/Data/Models/recently_watched_model.dart';
import 'package:uremz100/Data/Repositories/my_list_repository.dart';
import 'package:uremz100/Domain/UseCases/get_my_collection_usecase.dart';
import 'package:uremz100/Domain/UseCases/get_recently_watched_usecase.dart';
import 'package:uremz100/Domain/UseCases/remove_bulk_collection_usecase.dart';

class MyListController extends GetxController {
  late final GetRecentlyWatchedUseCase _getRecentlyWatchedUseCase;
  late final GetMyCollectionUseCase _getMyCollectionUseCase;
  late final RemoveBulkCollectionUseCase _removeBulkCollectionUseCase;

  // Observables for Recently Watched
  final recentlyWatched = <RecentlyWatchedData>[].obs;
  final isRecentlyWatchedLoading = false.obs;
  final recentlyWatchedError = ''.obs;

  // Observables for My Collection
  final myCollection = <MyCollectionData>[].obs;
  final isMyCollectionLoading = false.obs;
  final isMyCollectionPaginating = false.obs;
  final myCollectionError = ''.obs;

  // Pagination states
  int _currentPage = 1;
  bool _hasNextPage = true;
  final ScrollController scrollController = ScrollController();

  // Selection state
  final isSelectionMode = false.obs;
  final selectedItems = <String>{}.obs;

  @override
  void onInit() {
    super.onInit();
    final remoteDataSource = MyListRemoteDataSource();
    final repository = MyListRepository(remoteDataSource);
    _getRecentlyWatchedUseCase = GetRecentlyWatchedUseCase(repository);
    _getMyCollectionUseCase = GetMyCollectionUseCase(repository);
    _removeBulkCollectionUseCase = RemoveBulkCollectionUseCase(repository);

    scrollController.addListener(_onScroll);

    fetchRecentlyWatched();
    fetchMyCollection();
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }

  void _onScroll() {
    if (scrollController.position.pixels >=
        scrollController.position.maxScrollExtent - 200) {
      loadMoreMyCollection();
    }
  }

  Future<void> refreshRecentlyWatched() async {
    await fetchRecentlyWatched();
  }

  Future<void> refreshMyCollection() async {
    _currentPage = 1;
    _hasNextPage = true;
    await fetchMyCollection();
  }

  Future<void> fetchRecentlyWatched() async {
    try {
      isRecentlyWatchedLoading(true);
      recentlyWatchedError('');
      if (kDebugMode) {
        print('Fetching Recently Watched...');
      }
      final response = await _getRecentlyWatchedUseCase.execute();
      recentlyWatched.assignAll(response.data);
      if (kDebugMode) {
        print('Recently Watched Data Size: ${recentlyWatched.length}');
      }
    } catch (e) {
      recentlyWatchedError(e.toString());
      if (kDebugMode) {
        print('Error Fetching Recently Watched: $e');
      }
    } finally {
      isRecentlyWatchedLoading(false);
    }
  }

  Future<void> fetchMyCollection() async {
    try {
      isMyCollectionLoading(true);
      myCollectionError('');
      if (kDebugMode) {
        print('Fetching My Collection - Page 1');
      }
      final response = await _getMyCollectionUseCase.execute(page: 1);
      myCollection.assignAll(response.data);
      if (response.meta != null) {
        _hasNextPage = response.meta!.hasNext;
        _currentPage = response.meta!.page;
      }
      if (kDebugMode) {
        print('My Collection Data Size: ${myCollection.length}, HasNext: $_hasNextPage');
      }
    } catch (e) {
      myCollectionError(e.toString());
      if (kDebugMode) {
        print('Error Fetching My Collection: $e');
      }
    } finally {
      isMyCollectionLoading(false);
    }
  }

  Future<void> loadMoreMyCollection() async {
    if (isMyCollectionPaginating.value || !_hasNextPage || isMyCollectionLoading.value) {
      return;
    }

    try {
      isMyCollectionPaginating(true);
      if (kDebugMode) {
        print('Fetching My Collection - Page ${_currentPage + 1}');
      }
      final response = await _getMyCollectionUseCase.execute(page: _currentPage + 1);
      myCollection.addAll(response.data);
      if (response.meta != null) {
        _hasNextPage = response.meta!.hasNext;
        _currentPage = response.meta!.page;
      }
      if (kDebugMode) {
        print('Loaded More My Collection. New Size: ${myCollection.length}, HasNext: $_hasNextPage');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error Loading More My Collection: $e');
      }
    } finally {
      isMyCollectionPaginating(false);
    }
  }

  void toggleSelectionMode() {
    isSelectionMode.value = !isSelectionMode.value;
    if (!isSelectionMode.value) {
      selectedItems.clear();
    }
  }

  void toggleItemSelected(String id) {
    if (selectedItems.contains(id)) {
      selectedItems.remove(id);
    } else {
      selectedItems.add(id);
    }
  }

  bool get isAllSelected {
    final totalItems = recentlyWatched.length + myCollection.length;
    return totalItems > 0 && selectedItems.length == totalItems;
  }

  void toggleSelectAll() {
    if (isAllSelected) {
      selectedItems.clear();
    } else {
      final allRecent = recentlyWatched.map((e) => e.contentId.id).toSet();
      final allCollection = myCollection.map((e) => e.itemId.id).toSet();
      selectedItems.addAll(allRecent);
      selectedItems.addAll(allCollection);
    }
  }

  Future<void> removeSelected() async {
    if (selectedItems.isEmpty) return;

    try {
      Get.dialog(const Center(child: CircularProgressIndicator()), barrierDismissible: false);
      
      final response = await _removeBulkCollectionUseCase.execute(selectedItems.toList());
      
      Get.back(); // close dialog
      
      if (response.success) {
        // Remove locally
        recentlyWatched.removeWhere((item) => selectedItems.contains(item.contentId.id));
        myCollection.removeWhere((item) => selectedItems.contains(item.itemId.id));
        
        selectedItems.clear();
        isSelectionMode.value = false;
        
        Get.snackbar(
          "Success", 
          response.message.isNotEmpty ? response.message : "Items removed successfully", 
          snackPosition: SnackPosition.BOTTOM, 
          backgroundColor: Colors.green, 
          colorText: Colors.white
        );
      } else {
        Get.snackbar("Error", response.message.isNotEmpty ? response.message : "Failed to remove items", snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      Get.back(); // close dialog
      Get.snackbar("Error", e.toString(), snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
    }
  }
}
