import 'package:flutter/material.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:video_player/video_player.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class SamplePlayer extends StatefulWidget {
  final String videoUrl;
  const SamplePlayer({
    required this.videoUrl,
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
    const String apiUrl =
        'https://obai.aunakit-hosting.com/videos/1/track-view/';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
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
      final data = json.decode(response.body);
      setState(() {
        canViewVideo = false;
        message = data['detail'];
      });
    } else {
      setState(() {
        canViewVideo = false;
        message = 'An error occurred. Please try again later.';
      });
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
                      style: TextStyle(fontSize: 18, color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
