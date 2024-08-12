import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class EditSubject extends StatefulWidget {
  const EditSubject({super.key});

  @override
  State<EditSubject> createState() => _EditSubjectState();
}

class _EditSubjectState extends State<EditSubject> {
  List<Map<String, dynamic>> _subjects = [];
  String? _selectedSubjectId;
  String? _selectedGrade;
  TextEditingController _nameController = TextEditingController();
  bool isLoading = true; // Indicates whether data is being fetched
  bool isSubmitting = false; // Indicates whether the PUT request is in progress

  @override
  void initState() {
    super.initState();
    _fetchSubjects();
  }

  Future<void> _fetchSubjects() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      final url = Uri.parse('https://obai.aunakit-hosting.com/api/Subject/');
      final response =
          await http.get(url, headers: {'Authorization': 'Token $token'});

      if (response.statusCode == 200) {
        final List subjects = json.decode(utf8.decode(response.bodyBytes));
        setState(() {
          _subjects = subjects
              .map((subject) => {
                    'id': subject['id'],
                    'name': subject['name'],
                  })
              .toList();
          isLoading = false;
        });
      } else {
        print('Failed to load subjects');
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print('An error occurred: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _fetchSubjectDetails(String subjectId) async {
    try {
      setState(() {
        isLoading = true;
      });
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      final url = Uri.parse(
          'https://obai.aunakit-hosting.com/api/subjects/edit/$subjectId/');
      final response =
          await http.get(url, headers: {'Authorization': 'Token $token'});

      if (response.statusCode == 200) {
        final subject = json.decode(utf8.decode(response.bodyBytes));
        setState(() {
          _nameController.text = subject['name'];
          _selectedGrade =
              subject['grade'].toString(); // assuming grade is an integer
          isLoading = false;
        });
      } else {
        print('Failed to load subject details');
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print('An error occurred: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _editSubject(String subjectId) async {
    try {
      setState(() {
        isSubmitting = true;
      });
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      final url = Uri.parse(
          'https://obai.aunakit-hosting.com/api/subjects/edit/$subjectId/');

      final response = await http.put(
        url,
        headers: {
          'Authorization': 'Token $token',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'name': _nameController.text,
          'grade': _selectedGrade,
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تم التعديل بنجاح')),
        );
      } else {
        print('Failed to update subject');
      }
    } catch (e) {
      print('An error occurred: $e');
    } finally {
      setState(() {
        isSubmitting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('تعديل مادة'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  DropdownButtonFormField<String>(
                    value: _selectedSubjectId,
                    items: _subjects.map((subject) {
                      return DropdownMenuItem<String>(
                        value: subject['id'].toString(),
                        child: Text(subject['name']),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedSubjectId = value;
                        _fetchSubjectDetails(value!);
                      });
                    },
                    decoration: const InputDecoration(
                      labelText: 'اختر مادة',
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'اسم المادة',
                    ),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: _selectedGrade,
                    items: const [
                      DropdownMenuItem<String>(
                        value: '1',
                        child: Text('تاسع'),
                      ),
                      DropdownMenuItem<String>(
                        value: '2',
                        child: Text('بكالوريا علمي'),
                      ),
                      DropdownMenuItem<String>(
                        value: '3',
                        child: Text('بكالوريا أدبي'),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _selectedGrade = value;
                      });
                    },
                    decoration: const InputDecoration(
                      labelText: 'Select Grade',
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: isSubmitting
                        ? null
                        : _selectedSubjectId == null
                            ? null
                            : () => _editSubject(_selectedSubjectId!),
                    child: isSubmitting
                        ? const CircularProgressIndicator(
                            color: Colors.white,
                          )
                        : const Text('حفظ التغييرات'),
                  ),
                ],
              ),
            ),
    );
  }
}
