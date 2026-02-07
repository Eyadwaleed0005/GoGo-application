import 'package:flutter/material.dart';
import 'package:gogo/ui/admin_screens/admin_home_screen.dart/ui/admin_home_screen.dart';
import 'package:gogo/ui/admin_screens/driver_check_data_screen/ui/check_data_driver_screen.dart';
import 'package:gogo/ui/admin_screens/driver_request_charge_screen/ui/driver_request_charge_screen.dart';
import 'package:gogo/ui/admin_screens/driver_wating_list_screen/data/model/driver_detils_arges_model.dart';
import 'package:gogo/ui/admin_screens/driver_wating_list_screen/ui/driver_waiting_list_screen.dart';
import 'package:gogo/ui/auth_screens/account_type_screen/ui/account_type_screen.dart';
import 'package:gogo/ui/auth_screens/driver_screen/car_driver_informaton_screen/ui/car_driver_information_screen.dart';
import 'package:gogo/ui/auth_screens/driver_screen/driver_auth_screen/driver_auth_screen.dart';
import 'package:gogo/ui/auth_screens/driver_screen/driver_register_screen/ui/driver_register_screen.dart';
import 'package:gogo/ui/auth_screens/driver_screen/driver_login_screen/ui/driver_login_screen.dart';
import 'package:gogo/ui/auth_screens/user_screen/account_method_selection_login_screen/ui/account_method_selection_login_screen.dart';
import 'package:gogo/ui/auth_screens/user_screen/account_method_selection_register_screen/ui/account_method_selection_register_screen.dart';
import 'package:gogo/ui/auth_screens/user_screen/user_login_screen/ui/login_screen.dart';
import 'package:gogo/ui/auth_screens/user_screen/phone_number_login_screen.dart/ui/phone_number_login_screen.dart';
import 'package:gogo/ui/auth_screens/user_screen/phone_number_regiester_screen.dart/ui/phone_number_regiester_screen.dart';
import 'package:gogo/ui/auth_screens/user_screen/reset_passoword_screen/ui/reset_password_screen.dart';
import 'package:gogo/ui/auth_screens/user_screen/user_auth_screen/rider_auth_screen.dart';
import 'package:gogo/ui/auth_screens/user_screen/user_register_screen/ui/register_user_screen.dart';
import 'package:gogo/ui/developer_screens/clear_secure_storage_screen.dart';
import 'package:gogo/ui/developer_screens/place_order_test_screen.dart';
import 'package:gogo/ui/driver_screen/driver_details_order_screen/ui/driver_details_order_screen.dart';
import 'package:gogo/ui/driver_screen/driver_history_screen/ui/driver_history_screen.dart';
import 'package:gogo/ui/driver_screen/driver_home_screen/ui/driver_home_screen.dart';
import 'package:gogo/ui/driver_screen/driver_order_list_screen/ui/driver_order_list_screen.dart';
import 'package:gogo/ui/driver_screen/driver_profile_screen/ui/driver_profile_screen.dart';
import 'package:gogo/ui/driver_screen/driver_wallet_screen/ui/driver_wallet_screen.dart';
import 'package:gogo/ui/driver_screen/driver_map_screen_driver/ui/driver_map_screen.dart';
import 'package:gogo/ui/driver_screen/on_wating_driver_screen/ui/on_wating_driver.dart';
import 'package:gogo/ui/driver_screen/reject_driver_screen/ui/reject_driver_screen.dart';
import 'package:gogo/ui/user_screens/coming_soon_screen/ui/coming_soon_screen.dart';
import 'package:gogo/ui/user_screens/home_screen/ui/home_screen.dart';
import 'package:gogo/ui/user_screens/map_screen/ui/map_screen.dart';
import 'package:gogo/ui/start_screens/languge_screen/ui/languge_screen.dart';
import 'package:gogo/ui/start_screens/on_boarding_screens/ui/on_boarding_screen.dart';
import 'package:gogo/ui/start_screens/otp_screen/ui/otp_screen.dart';
import 'package:gogo/ui/start_screens/splash_screen/ui/splash_screen.dart';
import 'package:gogo/ui/user_screens/privacy_policy_screen/ui/privacy_policy_screen.dart';
import 'package:gogo/ui/user_screens/services_screen/ui/services_screen.dart';
import 'package:gogo/ui/user_screens/user_history_screen.dart/ui/user_history_screen.dart';
import 'package:gogo/ui/user_screens/user_profile_screen/ui/user_profile_screen.dart';
import 'package:gogo/ui/user_screens/waiting_order_status_screen/ui/waiting_order_status_screen.dart';

class AppRoutes {
  ////  user screens
  static const String accountMethodSelectionLoginScreen =
      '/accountMethodSelectionLoginScreen';
  static const String accountMethodSelectionRegisterScreen =
      '/accountMethodSelectionRegisterScreen';
  static const String accountTypeScreen = '/accountTypeScreen';
  static const String editProfileScreen = '/editProfileScreen';
  static const String languageScreen = '/languageScreen';
  static const String userProfileScreen = '/userProfileScreen';
  static const String loginScreen = '/loginScreen';
  static const String mapScreen = '/mapScreen';
  static const String onboardingScreens = '/onboardingScreens';
  static const String userRegisterScreen = '/userRegisterScreen';
  static const String otpScreen = '/otpScreen';
  static const String phoneNumberLoginScreen = '/phoneNumberLoginScreen';
  static const String phoneNumberRegisterScreen = '/phoneNumberRegisterScreen';
  static const String resetPasswordScreen = '/resetPasswordScreen';
  static const String homeScreen = '/homeScreen';
  static const String privacyPolicyScreen = '/privacyPolicyScreen';
  static const String riderAuthScreen = '/riderAuthScreen';
  static const String servicesScreen = '/servicesScreen';
  static const String userHistoryScreen = '/userHistoryScreen';
  static const String comingSoonScreen = '/comingSoonScreen';
  static const String waitingOrderStatusScreen = '/waitingOrderStatusScreen';
  static const String splashScreen = '/splashScreen';
  //////////// Driver Screens //////////
  static const String carDriverInformationScreen =
      '/carDriverInformationScreen';
  static const String driverAuthScreen = '/driverAuthScreen';
  static const String driverLoginScreen = '/driverLoginScreen';
  static const String driverRegisterScreen = '/driverRegisterScreen';
  static const String onWaitingDriver = '/onWaitingDriver';
  static const String rejectDriverScreen = '/rejectDriverScreen';
  static const String driverMapScreen = '/driverMapScreen';
  static const String driverProfileScreen = '/driverProfileScreen';
  static const String driverWalletScreen = '/driverWalletScreen';
  static const String driverHomeScreen = '/driverHomeScreen';
  static const String driverHistoryScreen = '/driverHistoryScreen';
  static const String driverOrderListScreen = '/driverOrderListScreen';
  static const String driverDetailsOrderScreen = '/driverDetailsOrderScreen';
  /// screen developers only //
  static const String clearSecureStorageScreen = '/clearSecureStorageScreen';
  static const String placeOrderTestScreen = '/placeOrderTestScreen';
  ////Admin Screen////
  static const String driverWatingListScreen = '/driverWatingListScreen';
  static const String checkDataDriverScreen = '/checkDataDriverScreen';
  static const String driverRequestChargeScreen = '/driverRequestChargeScreen';
  static const String adminHomeScreen = '/adminHomeScreen';
  // 🔹 Route generator
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case clearSecureStorageScreen:
        return MaterialPageRoute(builder: (_) => ClearSecureStorageScreen());
       case waitingOrderStatusScreen:
        return MaterialPageRoute(builder: (_) => WaitingOrderStatusScreen());
      case comingSoonScreen:
        return MaterialPageRoute(builder: (_) => ComingSoonScreen());
      case userProfileScreen:
        return MaterialPageRoute(builder: (_) => UserProfileScreen());
      case userHistoryScreen:
        final profileImageUrl = settings.arguments as String?;
        return MaterialPageRoute(
          builder: (_) => UserHistoryScreen(profileImageUrl: profileImageUrl),
        );
      case placeOrderTestScreen:
        return MaterialPageRoute(builder: (_) => PlaceOrderTestScreen());
      case servicesScreen:
        return MaterialPageRoute(builder: (_) => ServicesScreen());
      case driverDetailsOrderScreen:
        final orderId = settings.arguments as int;
        return MaterialPageRoute(
          builder: (_) => DriverDetailsOrderScreen(orderId: orderId),
        );
      case driverOrderListScreen:
        return MaterialPageRoute(builder: (_) => DriverOrderListScreen());
      case accountMethodSelectionLoginScreen:
        return MaterialPageRoute(
          builder: (_) => AccountMethodSelectionLoginScreen(),
        );
      case privacyPolicyScreen:
        return MaterialPageRoute(builder: (_) => PrivacyPolicyScreen());
      case accountMethodSelectionRegisterScreen:
        return MaterialPageRoute(
          builder: (_) => AccountMethodSelectionRegisterScreen(),
        );
      case accountTypeScreen:
        return MaterialPageRoute(builder: (_) => AccountTypeScreen());
      ///Admin Screen///////////////////////////////////////////////
      case driverWatingListScreen:
        return MaterialPageRoute(builder: (_) => DriverWaitingListScreen());
      case AppRoutes.checkDataDriverScreen:
        final args = settings.arguments as DriverDetailsArgs;
        return MaterialPageRoute(
          builder: (_) => CheckDataDriverScreen(
            driverId: args.driverId,
            userId: args.userId,
          ),
        );
      case driverRequestChargeScreen:
        return MaterialPageRoute(builder: (_) => DriverRequestChargeScreen());
      case adminHomeScreen:
        return MaterialPageRoute(builder: (_) => AdminHomeScreen());
      /////////////////////////////////////////////////////////////
      case carDriverInformationScreen:
        return MaterialPageRoute(builder: (_) => CarDriverInformationScreen());
      case driverHistoryScreen:
        return MaterialPageRoute(builder: (_) => DriverHistoryScreen());
      case homeScreen:
        return MaterialPageRoute(builder: (_) => HomeScreen());
      case driverProfileScreen:
        return MaterialPageRoute(builder: (_) => DriverProfileScreen());
      case driverAuthScreen:
        return MaterialPageRoute(builder: (_) => DriverAuthScreen());
      case onWaitingDriver:
        return MaterialPageRoute(builder: (_) => OnWaitingDriver());
      case rejectDriverScreen:
        return MaterialPageRoute(builder: (_) => RejectDriverScreen());
      case driverHomeScreen:
        return MaterialPageRoute(builder: (_) => DriverHomeScreen());
      case driverLoginScreen:
        return MaterialPageRoute(builder: (_) => DriverLoginScreen());
      case driverRegisterScreen:
        return MaterialPageRoute(builder: (_) => DriverRegisterScreen());
      case driverWalletScreen:
        return MaterialPageRoute(builder: (_) => DriverWalletScreen());
      case languageScreen:
        return MaterialPageRoute(builder: (_) => LanguageScreen());
      case loginScreen:
        return MaterialPageRoute(builder: (_) => LoginScreen());
      case mapScreen:
        return MaterialPageRoute(builder: (_) => MapScreen());
      case onboardingScreens:
        return MaterialPageRoute(builder: (_) => OnboardingScreen());
      case otpScreen:
        return MaterialPageRoute(builder: (_) => OtpScreen());
      case phoneNumberLoginScreen:
        return MaterialPageRoute(builder: (_) => PhoneNumberLoginScreen());
      case driverMapScreen:
        return MaterialPageRoute(builder: (_) => DriverMapScreen());
      case phoneNumberRegisterScreen:
        return MaterialPageRoute(builder: (_) => PhoneNumberRegisterScreen());
      case resetPasswordScreen:
        return MaterialPageRoute(builder: (_) => ResetPasswordScreen());
      case riderAuthScreen:
        return MaterialPageRoute(builder: (_) => RiderAuthScreen());
      case splashScreen:
        return MaterialPageRoute(builder: (_) => SplashScreen());
      case userRegisterScreen:
        return MaterialPageRoute(builder: (_) => RegisterUserScreen());
      default:
        return MaterialPageRoute(builder: (_) => OnboardingScreen());
    }
  }
}
