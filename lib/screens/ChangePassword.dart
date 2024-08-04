// ignore_for_file: file_names, depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _currentPasswordController =
      TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();

  Future<void> _changePassword() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (_formKey.currentState!.validate()) {
      final String currentPassword = _currentPasswordController.text;
      final String newPassword = _newPasswordController.text;

      var dio = Dio();
      var url = 'http://10.0.2.2:8000/api/change-password/';

      try {
        var response = await dio.post(
          url,
          data: {
            'current_password': currentPassword,
            'new_password': newPassword,
          },
          options: Options(
            headers: {
              'Authorization': 'Token $token',
              'Content-Type': 'application/json',
            },
          ),
        );

        if (response.statusCode == 200) {
          // Handle successful response
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('تم تغيير كلمة المرور')),
          );
          Navigator.of(context).pop();
        } else {
          // Handle error response
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to change password')),
          );
        }
      } catch (e) {
        // Handle any exceptions that occur during the POST request
        print('Error: $e'); // Optionally log the error
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('كلمة المرور الحالية غير صحيحة')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('تغيير كلمة المرور')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _currentPasswordController,
                decoration: InputDecoration(
                  labelText: 'كلمة المرور الحالية',
                  labelStyle: TextStyle(fontSize: 14.sp),
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'الرجاء إدخال كلمة المرور الحالية';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _newPasswordController,
                decoration: InputDecoration(
                  labelText: 'كلمة المرور الجديدة',
                  labelStyle: TextStyle(fontSize: 14.sp),
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'الرجاء إدخال كلمة المرور الجديدة';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: _changePassword,
                  child: Text(
                    'تغيير',
                    style: TextStyle(fontSize: 15.sp),
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
