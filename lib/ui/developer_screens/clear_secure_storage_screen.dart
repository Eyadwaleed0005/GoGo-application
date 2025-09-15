import 'package:flutter/material.dart';
import 'package:gogo/core/local/secure_storage.dart';
import 'package:gogo/core/local/shared_preferences.dart';

class ClearSecureStorageScreen extends StatelessWidget {
  const ClearSecureStorageScreen({super.key});

  Future<void> _clearStorage(BuildContext context) async {
    // مسح البيانات من SecureStorage
    await SecureStorageHelper.clearAll();

    // مسح البيانات من SharedPreferences
    await SharedPreferencesHelper.clearAll();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("✅ All secure & shared storage data has been cleared!"),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Clear All Storage"),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () => _clearStorage(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
          ),
          child: const Text("Clear All"),
        ),
      ),
    );
  }
}
