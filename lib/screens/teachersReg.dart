// ignore_for_file: file_names, depend_on_referenced_packages, library_private_types_in_public_api, avoid_print, unnecessary_to_list_in_spreads

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class TeacherReg extends StatefulWidget {
  const TeacherReg({super.key});

  @override
  _TeacherRegState createState() => _TeacherRegState();
}

class _TeacherRegState extends State<TeacherReg> {
  List<bool> isSelectedSubjects = [];
  List<Color> colorsSubjects = [];
  List<bool> isSelectedGrades = [];
  List<Color> colorsGrades = [];
  bool isLoadingGrades = true;
  bool isLoadingSubjects = true;
  bool isSubmitting = false; // Added to track submission state

  List<String> selectedSubjects = [];
  List<String> selectedGrades = [];

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  List<Map<String, dynamic>> grades = [];
  List<Map<String, dynamic>> subjects = [];

  @override
  void initState() {
    super.initState();
    fetchGrades();
    fetchSubjects();
  }

  Future<void> fetchGrades() async {
    setState(() {
      isLoadingGrades = true;
    });
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      if (token == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('يرجى تسجيل الدخول'),
          ),
        );
        return; // Exit if no token is found
      }
      final response = await http.get(
        Uri.parse('https://obai.aunakit-hosting.com/api/Grade/'),
      );

      if (response.statusCode == 200) {
        setState(() {
          grades = List<Map<String, dynamic>>.from(
              json.decode(utf8.decode(response.bodyBytes)));
          isSelectedGrades = List<bool>.filled(grades.length, false);
          colorsGrades = List<Color>.filled(grades.length, Colors.white);
        });
      } else {
        throw Exception('Failed to load grades');
      }
    } catch (e) {
      print('Error fetching grades: $e');
      // Optionally, show a message to the user or handle the error state
    } finally {
      setState(() {
        isLoadingGrades = false;
      });
    }
  }

  Future<void> fetchSubjects() async {
    setState(() {
      isLoadingSubjects = true;
    });
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      if (token == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('يرجى تسجيل الدخول'),
          ),
        );
        return; // Exit if no token is found
      }
      final response = await http.get(
        Uri.parse('https://obai.aunakit-hosting.com/api/Subject/'),
      );

      if (response.statusCode == 200) {
        setState(() {
          subjects = List<Map<String, dynamic>>.from(
              json.decode(utf8.decode(response.bodyBytes)));
          isSelectedSubjects = List<bool>.filled(subjects.length, false);
          colorsSubjects = List<Color>.filled(subjects.length, Colors.white);
        });
      } else {
        throw Exception('Failed to load subjects');
      }
    } catch (e) {
      print('Error fetching subjects: $e');
      // Optionally, show a message to the user or handle the error state
    } finally {
      setState(() {
        isLoadingSubjects = false;
      });
    }
  }

  void toggleSelection(int index, bool isSubject) {
    setState(() {
      if (isSubject) {
        if (isSelectedSubjects[index]) {
          colorsSubjects[index] = Colors.white;
          isSelectedSubjects[index] = false;
          selectedSubjects.remove(subjects[index]['name']);
        } else {
          colorsSubjects[index] = Colors.grey[300]!;
          isSelectedSubjects[index] = true;
          selectedSubjects.add(subjects[index]['name']);
        }
      } else {
        if (isSelectedGrades[index]) {
          colorsGrades[index] = Colors.white;
          isSelectedGrades[index] = false;
          selectedGrades.remove(grades[index]['level']);
        } else {
          colorsGrades[index] = Colors.grey[300]!;
          isSelectedGrades[index] = true;
          selectedGrades.add(grades[index]['level']);
        }
      }
    });
  }

  Future<void> submitForm() async {
    // Validate form fields
    if (_formKey.currentState!.validate()) {
      setState(() {
        isSubmitting = true; // Start loading
      });
      try {
        // Retrieve token from SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        final token = prefs.getString('token');

        // Handle missing token
        if (token == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('يرجى تسجيل الدخول'),
            ),
          );
          return;
        }

        // Send HTTP POST request
        final response = await http.post(
          Uri.parse('https://obai.aunakit-hosting.com/api/add-teacher/'),
          headers: {
            'Authorization': 'Token $token',
            'Content-Type': 'application/json',
          },
          body: json.encode({
            'name': _nameController.text,
            'email': _emailController.text,
            'subjects': selectedSubjects,
            'grades': selectedGrades,
          }),
        );

        // Handle successful response
        if (response.statusCode == 201) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('تم التسجيل بنجاح'),
            ),
          );
          Navigator.pop(context);
        } else {
          // Handle non-200 status codes gracefully
          print('Error adding teacher: ${response.statusCode}');
          throw Exception(
            'Failed to register teacher (status code: ${response.statusCode})',
          );
        }
      } catch (e) {
        // Handle unexpected errors
        print('Unexpected error: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('فشل في التسجيل'),
          ),
        );
      } finally {
        setState(() {
          isSubmitting = false; // Stop loading
        });
      }
    }
  }

  String getLevelDisplay(String level) {
    switch (level) {
      case '9':
        return 'تاسع';
      case '12':
        return 'بكالوريا علمي';
      case '13':
        return 'بكالوريا أدبي';
      default:
        return 'غير محدد';
    }
  }

  Widget buildCard(int index, String title, String subtitle, String trailing,
      bool isSubject) {
    final bool isSelected =
        isSubject ? isSelectedSubjects[index] : isSelectedGrades[index];
    final Color color = isSubject ? colorsSubjects[index] : colorsGrades[index];

    String displayText = isSubject ? title : getLevelDisplay(trailing);

    return Card(
      color: color,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            selected: isSelected,
            leading: const Icon(Icons.info),
            title: Text(displayText),
            subtitle: subtitle.isEmpty ? null : Text(subtitle),
            trailing: isSubject ? null : Text(getLevelDisplay(trailing)),
            onLongPress: () => toggleSelection(index, isSubject),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('تسجيل أستاذ'),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: ListView(
                children: <Widget>[
                  // Form fields
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'الإسم',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'الرجاء ادخال الإسم';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: 'الإيميل',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'الرجاء إدخال الإيميل';
                      }
                      if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                        return 'الإيميل غير صحيح';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'تحديد المواد التي يدرسها الأستاذ (كبسة مطولة)',
                        style: TextStyle(fontSize: 15.sp, color: Colors.blue),
                      ),
                    ],
                  ),
                  if (isLoadingSubjects)
                    const Center(child: CircularProgressIndicator())
                  else
                    ...subjects.map((subject) {
                      int index = subjects.indexOf(subject);
                      return buildCard(
                          index, subject['name'], "", subject['name'], true);
                    }).toList(),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'تحديد الصفوف التي يدرسها الأستاذ',
                        style: TextStyle(fontSize: 20.sp, color: Colors.blue),
                      ),
                    ],
                  ),
                  if (isLoadingGrades)
                    const Center(child: CircularProgressIndicator())
                  else
                    ...grades.map((grade) {
                      int index = grades.indexOf(grade);
                      return buildCard(
                          index,
                          "Grade ${getLevelDisplay(grade['level'])}",
                          "",
                          grade['level'],
                          false);
                    }).toList(),
                  ElevatedButton(
                    onPressed: submitForm,
                    child: const Text('تسجيل'),
                  ),
                ],
              ),
            ),
          ),
          if (isSubmitting) // Show loading indicator if submitting
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}
