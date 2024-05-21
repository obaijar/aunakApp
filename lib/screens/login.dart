import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:testt/screens/home.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testt/screens/register.dart'; // Add

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
                          setState(() {
                            isLoading = true; // Set loading state
                          });

                          try {
                            var url =
                                Uri.parse('https://dummyjson.com/auth/login');
                            var response = await http.post(
                              url,
                              body: jsonEncode({
                                'username': usernameController.text,
                                'password': passwordController.text,
                              }),
                              headers: {
                                'Content-Type': 'application/json',
                              },
                            );

                            if (response.statusCode == 200) {
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              prefs.setString(
                                  'username', usernameController.text);

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
                ElevatedButton(
                  onPressed: () async {
                    Get.to(RegisterScreen());
                  },
                  child: Text(
                    'التسجيل',
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
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("images/bottom2.png"),
                    fit: BoxFit.contain)),
          ),
        ],
      ),
    );
  }
}
