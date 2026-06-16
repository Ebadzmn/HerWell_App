import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../core/network/api_client.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class HomeController extends GetxController {
  var selectedDate = DateTime.now().obs;
  var currentPhase = 'Follicular'.obs;
  var cycleDay = 8.obs;
  var cycleLength = 28.obs;
  var periodStartDate = DateTime.now().subtract(const Duration(days: 7)).obs;

  // AI Insights and Daily Logs tracking
  final recentLogs = <dynamic>[].obs;
  final isLoadingInsights = false.obs;
  final aiInsights = Rxn<Map<String, dynamic>>();
  final isInsightsExpanded = false.obs;
  final lastInsightsGenerated = Rxn<DateTime>();

  IO.Socket? socket;

  @override
  void onInit() {
    super.onInit();
    fetchCycleData();
    calculatePhase();
    fetchRecentLogs();
    initSocket();
  }

  @override
  void onClose() {
    socket?.disconnect();
    socket?.dispose();
    super.onClose();
  }

  Future<void> fetchCycleData() async {
    try {
      final ApiClient apiClient = Get.find<ApiClient>();
      final response = await apiClient.get('/cycle/cycle-data');
      if (response.isSuccess && response.data != null && response.data is List && (response.data as List).isNotEmpty) {
        final cycleData = response.data[0]; // Get the latest cycle data
        if (cycleData['cycle_length'] != null) {
          cycleLength.value = cycleData['cycle_length'];
        }
        if (cycleData['cycle_start_date'] != null) {
          try {
            periodStartDate.value = DateTime.parse(cycleData['cycle_start_date']);
          } catch (_) {}
        }
        calculatePhase();
      }
    } catch (e) {
      debugPrint("Failed to fetch cycle data: $e");
    }
  }

  void initSocket() async {
    try {
      final ApiClient apiClient = Get.find<ApiClient>();
      final String socketUrl = apiClient.baseUrl.replaceFirst('/api/v1', '');
      
      socket = IO.io(socketUrl, IO.OptionBuilder()
        .setTransports(['websocket', 'polling'])
        .enableAutoConnect()
        .build()
      );
      
      socket?.onConnect((_) async {
        debugPrint("🔌 Connected to Socket.io server");
        // Register user
        final userResponse = await apiClient.get('/auth/me');
        if (userResponse.isSuccess && userResponse.data != null) {
          final userId = userResponse.data['id'];
          if (userId != null) {
            socket?.emit('register', userId);
          }
        }
      });
      
      socket?.on('notification', (data) {
        debugPrint("📢 Socket notification received: $data");
        if (data != null && data['message'] != null) {
          Get.snackbar(
            data['title'] ?? 'Cycle Notification',
            data['message'],
            snackPosition: SnackPosition.TOP,
            backgroundColor: const Color(0xFFE8927C).withOpacity(0.95),
            colorText: Colors.white,
            duration: const Duration(seconds: 5),
          );
          
          // Re-fetch cycle data or logs if updated
          if (data['type'] == 'menstrual_stage' || data['type'] == 'menstrual_log') {
            fetchCycleData();
            fetchRecentLogs();
          }
        }
      });
      
      socket?.onDisconnect((_) => debugPrint("❌ Disconnected from Socket.io server"));
    } catch (e) {
      debugPrint("Failed to initialize socket connection: $e");
    }
  }

  Future<void> fetchRecentLogs() async {
    try {
      final ApiClient apiClient = Get.find<ApiClient>();
      final response = await apiClient.get(
        '/cycle/daily-logs',
        queryParameters: {
          "sort": "-date",
          "limit": 90,
        },
      );
      if (response.isSuccess && response.data != null && response.data is List) {
        recentLogs.value = response.data;
      }
    } catch (e) {
      debugPrint("Failed to fetch recent daily logs: $e");
    }
  }

  Future<void> generateInsights() async {
    if (recentLogs.length < 5 || isLoadingInsights.value) return;
    try {
      isLoadingInsights.value = true;
      final ApiClient apiClient = Get.find<ApiClient>();
      
      final summary = recentLogs.take(60).map((l) {
        final date = l['date'] ?? '';
        final phase = l['phase'] ?? '?';
        final cycleDay = l['cycle_day'] ?? '?';
        final mood = l['mood'] ?? '?';
        final checkins = (l['checkins'] as List?)?.join(', ') ?? 'nothing';
        return "$date | Phase: $phase | Day: $cycleDay | Mood: $mood | Done: $checkins";
      }).join('\n');

      final response = await apiClient.post(
        '/integration/ai/coach',
        data: {
          "prompt": "You are a women's health and fitness coach. Analyse the following ${recentLogs.length} days of daily check-in data for a user tracking their menstrual cycle and wellness habits.\n\nData (date | phase | cycle day | mood | activities):\n$summary\n\nProvide 3-4 concise, encouraging, and specific insights about:\n1. Patterns between cycle phase and mood/energy\n2. Which habits (workout, walk, self care, water, eating well) correlate with better mood\n3. Any consistency trends (e.g. workouts drop in a specific phase)\n4. One actionable tip personalised to their data\n\nKeep each insight to 1-2 sentences. Be warm and supportive.",
          "response_json_schema": {
            "type": "object",
            "properties": {
              "insights": {
                "type": "array",
                "items": {
                  "type": "object",
                  "properties": {
                    "title": {"type": "string"},
                    "body": {"type": "string"},
                    "emoji": {"type": "string"}
                  }
                }
              },
              "summary": {"type": "string"}
            }
          }
        },
      );

      if (response.isSuccess && response.data != null) {
        aiInsights.value = Map<String, dynamic>.from(response.data);
        lastInsightsGenerated.value = DateTime.now();
        isInsightsExpanded.value = true;
      } else {
        aiInsights.value = {"error": true};
      }
    } catch (e) {
      aiInsights.value = {"error": true};
    } finally {
      isLoadingInsights.value = false;
    }
  }

  void selectDate(DateTime date) {
    selectedDate.value = date;
    calculatePhase();
  }

  void calculatePhase() {
    final difference = selectedDate.value.difference(periodStartDate.value).inDays;
    cycleDay.value = (difference % cycleLength.value) + 1;
    currentPhase.value = getPhaseForDate(selectedDate.value);
  }

  String getPhaseForDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final targetDate = DateTime(date.year, date.month, date.day);
    
    final difference = targetDate.difference(periodStartDate.value).inDays;
    final dayInCycle = (difference % cycleLength.value) + 1;

    if (dayInCycle <= 5) {
      if (targetDate.isAfter(today)) {
        return 'Predicted period';
      }
      return 'Menstruation';
    } else if (dayInCycle <= 13) {
      return 'Follicular';
    } else if (dayInCycle <= 16) {
      return 'Ovulation';
    } else {
      return 'Luteal';
    }
  }

  int getDayInCycleForDate(DateTime date) {
    final difference = date.difference(periodStartDate.value).inDays;
    return (difference % cycleLength.value) + 1;
  }

  void updateCycleData({DateTime? startDate, int? length}) {
    if (startDate != null) periodStartDate.value = startDate;
    if (length != null) cycleLength.value = length;
    calculatePhase();
  }

  int getPhaseNumber() {
    final day = getDayInCycleForDate(selectedDate.value);
    if (day <= 5) return 1;
    if (day <= 13) return 2;
    if (day <= 16) return 3;
    return 4;
  }

  Color getPhaseColor(String phase) {
    switch (phase) {
      case 'Menstruation':
        return const Color(0xFFFFD1D1);
      case 'Predicted period':
        return const Color(0xFFFFEBEB);
      case 'Follicular':
        return const Color(0xFFFFF4D1);
      case 'Ovulation':
        return const Color(0xFFD1F9ED);
      case 'Luteal':
        return const Color(0xFFE8D1FF);
      default:
        return Colors.transparent;
    }
  }
}
