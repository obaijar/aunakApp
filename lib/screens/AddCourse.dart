// ignore_for_file: file_names, depend_on_referenced_packages, non_constant_identifier_names, prefer_collection_literals, prefer_final_fields, avoid_print

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
  List<String> _subjects_id = [];
  List<String> _teachers = [];
  List<String> _teachers_id = [];
  List<String> _grades = [];
  List<String> _subjectTypes = [];
  List<String> _subjectTypes_id = [];

  // Variables to hold video data
  List<dynamic> _videos = [];
  Set<String> _selectedVideos = Set<String>();

  int? _selectedSubjectTypeIndex;
  int? _selectedTeacherIndex;
  int? _selectedSubjectIndex;
  int? _selectedGradeIndex;

  @override
  void initState() {
    super.initState();
    _fetchDropdownData();
    _fetchVideos();
  }

  Future<void> _fetchDropdownData() async {
    // URLs for APIs
    const subjectUrl = 'http://10.0.2.2:8000/api/Subject/';
    const subjectTypeUrl = 'http://10.0.2.2:8000/api/Subject_type/';
    const teacherUrl = 'http://10.0.2.2:8000/api/teachers/';
    const gradeUrl = 'http://10.0.2.2:8000/api/Grade/';

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
          _subjects_id =
              subjectData.map((item) => item['id'].toString()).toList();
          _subjectTypes =
              subjectTypeData.map((item) => item['name'] as String).toList();
          _subjectTypes_id =
              subjectTypeData.map((item) => item['id'].toString()).toList();
          _teachers =
              teacherData.map((item) => item['name'] as String).toList();
          _teachers_id =
              teacherData.map((item) => item['id'].toString()).toList();

          _grades = gradeData.map((item) => item['level'] as String).toList();
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error fetching data: $e');
      // Handle errors
    }
  }

  Future<void> _fetchVideos() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token == null) {
      print('No token found');
      return;
    }

    const videoUrl = 'http://10.0.2.2:8000/api/videos/';

    try {
      final response = await http.get(
        Uri.parse(videoUrl),
        headers: {
          'Authorization': 'token $token',
        },
      );

      if (response.statusCode == 200) {
        final videoData = json.decode(response.body) as List;
        setState(() {
          _videos = videoData;
        });
      } else {
        throw Exception('Failed to load videos');
      }
    } catch (e) {
      print('Error fetching videos: $e');
      // Handle errors
    }
  }

  Future<bool> _checkConnectivity() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    // ignore: unrelated_type_equality_checks
    bool isConnected = connectivityResult != ConnectivityResult.none;
    if (!isConnected) {
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
      return false;
    }
    return true;
  }

  void _submitForm() async {
    bool isConnected = await _checkConnectivity();
    if (isConnected) {
      if (_formKey.currentState?.validate() ?? false) {
        // Process data
        final courseData = {
          "title": _titleController.text,
          "description": _descriptionController.text,
          "subject_type": _selectedSubjectTypeIndex != null
              ? _subjectTypes_id[_selectedSubjectTypeIndex!]
              : null,
          "teacher": _selectedTeacherIndex != null
              ? _teachers_id[_selectedTeacherIndex!]
              : null,
          "subject": _selectedSubjectIndex != null
              ? _subjects_id[_selectedSubjectIndex!]
              : null,
          "grade": _selectedGradeIndex != null
              ? (_selectedGradeIndex! + 1).toString()
              : null,
          "videos": _selectedVideos.toList(),
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
                DropdownButtonFormField<int>(
                  value: _selectedSubjectTypeIndex,
                  decoration: const InputDecoration(
                    labelText: 'نوع المادة',
                  ),
                  items: List.generate(_subjectTypes.length, (index) {
                    return DropdownMenuItem<int>(
                      value: index,
                      child: Text(_subjectTypes[index]),
                    );
                  }),
                  onChanged: (int? newValue) {
                    setState(() {
                      _selectedSubjectTypeIndex = newValue;
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
                DropdownButtonFormField<int>(
                  value: _selectedTeacherIndex,
                  decoration: const InputDecoration(
                    labelText: 'المدرس',
                  ),
                  items: List.generate(_teachers.length, (index) {
                    return DropdownMenuItem<int>(
                      value: index,
                      child: Text(_teachers[index]),
                    );
                  }),
                  onChanged: (int? newValue) {
                    setState(() {
                      _selectedTeacherIndex = newValue;
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
                DropdownButtonFormField<int>(
                  value: _selectedSubjectIndex,
                  decoration: const InputDecoration(
                    labelText: 'المادة',
                  ),
                  items: List.generate(_subjects.length, (index) {
                    return DropdownMenuItem<int>(
                      value: index,
                      child: Text(_subjects[index]),
                    );
                  }),
                  onChanged: (int? newValue) {
                    setState(() {
                      _selectedSubjectIndex = newValue;
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
                DropdownButtonFormField<int>(
                  value: _selectedGradeIndex,
                  decoration: const InputDecoration(
                    labelText: 'الصف',
                  ),
                  items: List.generate(_grades.length, (index) {
                    return DropdownMenuItem<int>(
                      value: index,
                      child: Text(_grades[index]),
                    );
                  }),
                  onChanged: (int? newValue) {
                    setState(() {
                      _selectedGradeIndex = newValue;
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
                const Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'الفيديوهات',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  height: 200.sp, // Fixed height for the video list
                  child: ListView.builder(
                    itemCount: _videos.length,
                    itemBuilder: (context, index) {
                      final video = _videos[index];
                      return ListTile(
                        title: Text(video['title']),
                        onTap: () {
                          setState(() {
                            if (_selectedVideos
                                .contains(video['id'].toString())) {
                              _selectedVideos.remove(video['id'].toString());
                            } else {
                              _selectedVideos.add(video['id'].toString());
                            }
                          });
                        },
                        selected:
                            _selectedVideos.contains(video['id'].toString()),
                        selectedTileColor: Colors.grey[300],
                      );
                    },
                  ),
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
