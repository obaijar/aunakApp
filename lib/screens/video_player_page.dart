// ignore_for_file: depend_on_referenced_packages, library_private_types_in_public_api, avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:video_player/video_player.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SamplePlayer extends StatefulWidget {
  final String videoUrl;
  final int videoID;

  const SamplePlayer({
    super.key,
    required this.videoUrl,
    required this.videoID,
  });

  @override
  _SamplePlayerState createState() => _SamplePlayerState();
}

class _SamplePlayerState extends State<SamplePlayer> {
  late FlickManager flickManager;
  bool canViewVideo = false;
  String message = "";

  @override
  void initState() {
    super.initState();
    _checkVideoAccess();
  }

  Future<void> _checkVideoAccess() async {
    String apiUrl = 'http://10.0.2.2:8000/videos/${widget.videoID}/track-view/';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Token $token', // replace with actual token
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          canViewVideo = true;
          flickManager = FlickManager(
            videoPlayerController: VideoPlayerController.networkUrl(
              Uri.parse(data['video_url']),
            ),
          );
        });
      } else if (response.statusCode == 403) {
        setState(() {
          canViewVideo = false;
          message = "لقد تجاوزت الحد المسموح لمشاهدة الفيديو";
        });
      } else {
        setState(() {
          canViewVideo = false;
          message = 'An error occurred. Please try again later.';
        });
      }
    } catch (e) {
      // Handle exceptions, such as network errors
      setState(() {
        canViewVideo = false;
        message =
            'Failed to connect to server. Please check your internet connection and try again.';
      });
      print('Error: $e');
    }
  }

  @override
  void dispose() {
    if (canViewVideo) {
      flickManager.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("برنامج تعليمي"),
        ),
        body: Center(
          child: canViewVideo
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      child: FlickVideoPlayer(flickManager: flickManager),
                    ),
                  ],
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      message,
                      style: TextStyle(fontSize: 18.sp, color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
