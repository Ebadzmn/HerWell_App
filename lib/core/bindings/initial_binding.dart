import 'package:get/get.dart';
import '../network/api_client.dart';
import '../services/notification_service.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(
      ApiClient(baseUrl: 'https://herwellness-server.vercel.app/api/v1'),
      permanent: true,
    );
    Get.putAsync<NotificationService>(
      () async => NotificationService().init(),
      permanent: true,
    );
  }
}
