class EndPoints {
  static const String baseurl = "https://in-drive.runasp.net";

  // ---------------- AUTH ----------------
  static const String registerUser = "$baseurl/api/UsersIdentity/Register";
  static const String loginUser = "$baseurl/api/UsersIdentity/Login";

  // ---------------- DRIVER ----------------
  static const String getDataDriver = "$baseurl/api/Driver";
  static String getDriverData(String userId) => "$getDataDriver/$userId";
  static String updateDriverStatus(int driverId) => "$getDataDriver/$driverId/status";
  static String getDriverHistory(String userId) => "$baseurl/api/TripsHistory/driver/$userId";
  static const String sendDriverPay = "$baseurl/api/Driver/requestcharge";
  static const String deductDriverAmount = "$baseurl/api/Driver/deductwallet";
  static const String updateDriverLocation = "$baseurl/api/Location/update";
  static const String addDriverHistory = "$baseurl/api/TripsHistory";
  static const String getDriverPlaces = "$baseurl/api/Location/drivers";


  // ---------------- ORDERS ----------------
  static const String getAllOrders = "$baseurl/api/Orders";
  static String getOrderDetails(int orderId) => "$baseurl/api/Orders/$orderId"; 
  static String deleteOrder(int orderId) => "$baseurl/api/Orders/$orderId";


  // ---------------- CAR ----------------
  static const String sendDataCar = "$baseurl/api/CarData";
  static String getCarData(int driverId) => "$baseurl/api/CarData/by-driver/$driverId";

  // ---------------- ADMIN ----------------
  static const String getDriverWaitingList = "$baseurl/api/Driver/pending";
  static const String getDriverCharges = "$baseurl/api/Driver/charges"; 
  static String sendDriverAction(int chargeId) => "$baseurl/api/Driver/charge/$chargeId/action";

  // ---------------- MAPBOX ----------------
  static const String mapboxBase = "https://api.mapbox.com";
  static const String geocoding = "$mapboxBase/geocoding/v5/mapbox.places";
  static const String directions = "$mapboxBase/directions/v5/mapbox/driving";

  static const String accessToken =
      "pk.eyJ1IjoiZXlhZHdhbGVlZDIzMzIiLCJhIjoiY21lN3JuZnRvMDZlOTJrcGdldXZzODh6YiJ9.xee3Qn8oGLQkBldduDQYhA";

  // ---------------- FCM ----------------
  static String sendFcmMessage(String projectId) =>
      "https://fcm.googleapis.com/v1/projects/$projectId/messages:send";

  static const String fcmScope = "https://www.googleapis.com/auth/firebase.messaging";

  // ---------------- COMMUNICATION ----------------
  static String whatsappUrl(String phone, String message) =>
      "https://wa.me/$phone?text=${Uri.encodeComponent(message)}";

  static String telUrl(String phone) => "tel:$phone";

// ---------------- USER ----------------
static String updateUserImage(String userId) =>
    "$baseurl/api/UsersIdentity/UpdateImage/$userId";
static String getUserImage(String userId) =>
    "$baseurl/api/UsersIdentity/GetImage/$userId";
  static String getUserHistory(String userId) => "$baseurl/api/UserHistory/user/$userId";
}
