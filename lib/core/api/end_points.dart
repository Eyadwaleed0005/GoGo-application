class EndPoints {
  static const String baseurl = "http://38.242.129.50:5000";

  // ---------------- AUTH ----------------
  static const String registerUser = "$baseurl/api/UsersIdentity/Register";
  static const String loginUser = "$baseurl/api/UsersIdentity/Login";
  static String deleteAccount(String userId) =>
      "$baseurl/api/UsersIdentity/Delete/$userId";

  // ---------------- DRIVER ----------------
  static const String getDataDriver = "$baseurl/api/Driver";
  static String getDriverData(String userId) => "$getDataDriver/$userId";
  static String updateDriverStatus(int driverId) =>
      "$getDataDriver/$driverId/status";
  static String getDriverHistory(String userId) =>
      "$baseurl/api/TripsHistory/driver/$userId";
  static const String sendDriverPay = "$baseurl/api/Driver/requestcharge";
  static const String deductDriverAmount = "$baseurl/api/Driver/deductwallet";
  static const String updateDriverLocation = "$baseurl/api/Location/update";
  static const String addDriverHistory = "$baseurl/api/TripsHistory";
  static const String getDriverPlaces = "$baseurl/api/Location/drivers";
  static String getDriverPlace(int driverId) =>
      "$baseurl/api/Location/driver/$driverId";
  static String driverReview(int driverId) =>
      "$baseurl/api/Driver/$driverId/review";

  static String getDriverById(int driverId) =>
      "$baseurl/api/Driver/DriverId/$driverId";

  // ---------------- ORDERS ----------------
  static const String getAllOrders = "$baseurl/api/Orders";
  static String getOrderDetails(int orderId) => "$baseurl/api/Orders/$orderId";
  static const String createOrder = "$baseurl/api/Orders";
  static const String updateOrder = "$baseurl/api/Orders/driver";
  static String getOrderById(int orderId) => "$baseurl/api/Orders/$orderId";
  static String deleteOrder(int orderId) => "$baseurl/api/Orders/$orderId";

  // ---------------- CAR ----------------
  static const String sendDataCar = "$baseurl/api/CarData";
  static String getCarData(int driverId) =>
      "$baseurl/api/CarData/by-driver/$driverId";

  // ---------------- ADMIN ----------------
  static const String getDriverWaitingList = "$baseurl/api/Driver/pending";
  static const String getDriverCharges = "$baseurl/api/Driver/charges";
  static String sendDriverAction(int chargeId) =>
      "$baseurl/api/Driver/charge/$chargeId/action";
  static const String getDriverapproved = "$baseurl/api/Driver/approved";



  // ---------------- FCM ----------------
  static String sendFcmMessage(String projectId) =>
      "https://fcm.googleapis.com/v1/projects/$projectId/messages:send";

  static const String fcmScope =
      "https://www.googleapis.com/auth/firebase.messaging";

  // ---------------- COMMUNICATION ----------------
  static String whatsappUrl(String phone, String message) =>
      "https://wa.me/$phone?text=${Uri.encodeComponent(message)}";

  static String telUrl(String phone) => "tel:$phone";

  // ---------------- USER ----------------
  static String updateUserImage(String userId) =>
      "$baseurl/api/UsersIdentity/UpdateImage/$userId";
  static String getUserImage(String userId) =>
      "$baseurl/api/UsersIdentity/GetImage/$userId";
  static String getUserHistory(String userId) =>
      "$baseurl/api/UserHistory/user/$userId";
  static const String savePassengerHistory = "$baseurl/api/UserHistory";

  // ===== Cloudinary Config =====
  static const String cloudinaryCloudName = 'docvppjyh';
  static const String cloudinaryUploadPreset = 'gogo_unsigned';
  static const String cloudinaryFolder = 'gogo_app';
  static String get cloudinaryUploadUrl =>
      'https://api.cloudinary.com/v1_1/$cloudinaryCloudName/image/upload';

  // ---------------- Google maps ----------------

  static const String googleMapsKey = "AIzaSyA4Ie0jJRI6OUJPCqvXi8tsVI_x1sUhCv0";
  static const String googlePlacesAutocomplete =
      "https://maps.googleapis.com/maps/api/place/autocomplete/json";
  static const String googlePlaceDetails =
      "https://maps.googleapis.com/maps/api/place/details/json";
  static const String googleGeocode =
      "https://maps.googleapis.com/maps/api/geocode/json";
  static const String googleDirections =
      "https://maps.googleapis.com/maps/api/directions/json";
}
