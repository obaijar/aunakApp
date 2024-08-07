// ignore_for_file: depend_on_referenced_packages, file_names

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dio/dio.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class RegisterStudent extends StatefulWidget {
  const RegisterStudent({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _RegisterStudentState createState() => _RegisterStudentState();
}

class _RegisterStudentState extends State<RegisterStudent> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController passwordConformationController =
      TextEditingController();
  final TextEditingController phonenumberController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  String selectedRole = '..'; // Default value
  bool isadmin = false;
  @override
  Widget build(BuildContext context) {
    final double wScreen = MediaQuery.of(context).size.width;
    final double hScreen = MediaQuery.of(context).size.height;
    final bool isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    return Scaffold(
      appBar: AppBar(title: const Text('التسجيل')),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
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
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Material(
                      elevation: 4.0, // Adjust the elevation value as needed
                      borderRadius: BorderRadius.circular(10.0),
                      child: TextFormField(
                        controller: usernameController,
                        decoration: InputDecoration(
                          labelText: 'إسم المستخدم',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          labelStyle: TextStyle(fontSize: 12.sp),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'يرجى إدخال إسم المستخدم';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    Material(
                      elevation: 4.0, // Adjust the elevation value as needed
                      borderRadius: BorderRadius.circular(10.0),
                      child: TextFormField(
                        controller: emailController,
                        decoration: InputDecoration(
                          labelStyle: TextStyle(fontSize: 12.sp),
                          labelText: 'الإيميل',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'يرجى إدخال الإيميل';
                          }
                          if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                            return 'يرجى إدخال بريد إلكتروني صحيح';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    Material(
                      elevation: 4.0, // Adjust the elevation value as needed
                      borderRadius: BorderRadius.circular(10.0),
                      child: TextFormField(
                        controller: passwordController,
                        decoration: InputDecoration(
                          labelStyle: TextStyle(fontSize: 12.sp),
                          labelText: 'كلمة المرور',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'يرجى إدخال كلمة المرور';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    Material(
                      elevation: 4.0, // Adjust the elevation value as needed
                      borderRadius: BorderRadius.circular(10.0),
                      child: TextFormField(
                        controller: passwordConformationController,
                        decoration: InputDecoration(
                          labelStyle: TextStyle(fontSize: 12.sp),
                          labelText: 'تأكيد كلمة المرور',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'يرجى إدخال كلمة المرور';
                          }
                          if (value != passwordController.text) {
                            return 'كلمة المرور غير متطابقة';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    isLoading
                        ? const CircularProgressIndicator(color: Colors.blue)
                        : ElevatedButton(
                            onPressed: () async {
                              var connectivityResult =
                                  await Connectivity().checkConnectivity();
                              bool isConnected = connectivityResult.any(
                                  (result) =>
                                      result != ConnectivityResult.none);
                              if (!isConnected) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('لا يوجد اتصال بالإنترنت'),
                                  ),
                                );
                                return; // Exit the button press function if no connection
                              }
                              if (_formKey.currentState!.validate()) {
                                setState(() {
                                  isLoading = true;
                                });

                                try {
                                  if (selectedRole == 'أدمن') isadmin = true;
                                  var dio = Dio();
                                  var url =
                                      'https://obai.aunakit-hosting.com/api/register/';
                                  var response = await dio.post(
                                    url,
                                    data: {
                                      'username': usernameController.text,
                                      'password': passwordController.text,
                                      'is_admin':
                                          false, // Include the selected role
                                      'email': emailController.text
                                    },
                                    options: Options(
                                      headers: {
                                        'Content-Type': 'application/json',
                                      },
                                    ),
                                  );

                                  if (response.statusCode == 200) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('تم التسجيل بنجاح'),
                                      ),
                                    );
                                    Navigator.pop(context);
                                  }
                                  if (response.statusCode == 403) {
                                    //var responseBody = response.data;

                                    //if (responseBody['username'] != null &&
                                    //   responseBody['username'].contains(
                                    //      'A user with that username already exists.')) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('يوجد مستخدم بهذا الاسم'),
                                      ),
                                    );
                                    //}
                                  }
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text("يوجد مستخدم بهذا الاسم"),
                                    ),
                                  );
                                } finally {
                                  setState(() {
                                    isLoading = false;
                                  });
                                }
                              }
                            },
                            child: Text(
                              'التسجيل',
                              style: TextStyle(
                                  fontSize: 15.sp, color: Colors.blue),
                            ),
                          ),
                  ],
                ),
              ),
            ),
            Row(
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
      ),
    );
  }
}
