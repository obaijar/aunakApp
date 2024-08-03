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
    final bool isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            width: wScreen,
            height: isLandscape ? hScreen : hScreen * 0.25,
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
                      prefixIcon: const Icon(Icons.person),
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
                      prefixIcon: const Icon(Icons.lock),
                    ),
                    obscureText: true,
                  ),
                ),
                SizedBox(height: 20.h),
                isLoading // Add this block
                    ? const CircularProgressIndicator(color: Colors.blue)
                    : ElevatedButton(
                        onPressed: () async {
                          var connectivityResult =
                              await Connectivity().checkConnectivity();
                          bool isConnected = connectivityResult.any(
                              (result) => result != ConnectivityResult.none);
                          if (!isConnected) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('لا يوجد اتصال بالإنترنت'),
                              ),
                            );
                            return; // Exit the button press function if no connection
                          }

                          setState(() {
                            isLoading = true; // Set loading state
                          });

                          try {
                            var url = 'http://10.0.2.2:8000/api/login/';
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
                            if (response.statusCode == 200) {
                              final jsonResponse = response.data;
                              print("token");
                              final int id = jsonResponse['user_id'];
                              final String token = jsonResponse['token'];
                              final String username = jsonResponse['user'];
                              final bool isadmin = jsonResponse['isadmin'];
                              /*final jsonResponse = response.data;
                              final String username = jsonResponse['username'];
                              final String email = jsonResponse['email'];
                              final String firstName =
                                  jsonResponse['firstName'];
                              final String lastName = jsonResponse['lastName'];
                              final String gender = jsonResponse['gender'];*/

                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              prefs.setString('token', token.toString());
                              prefs.setString('id', id.toString());
                              prefs.setString('username', username.toString());
                              prefs.setString('isadmin', isadmin.toString());
                              Get.off(const Home());
                            }
                          } on DioException catch (e) {
                            print(e);
                            if (e.response?.statusCode == 401) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                      'إسم المستخدم أو كلمة المرور خاطئة , يرجى اعادة المحاولة'),
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content:
                                      Text('هناك خطأ ما , يرجى اعادة المحاولة'),
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
                        child: Text('تسجيل الدخول',
                            style: TextStyle(
                              color: Colors.blue,
                              fontSize: 15.sp,
                              fontWeight: FontWeight.bold,
                            )),
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
