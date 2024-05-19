import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Courses extends StatefulWidget {
  final String teacher;
  Courses({required this.teacher});

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

  void _onCourseTap(String courseName) {
    // Perform the desired action when a course is tapped
    // For example, you could navigate to a new page or show a dialog
    print('Tapped on course: $courseName');
    // Example: Navigate to a new page
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => CourseDetailPage(courseName: courseName)),
    );
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
              onTap: () => _onCourseTap(course['name']!),
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

class CourseDetailPage extends StatelessWidget {
  final String courseName;

  const CourseDetailPage({required this.courseName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(courseName),
      ),
      body: Center(
        child: Text('Details for $courseName'),
      ),
    );
  }
}
