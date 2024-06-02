// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dio/dio.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController phonenumberController = TextEditingController();

  bool isLoading = false;
  String selectedRole = 'طالب تاسع'; // Default value

  @override
  Widget build(BuildContext context) {
    final double wScreen = MediaQuery.of(context).size.width;
    final double hScreen = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(title: const Text('التسجيل')),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
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
                children: [
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
                        labelStyle: TextStyle(fontSize: 12.sp),
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
                        labelStyle: TextStyle(fontSize: 12.sp),
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
                      controller: passwordController,
                      decoration: InputDecoration(
                        labelStyle: TextStyle(fontSize: 12.sp),
                        labelText: 'كلمة المرور',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      obscureText: true,
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
                        labelStyle: TextStyle(fontSize: 12.sp),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        "نوع الحساب",
                        style: TextStyle(
                          fontSize: 17.sp,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Material(
                    elevation: 4.0, // Adjust the elevation value as needed
                    borderRadius: BorderRadius.circular(10.0),
                    child: DropdownButtonFormField<String>(
                      value: selectedRole,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                      ),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedRole = newValue!;
                        });
                      },
                      items: <String>[
                        'طالب بكالوريا أدبي',
                        'طالب بكالوريا علمي',
                        'طالب تاسع',
                        'أستاذ',
                        'أدمن'
                      ].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                  SizedBox(height: 20.h),
                  isLoading
                      ? const CircularProgressIndicator(color: Colors.blue)
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
                                  'role':
                                      selectedRole, // Include the selected role
                                },
                              );

                              if (response.statusCode == 201) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('تم التسجيل بنجاح'),
                                  ),
                                );
                                Navigator.pop(context);
                              } else {
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
                                      Text('حدث خطأ ما , يرجى اعادة المحاولة'),
                                ),
                              );
                            } finally {
                              setState(() {
                                isLoading = false;
                              });
                            }
                          },
                          child: Text(
                            'التسجيل',
                            style:
                                TextStyle(fontSize: 15.sp, color: Colors.blue),
                          ),
                        ),
                ],
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
