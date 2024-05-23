import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
            leading: Icon(Icons.email, size: 25.w),
            title: Text(
              'Email',
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
          ListTile(
            leading: Icon(Icons.account_circle, size: 25.w),
            title: Text('First Name',
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
            leading: Icon(Icons.account_circle, size: 25.w),
            title: Text('Last Name',
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Roboto',
                )),
            subtitle: Text(lastName,
                style: TextStyle(
                  fontSize: 12.sp,
                )),
          ),
          ListTile(
            leading: Icon(
              Icons.person_outline, size: 25.w, // Adjust the size as needed
            ),
            title: Text('Gender',
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.bold,
                )),
            subtitle: Text(gender,
                style: TextStyle(
                  fontSize: 12.sp,
                )),
          ),
        ],
      ),
    );
  }
}
