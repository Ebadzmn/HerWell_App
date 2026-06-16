import 'package:get/get.dart';
import '../network/api_client.dart';
import '../services/notification_service.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ApiClient(baseUrl: 'http://10.10.7.111:5000/api/v1'), permanent: true);
    Get.putAsync<NotificationService>(() async => NotificationService().init(), permanent: true);
  }
}
