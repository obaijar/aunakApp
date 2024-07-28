// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:testt/screens/ChangePassword.dart';
import 'package:get/get.dart';

class Profile extends StatelessWidget {
  final String username;
  final String email;
  final String firstName;
  final String lastName;
  final String gender;

  const Profile({
    super.key,
    required this.username,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.gender,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          ListTile(
            leading: Icon(Icons.account_circle, size: 35.w),
            title: Text('الإسم',
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Roboto',
                )),
            subtitle: Text(firstName,
                style: TextStyle(
                  fontSize: 12.sp,
                )),
          ),
          ListTile(
            leading: Icon(Icons.email, size: 35.w),
            title: Text(
              'الإيميل',
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.bold,
                fontFamily: 'Roboto',
              ),
            ),
            subtitle: Text(
              email,
              style: TextStyle(
                fontSize: 12.sp,
              ),
            ),
          ),
          // Add the change password button
          const SizedBox(height: 20),
          Center(
            child: ElevatedButton(
              onPressed: () {
                Get.to(ChangePassword());
                // Handle change password logic here
              },
              child: Text(
                'تغيير كلمة المرور',
                style: TextStyle(
                  fontSize: 15.sp,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
