import 'package:get/get.dart';
import 'package:uremz100/Features/Auth/Views/Forgot_OTP_Screen/forgot_OTP_Screen.dart';
import 'package:uremz100/Features/Auth/Views/Forgot_Pass_Screen/forgot_Pass_Screen.dart';
import 'package:uremz100/Features/Auth/Views/Set_Pass_Screen/set_Pass_Screen.dart';
import 'package:uremz100/Features/Auth/Views/SignIn_Screen/signIn_Screen.dart';
import 'package:uremz100/Features/Auth/Views/SignUp_Screen/signUp_Screen.dart';
import 'package:uremz100/Features/Auth/Views/Signin_&_Signup_Screen/Signin_And_Signup_Screen.dart';
import 'package:uremz100/Features/Home/Views/Bottom_NabBar/Bottom_NabBar_Screens.dart';
import 'package:uremz100/Features/Home/Views/My_List/my_list_screen.dart';
import 'package:uremz100/Features/Home/Views/Profile/Change_password/change_password.dart';
import 'package:uremz100/Features/Home/Views/Profile/Change_profile_info/change_profile_info.dart';
import 'package:uremz100/Features/Home/Views/Profile/Change_email/change_email.dart';
import 'package:uremz100/Features/Home/Views/Profile/Privacy_Policy/privacy_policy.dart';
import 'package:uremz100/Features/Home/Views/Profile/Settings/settings_screen.dart';
import 'package:uremz100/Features/Home/Views/Profile/User_agreement/user_agreement.dart';
import 'package:uremz100/Features/Home/Views/Rewards/rewards_screen.dart';
import 'package:uremz100/Features/Home/Views/Shorts/More/more_screen.dart';
import 'package:uremz100/Features/Home/Views/Shorts/Shorts_FullSeriesScreen.dart';
import 'package:uremz100/Features/Home/Views/Shorts/shorts_screen.dart';
import 'package:uremz100/Features/Home/Views/Standard_VIP/standard_vip.dart';
import '../Features/Auth/Welcome_Screen/welcome_Screen.dart';
import '../Features/Home/Views/Discover/discover_screen.dart';
import 'package:uremz100/Features/Home/Views/Discover/Detail/discover_detail_screen.dart';

class Routes {
  static const String welcomeScreen = "/WelcomeScreen";
  static const String movieDetailScreen = "/MovieDetailScreen";
  static const String signinAndSignupScreen = "/SigninAndSignupScreen";
  static const String signinScreen = "/SigninScreen";
  static const String signupScreen = "/SignupScreen";
  static const String forgotPassScreen = "/ForgotPassScreen";
  static const String forgotOtpScreen = "/ForgotOtpScreen";
  static const String setPassScreen = "/SetPassScreen";
  static const String bottomNabbarScreens = "/BottomNabbarScreens";
  static const String discoverScreen = "/DiscoverScreen";
  static const String settingsScreen = "/SettingsScreen";
  static const String changeProfileInfo = "/change_profile_info";
  static const String changeEmail = "/change_email";
  static const String changePassword = "/change_password";
  static const String privacyPolicy = "/privacy_policy";
  static const String userAgreement = "/user_agreement";
  static const String standardVip = "/StandardVip";
  static const String myListScreen = "/MyListScreen";
  static const String rewardsScreen = "/RewardsScreen";
  static const String shortsScreen = "/ShortsScreen";
  static const String shortsFullSeriesOverlay = "/ShortsFullSeriesOverlay";
  static const String moreScreen = "/MoreScreen";

  static List<GetPage> routes = [
    GetPage(
      name: welcomeScreen,
      page: () => WelcomeScreen(),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: signinAndSignupScreen,
      page: () => SigninAndSignupScreen(),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: signinScreen,
      page: () => SigninScreen(),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: signupScreen,
      page: () => SignupScreen(),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: forgotPassScreen,
      page: () => ForgotPassScreen(),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: forgotOtpScreen,
      page: () => ForgotOtpScreen(),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: setPassScreen,
      page: () => SetPassScreen(),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: bottomNabbarScreens,
      page: () => BottomNabbarScreens(),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: discoverScreen,
      page: () => DiscoverScreen(),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: settingsScreen,
      page: () => SettingsScreen(),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: changeProfileInfo,
      page: () => ChangeProfileInfoScreen(),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: changeEmail,
      page: () => ChangeEmailScreen(),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: changePassword,
      page: () => ChangePasswordScreen(),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: privacyPolicy,
      page: () => PrivacyPolicyScreen(),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: userAgreement,
      page: () => UserAgreementScreen(),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: standardVip,
      page: () => StandardVip(),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: myListScreen,
      page: () => MyListScreen(),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: rewardsScreen,
      page: () => RewardsScreen(),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: shortsScreen,
      page: () => ShortsScreen(),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: shortsFullSeriesOverlay,
      page: () => ShortsFullSeriesScreen(),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: moreScreen,
      page: () => MoreScreen(movieId: Get.arguments?['movieId'] ?? ''),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: movieDetailScreen,
      page: () => const MovieDetailScreen(),
      transition: Transition.noTransition,
    ),
  ];
}
