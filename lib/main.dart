import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uremz100/Config/routes.dart';
import 'package:uremz100/Shared/Widgets/pip_wrapper_video_Popup.dart';
import 'package:uremz100/Utils/app_colors.dart';
import 'package:uuid/uuid.dart';

import 'package:uremz100/core/services/storage_service.dart';
import 'package:uremz100/core/network/network_caller.dart';
import 'package:uremz100/Data/Repositories/home_repository.dart';
import 'package:uremz100/Data/Repositories/content_details_repository.dart';
import 'package:uremz100/Data/Datasources/Remote/user_remote_datasource.dart' as uremz100_user_remote;
import 'package:uremz100/Data/Repositories/user_profile_repository.dart' as uremz100_user_repo;
import 'package:uremz100/Data/Datasources/Remote/search_remote_datasource.dart';
import 'package:uremz100/Data/Repositories/search_repository.dart';
import 'package:uremz100/Domain/UseCases/search_content_usecase.dart';
import 'package:uremz100/core/services/rewards_service.dart';
import 'package:uremz100/core/services/admob_service.dart';
import 'package:uremz100/core/services/location_service.dart';

Future<void> _initializeGuestId() async {
  final prefs = await SharedPreferences.getInstance();
  String? guestId = prefs.getString('guest_id');
  if (guestId == null) {
    const uuid = Uuid();
    guestId = 'guest-${uuid.v4()}';
    await prefs.setString('guest_id', guestId);
    debugPrint('guest id generate hoyse $guestId');
  }
}

void main() async {
  // Ensure Flutter is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Services and Core Components
  await Get.putAsync(() => StorageService().init());
  Get.put(NetworkCaller());
  Get.put(HomeRepository());
  Get.put(ContentDetailsRepository());
  Get.put(uremz100_user_remote.UserRemoteDataSource());
  Get.put(uremz100_user_repo.UserProfileRepo());
  Get.put(SearchRemoteDataSource());
  Get.put(SearchRepository(Get.find()));
  Get.put(SearchContentUseCase(Get.find()));
  Get.put(RewardsService());
  Get.put(AdMobService());

  // // Initialize Firebase
  // await Firebase.initializeApp();
  //
  // // Initialize Firebase Messaging
  // await FirebaseNotificationService.initialize();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  
  await _initializeGuestId();

  // Detect Country on Startup
  final locationService = Get.put(LocationService());
  locationService.detectCountryOnStartup();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      splitScreenMode: true,
      child: GetMaterialApp(
        theme: ThemeData(scaffoldBackgroundColor: AppColors.black100),
        debugShowCheckedModeBanner: false,
        getPages: Routes.routes,
        initialRoute: Routes.welcomeScreen,
        builder: (context, child) {
          return child != null
              ? PipWrapper(child: child)
              : const SizedBox.shrink();
        },
      ),
    );
  }
}
