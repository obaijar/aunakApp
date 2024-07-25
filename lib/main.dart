// ignore_for_file: depend_on_referenced_packages
import 'package:flutter/material.dart';
import 'package:testt/screens/home.dart';
import 'package:testt/screens/onboarding.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:device_preview/device_preview.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

SharedPreferences? prefs;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  prefs = await SharedPreferences.getInstance();
  runApp(
    DevicePreview(
      enabled: true,
      builder: (context) => const MyApp(),
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
          theme: ThemeData(
            // Change the scaffold background color here
            scaffoldBackgroundColor: Colors.white,
          ),
          debugShowCheckedModeBanner: false,
          home: FutureBuilder<bool>(
            future: isLoggedIn(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                    child: CircularProgressIndicator(
                  color: Colors.blue,
                )); // Show loading indicator
              } else if (snapshot.hasError) {
                // Handle potential errors
                return const Center(child: Text('حدث خطأ ما '));
              } else {
                if (snapshot.data == true) {
                  return const Home();
                } else {
                  return Onbording(); // Correct the class name to Onboarding
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
    return username != null && username.isNotEmpty;
  }
}
