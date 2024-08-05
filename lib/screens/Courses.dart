import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:testt/screens/CoursesDetail.dart';

class Courses extends StatefulWidget {
  final int teacher;
  final String subject;
  final int section;
  Courses(
      {required this.teacher, required this.subject, required this.section});

  @override
  State<Courses> createState() => _CoursesState();
}

class _CoursesState extends State<Courses> {
  late Future<List<Map<String, dynamic>>> _futureCourses;

  @override
  void initState() {
    super.initState();
    _futureCourses = fetchCourses();
  }

  Future<List<Map<String, dynamic>>> fetchCourses() async {
    final response =
        await http.get(Uri.parse('http://10.0.2.2:8000/api/Subject_type/'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
      // Assuming the API returns a list of courses with the same structure
      // Map the API response to include local images
      return data.map((course) {
        String imageName;
        switch (course['id']) {
          case 1:
            imageName = 'images/161.png';
            break;
          case 2:
            imageName = 'images/151.png';
            break;
          case 3:
            imageName = 'images/151.png';
            break;
          default:
            imageName = 'images/151.png'; // Fallback image
        }
        return {
          'id': course['id'],
          'name': course['name'],
          'image': imageName,
        };
      }).toList();
    } else {
      throw Exception('Failed to load courses');
    }
  }

  void _onCourseTap(
      String courseName, int courseID, int teacher, String subject) {
    Get.to(() => CourseDetailPage(
          courseID: courseID,
          courseName: courseName,
          teacher: teacher,
          subject: subject,
          section: widget.section,
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "الدورات",
          style: TextStyle(fontSize: 20.sp),
        ),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _futureCourses,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Failed to load courses'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No courses available'));
          }

          final courses = snapshot.data!;

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
              itemCount: courses.length,
              itemBuilder: (context, index) {
                final course = courses[index];
                return GestureDetector(
                  onTap: () => _onCourseTap(course['name']!, course['id'],
                      widget.teacher, widget.subject),
                  child: GridTile(
                    child: Column(
                      children: [
                        Expanded(
                          child: Image.asset(
                            course['image']!,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          course['name']!,
                          style: TextStyle(
                              fontSize: 16.sp, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
