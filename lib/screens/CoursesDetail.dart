import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testt/screens/CourseRegister.dart';
import 'package:get/get.dart';
import 'package:fancy_button_flutter/fancy_button_flutter.dart';
import 'package:http/http.dart' as http;

class CourseDetailPage extends StatefulWidget {
  final String courseName;
  final int courseID;
  final int teacher;
  final String subject;
  final int section;

  const CourseDetailPage({
    super.key,
    required this.courseName,
    required this.courseID,
    required this.teacher,
    required this.subject,
    required this.section,
  });

  @override
  State<CourseDetailPage> createState() => _CourseDetailPageState();
}

class _CourseDetailPageState extends State<CourseDetailPage> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  String? description;
  int? price;

  @override
  void initState() {
    super.initState();
    _fetchCourseDescription();
  }

  Future<void> _fetchCourseDescription() async {
    final SharedPreferences prefs = await _prefs;
    String? token = prefs.getString('token');
    if (token == null || token.isEmpty) {
      _showNotLoggedInDialog();
      return;
    }
    int grade = _getGradeInt(widget.section);

    print(grade);
    print(widget.subject);
    print(widget.teacher);
    print(widget.courseID);

    String url =
        'http://10.0.2.2:8000/api/courses/search/$grade/${widget.subject}/${widget.courseID}/${widget.teacher}/';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {'Authorization': 'Token $token'},
      );

      if (response.statusCode == 200) {
        var data = json.decode(utf8.decode(response.bodyBytes));
        if (data is List && data.isNotEmpty) {
          // Assuming we want the description and price of the first course in the list
          setState(() {
            description = data[0]['description'] as String?;
            price = data[0]['price'] as int?;
          });
        } else {
          print('Unexpected response format or empty data: $data');
        }
      } else {
        print('Failed to fetch course description: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching course description: $e');
    }
  }

  int _getGradeInt(int section) {
    switch (section) {
      case 9:
        return 1;
      case 12:
        return 2;
      case 13:
        return 3;
      default:
        return 0;
    }
  }

  Future<String> getUsername() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getString('username') ?? '';
  }

  void _checkLoginStatus() async {
    String username = await getUsername();
    if (username.isEmpty) {
      _showNotLoggedInDialog();
    } else {
      Get.to(() => CourseRegister(
            courseID: widget.courseID,
            courseName: widget.courseName,
            teacher: widget.teacher,
            subject: widget.subject,
            section: widget.section,
          ));
    }
  }

  void _showNotLoggedInDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('تسجيل الدخول'),
          content: const Text('للمتابعة يرجى تسجيل الدخول'),
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
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(widget.courseName),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset("images/121.png"),
                if (description != null) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'عن هذا الكورس',
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    description!,
                    style: TextStyle(fontSize: 16.sp),
                  ),
                ],
                const SizedBox(height: 20),
                if (price != null) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'السعر',
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Card(
                      elevation: 4.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            vertical: 15.0.h, horizontal: 20.0.w),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '$price',
                              style: TextStyle(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 50),
                FancyButton(
                  button_text: "التسجيل في الكورس",
                  button_height: 40.h,
                  button_width: 150.w,
                  button_color: const Color.fromARGB(255, 26, 114, 186),
                  button_outline_color: Colors.white,
                  button_text_color: Colors.white,
                  button_text_size: 15.sp,
                  onClick: _checkLoginStatus,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
