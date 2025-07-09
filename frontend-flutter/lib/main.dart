// main.dart
import 'package:app/View/Home_Page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:app/Controller/pusher_controller.dart'; // Ensure correct casing

void main() {
  // Initialize PusherController with the CORRECT API key from your Pusher dashboard.
  // The App Key from your 'SmartIncubatorApp' dashboard is '2c9ed517b4b8133b9f8b'.
  Get.put(PusherController(apiKey: "2c9ed517b4b8133b9f8b", cluster: "mt1"),
      tag: 'pusher');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(
        fontFamily: 'Roboto',
      ),
      debugShowCheckedModeBanner: false,
      title: 'F.F',
      home: const HomePage(),
    );
  }
}
