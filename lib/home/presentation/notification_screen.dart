import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/app_colors.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> notifications = [
      {
        'title': 'Phase Update',
        'desc': 'You have entered the Ovulation phase. Peak energy levels expected!',
        'time': '2h ago',
        'icon': Icons.wb_sunny_rounded,
        'color': const Color(0xFFF5D6C6),
        'isRead': false,
      },
      {
        'title': 'Workout Reminder',
        'desc': 'Time for your Peak Performance strength session.',
        'time': '5h ago',
        'icon': Icons.fitness_center_rounded,
        'color': const Color(0xFFE8D5C4),
        'isRead': false,
      },
      {
        'title': 'Nutrition Tip',
        'desc': 'Focus on complex carbs today to maintain steady energy.',
        'time': 'Yesterday',
        'icon': Icons.apple_rounded,
        'color': const Color(0xFFC8DCC8),
        'isRead': true,
      },
      {
        'title': 'Cycle Insight',
        'desc': 'Your cycle has been very regular for the last 3 months. Great job logging!',
        'time': '2 days ago',
        'icon': Icons.auto_awesome,
        'color': const Color(0xFFA78BCA).withOpacity(0.2),
        'isRead': true,
      },
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF2D2420), size: 20),
        ),
        title: const Text(
          'Notifications',
          style: TextStyle(
            color: Color(0xFF2D2420),
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontFamily: 'Georgia',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text(
              'Mark all as read',
              style: TextStyle(color: Color(0xFFE8927C), fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: notifications.isEmpty
          ? _buildEmptyState()
          : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final item = notifications[index];
                return _buildNotificationCard(item);
              },
            ),
    );
  }

  Widget _buildNotificationCard(Map<String, dynamic> item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: item['isRead'] ? Colors.white.withOpacity(0.6) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: !item['isRead']
            ? Border.all(color: const Color(0xFFE8927C).withOpacity(0.3), width: 1)
            : null,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: item['color'],
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(item['icon'], color: const Color(0xFF2D2420).withOpacity(0.7), size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      item['title'],
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF2D2420).withOpacity(item['isRead'] ? 0.6 : 1.0),
                      ),
                    ),
                    Text(
                      item['time'],
                      style: TextStyle(
                        fontSize: 11,
                        color: const Color(0xFF8B7355).withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  item['desc'],
                  style: TextStyle(
                    fontSize: 13,
                    color: const Color(0xFF5C4A3A).withOpacity(item['isRead'] ? 0.6 : 0.9),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          if (!item['isRead'])
            Container(
              margin: const EdgeInsets.only(left: 8, top: 4),
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: Color(0xFFE8927C),
                shape: BoxShape.circle,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: const Color(0xFFEDE6DD),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.notifications_off_outlined, size: 40, color: Color(0xFFD4C5B9)),
          ),
          const SizedBox(height: 24),
          const Text(
            'All caught up!',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D2420),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'No new notifications at the moment.',
            style: TextStyle(color: Color(0xFF8B7355)),
          ),
        ],
      ),
    );
  }
}
