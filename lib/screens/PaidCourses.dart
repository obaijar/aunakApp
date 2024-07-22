import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class PaidCourses extends StatefulWidget {
  const PaidCourses({super.key});

  @override
  State<PaidCourses> createState() => _PaidCoursesState();
}

class _PaidCoursesState extends State<PaidCourses> {
  List<dynamic> _courses = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchCourses();
  }

  Future<void> _fetchCourses() async {
    final prefs = await SharedPreferences.getInstance();
    final String? authToken = prefs
        .getString('token'); // Replace with the key you use to store the token
    final String? id = prefs.getString('id');
    if (authToken == null) {
      // Handle missing token case
      print('No authentication token found');
      setState(() {
        _isLoading = false;
      });
      return;
    }

    final url = Uri.parse(
        'https://obai.aunakit-hosting.com/purchases/user/$id/'); // Replace with your API endpoint
    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Token $authToken',
        },
      );
      if (response.statusCode == 200) {
        final List<dynamic> jsonResponse = json.decode(response.body);
        setState(() {
          _courses = jsonResponse.map((item) => item['course']).toList();
          _isLoading = false;
        });
      } else {
        // Handle error here
        throw Exception('Failed to load courses');
      }
    } catch (e) {
      // Handle network or parsing errors here
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Paid Courses'),
      ),
      body: ListView.builder(
        itemCount: _courses.length,
        itemBuilder: (context, index) {
          final course = _courses[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            elevation: 5,
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              leading: Icon(Icons.book, color: Colors.blueGrey[700]),
              title: Text(
                course['title'] ?? 'No title',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                course['description'] ?? 'No description',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: IconButton(
                icon: const Icon(Icons.arrow_forward),
                onPressed: () {
                  // Handle the tap event here
                  print('Tapped on course: ${course['title']}');
                },
              ),
              isThreeLine: true,
              dense: false,
            ),
          );
        },
      ),
    );
  }
}
