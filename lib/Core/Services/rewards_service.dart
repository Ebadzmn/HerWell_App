import 'package:get/get.dart';
import 'package:uremz100/core/network/network_caller.dart';

class RewardsService extends GetxService {
  final NetworkCaller _networkCaller = Get.find<NetworkCaller>();

  // Real API: POST /api/v1/rewards/claim/check-in
  Future<Map<String, dynamic>> claimDailyCheckIn() async {
    try {
      final response = await _networkCaller.postRequest<Map<String, dynamic>>(
        '/rewards/claim/check-in',
      );

      if (response.isSuccess) {
        final fullJson = response.data ?? {};
        return {
          "success": true,
          "statusCode": response.statusCode,
          "message": response.message,
          "data": fullJson['data'],
        };
      } else {
        return {
          "success": false,
          "statusCode": response.statusCode,
          "message": response.message,
          "data": null,
        };
      }
    } catch (e) {
      return {
        "success": false,
        "statusCode": 500,
        "message": e.toString(),
        "data": null,
      };
    }
  }

  // Real API: GET /api/v1/rewards/wallet
  Future<Map<String, dynamic>> fetchWallet() async {
    try {
      final response = await _networkCaller.getRequest<Map<String, dynamic>>(
        '/rewards/wallet',
      );

      if (response.isSuccess) {
        final fullJson = response.data ?? {};
        return {
          "success": true,
          "statusCode": response.statusCode,
          "message": response.message,
          "data": fullJson['data'],
        };
      } else {
        return {
          "success": false,
          "statusCode": response.statusCode,
          "message": response.message,
          "data": null,
        };
      }
    } catch (e) {
      return {
        "success": false,
        "statusCode": 500,
        "message": e.toString(),
        "data": null,
      };
    }
  }

  // Real API: POST /api/v1/rewards/claim/watch-time
  Future<Map<String, dynamic>> claimWatchTimeReward(int videoDuration) async {
    try {
      final response = await _networkCaller.postRequest<Map<String, dynamic>>(
        '/rewards/claim/watch-time',
        data: {
          "videoDuration": videoDuration
        }
      );

      if (response.isSuccess) {
        final fullJson = response.data ?? {};
        return {
          "success": true,
          "statusCode": response.statusCode,
          "message": response.message,
          "data": fullJson['data'],
        };
      } else {
        return {
          "success": false,
          "statusCode": response.statusCode,
          "message": response.message,
          "data": null,
        };
      }
    } catch (e) {
      return {
        "success": false,
        "statusCode": 500,
        "message": e.toString(),
        "data": null,
      };
    }
  }

  // Real API: POST /api/v1/rewards/claim/task
  Future<Map<String, dynamic>> claimTaskReward(String taskType) async {
    try {
      final response = await _networkCaller.postRequest<Map<String, dynamic>>(
        '/rewards/claim/task',
        data: {
          "taskType": taskType
        }
      );

      if (response.isSuccess) {
        final fullJson = response.data ?? {};
        return {
          "success": true,
          "statusCode": response.statusCode,
          "message": response.message,
          "data": fullJson['data'],
        };
      } else {
        return {
          "success": false,
          "statusCode": response.statusCode,
          "message": response.message,
          "data": null,
        };
      }
    } catch (e) {
      return {
        "success": false,
        "statusCode": 500,
        "message": e.toString(),
        "data": null,
      };
    }
  }
}
