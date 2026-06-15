import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../core/app_colors.dart';
import '../../core/app_route.dart';

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({super.key});

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  String _selectedCategory = 'all';
  final List<String> _categories = [
    'all',
    'general',
    'tips',
    'support',
    'workout',
    'nutrition',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            // Top Section with Gradient
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.homeGradientStart,
                    AppColors.homeGradientMid,
                    AppColors.homeGradientEnd,
                  ],
                ),
              ),
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () => Get.back(),
                            child: const Icon(
                              Icons.arrow_back_ios_rounded,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                          const Spacer(),
                          const Icon(
                            Icons.search_rounded,
                            color: Colors.white,
                            size: 24,
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'Community',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const Text(
                        'Connect with your tribe',
                        style: TextStyle(fontSize: 16, color: Colors.white70),
                      ),
                      const SizedBox(height: 24),

                      // Create Post Input Card
                      GestureDetector(
                        onTap: _showCreatePostDialog,
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 18,
                                backgroundColor: AppColors.background
                                    .withOpacity(0.4),
                                child: const Text(
                                  'M',
                                  style: TextStyle(
                                    color: AppColors.textPrimary,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              const Expanded(
                                child: Text(
                                  "What's on your mind?",
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.textPrimary,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Text(
                                  'Post',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Category filters
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: _categories.map((cat) {
                            final isActive = _selectedCategory == cat;
                            return GestureDetector(
                              onTap: () =>
                                  setState(() => _selectedCategory = cat),
                              child: Container(
                                margin: const EdgeInsets.only(right: 8),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: isActive
                                      ? Colors.white.withOpacity(0.3)
                                      : Colors.white.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: isActive
                                        ? Colors.white
                                        : Colors.white24,
                                  ),
                                ),
                                child: Text(
                                  cat.toUpperCase(),
                                  style: const TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),

            // Content Section
            Transform.translate(
              offset: const Offset(0, -20),
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      _buildPostCard(
                        username: 'Sarah M.',
                        category: 'workout',
                        timeAgo: '2h ago',
                        content:
                            'Just finished a great follicular phase workout! Energy levels are 🔥',
                        likes: 24,
                      ),
                      const SizedBox(height: 16),
                      _buildPostCard(
                        username: 'Emma W.',
                        category: 'nutrition',
                        timeAgo: '4h ago',
                        content:
                            'Tried the iron-rich lentil soup recipe today. It was delicious and perfect for my period week! 🥣',
                        likes: 18,
                      ),
                      const SizedBox(height: 16),
                      _buildPostCard(
                        username: 'Jessica L.',
                        category: 'support',
                        timeAgo: '6h ago',
                        content:
                            'Anyone else feeling extra tired during the luteal phase? Struggling to stay motivated today. 😴',
                        likes: 32,
                      ),
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCreatePostDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text(
          'Create Post',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              maxLines: 4,
              decoration: InputDecoration(
                hintText: "What's on your mind?",
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.textPrimary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Post'),
          ),
        ],
      ),
    );
  }

  Widget _buildPostCard({
    required String username,
    required String category,
    required String timeAgo,
    required String content,
    required int likes,
  }) {
    return GestureDetector(
      onTap: () => Get.toNamed(AppRoute.postDetail),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: AppColors.background.withOpacity(0.4),
                  child: Text(
                    username[0],
                    style: const TextStyle(color: AppColors.textPrimary),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            username,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(width: 8),
                          _buildCategoryBadge(category),
                        ],
                      ),
                      Text(
                        timeAgo,
                        style: const TextStyle(
                          fontSize: 11,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.more_horiz, color: Colors.grey),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              content,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textPrimary,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _buildActionButton(
                  Icons.favorite_border_rounded,
                  likes.toString(),
                ),
                const SizedBox(width: 20),
                _buildActionButton(
                  Icons.chat_bubble_outline_rounded,
                  'Comment',
                ),
                const Spacer(),
                const Icon(Icons.flag_outlined, size: 18, color: Colors.grey),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryBadge(String category) {
    Color color;
    Color bg;
    switch (category) {
      case 'workout':
        color = Colors.orange[700]!;
        bg = Colors.orange[50]!;
        break;
      case 'nutrition':
        color = Colors.green[700]!;
        bg = Colors.green[50]!;
        break;
      case 'support':
        color = Colors.pink[700]!;
        bg = Colors.pink[50]!;
        break;
      case 'tips':
        color = Colors.blue[700]!;
        bg = Colors.blue[50]!;
        break;
      default:
        color = Colors.grey[700]!;
        bg = Colors.grey[100]!;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        category,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String label) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.textMuted),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
        ),
      ],
    );
  }
}
