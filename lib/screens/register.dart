import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('التسجيل')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: usernameController,
              decoration: const InputDecoration(labelText: 'إسم المستخدم'),
            ),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'الإيميل'),
            ),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: 'كلمة المرور'),
              obscureText: true,
            ),
            SizedBox(height: 20.h),
            isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: () async {
                      setState(() {
                        isLoading = true;
                      });

                      try {
                        var dio = Dio();
                        var url = 'https://jsonplaceholder.typicode.com/posts';
                        var response = await dio.post(
                          url,
                          data: {
                            'username': usernameController.text,
                            'email': emailController.text,
                            'password': passwordController.text,
                          },
                        );

                        final jsonResponse = response.data;

                        // Access the value of 'id'
                        final int id = jsonResponse['id'];
                        print("status code ${response.statusCode}");
                        if (response.statusCode == 201) {
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          prefs.setString('id', id.toString());

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
                        print(e);
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
                    child: const Text('التسجيل'),
                  ),
          ],
        ),
      ),
    );
  }
}
