import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class EditCourseScreen extends StatefulWidget {
  @override
  _EditCourseScreenState createState() => _EditCourseScreenState();
}

class _EditCourseScreenState extends State<EditCourseScreen> {
  final _formKey = GlobalKey<FormState>();
  int? _selectedCourseId;
  String? _title;
  String? _description;
  int? _subjectTypeId;
  int? _teacherId;
  int? _subjectId;
  int? _gradeId;
  int? _price;
  List<int> _selectedVideoIds = [];
  bool _isLoading = false;

  List<dynamic> _courses = [];
  List<dynamic> _subjectTypes = [];
  List<dynamic> _teachers = [];
  List<dynamic> _subjects = [];
  List<dynamic> _grades = [];
  List<dynamic> _videos = [];

  @override
  void initState() {
    super.initState();
    _fetchCourses();
    _fetchDropdownData();
    _fetchVideos();
  }

  Future<void> _fetchCourses() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    final response = await http.get(
      Uri.parse('https://obai.aunakit-hosting.com/api/courses/'),
      headers: {'Authorization': 'Token $token'},
    );

    if (response.statusCode == 200) {
      setState(() {
        _courses = json.decode(utf8.decode(response.bodyBytes));
      });
    } else {
      print('Failed to load courses');
    }
  }

  Future<void> _fetchCourseDetails(int courseId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    final response = await http.get(
      Uri.parse('https://obai.aunakit-hosting.com/api/courses/$courseId/'),
      headers: {'Authorization': 'Token $token'},
    );

    if (response.statusCode == 200) {
      var data = json.decode(utf8.decode(response.bodyBytes));
      setState(() {
        _selectedCourseId = courseId;
        _title = data['title'];
        _description = data['description'];
        _subjectTypeId = data['subject_type'];
        _teacherId = data['teacher'];
        _subjectId = data['subject'];
        _gradeId = data['grade'];
        _price = data['price'];
        _selectedVideoIds = List<int>.from(data['videos']);
      });
    } else {
      print('Failed to load course details');
    }
  }

  Future<void> _fetchDropdownData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    final subjectTypeResponse = await http.get(
      Uri.parse('https://obai.aunakit-hosting.com/api/Subject_type/'),
      headers: {'Authorization': 'Token $token'},
    );

    final teacherResponse = await http.get(
      Uri.parse('https://obai.aunakit-hosting.com/api/teachers/'),
      headers: {'Authorization': 'Token $token'},
    );

    final subjectResponse = await http.get(
      Uri.parse('https://obai.aunakit-hosting.com/api/Subject/'),
      headers: {'Authorization': 'Token $token'},
    );

    final gradeResponse = await http.get(
      Uri.parse('https://obai.aunakit-hosting.com/api/Grade/'),
      headers: {'Authorization': 'Token $token'},
    );

    if (subjectTypeResponse.statusCode == 200 &&
        teacherResponse.statusCode == 200 &&
        subjectResponse.statusCode == 200 &&
        gradeResponse.statusCode == 200) {
      setState(() {
        _subjectTypes = json.decode(utf8.decode(subjectTypeResponse.bodyBytes));
        _teachers = json.decode(utf8.decode(teacherResponse.bodyBytes));
        _subjects = json.decode(utf8.decode(subjectResponse.bodyBytes));
        _grades = json.decode(utf8.decode(gradeResponse.bodyBytes));
      });
    } else {
      print('Failed to load dropdown data');
    }
  }

  Future<void> _fetchVideos() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    final response = await http.get(
      Uri.parse('https://obai.aunakit-hosting.com/api/videos/'),
      headers: {'Authorization': 'Token $token'},
    );

    if (response.statusCode == 200) {
      setState(() {
        _videos = json.decode(utf8.decode(response.bodyBytes));
      });
    } else {
      print('Failed to load videos');
    }
  }

  Future<void> _editCourse() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Start loading
    setState(() {
      _isLoading = true;
    });

    // Save the form fields
    _formKey.currentState!.save();

    // Retrieve the token from shared preferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    // Make the PATCH request to update the course
    final response = await http.patch(
      Uri.parse(
          'https://obai.aunakit-hosting.com/api/courses/$_selectedCourseId/'),
      headers: {
        'Authorization': 'Token $token',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'title': _title,
        'description': _description,
        'subject_type': _subjectTypeId,
        'teacher': _teacherId,
        'subject': _subjectId,
        'grade': _gradeId,
        'price': _price,
        'videos': _selectedVideoIds,
      }),
    );

    // Stop loading
    setState(() {
      _isLoading = false;
    });

    // Handle the response from the API
    print("Response status code: ${response.statusCode}");
    if (response.statusCode == 200) {
      Navigator.of(context).pop();
    } else {
      print('Failed to edit course: ${response.body}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('تعديل كورس'),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  DropdownButtonFormField<int>(
                    value: _selectedCourseId,
                    decoration: InputDecoration(labelText: 'اختار كورس'),
                    items: _courses
                        .map((course) => DropdownMenuItem<int>(
                              value: course['id'],
                              child: Text(course['title']),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedCourseId = value;
                      });
                      if (value != null) {
                        _fetchCourseDetails(value);
                      }
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'الرجاء اختيار كورس';
                      }
                      return null;
                    },
                  ),
                  if (_selectedCourseId != null) ...[
                    TextFormField(
                      initialValue: _title,
                      decoration: InputDecoration(labelText: 'العنوان'),
                      onSaved: (value) => _title = value,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'الرجاء ادخال عنوان';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      initialValue: _description,
                      decoration: InputDecoration(labelText: 'الوصف'),
                      onSaved: (value) => _description = value,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'الرجاء ادخال الوصف';
                        }
                        return null;
                      },
                    ),
                    DropdownButtonFormField<int>(
                      value: _subjectTypeId,
                      decoration: InputDecoration(labelText: 'نوع'),
                      items: _subjectTypes
                          .map((item) => DropdownMenuItem<int>(
                                value: item['id'],
                                child: Text(item['name']),
                              ))
                          .toList(),
                      onChanged: (value) =>
                          setState(() => _subjectTypeId = value),
                      validator: (value) {
                        if (value == null) {
                          return 'الرجاء اختيار نوع';
                        }
                        return null;
                      },
                    ),
                    DropdownButtonFormField<int>(
                      value: _teacherId,
                      decoration: InputDecoration(labelText: 'المدرس'),
                      items: _teachers
                          .map((item) => DropdownMenuItem<int>(
                                value: item['id'],
                                child: Text(item['name']),
                              ))
                          .toList(),
                      onChanged: (value) => setState(() => _teacherId = value),
                      validator: (value) {
                        if (value == null) {
                          return 'الرجاء اختيار مدرس';
                        }
                        return null;
                      },
                    ),
                    DropdownButtonFormField<int>(
                      value: _subjectId,
                      decoration: InputDecoration(labelText: 'المادة'),
                      items: _subjects
                          .map((item) => DropdownMenuItem<int>(
                                value: item['id'],
                                child: Text(item['name']),
                              ))
                          .toList(),
                      onChanged: (value) => setState(() => _subjectId = value),
                      validator: (value) {
                        if (value == null) {
                          return 'الرجاء اختيار مادة';
                        }
                        return null;
                      },
                    ),
                    DropdownButtonFormField<int>(
                      value: _gradeId,
                      decoration: InputDecoration(labelText: 'الصف'),
                      items: _grades.map((item) {
                        String gradeName;
                        switch (item['id']) {
                          case 9:
                            gradeName = 'تاسع';
                            break;
                          case 12:
                            gradeName = 'بكالوريا علمي';
                            break;
                          case 13:
                            gradeName = 'بكالوريا أدبي';
                            break;
                          default:
                            gradeName = item['level'];
                        }
                        return DropdownMenuItem<int>(
                          value: item['id'],
                          child: Text(gradeName),
                        );
                      }).toList(),
                      onChanged: (value) => setState(() => _gradeId = value),
                      validator: (value) {
                        if (value == null) {
                          return 'الرجاء اختيار صف';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      initialValue: _price?.toString(),
                      decoration: InputDecoration(labelText: 'السعر'),
                      keyboardType: TextInputType.number,
                      onSaved: (value) => _price = int.tryParse(value!),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'الرجاء ادخال السعر';
                        }
                        if (int.tryParse(value) == null) {
                          return 'الرجاء إدخال رقم صحيح';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Select Videos',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      padding: EdgeInsets.all(8.0),
                      child: Column(
                        children: _videos.map((video) {
                          return CheckboxListTile(
                            title: Text(video['title']),
                            value: _selectedVideoIds.contains(video['id']),
                            onChanged: (bool? value) {
                              setState(() {
                                if (value == true) {
                                  _selectedVideoIds.add(video['id']);
                                } else {
                                  _selectedVideoIds.remove(video['id']);
                                }
                              });
                            },
                          );
                        }).toList(),
                      ),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _editCourse,
                      child: Text('حفظ التغييرات'),
                    ),
                  ]
                ],
              ),
            ),
          ),
          if (_isLoading)
            Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}
