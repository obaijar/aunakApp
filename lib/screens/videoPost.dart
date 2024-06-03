// ignore_for_file: file_names, depend_on_referenced_packages, use_key_in_widget_constructors, library_private_types_in_public_api, avoid_init_to_null, avoid_print

import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_screenutil/flutter_screenutil.dart';

class VideoPost extends StatefulWidget {
  @override
  _VideoPostState createState() => _VideoPostState();
}

class _VideoPostState extends State<VideoPost> {
  File? _videoFile = null;

  Future<void> pickVideo() async {
    final pickedFile =
        await ImagePicker().pickVideo(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _videoFile = File(pickedFile.path);
      });
    }
  }

  Future<void> uploadVideo(File videoFile) async {
    final url = Uri.parse('YOUR_UPLOAD_URL_HERE');
    final request = http.MultipartRequest('POST', url);
    request.files
        .add(await http.MultipartFile.fromPath('video', videoFile.path));

    final response = await request.send();
    if (response.statusCode == 200) {
      // Upload successful
      print('Video uploaded successfully');
    } else {
      // Upload failed
      print('Failed to upload video');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'تحميل دروس',
          style: TextStyle(fontSize: 20.sp),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: pickVideo,
              child: Text(
                'إختيار درس',
                style: TextStyle(fontSize: 15.sp, color: Colors.blue),
              ),
            ),
            if (_videoFile != null)
              Text(
                '   :الملف المختار ${_videoFile!.path}',
                style: TextStyle(fontSize: 15.sp),
              ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_videoFile != null) {
                  uploadVideo(_videoFile!);
                } else {
                  // Show an error message or handle no selected file case
                  print('No video selected');
                }
              },
              child: Text(
                'رفع الدرس',
                style: TextStyle(fontSize: 15.sp, color: Colors.blue),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
