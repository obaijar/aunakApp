// ignore_for_file: depend_on_referenced_packages, file_names

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testt/screens/CourseRegister.dart';
import 'package:get/get.dart';
import 'package:fancy_button_flutter/fancy_button_flutter.dart';

class CourseDetailPage extends StatefulWidget {
  final String courseName;
  final String teacher;
  final String subject;
  final int section;
  const CourseDetailPage({
    super.key,
    required this.courseName,
    required this.teacher,
    required this.subject,
    required this.section,
  });

  @override
  State<CourseDetailPage> createState() => _CourseDetailPageState();
}

class _CourseDetailPageState extends State<CourseDetailPage> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future<String> getUsername() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getString('username') ?? '';
  }

  void _checkLoginStatus() async {
    String username = await getUsername();
    if (username.isEmpty) {
      _showNotLoggedInDialog();
    } else {
      // Proceed with the action for logged-in users
      Get.to(const CourseRegister());
    }
  }

  void _showNotLoggedInDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('تسجيل الدخول'),
          content: const Text('للمتابعة  يرجى تسجيل الدخول'),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    String sectionName = '';
    if (widget.section == 1) sectionName = "تاسع";
    if (widget.section == 2) sectionName = "بكالوريا علمي";
    if (widget.section == 3) sectionName = "بكالوريا أدبي";
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(widget.courseName),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("images/121.png"),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    " عن هذا الكورس",
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Text(
                'التفاصيل عن',
                style: TextStyle(
                    fontSize: 16.sp), // Adjust the font size as needed
              ),
              Text(
                widget.courseName,
                style: TextStyle(fontSize: 16.sp),
              ),
              Text(
                'الإستاذ: ${widget.teacher}',
                style: TextStyle(fontSize: 16.sp),
              ),
              Text(
                'المادة: ${widget.subject}',
                style: TextStyle(fontSize: 16.sp),
              ),
              Text(
                'الصف: $sectionName',
                style: TextStyle(fontSize: 16.sp),
              ),
              const SizedBox(
                height: 50,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                      child: Card(
                    elevation: 2.0, // Small elevation
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Container(
                      width: 100.w, // Width of the card
                      height: 35.h, // Height of the card
                      padding: EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            'السعر',
                            style:
                                TextStyle(fontSize: 16.sp, color: Colors.blue),
                          ),
                        ],
                      ),
                    ),
                  )),
                  SizedBox(
                    width: 10.w,
                  ),
                  FancyButton(
                      button_text: "التسجيل في الكورس",
                      button_height: 40.h,
                      button_width: 150.w,
                      button_color: const Color.fromARGB(255, 26, 114, 186),
                      button_outline_color: Colors.white,
                      button_text_color: Colors.white,
                      button_text_size: 15.sp,
                      onClick: _checkLoginStatus),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
