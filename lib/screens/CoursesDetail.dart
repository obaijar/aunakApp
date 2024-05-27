// ignore_for_file: depend_on_referenced_packages, file_names

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testt/screens/CourseVideos.dart';
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
      Get.to(const CourseVideo());
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  ": عن هذا الكورس",
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Text(
              'التفاصيل عن',
              style:
                  TextStyle(fontSize: 16.sp), // Adjust the font size as needed
            ),
            Text(
              '${widget.courseName}',
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
            FancyButton(
                button_text: "مشاهدة الكورس",
                button_height: 40,
                button_width: 150,
                button_color: const Color.fromARGB(255, 26, 114, 186),
                button_outline_color: Colors.white,
                button_outline_width: 1,
                button_text_color: Colors.white,
                button_icon_color: Colors.white,
                icon_size: 22,
                button_text_size: 15,
                onClick: _checkLoginStatus),
          ],
        ),
      ),
    );
  }
}
