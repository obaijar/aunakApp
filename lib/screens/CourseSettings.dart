// ignore_for_file: depend_on_referenced_packages, file_names, avoid_print

import 'package:flutter/material.dart';
import 'package:testt/screens/AddCourse.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:io';

class CourseSettings extends StatelessWidget {
  const CourseSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('كورس'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // First Text and Button
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                  child: Text(
                    'إضافة كورس',
                    textAlign: TextAlign.right,
                    style: TextStyle(fontSize: 20.sp),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Get.to(() => const AddCourse());
                    // Action for Button 1
                  },
                  child: Text(
                    'إضافة',
                    style: TextStyle(fontSize: 15.sp),
                  ),
                ),
              ],
            ),
            /* const Divider(),
            const SizedBox(height: 16.0), // Spacing between elements

            // Second Text and Button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'تعديل كورس',
                    textAlign: TextAlign.right,
                    style: TextStyle(fontSize: 20.sp),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Action for Button 2
                  },
                  child: Text(
                    'تعديل',
                    style: TextStyle(fontSize: 15.sp),
                  ),
                ),
              ],
            ),*/
            const Divider(),
            const SizedBox(height: 16.0), // Spacing between elements

            // Third Text and Button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'حذف كورس',
                    textAlign: TextAlign.right,
                    style: TextStyle(fontSize: 20.sp),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Get.to(() => const DeleteCourse());
                    // Action for Button 3
                  },
                  child: Text(
                    'حذف',
                    style: TextStyle(fontSize: 15.sp),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class DeleteCourse extends StatefulWidget {
  const DeleteCourse({super.key});

  @override
  State<DeleteCourse> createState() => _DeleteCourseState();
}

class _DeleteCourseState extends State<DeleteCourse> {
  String? _selectedSubject;
  Map<String, String> _subjects = {};

  @override
  void initState() {
    super.initState();
    fetchCourses();
  }

  Future<void> fetchCourses() async {
    final url = Uri.parse('https://obai.aunakit-hosting.com/api/courses/');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
        setState(() {
          _subjects = {
            for (var subject in data)
              subject['id'].toString(): subject['title'],
          };

          // Set the initial selected subject if available
          if (_subjects.isNotEmpty) {
            _selectedSubject = _subjects.keys.first;
          }
        });
      } else {
        print('Failed to fetch courses');
      }
    } catch (e) {
      print('Error during fetching subjects: $e');
    }
  }

  Future<void> deleteCourse(String subjectId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    final url = Uri.parse(
        'https://obai.aunakit-hosting.com/api/courses/delete/$subjectId/');

    try {
      final response = await http.delete(url, headers: {
        HttpHeaders.authorizationHeader: 'Token $token',
      });

      if (response.statusCode == 204) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تم حذف الكورس بنجاح')),
        );
        // Refresh the list after deletion
        fetchCourses();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('فشل في حذف الكورس')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error during deletion: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('حذف كورس'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              value: _selectedSubject,
              items: _subjects.entries.map((entry) {
                return DropdownMenuItem<String>(
                  value: entry.key,
                  child: Text(entry.value),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  _selectedSubject = newValue;
                });
              },
              decoration: const InputDecoration(
                labelText: 'اختيار كورس',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null) {
                  return 'الرجاء تحديد الكورس';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_selectedSubject != null) {
                  deleteCourse(_selectedSubject!);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('الرجاء تحديد مادة لحذفها')),
                  );
                }
              },
              child: const Text('حذف الكورس'),
            ),
          ],
        ),
      ),
    );
  }
}
