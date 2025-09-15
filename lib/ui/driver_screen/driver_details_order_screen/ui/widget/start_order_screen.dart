import 'package:flutter/material.dart';

class StartOrderScreen extends StatelessWidget {
  final double fromLat;
  final double fromLng;
  final double toLat;
  final double toLng;
  final String userPhone; 

  const StartOrderScreen({
    super.key,
    required this.fromLat,
    required this.fromLng,
    required this.toLat,
    required this.toLng,
    required this.userPhone, 
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Start Order")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("From: ($fromLat, $fromLng)"),
            Text("To: ($toLat, $toLng)"),
            Text("User Phone: $userPhone"), 
          ],
        ),
      ),
    );
  }
}
