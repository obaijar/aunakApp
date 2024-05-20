import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:testt/screens/CoursesDetail.dart';

class Courses extends StatefulWidget {
  final String teacher;
  final String subject;
  final int section;
  Courses(
      {required this.teacher, required this.subject, required this.section});

  @override
  State<Courses> createState() => _CoursesState();
}

class _CoursesState extends State<Courses> {
  // Sample data for courses
  final List<Map<String, String>> courses = [
    {'image': 'https://via.placeholder.com/150', 'name': 'مكثفة'},
    {'image': 'https://via.placeholder.com/150', 'name': 'تأسيس'},
    {'image': 'https://via.placeholder.com/150', 'name': 'الجلسات الإمتحانية'},
  ];

  void _onCourseTap(String courseName, String teacher, String subject) {
    // Perform the desired action when a course is tapped
    // For example, you could navigate to a new page or show a dialog
    print('Tapped on course: $courseName');
    // Example: Navigate to a new page
    Get.to(() => CourseDetailPage(
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
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.75, // Adjusts the aspect ratio of the items
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: courses.length,
          itemBuilder: (context, index) {
            final course = courses[index];
            return GestureDetector(
              onTap: () =>
                  _onCourseTap(course['name']!, widget.teacher, widget.subject),
              child: GridTile(
                child: Column(
                  children: [
                    Expanded(
                      child: Image.network(
                        course['image']!,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      course['name']!,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    //  Text("teacher${widget.teacher}, subject${widget.subject}")
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
