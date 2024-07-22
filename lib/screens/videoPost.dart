import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class VideoPost extends StatefulWidget {
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
  String? _selectedTeacher;

  final Map<String, String> _grades = {
    'تاسع': '9',
    'بكالوريا علمي': '12',
    'بكالوريا أدبي': '11'
  };

  final Map<String, String> _subjects = {
    'رياضيات': 'math',
    'علوم': 'science',
    'تاريخ': 'history'
  };

  final Map<String, String> _subjectTypes = {
    'Lecture': '1',
    'Tutorial': '2',
    'Lab': '3'
  };

  List<String> _teachers = [];

  @override
  void initState() {
    super.initState();
    fetchTeachers();
  }

  Future<void> fetchTeachers() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    final url = Uri.parse('https://obai.aunakit-hosting.com/api/teachers/');
    try {
      final response = await http.get(
        url,
        headers: {
          HttpHeaders.authorizationHeader: 'Token $token',
        },
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          _teachers = data
              .map((teacher) => teacher['name'].toString())
              .toSet()
              .toList(); // Ensure unique names
          if (_teachers.isNotEmpty && _selectedTeacher == null) {
            _selectedTeacher = _teachers
                .first; // Set the first teacher as default if none is selected
          }
        });
      } else {
        print('Failed to fetch teachers');
      }
    } catch (e) {
      print('Error during fetching teachers: $e');
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
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    final url =
        Uri.parse('https://obai.aunakit-hosting.com/api/videos_upload/');
    final request = http.MultipartRequest('POST', url);
    request.headers[HttpHeaders.authorizationHeader] = 'Bearer $token';
    request.files
        .add(await http.MultipartFile.fromPath('video', videoFile.path));
    request.fields['title'] = _titleController.text;
    request.fields['grade'] = _grades[_selectedGrade]!;
    request.fields['subject'] = _subjects[_selectedSubject]!;
    request.fields['subject_type'] = _subjectTypes[_selectedSubjectType]!;
    request.fields['teacher'] = _selectedTeacher!;

    try {
      final response = await request.send();
      if (response.statusCode == 200) {
        print('Video uploaded successfully');
      } else {
        print('Failed to upload video');
      }
    } catch (e) {
      print('Error during upload: $e');
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
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextFormField(
                  controller: _titleController,
                  decoration: InputDecoration(
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
                SizedBox(height: 10),
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
                  decoration: InputDecoration(
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
                SizedBox(height: 10),
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
                  decoration: InputDecoration(
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
                SizedBox(height: 10),
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
                  decoration: InputDecoration(
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
                SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: _selectedTeacher,
                  items: _teachers.map((teacher) {
                    return DropdownMenuItem(
                      value: teacher,
                      child: Text(teacher),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      _selectedTeacher = newValue;
                    });
                  },
                  decoration: InputDecoration(
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
                SizedBox(height: 20),
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
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate() &&
                        _videoFile != null) {
                      uploadVideo(_videoFile!);
                    } else {
                      print('Please complete all fields and select a video');
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
