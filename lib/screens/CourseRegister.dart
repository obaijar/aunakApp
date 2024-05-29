// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dio/dio.dart';
import 'package:testt/screens/CourseVideos.dart';
import 'package:get/get.dart';

class CourseRegister extends StatefulWidget {
  const CourseRegister({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CourseRegisterState createState() => _CourseRegisterState();
}

class _CourseRegisterState extends State<CourseRegister> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController phonenumberController = TextEditingController();

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('الدفع')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "سيرياتيل كاش",
                style: TextStyle(
                  fontSize: 14.sp,
                ),
              ),
              SizedBox(
                height: 30.h,
              ),
              Material(
                elevation: 4.0, // Adjust the elevation value as needed
                borderRadius: BorderRadius.circular(10.0),
                child: TextField(
                  controller: usernameController,
                  decoration: InputDecoration(
                    labelText: 'إسم المستخدم',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20.h,
              ),
              Material(
                elevation: 4.0, // Adjust the elevation value as needed
                borderRadius: BorderRadius.circular(10.0),
                child: TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: 'الإيميل',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20.h,
              ),
              Material(
                elevation: 4.0, // Adjust the elevation value as needed
                borderRadius: BorderRadius.circular(10.0),
                child: TextField(
                  controller: phonenumberController,
                  decoration: InputDecoration(
                    labelText: 'رقم الهاتف',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20.h,
              ),
              SizedBox(height: 20.h),
              isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: () async {
                        setState(() {
                          isLoading = true;
                        });

                        try {
                          var dio = Dio();
                          var url =
                              'https://jsonplaceholder.typicode.com/posts';
                          var response = await dio.post(
                            url,
                            data: {
                              'username': usernameController.text,
                              'email': emailController.text,
                              'password': passwordController.text,
                            },
                          );

                          if (response.statusCode == 201) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('تمت عملية الدفع بنجاح'),
                              ),
                            );

                            Get.to(const CourseVideo());
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                    'معلومات الدفع خاطئة , يرجى إعادة المحاولة'),
                              ),
                            );
                          }
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('حدث خطأ ما , يرجى اعادة المحاولة'),
                            ),
                          );
                        } finally {
                          setState(() {
                            isLoading = false;
                          });
                        }
                      },
                      child: Text(
                        'الدفع',
                        style: TextStyle(
                          fontSize: 15.sp,
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
