import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoScreen extends StatefulWidget {
  const VideoScreen({super.key});

  @override
  State<VideoScreen> createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(
      Uri.parse(
        "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4",
      ),
      formatHint: VideoFormat.hls,
    )..initialize().then((_) {
        if (mounted) {
          setState(() {
            _controller.play();
            _controller.setLooping(true);
          });
        }
      }).catchError((error) {
        debugPrint("Error initializing video: $error");
        if (mounted) {
          setState(() {});
        }
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          height: 350,
          width: 250,
          color: Colors.red,
          child: VideoPlayer(_controller),
        ),
      ),
    );
  }
}
