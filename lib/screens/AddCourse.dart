// ignore_for_file: file_names, depend_on_referenced_packages, non_constant_identifier_names, prefer_collection_literals, prefer_final_fields, avoid_print, prefer_const_constructors

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
  final TextEditingController _priceController =
      TextEditingController(); // New price controller

  // Variables to hold dropdown data
  List<String> _subjects = [];
  List<String> _subjects_id = [];
  List<String> _teachers = [];
  List<String> _teachers_id = [];
  List<String> _subjectTypes = [];
  List<String> _subjectTypes_id = [];

  final List<String> _grades = [
    'تاسع',
    'بكالوريا علمي',
    'بكالوريا أدبي',
  ];
  // Variables to hold video data
  List<dynamic> _videos = [];
  Set<String> _selectedVideos = Set<String>();

  int? _selectedSubjectTypeIndex;
  int? _selectedTeacherIndex;
  int? _selectedSubjectIndex;
  int? _selectedGradeIndex;

  bool _isLoading = false; // Loading state

  @override
  void initState() {
    super.initState();
    _fetchDropdownData();
    _fetchVideos();
  }

  Future<void> _fetchDropdownData() async {
    // URLs for APIs
    const subjectUrl = 'https://obai.aunakit-hosting.com/api/Subject/';
    const subjectTypeUrl = 'https://obai.aunakit-hosting.com/api/Subject_type/';
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
        final subjectData =
            json.decode(utf8.decode(subjectResponse.bodyBytes)) as List;
        final subjectTypeData =
            json.decode(utf8.decode(subjectTypeResponse.bodyBytes)) as List;
        final teacherData =
            json.decode(utf8.decode(teacherResponse.bodyBytes)) as List;
        // ignore: unused_local_variable
        final gradeData =
            json.decode(utf8.decode(gradeResponse.bodyBytes)) as List;

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

          // _grades = gradeData.map((item) => item['level'] as String).toList();
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

    const videoUrl = 'https://obai.aunakit-hosting.com/api/videos/';

    try {
      final response = await http.get(
        Uri.parse(videoUrl),
        headers: {
          'Authorization': 'token $token',
        },
      );

      if (response.statusCode == 200) {
        final videoData = json.decode(utf8.decode(response.bodyBytes)) as List;
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

  Future<void> _submitForm() async {
    bool isConnected = await _checkConnectivity();
    if (isConnected) {
      if (_formKey.currentState?.validate() ?? false) {
        setState(() {
          _isLoading = true; // Start loading
        });

        // Prepare the data to be sent in the POST request
        final courseData = {
          "title": _titleController.text,
          "description": _descriptionController.text,
          "price": _priceController.text, // Add price to courseData
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

        // Define the API endpoint
        const createCourseUrl =
            'https://obai.aunakit-hosting.com/api/courses/create/';

        // Send POST request
        try {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          String? token = prefs.getString('token');
          final response = await http.post(
            Uri.parse(createCourseUrl),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Token $token',
            },
            body: json.encode(courseData),
          );

          if (response.statusCode == 201) {
            // Successfully created the course
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('تم اضافة الكورس بنجاح')),
            );
          } else {
            // Failed to create the course
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('فشل في اضافة الكورس')),
            );
          }
        } catch (e) {
          print('Error during POST request: $e');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error during POST request: $e')),
          );
        } finally {
          setState(() {
            _isLoading = false; // Stop loading
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('إضافة كورس'),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
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
                    TextFormField(
                      controller: _priceController,
                      decoration: const InputDecoration(
                        labelText: 'السعر',
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'الرجاء ادخال السعر';
                        }
                        if (!RegExp(r'^\d+$').hasMatch(value)) {
                          return 'الرجاء ادخال أرقام فقط';
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
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
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
                                  _selectedVideos
                                      .remove(video['id'].toString());
                                } else {
                                  _selectedVideos.add(video['id'].toString());
                                }
                              });
                            },
                            selected: _selectedVideos
                                .contains(video['id'].toString()),
                            selectedTileColor: Colors.grey[300],
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: _isLoading ? null : _submitForm,
                      child: _isLoading
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(),
                            )
                          : const Text('إضافة'),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (_isLoading)
            Container(
              color: Colors.black54,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}
