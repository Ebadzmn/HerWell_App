import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/network/api_client.dart';

class CommunityPostModel {
  final String id;
  final String content;
  final String? authorName;
  final int likes;
  final String category;
  final String createdBy;
  final DateTime createdAt;
  final List<PostCommentModel> comments;

  CommunityPostModel({
    required this.id,
    required this.content,
    this.authorName,
    required this.likes,
    required this.category,
    required this.createdBy,
    required this.createdAt,
    required this.comments,
  });

  factory CommunityPostModel.fromJson(Map<String, dynamic> json) {
    var commentsList = <PostCommentModel>[];
    if (json['comments'] != null) {
      commentsList = (json['comments'] as List)
          .map((c) => PostCommentModel.fromJson(c))
          .toList();
    }

    // Convert likes to integer (handling both float/int/string)
    int likesCount = 0;
    if (json['likes'] != null) {
      if (json['likes'] is num) {
        likesCount = (json['likes'] as num).toInt();
      } else {
        likesCount = int.tryParse(json['likes'].toString()) ?? 0;
      }
    }

    return CommunityPostModel(
      id: json['id'] ?? '',
      content: json['content'] ?? '',
      authorName: json['author_name'] ?? json['created_by']?.split('@')[0],
      likes: likesCount,
      category: json['category'] ?? 'general',
      createdBy: json['created_by'] ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt']) ?? DateTime.now()
          : DateTime.now(),
      comments: commentsList,
    );
  }
}

class PostCommentModel {
  final String id;
  final String postId;
  final String content;
  final String? authorName;
  final String createdBy;
  final DateTime createdAt;

  PostCommentModel({
    required this.id,
    required this.postId,
    required this.content,
    this.authorName,
    required this.createdBy,
    required this.createdAt,
  });

  factory PostCommentModel.fromJson(Map<String, dynamic> json) {
    return PostCommentModel(
      id: json['id'] ?? '',
      postId: json['post_id'] ?? '',
      content: json['content'] ?? '',
      authorName: json['author_name'] ?? json['created_by']?.split('@')[0],
      createdBy: json['created_by'] ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt']) ?? DateTime.now()
          : DateTime.now(),
    );
  }
}

class CommunityController extends GetxController {
  final posts = <CommunityPostModel>[].obs;
  final selectedPost = Rxn<CommunityPostModel>();
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchPosts();
  }

  Future<void> fetchPosts({String? category}) async {
    try {
      isLoading.value = true;
      final ApiClient apiClient = Get.find<ApiClient>();
      
      Map<String, dynamic> params = {};
      if (category != null && category != 'all') {
        params['category'] = category.toLowerCase();
      }

      final response = await apiClient.get('/community/posts', queryParameters: params);
      if (response.isSuccess && response.data != null && response.data is List) {
        posts.value = (response.data as List)
            .map((p) => CommunityPostModel.fromJson(p))
            .toList();
      }
    } catch (e) {
      debugPrint("Failed to fetch posts: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> createPost(String content, String category) async {
    try {
      final ApiClient apiClient = Get.find<ApiClient>();
      final response = await apiClient.post(
        '/community/posts',
        data: {
          "content": content,
          "category": category.toLowerCase(),
          "image_url": "",
        },
      );

      if (response.isSuccess) {
        Get.snackbar(
          'Success',
          'Post created successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.withOpacity(0.1),
          colorText: Colors.green[800],
        );
        fetchPosts(category: category);
        return true;
      } else {
        Get.snackbar(
          'Error',
          response.message.isNotEmpty ? response.message : 'Failed to create post',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
        return false;
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'An unexpected error occurred',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return false;
    }
  }

  Future<void> likePost(String postId, int currentLikes) async {
    try {
      final ApiClient apiClient = Get.find<ApiClient>();
      final response = await apiClient.put(
        '/community/posts/$postId',
        data: {
          "likes": currentLikes + 1,
        },
      );

      if (response.isSuccess) {
        // Optimistically update post in lists
        final postIndex = posts.indexWhere((p) => p.id == postId);
        if (postIndex != -1) {
          final p = posts[postIndex];
          posts[postIndex] = CommunityPostModel(
            id: p.id,
            content: p.content,
            authorName: p.authorName,
            likes: currentLikes + 1,
            category: p.category,
            createdBy: p.createdBy,
            createdAt: p.createdAt,
            comments: p.comments,
          );
        }

        if (selectedPost.value?.id == postId) {
          final p = selectedPost.value!;
          selectedPost.value = CommunityPostModel(
            id: p.id,
            content: p.content,
            authorName: p.authorName,
            likes: currentLikes + 1,
            category: p.category,
            createdBy: p.createdBy,
            createdAt: p.createdAt,
            comments: p.comments,
          );
        }
      }
    } catch (e) {
      debugPrint("Failed to like post: $e");
    }
  }

  Future<void> fetchPostDetails(String postId) async {
    try {
      final ApiClient apiClient = Get.find<ApiClient>();
      final response = await apiClient.get('/community/posts/$postId');
      if (response.isSuccess && response.data != null) {
        selectedPost.value = CommunityPostModel.fromJson(response.data);
      }
    } catch (e) {
      debugPrint("Failed to fetch post details: $e");
    }
  }

  Future<bool> addComment(String postId, String commentText) async {
    try {
      final ApiClient apiClient = Get.find<ApiClient>();
      final response = await apiClient.post(
        '/community/comments',
        data: {
          "post_id": postId,
          "content": commentText,
        },
      );

      if (response.isSuccess) {
        await fetchPostDetails(postId);
        // Also refresh feed to update comment counts if needed
        fetchPosts();
        return true;
      } else {
        Get.snackbar(
          'Error',
          response.message.isNotEmpty ? response.message : 'Failed to post comment',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
        return false;
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'An unexpected error occurred',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return false;
    }
  }
}
