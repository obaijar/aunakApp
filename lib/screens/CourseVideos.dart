import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'dart:convert';
import 'package:get/get.dart';
import 'package:testt/screens/video_player_page.dart'; // Import to use jsonDecode

class CourseVideo extends StatefulWidget {
  const CourseVideo({super.key});

  @override
  State<CourseVideo> createState() => _CourseVideoState();
}

class _CourseVideoState extends State<CourseVideo> {
  List<dynamic> _videos = [];
  bool _isLoading = true;
  String _error = '';

  @override
  void initState() {
    super.initState();
    _fetchVideos();
  }

  Future<void> _fetchVideos() async {
    final dio = Dio();
    final url =
        'https://gist.githubusercontent.com/poudyalanil/ca84582cbeb4fc123a13290a586da925/raw/14a27bd0bcd0cd323b35ad79cf3b493dddf6216b/videos.json';

    try {
      final response = await dio.get(url);

      if (response.statusCode == 200) {
        setState(() {
          _videos = jsonDecode(response.data); // Parse the response as JSON
          _isLoading = false;
        });
      } else {
        setState(() {
          _error = 'Error: ${response.statusCode}';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Error: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error.isNotEmpty) {
      return Center(child: Text(_error));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Course Videos'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: _videos.length,
          itemBuilder: (context, index) {
            final video = _videos[index];
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              elevation: 4,
              child: ListTile(
                contentPadding: const EdgeInsets.all(8.0),
                leading: video['thumbnailUrl'] != null
                    ? Image.network(
                        video['thumbnailUrl'],
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      )
                    : const Icon(Icons.video_library, size: 100),
                title: Text(
                  video['title'],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                subtitle: Text(
                  video['description'],
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
                trailing: const Icon(Icons.arrow_forward),
                onTap: () {
                  Get.to(SamplePlayer(videoUrl: video['videoUrl']));
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
