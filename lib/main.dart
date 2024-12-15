import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'view/Home_Screen.dart';
import 'view/Main_Screen.dart';
import 'view/Visit_Screen.dart';
import 'view/Backpack_Screen.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return const GetMaterialApp(
      title: 'Tour Guide',
      debugShowCheckedModeBanner: false,
      home: MainScreen(),
    );
  }
}
