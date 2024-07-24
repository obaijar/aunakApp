import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  void _confirmDeleteVideo(int id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('تاكيد الحذف'),
          content: Text('هل انت متأكد انك تريد حذف هذا الفيديو'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // Return false
              },
              child: Text('لا'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true); // Return true
              },
              child: Text('نعم'),
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
        title: Text('حذف فيديو'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
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
                          title: Text('تأكيد الحذف'),
                          content: Text('هل انت متاكد تريد حذف هذا الفيديو'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context)
                                    .pop(false); // Return false
                              },
                              child: Text('لا'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop(true); // Return true
                              },
                              child: Text('نعم'),
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
                  child: Card(
                    margin:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    elevation: 5,
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16),
                      title: Text(
                        video['title'] ?? 'No title',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        video['video_file'] ?? 'No video file',
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: Icon(Icons.arrow_forward),
                      isThreeLine: true,
                      dense: false,
                    ),
                  ),
                );
              },
            ),
    );
  }
}
