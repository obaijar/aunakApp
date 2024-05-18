import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class RegisterScreen extends StatelessWidget {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  RegisterScreen({super.key});

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
            ElevatedButton(
              onPressed: () async {
                try {
                  var url =
                      Uri.parse('https://jsonplaceholder.typicode.com/posts');
                  var response = await http.post(
                    url,
                    body: jsonEncode({
                      'username': usernameController.text,
                      'email': emailController.text,
                      'password': passwordController.text,
                    }),
                    headers: {
                      'Content-Type': 'application/json',
                    },
                  );
                  final jsonResponse = json.decode(response.body);

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
                  print(e.toString());
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
