import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class VideoUploadScreen extends StatefulWidget {
  @override
  _VideoUploadScreenState createState() => _VideoUploadScreenState();
}

class _VideoUploadScreenState extends State<VideoUploadScreen> {
  File? _videoFile;

  Future<void> _pickVideo() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: false, // Only allow single video selection
      type: FileType.video, // Specify video type
    );

    if (result != null) {
      setState(() {
        _videoFile = File(result.files.single.path!);
      });
    } else {
      // Handle no file selected case (optional)
      print('No video selected.');
    }
  }

  Future<void> _uploadVideo() async {
    final dio = Dio();
    final formData = FormData.fromMap({
      'video': await MultipartFile.fromFile(
        _videoFile!.path,
        filename: _videoFile!.path.split('/').last,
      ),
      // Add any additional fields required by your API (optional)
    });

    try {
      final response = await dio.post(
        '<your_api_endpoint>', // Replace with your actual API endpoint
        data: formData,
        onSendProgress: (sent, total) {
          // Display upload progress (optional)
          print('Progress: ${sent}/${total}');
        },
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Video uploaded successfully!'),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Upload failed. Status code: ${response.statusCode}'),
          ),
        );
      }
    } on DioException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Upload error: ${e.message}'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Video Upload'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _pickVideo,
              child: Text('Pick Video'),
            ),
            SizedBox(height: 20),
            if (_videoFile != null) Text('Selected video: ${_videoFile!.path}'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _uploadVideo,
              child: Text('Upload Video'),
            ),
          ],
        ),
      ),
    );
  }
}
