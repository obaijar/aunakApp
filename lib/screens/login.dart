// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
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
  final TextEditingController usernameController = TextEditingController();
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
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: wScreen,
            height: hScreen * 0.4,
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("images/top1.png"), fit: BoxFit.contain)),
          ),
          Padding(
            padding: EdgeInsets.all(16.h),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  controller: usernameController,
                  decoration: InputDecoration(
                    labelText: 'البريد الإلكتروني',
                    labelStyle: TextStyle(fontSize: 12.sp),
                  ),
                ),
                TextField(
                  controller: passwordController,
                  decoration: InputDecoration(
                    labelText: 'كلمة السر',
                    labelStyle: TextStyle(fontSize: 12.sp),
                  ),
                  obscureText: true,
                ),
                SizedBox(height: 20.h),
                isLoading // Add this block
                    ? CircularProgressIndicator()
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
                                'username': usernameController.text,
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
                              Get.off(Home());
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                      'إسم المستخدم أو كلمة المرور خاطئة , يرجى اعادة المحاولة'),
                                ),
                              );
                            }
                          } catch (e) {
                            print('Error during login: $e');
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
                      Get.to(Home());
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
                )
              ],
            ),
          ),
          Container(
            width: wScreen,
            height: hScreen * 0.2,
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("images/bottom2.png"),
                    fit: BoxFit.contain)),
          ),
        ],
      ),
    );
  }
}
