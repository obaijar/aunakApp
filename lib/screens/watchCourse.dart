// ignore_for_file: file_names, depend_on_referenced_packages, camel_case_types

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testt/screens/video_player_page.dart'; // Ensure this path is correct

class watchCourse extends StatefulWidget {
  final List<dynamic> videoList;
  const watchCourse({
    super.key,
    required this.videoList,
  });

  @override
  State<watchCourse> createState() => _watchCourseState();
}

class _watchCourseState extends State<watchCourse> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('مشاهدة الكورس'),
        elevation: 4.0, // AppBar elevation
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.grey[200]!],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: ListView.builder(
          padding: const EdgeInsets.all(16.0), // Padding around the ListView
          itemCount: widget.videoList.length,
          itemBuilder: (context, index) {
            final video = widget.videoList[index];
            return Card(
              elevation: 5.0, // Elevation of each card
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              child: ListTile(
                contentPadding: const EdgeInsets.all(16.0),
                leading: const Icon(
                  Icons.video_library,
                  color: Colors.deepPurple,
                ),
                title: Text(
                  video['title'] ?? 'No titlee',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                  ),
                ),
                onTap: () {
                  Get.to(SamplePlayer(
                    videoUrl: video['preview_link'],
                    videoID: video['id'],
                  ));
                  // ignore: avoid_print
                  print('Playing video: ${video['title']}');
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
