// ignore_for_file: file_names, depend_on_referenced_packages, library_private_types_in_public_api, avoid_print

import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class VideoPost extends StatefulWidget {
  const VideoPost({super.key});

  @override
  _VideoPostState createState() => _VideoPostState();
}

class _VideoPostState extends State<VideoPost> {
  File? _videoFile;
  final TextEditingController _titleController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? _selectedGrade;
  String? _selectedSubject;
  String? _selectedSubjectType;
  String? _selectedTeacherId;

  final Map<String, String> _grades = {
    'تاسع': '9',
    'بكالوريا علمي': '12',
    'بكالوريا أدبي': '11'
  };

  Map<String, String> _subjects = {}; // Empty initially
  Map<String, String> _subjectTypes = {}; // Empty initially

  List<Map<String, String>> _teachers = [];

  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    fetchTeachers();
    fetchSubjects(); // Fetch subjects when the widget is initialized
    fetchSubjectTypes(); // Fetch subject types when the widget is initialized
  }

  Future<void> fetchTeachers() async {
    final url = Uri.parse('https://obai.aunakit-hosting.com/api/teachers/');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
        setState(() {
          _teachers = data.map((teacher) {
            return {
              'id': teacher['id'].toString(),
              'name': teacher['name'].toString(),
            };
          }).toList();

          if (_teachers.isNotEmpty && _selectedTeacherId == null) {
            _selectedTeacherId = _teachers.first['id'];
          }
        });
      } else {
        print('Failed to fetch teachers');
      }
    } catch (e) {
      print('Error during fetching teachers: $e');
    }
  }

  Future<void> fetchSubjects() async {
    final url = Uri.parse('https://obai.aunakit-hosting.com/api/Subject/');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
        setState(() {
          _subjects = {
            for (var subject in data) subject['name']: subject['id'].toString(),
          };

          if (_subjects.isNotEmpty && _selectedSubject == null) {
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

  Future<void> fetchSubjectTypes() async {
    final url = Uri.parse('https://obai.aunakit-hosting.com/api/Subject_type/');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
        setState(() {
          _subjectTypes = {
            for (var subjectType in data)
              subjectType['name']: subjectType['id'].toString(),
          };

          if (_subjectTypes.isNotEmpty && _selectedSubjectType == null) {
            _selectedSubjectType = _subjectTypes.keys.first;
          }
        });
      } else {
        print('Failed to fetch subject types');
      }
    } catch (e) {
      print('Error during fetching subject types: $e');
    }
  }

  Future<void> pickVideo() async {
    final pickedFile =
        await ImagePicker().pickVideo(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _videoFile = File(pickedFile.path);
      });
    }
  }

  Future<void> uploadVideo(File videoFile) async {
    setState(() {
      _isUploading = true;
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    final url = Uri.parse('https://obai.aunakit-hosting.com/upload-video/');
    final request = http.MultipartRequest('POST', url);
    request.headers[HttpHeaders.authorizationHeader] = 'Token $token';
    request.files
        .add(await http.MultipartFile.fromPath('video_file', videoFile.path));
    request.fields['title'] = _titleController.text;
    request.fields['grade'] = _grades[_selectedGrade]!;
    request.fields['subject'] = _subjects[_selectedSubject]!;
    request.fields['subject_type'] = _subjectTypes[_selectedSubjectType]!;
    request.fields['teacher'] = _selectedTeacherId!;

    try {
      final response = await request.send();
      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تم رفع الفيديو بنجاح')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('فشل في رفع')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error during upload: $e')),
      );
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'تحميل دروس',
          style: TextStyle(fontSize: 20.sp),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'العنوان',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'الرجاء إدخال العنوان';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: _selectedGrade,
                  items: _grades.keys.map((grade) {
                    return DropdownMenuItem(
                      value: grade,
                      child: Text(grade),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      _selectedGrade = newValue;
                      print('Selected grade value: ${_grades[_selectedGrade]}');
                    });
                  },
                  decoration: const InputDecoration(
                    labelText: 'الصف',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null) {
                      return 'الرجاء اختيار الصف';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: _selectedSubject,
                  items: _subjects.keys.map((subject) {
                    return DropdownMenuItem(
                      value: subject,
                      child: Text(subject),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      _selectedSubject = newValue;
                      print(
                          'Selected subject value: ${_subjects[_selectedSubject]}');
                    });
                  },
                  decoration: const InputDecoration(
                    labelText: 'المادة',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null) {
                      return 'الرجاء اختيار المادة';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: _selectedSubjectType,
                  items: _subjectTypes.keys.map((subjectType) {
                    return DropdownMenuItem(
                      value: subjectType,
                      child: Text(subjectType),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      _selectedSubjectType = newValue;
                      print(
                          'Selected subject type value: ${_subjectTypes[_selectedSubjectType]}');
                    });
                  },
                  decoration: const InputDecoration(
                    labelText: 'نوع الدروس',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null) {
                      return 'الرجاء الاختيار';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: _selectedTeacherId,
                  items: _teachers.map((teacher) {
                    return DropdownMenuItem<String>(
                      value: teacher['id'],
                      child: Text(teacher['name']!),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      _selectedTeacherId = newValue;
                      print('Selected teacher ID: $_selectedTeacherId');
                    });
                  },
                  decoration: const InputDecoration(
                    labelText: 'المدرس',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null) {
                      return 'الرجاء اختيار المدرس';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: pickVideo,
                  child: Text(
                    'إختيار درس',
                    style: TextStyle(fontSize: 15.sp, color: Colors.blue),
                  ),
                ),
                if (_videoFile != null)
                  Text(
                    '   :الملف المختار ${_videoFile!.path}',
                    style: TextStyle(fontSize: 15.sp),
                  ),
                const SizedBox(height: 20),
                _isUploading
                    ? const Center(child: CircularProgressIndicator())
                    : ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate() &&
                              _videoFile != null) {
                            uploadVideo(_videoFile!);
                          } else {
                            print(
                                'Please complete all fields and select a video');
                          }
                        },
                        child: Text(
                          'رفع الدرس',
                          style: TextStyle(fontSize: 15.sp, color: Colors.blue),
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
