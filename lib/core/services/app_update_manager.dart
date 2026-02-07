import 'package:flutter/material.dart';
import 'package:in_app_update/in_app_update.dart';

class AppUpdateManager {
  static Future<void> checkForUpdate(BuildContext context) async {
    try {
      final info = await InAppUpdate.checkForUpdate();
      if (info.updateAvailability == UpdateAvailability.updateAvailable &&
          info.immediateUpdateAllowed) {
        await InAppUpdate.performImmediateUpdate();
      }
    } catch (e) {
      debugPrint("Error checking for update: $e");
    }
  }
}
