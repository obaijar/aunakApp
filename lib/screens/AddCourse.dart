import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';

class AddCourse extends StatefulWidget {
  const AddCourse({super.key});

  @override
  State<AddCourse> createState() => _AddCourseState();
}

class _AddCourseState extends State<AddCourse> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  // Variables to hold dropdown data
  List<String> _subjects = [];
  List<String> _teachers = [];
  List<String> _grades = [];
  List<String> _subjectTypes = [];

  String? _selectedSubjectType;
  String? _selectedTeacher;
  String? _selectedSubject;
  String? _selectedGrade;

  @override
  void initState() {
    super.initState();
    _fetchDropdownData();
  }

  Future<void> _fetchDropdownData() async {
    // URLs for APIs
    const subjectUrl = 'https://obai.aunakit-hosting.com/api/Subject/';
    const subjectTypeUrl = 'http://obai.aunakit-hosting.com/api/Subject_type/';
    const teacherUrl = 'https://obai.aunakit-hosting.com/api/teachers/';
    const gradeUrl = 'https://obai.aunakit-hosting.com/api/Grade/';

    // Fetch data from APIs
    try {
      final subjectResponse = await http.get(Uri.parse(subjectUrl));
      final subjectTypeResponse = await http.get(Uri.parse(subjectTypeUrl));
      final teacherResponse = await http.get(Uri.parse(teacherUrl));
      final gradeResponse = await http.get(Uri.parse(gradeUrl));

      if (subjectResponse.statusCode == 200 &&
          subjectTypeResponse.statusCode == 200 &&
          teacherResponse.statusCode == 200 &&
          gradeResponse.statusCode == 200) {
        final subjectData = json.decode(subjectResponse.body) as List;
        final subjectTypeData = json.decode(subjectTypeResponse.body) as List;
        final teacherData = json.decode(teacherResponse.body) as List;
        final gradeData = json.decode(gradeResponse.body) as List;

        setState(() {
          _subjects =
              subjectData.map((item) => item['name'] as String).toList();
          _subjectTypes =
              subjectTypeData.map((item) => item['name'] as String).toList();
          _teachers =
              teacherData.map((item) => item['name'] as String).toList();
          _grades = gradeData.map((item) => item['name'] as String).toList();
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error fetching data: $e');
      // Handle errors
    }
  }

  Future<bool> _checkConnectivity() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    bool isConnected =
        connectivityResult.any((result) => result != ConnectivityResult.none);
    if (!isConnected) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('إتصال الإنترنت'),
            content: const Text('لا يوجد اتصال بالإنترنت'),
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
      return false;
    }
    return true;
  }

  void _showNoConnectionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('No Internet Connection'),
          content: const Text(
              'Please check your internet connection and try again.'),
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

  void _submitForm() async {
    bool isConnected = await _checkConnectivity();
    if (isConnected) {
      if (_formKey.currentState?.validate() ?? false) {
        // Process data
        final courseData = {
          "title": _titleController.text,
          "description": _descriptionController.text,
          "subject_type": _selectedSubjectType,
          "teacher": _selectedTeacher,
          "subject": _selectedSubject,
          "grade": _selectedGrade,
        };
        print(courseData);
        // Handle the courseData as needed
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('إضافة كورس'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'العنوان',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'الرجاء ادخال عنوان';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'الوصف',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'الرجاء ادخال الوصف';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _selectedSubjectType,
                  decoration: const InputDecoration(
                    labelText: 'نوع المادة',
                  ),
                  items: _subjectTypes.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedSubjectType = newValue;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'الرجاء ادخال نوع المادة';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _selectedTeacher,
                  decoration: const InputDecoration(
                    labelText: 'المدرس',
                  ),
                  items: _teachers.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedTeacher = newValue;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'الرجاء ادخال مدرس';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _selectedSubject,
                  decoration: const InputDecoration(
                    labelText: 'المادة',
                  ),
                  items: _subjects.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedSubject = newValue;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'الرجاء إدخال مادة';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _selectedGrade,
                  decoration: const InputDecoration(
                    labelText: 'الصف',
                  ),
                  items: _grades.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedGrade = newValue;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'الرجاء إدخال الصف';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _submitForm,
                  child: const Text('إضافة'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
