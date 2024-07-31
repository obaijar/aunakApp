// ignore_for_file: file_names, depend_on_referenced_packages, prefer_const_declarations, avoid_print

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testt/screens/video_player_page.dart';

class DeleteVideo extends StatefulWidget {
  const DeleteVideo({super.key});

  @override
  State<DeleteVideo> createState() => _DeleteVideoState();
}

class _DeleteVideoState extends State<DeleteVideo> {
  List<Map<String, dynamic>> _videos = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchVideos();
  }

  Future<void> _fetchVideos() async {
    final prefs = await SharedPreferences.getInstance();
    final String? authToken = prefs.getString('token');

    if (authToken == null) {
      print('No authentication token found');
      setState(() {
        _isLoading = false;
      });
      return;
    }

    final url = 'https://obai.aunakit-hosting.com/api/videos/';
    final dio = Dio();
    try {
      final response = await dio.get(
        url,
        options: Options(
          headers: {
            'Authorization': 'Token $authToken',
          },
        ),
      );
      if (response.statusCode == 200) {
        final List<dynamic> jsonResponse = response.data;
        setState(() {
          _videos = jsonResponse.map((item) {
            return {
              'id': item['id'],
              'title': item['title'],
              'video_file': item['video_file'],
              'grade': item['grade'],
              'subject': item['subject'],
            };
          }).toList();
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to load videos');
      }
    } catch (e) {
      print(e);
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _deleteVideo(int id) async {
    final prefs = await SharedPreferences.getInstance();
    final String? authToken = prefs.getString('token');

    if (authToken == null) {
      print('No authentication token found');
      return;
    }

    final url = 'https://obai.aunakit-hosting.com/videos/$id/delete/';
    final dio = Dio();
    try {
      final response = await dio.delete(
        url,
        options: Options(
          headers: {
            'Authorization': 'Token $authToken',
          },
        ),
      );
      if (response.statusCode == 204) {
        setState(() {
          _videos.removeWhere((video) => video['id'] == id);
        });
      } else {
        throw Exception('Failed to delete video');
      }
    } catch (e) {
      print(e);
    }
  }

  // ignore: unused_element
  void _confirmDeleteVideo(int id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('تأكيد الحذف'),
          content: const Text('هل انت متاكد تريد حذف هذا الفيديو'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // Return false
              },
              child: const Text('لا'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true); // Return true
              },
              child: const Text('نعم'),
            ),
          ],
        );
      },
    ).then((confirmed) {
      if (confirmed == true) {
        _deleteVideo(id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('حذف فيديو'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _videos.length,
              itemBuilder: (context, index) {
                final video = _videos[index];
                return Dismissible(
                  key: Key(video['id'].toString()), // Unique key for each item
                  direction: DismissDirection.endToStart,
                  confirmDismiss: (direction) async {
                    return await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('تأكيد الحذف'),
                          content:
                              const Text('هل انت متاكد تريد حذف هذا الفيديو'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context)
                                    .pop(false); // Return false
                              },
                              child: const Text('لا'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop(true); // Return true
                              },
                              child: const Text('نعم'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  onDismissed: (direction) {
                    // This callback is executed if the confirmDismiss returns true
                    _deleteVideo(video['id']);
                  },
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => SamplePlayer(
                            videoUrl: video['video_file'],
                            videoID: video['id'],
                          ),
                        ),
                      );
                    },
                    child: Card(
                      margin: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 16),
                      elevation: 5,
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(16),
                        title: Text(
                          video['title'] ?? 'No title',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Grade: ${video['grade'] ?? 'No grade'}',
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                            Text(
                              'Subject: ${video['subject'] ?? 'No subject'}',
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          ],
                        ),
                        trailing: const Icon(Icons.arrow_forward),
                        isThreeLine: true,
                        dense: false,
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
