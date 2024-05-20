import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CourseDetailPage extends StatefulWidget {
  final String courseName;
  final String teacher;
  final String subject;
  final int section;
  const CourseDetailPage({
    required this.courseName,
    required this.teacher,
    required this.subject,
    required this.section,
  });

  @override
  State<CourseDetailPage> createState() => _CourseDetailPageState();
}

class _CourseDetailPageState extends State<CourseDetailPage> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

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
      print('User is logged in');
    }
  }

  void _showNotLoggedInDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('تسجيل الدخول'),
          content: Text('للمتابعة  يرجى تسجيل الدخول'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
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
      appBar: AppBar(
        title: Text(widget.courseName),
      ),
      body: Center(
        child: Column(
          children: [
            Text(
                'Details for cource  ${widget.courseName}  teacher: ${widget.teacher} , subject${widget.subject} , section $sectionName'),
            ElevatedButton(
              onPressed: _checkLoginStatus,
              child: Text(
                'مشاهدة الكورس',
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Roboto',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
