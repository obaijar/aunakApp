import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class TeacherDelete extends StatefulWidget {
  const TeacherDelete({super.key});

  @override
  State<TeacherDelete> createState() => _TeacherDeleteState();
}

class _TeacherDeleteState extends State<TeacherDelete> {
  List<dynamic> _teachers = [];
  dynamic _selectedTeacher;
  bool _isDeleting = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchTeachers();
  }

  Future<void> _fetchTeachers() async {
    final response = await http
        .get(Uri.parse('https://obai.aunakit-hosting.com/api/teachers/'));

    if (response.statusCode == 200) {
      setState(() {
        _teachers = json.decode(utf8.decode(response.bodyBytes));
        _isLoading = false;
      });
    } else {
      throw Exception('Failed to load teachers');
    }
  }

  Future<void> _deleteTeacher(int id) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    setState(() {
      _isDeleting = true;
    });

    print(id);
    final response = await http.delete(
      Uri.parse('https://obai.aunakit-hosting.com/teacher/$id/'),
      headers: {
        'Authorization': 'Token $token',
      },
    );

    if (response.statusCode == 204) {
      setState(() {
        _teachers.removeWhere((teacher) => teacher['id'] == id);
        _selectedTeacher = null;
        _isDeleting = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('تم الحذف')),
      );
    } else {
      setState(() {
        _isDeleting = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('فشل')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('حذف استاذ'),
      ),
      body: _isLoading
          ? Center(child: Text('لا يوجد بيانات'))
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  DropdownButton<dynamic>(
                    isExpanded: true,
                    value: _selectedTeacher,
                    hint: Text('اختيار الأستاذ'),
                    items: _teachers.map((teacher) {
                      return DropdownMenuItem<dynamic>(
                        value: teacher,
                        child: Text(teacher['name']),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedTeacher = value;
                      });
                    },
                  ),
                  SizedBox(height: 20),
                  _isDeleting
                      ? CircularProgressIndicator()
                      : ElevatedButton(
                          onPressed: _selectedTeacher == null
                              ? null
                              : () => _deleteTeacher(_selectedTeacher['id']),
                          child: Text('حذف'),
                        ),
                ],
              ),
            ),
    );
  }
}
