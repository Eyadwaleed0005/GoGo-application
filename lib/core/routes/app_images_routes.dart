class AppImage {
  // 🟡 Singleton Pattern
  static AppImage? _instance;
  factory AppImage() {
    _instance ??= AppImage._internal();
    return _instance!;
  }
  AppImage._internal();

  // 📂 Base paths
  String get base => 'assets/images/';
  String get baseAnimation => 'assets/animation/';
  String get baseIcons => 'assets/icons/';
  String get baseKeys => 'assets/keys/';

  // 🎞 Animations
  String get splashScreenAnimation => '${baseAnimation}Man_waiting_car.json';
  String get loginAnimation        => '${baseAnimation}login.json';
  String get adriver               => '${baseAnimation}A_driver.json';
  String get otp                   => '${baseAnimation}otp.json';
  String get loading               => '${baseAnimation}loading.json';
  String get emptyBox              => '${baseAnimation}Empty_Box.json';
  String get car                   => '${baseAnimation}car.json';
  String get sucsses               => '${baseAnimation}sucsses.json';
  String get error                 => '${baseAnimation}Error.json';
  String get searching             => '${baseAnimation}searching.json';

  // 🖼 Onboarding & Banners
  String get onboard1 => '${base}onboard1.jpg';
  String get business => '${base}business-man-car.png';
  String get onboard2 => '${base}onboard2.jpg';
  String get onboard3 => '${base}onboard3.jpg';
  String get onboard5 => '${base}onboard5.jpg';
  String get onboard8 => '${base}onborder8.jpg';
  String get backGround1 => '${base}background1.png';
  String get backGround2 => '${base}background2.png';
  String get commingSoon => '${base}commingsoon.png';
  String get bannar => '${base}bannar1.png';
  String get bannar2 => '${base}bannar2.png';

  // 🔑 Auth Screens
  String get auth1  => '${base}auth.webp';
  String get driver => '${base}driver.jpg';
  

  // 🍔 Categories
  String get food => '${base}food.png';
  String get box  => '${base}box.png';
  String get taxi   => '${base}taxi.png';
  String get bus  => '${base}bus.png';
  
  
  // 🌍 Social Media Icons
  String get facebook => '${base}Facebook.png';
  String get google   => '${base}Google.png';
  String get defultProfileAccount  => '${base}defult_profile_account.png';
  String get language => '${base}language.jpg';
  String get taxiIcon => '${baseIcons}taxi icon.png';
  String get busIcon  => '${baseIcons}bus icon.png';
  String get calendar => '${baseIcons}calendar.png';
  String get delivery  => '${baseIcons}delivery.png';
  String get servises => '${baseIcons}servises.png';
  String get privacyPolicy => '${baseIcons}privacy_policy.png';
  String get masterCard => '${baseIcons}Mastercard.png';
  String get activity => '${baseIcons}Activity.png';
  String get notifications => '${base}notifications.png';
  // keys
  String get notificationKey => '${baseKeys}serviceAccountKey.json';
}
