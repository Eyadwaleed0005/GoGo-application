import 'package:shared_preferences/shared_preferences.dart';

class DriverDailyAmountHelper {
  static const String _driverDailyAmountKey = 'driverDailyAmount';
  static const String _lastUpdatedDateKey = 'lastUpdatedDate';

  static Future<int> getDailyAmount() async {
    final prefs = await SharedPreferences.getInstance();
    final today = DateTime.now().toIso8601String().split('T')[0]; 
    final lastUpdated = prefs.getString(_lastUpdatedDateKey);

    if (lastUpdated != today) {
      await prefs.setInt(_driverDailyAmountKey, 0);
      await prefs.setString(_lastUpdatedDateKey, today);
      return 0;
    }

    return prefs.getInt(_driverDailyAmountKey) ?? 0;
  }

  static Future<void> addToDailyAmount(int amount) async {
    final prefs = await SharedPreferences.getInstance();
    int currentAmount = await getDailyAmount();
    currentAmount += amount;
    await prefs.setInt(_driverDailyAmountKey, currentAmount);
  }
}
