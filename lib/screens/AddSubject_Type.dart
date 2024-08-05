// ignore_for_file: depend_on_referenced_packages, prefer_const_constructors, avoid_print, prefer_const_declarations, file_names

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert'; // Add this import for jsonEncode

class AddSubjectType extends StatefulWidget {
  const AddSubjectType({super.key});

  @override
  State<AddSubjectType> createState() => _AddSubjectTypeState();
}

class _AddSubjectTypeState extends State<AddSubjectType> {
  final TextEditingController _nameController = TextEditingController();
 
  bool _isLoading = false;

  Future<void> _AddSubjectType() async {
    final String name = _nameController.text.trim(); 

    if (name.isEmpty) {
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
    final url = 'http://10.0.2.2:8000/api/subject-type/add/';
    final headers = {
      'Authorization': 'Token $authToken',
      'Content-Type': 'application/json',
    };
    final body = jsonEncode({
      'name': name, 
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
          SnackBar(content: Text('تم لإضافة بنجاح')),
        );
        // Clear the form
        _nameController.clear();
        
      } else {
        throw Exception('فشل في لاضافة  ');
      }
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('فشل في لاضافة  ')),
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
            SizedBox(height: 32.0),
            _isLoading
                ? Center(child: CircularProgressIndicator())
                : SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _AddSubjectType,
                      child: Text('إضافة'),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
