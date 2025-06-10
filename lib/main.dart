import 'package:app/View/Home_Page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:app/Controller/pusher_controller.dart'; // Ensure correct casing: pusher_controller.dart

void main() {
  // Initialize PusherController with the required API key and cluster,
  // and assign the tag 'pusher' so it can be found later.
  Get.put(PusherController(apiKey: "cb788493e8aa5bf58a70", cluster: "mt1"), tag: 'pusher');

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