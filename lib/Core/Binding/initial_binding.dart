// import 'package:get/get.dart';
// import '../../Controller/internet_controller.dart';
// import '../../Ripositoryes/auth_reporitory.dart';
// import '../../Ripositoryes/job_repository.dart';
// import '../../Ripositoryes/user_profile_repository.dart';
// import '../../Ripositoryes/ratings_feedback_repository.dart';
// import '../../Ripositoryes/user_repository.dart';
// import '../../Ripositoryes/socket_repository.dart';
// import '../../Services/api_client.dart';
// import '../../Services/auth_service.dart';
// import '../../Services/job_service.dart';
// import '../../Services/storege_service.dart';
// import '../../Services/socket_service.dart';
// import '../../Services/user_profile_service.dart';
// import '../../Services/ratings_feedback_service.dart';
// import '../../Services/user_service.dart';
// import '../../Ripositoryes/support_repository.dart';
// import '../../Ripositoryes/community_repository.dart';
// import '../../Services/support_service.dart';
// import '../../Services/community_service.dart';
// import '../../Views/auth/Splash_Screen/controller/splashcontroller.dart';
//
// import '../../Views/home/ChatPage/Controller/Chat_controller.dart';
// import '../../Views/home/Bottom_NabBar/Controller/bottom_nabbar_controller.dart';
// import '../../Views/home/RidesPage/Controller/Rides_controller.dart';
// import '../../Views/home/JobOfferPage/My_jobs/Controller/My_job_controller.dart';
//
// class InitialBinding extends Bindings {
//   @override
//   void dependencies() {
//     Get.put(InternetController(), permanent: true);
//     Get.put(ApiClient(), permanent: true);
//     Get.put(StorageService(), permanent: true);
//
//     // Repos আগে
//     Get.put(AuthRepo(apiClient: Get.find()), permanent: true);
//     Get.put(UserRepo(apiClient: Get.find()), permanent: true); // 👈 যোগ করো
//     Get.put(UserProfileRepo(apiClient: Get.find()), permanent: true);
//     Get.put(JobRepo(apiClient: Get.find()), permanent: true);
//     Get.put(RatingsFeedbackRepo(apiClient: Get.find()), permanent: true);
//     Get.put(SocketRepository(apiClient: Get.find()), permanent: true);
//     Get.put(SupportRepo(apiClient: Get.find()), permanent: true);
//     Get.put(CommunityRepo(apiClient: Get.find()), permanent: true);
//
//     // Services পরে
//     Get.put(UserService(), permanent: true); // 👈 AuthService এর আগে দাও
//     Get.put(SocketService(), permanent: true);
//     Get.put(AuthService(), permanent: true);
//     Get.put(SupportService(), permanent: true);
//     Get.put(CommunityService(), permanent: true);
//     Get.put(UserProfileService(userProfileRepo: Get.find()), permanent: true);
//     Get.put(JobService(), permanent: true);
//     Get.put(
//       RatingsFeedbackService(ratingsFeedbackRepo: Get.find()),
//       permanent: true,
//     );
//
//     Get.lazyPut(() => SplashScreenController());
//
//     // Controllers
//     Get.lazyPut(() => NavigationController());
//     Get.lazyPut(() => BookingController());
//     Get.lazyPut(() => RidesController());
//     Get.lazyPut(() => ChatController());
//   }
// }