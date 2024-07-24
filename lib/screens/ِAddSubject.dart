import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert'; // Add this import for jsonEncode

class AddSubject extends StatefulWidget {
  const AddSubject({super.key});

  @override
  State<AddSubject> createState() => _AddSubjectState();
}

class _AddSubjectState extends State<AddSubject> {
  final TextEditingController _nameController = TextEditingController();
  int? _selectedGradeIndex;
  bool _isLoading = false;

  final List<String> _grades = [
    'تاسع',
    'بكالوريا علمي',
    'بكالوريا أدبي',
  ];

  Future<void> _addSubject() async {
    final String name = _nameController.text.trim();
    final int? gradeIndex = _selectedGradeIndex;

    if (name.isEmpty || gradeIndex == null) {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('الرجاء إدخال جميع الحقول')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final prefs = await SharedPreferences.getInstance();
    final String? authToken = prefs.getString('token');

    if (authToken == null) {
      print('No authentication token found');
      setState(() {
        _isLoading = false;
      });
      return;
    }
    print(authToken);
    final url = 'https://obai.aunakit-hosting.com/api/subject_create/';
    final headers = {
      'Authorization': 'Token $authToken',
      'Content-Type': 'application/json',
    };
    final body = jsonEncode({
      'name': name,
      'grade': gradeIndex.toString(), // Send the index as a string
    });

    try {
      final dio = Dio();
      final response = await dio.post(
        url,
        options: Options(headers: headers),
        data: body,
      );
      print(response.statusCode);
      if (response.statusCode == 201) {
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('تم إضافة المادة بنجاح')),
        );
        // Clear the form
        _nameController.clear();
        setState(() {
          _selectedGradeIndex = null;
        });
      } else {
        throw Exception('فشل في اضافة مادة');
      }
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('فشل في اضافة مادة')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('إضافة مادة'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'المادة'),
            ),
            SizedBox(height: 16.0),
            DropdownButtonFormField<int>(
              value: _selectedGradeIndex,
              items: List.generate(_grades.length, (index) {
                return DropdownMenuItem<int>(
                  value: index + 1, // Start count from 1
                  child: Text(_grades[index]),
                );
              }),
              onChanged: (int? newValue) {
                setState(() {
                  _selectedGradeIndex = newValue;
                });
              },
              decoration: InputDecoration(labelText: 'الصف'),
            ),
            SizedBox(height: 32.0),
            _isLoading
                ? Center(child: CircularProgressIndicator())
                : SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _addSubject,
                      child: Text('Add'),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
