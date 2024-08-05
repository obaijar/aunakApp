// ignore_for_file: depend_on_referenced_packages, file_names, avoid_print, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:testt/screens/%D9%90AddSubject.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:io';

class Subjects extends StatelessWidget {
  const Subjects({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('المواد'),
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
                    'إضافة مادة',
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
                    Get.to(() => const AddSubject());
                    // Action for Button 1
                  },
                  child: Text(
                    'إضافة',
                    style: TextStyle(fontSize: 15.sp),
                  ),
                ),
              ],
            ),
            const Divider(),
            const SizedBox(height: 16.0), // Spacing between elements
            // Third Text and Button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'حذف مادة',
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
                    Get.to(() => const DeleteSubject());
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

class DeleteSubject extends StatefulWidget {
  const DeleteSubject({super.key});

  @override
  State<DeleteSubject> createState() => _DeleteSubjectState();
}

class _DeleteSubjectState extends State<DeleteSubject> {
  String? _selectedSubject;
  Map<String, String> _subjects = {};

  @override
  void initState() {
    super.initState();
    fetchSubjects();
  }

  Future<void> fetchSubjects() async {
    final url = Uri.parse('http://10.0.2.2:8000/api/Subject/');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
        setState(() {
          _subjects = {
            for (var subject in data) subject['id'].toString(): subject['name'],
          };

          // Set the initial selected subject if available
          if (_subjects.isNotEmpty) {
            _selectedSubject = _subjects.keys.first;
          }
        });
      } else {
        print('Failed to fetch subjects');
      }
    } catch (e) {
      print('Error during fetching subjects: $e');
    }
  }

  Future<void> deleteSubject(String subjectId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    final url =
        Uri.parse('http://10.0.2.2:8000/api/subject/delete/$subjectId/');

    try {
      final response = await http.delete(url, headers: {
        HttpHeaders.authorizationHeader: 'Token $token',
      });

      if (response.statusCode == 204) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Subject deleted successfully')),
        );
        // Refresh the list after deletion
        fetchSubjects();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete subject')),
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
        title: Text('حذف مادة'),
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
                labelText: 'اختيار مادة',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null) {
                  return 'الرجاء تحديد المادة';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_selectedSubject != null) {
                  deleteSubject(_selectedSubject!);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('الرجاء تحديد مادة لحذفها')),
                  );
                }
              },
              child: Text('حذف المادة'),
            ),
          ],
        ),
      ),
    );
  }
}
