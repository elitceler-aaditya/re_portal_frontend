import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:re_portal_frontend/modules/shared/widgets/colors.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoScreen extends StatefulWidget {
  final String videoLink;
  const VideoScreen({super.key, required this.videoLink});

  @override
  State<VideoScreen> createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  YoutubePlayerController? _controller;
  bool isMute = false;

  @override
  void initState() {
    _controller = YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId(widget.videoLink) ?? '',
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
        enableCaption: false,
      ),
    );
    super.initState();
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: SystemUiOverlay.values,
    );
    _controller!.pause();
    _controller!.removeListener(() {});
    _controller!.dispose();
    super.dispose();
  }

  @override
  void deactivate() {
    _controller!.pause();
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !_controller!.value.isFullScreen,
      onPopInvokedWithResult: (canPop, res) async {
        _controller!.value.isFullScreen
            ? {
                _controller!.toggleFullScreenMode(),
                SystemChrome.setEnabledSystemUIMode(
                  SystemUiMode.manual,
                  overlays: SystemUiOverlay.values,
                ),
              }
            : {
                _controller!.pause(),
                _controller!.removeListener(() {}),
                _controller!.dispose(),
              };
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            Center(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: CustomColors.black,
                  borderRadius: BorderRadius.circular(10),
                ),
                alignment: Alignment.center,
                child: Center(
                  child: YoutubePlayer(
                    controller: _controller!,
                    showVideoProgressIndicator: true,
                    progressIndicatorColor: CustomColors.primary,
                    progressColors: const ProgressBarColors(
                      playedColor: CustomColors.primary,
                      handleColor: CustomColors.primary,
                    ),
                    onReady: () {},
                  ),
                ),
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).padding.top + 10,
              left: 10,
              child: Row(
                children: [
                  IconButton(
                    style: IconButton.styleFrom(
                        backgroundColor: CustomColors.black.withOpacity(0.5)),
                    icon: Icon(
                      _controller!.value.isFullScreen
                          ? Icons.fullscreen_exit
                          : Icons.arrow_back,
                      color: CustomColors.white,
                    ),
                    onPressed: () {
                      _controller!.value.isFullScreen
                          ? {
                              _controller!.toggleFullScreenMode(),
                              SystemChrome.setEnabledSystemUIMode(
                                SystemUiMode.manual,
                                overlays: SystemUiOverlay.values,
                              ),
                              setState(() {}),
                            }
                          : {
                              _controller!.pause(),
                              _controller!.removeListener(() {}),
                              _controller!.dispose(),
                              Navigator.pop(context),
                            };
                    },
                  ),
                  if (!_controller!.value.isFullScreen)
                    const Text(
                      'Video Walkthrough',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    )
                ],
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).padding.top + 10,
              right: 10,
              child: IconButton.filled(
                style: IconButton.styleFrom(
                    backgroundColor: CustomColors.black.withOpacity(0.5)),
                icon: Icon(
                  isMute ? Icons.volume_off : Icons.volume_up,
                  color: CustomColors.white,
                ),
                onPressed: () {
                  isMute ? _controller!.unMute() : _controller!.mute();
                  setState(() {
                    isMute = !isMute;
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
