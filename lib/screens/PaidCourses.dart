// ignore_for_file: file_names, depend_on_referenced_packages, avoid_print

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:get/get.dart';
import 'package:testt/screens/watchCourse.dart';

class PaidCourses extends StatefulWidget {
  const PaidCourses({super.key});

  @override
  State<PaidCourses> createState() => _PaidCoursesState();
}

class _PaidCoursesState extends State<PaidCourses> {
  List<Map<String, dynamic>> _courses = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchCourses();
  }

  Future<void> _fetchCourses() async {
    final prefs = await SharedPreferences.getInstance();
    final String? authToken = prefs.getString('token');
    final String? id = prefs.getString('id');
    if (authToken == null) {
      print('No authentication token found');
      setState(() {
        _isLoading = false;
      });
      return;
    }

    final url =
        Uri.parse('https://obai.aunakit-hosting.com/purchases/user/$id/');
    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Token $authToken',
        },
      );
      if (response.statusCode == 200) {
        final List<dynamic> jsonResponse = json.decode(response.body);
        setState(() {
          _courses = jsonResponse.map((item) {
            return {
              'id': item['id'], // Include the id of the purchase
              'title': item['course']['title'],
              'description': item['course']['description'],
              'videos': item['course']['videos'],
            };
          }).toList();
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to load courses');
      }
    } catch (e) {
      print(e);
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _deleteCourse(int id) async {
    final prefs = await SharedPreferences.getInstance();
    final String? authToken = prefs.getString('token');
    if (authToken == null) {
      print('No authentication token found');
      return;
    }

    final url =
        Uri.parse('https://obai.aunakit-hosting.com/api/purchase/delete/$id/');
    try {
      final response = await http.delete(
        url,
        headers: {
          'Authorization': 'Token $authToken',
        },
      );
      if (response.statusCode == 204) {
        setState(() {
          _courses.removeWhere((course) => course['id'] == id);
        });
      } else {
        throw Exception('Failed to delete course');
      }
    } catch (e) {
      print(e);
    }
  }

  Future<bool> _confirmDelete(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('تأكيد الحذف'),
              content: const Text('هل أنت متاكد من حذف هذا الكورس'),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('لا'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text('نعم'),
                ),
              ],
            );
          },
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('الكورسات المدفوعة'),
      ),
      body: ListView.builder(
        itemCount: _courses.length,
        itemBuilder: (context, index) {
          final course = _courses[index];
          return Dismissible(
            key: Key(course['id'].toString()), // Unique key for each item
            direction: DismissDirection.endToStart,
            confirmDismiss: (direction) async {
              return await _confirmDelete(context);
            },
            onDismissed: (direction) {
              _deleteCourse(course['id']);
            },
            background: Container(
              color: Colors.red,
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: const Icon(Icons.delete, color: Colors.white),
            ),
            child: Card(
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              elevation: 5,
              child: InkWell(
                onTap: () {
                  // Navigate to watchCourse and pass the video list
                  Get.to(() => watchCourse(
                        videoList: course['videos'], // Pass the video list here
                      ));
                  print('Tapped on course: ${course['title']}');
                },
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  leading: Icon(Icons.book, color: Colors.blueGrey[700]),
                  title: Text(
                    course['title'] ?? 'No title',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    course['description'] ?? 'No description',
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: const Icon(Icons.arrow_forward),
                  isThreeLine: true,
                  dense: false,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
