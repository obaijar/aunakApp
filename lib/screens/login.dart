// ignore_for_file: depend_on_referenced_packages, use_key_in_widget_constructors, library_private_types_in_public_api, avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:testt/screens/home.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false; // Add this line

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text(
            'تسجيل الدخول',
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.bold,
              fontFamily: 'Roboto',
            ),
          ),
        ),
        body: buildHomeWidget(),
      ),
    );
  }

  Widget buildHomeWidget() {
    final double wScreen = MediaQuery.of(context).size.width;
    final double hScreen = MediaQuery.of(context).size.height;
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            width: wScreen,
            height: hScreen * 0.25,
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("images/Vector 1.jpg"),
                    fit: BoxFit.contain)),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Material(
                  elevation: 4.0, // Adjust the elevation value as needed
                  borderRadius: BorderRadius.circular(
                      10.0), // Match border radius for consistency
                  child: TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: 'البريد الإلكتروني',
                      labelStyle: TextStyle(fontSize: 12.sp),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      prefixIcon: Icon(Icons.person),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20.h,
                ),
                Material(
                  elevation: 4.0, // Adjust the elevation value as needed
                  borderRadius: BorderRadius.circular(
                      10.0), // Match border radius for consistency
                  child: TextField(
                    controller: passwordController,
                    decoration: InputDecoration(
                      labelText: 'كلمة السر',
                      labelStyle: TextStyle(fontSize: 12.sp),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      prefixIcon: Icon(Icons.lock),
                    ),
                    obscureText: true,
                  ),
                ),
                SizedBox(height: 20.h),
                isLoading // Add this block
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: () async {
                          var connectivityResult =
                              await Connectivity().checkConnectivity();
                          bool isConnected = connectivityResult.any(
                              (result) => result != ConnectivityResult.none);
                          if (!isConnected) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                    'لا يوجد اتصال بالإنترنت. يرجى المحاولة مرة أخرى'),
                              ),
                            );
                            return; // Exit the button press function if no connection
                          }
                          setState(() {
                            isLoading = true; // Set loading state
                          });

                          try {
                            var url = 'https://dummyjson.com/auth/login';
                            var dio = Dio();

                            var response = await dio.post(
                              url,
                              data: {
                                'username': emailController.text,
                                'password': passwordController.text,
                              },
                              options: Options(
                                headers: {
                                  'Content-Type': 'application/json',
                                },
                              ),
                            );
                            final jsonResponse = response.data;
                            final String username = jsonResponse['username'];
                            final String email = jsonResponse['email'];
                            final String firstName = jsonResponse['firstName'];
                            final String lastName = jsonResponse['lastName'];
                            final String gender = jsonResponse['gender'];

                            if (response.statusCode == 200) {
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              prefs.setString('email', email.toString());
                              prefs.setString(
                                  'firstName', firstName.toString());
                              prefs.setString('lastName', lastName.toString());
                              prefs.setString('gender', gender.toString());
                              prefs.setString('username', username.toString());
                              Get.off(const Home());
                            }

                            if (response.statusCode == 400) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                      'إسم المستخدم أو كلمة المرور خاطئة , يرجى اعادة المحاولة'),
                                ),
                              );
                            }
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content:
                                    Text('هناك خطأ ما , يرجى اعادة المحاولة'),
                              ),
                            );
                          } finally {
                            setState(() {
                              isLoading = false; // Reset loading state
                            });
                          }
                        },
                        child: Text(
                          'تسجيل الدخول',
                          style: TextStyle(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Roboto',
                          ),
                        ),
                      ),
                SizedBox(height: 10.h),
                Center(
                  child: GestureDetector(
                    onTap: () {
                      Get.to(const Home());
                    },
                    child: Text(
                      'زائر',
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                width: 100.w,
                height: 200.w,
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("images/Vector 2.jpg"),
                        fit: BoxFit.contain)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
