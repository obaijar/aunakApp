// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:testt/screens/home.dart';
import 'package:testt/screens/onboarding.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:device_preview/device_preview.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import shared_preferences

SharedPreferences? prefs;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  prefs = await SharedPreferences.getInstance();
  runApp(
    DevicePreview(
      enabled: true,
      builder: (context) => const MyApp(), // Wrap your app
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (BuildContext context, child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          home: FutureBuilder<bool>(
            future: isLoggedIn(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Container(); // Show loading indicator while checking login status
              } else {
                if (snapshot.data == true) {
                  // If user is logged in, navigate to Home screen
                  return const Home();
                } else {
                  // If user is not logged in, go to Onboarding screen
                  return Onbording();
                }
              }
            },
          ),
        );
      },
    );
  }

  Future<bool> isLoggedIn() async {
    String? username = prefs?.getString('username');
    return username != null &&
        username.isNotEmpty; // Check if username is not null or empty
  }
}
