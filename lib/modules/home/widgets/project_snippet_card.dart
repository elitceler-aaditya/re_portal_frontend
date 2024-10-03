import 'package:flutter/material.dart';
import 'package:re_portal_frontend/modules/home/screens/property_details.dart';
import 'package:re_portal_frontend/modules/shared/models/appartment_model.dart';
import 'package:re_portal_frontend/modules/shared/widgets/colors.dart';
import 'package:video_player/video_player.dart';
import 'package:shimmer/shimmer.dart';

class ProjectSnippetCard extends StatefulWidget {
  final ApartmentModel apartment;
  final String videoLink;

  const ProjectSnippetCard({
    Key? key,
    required this.apartment,
    required this.videoLink,
  }) : super(key: key);

  @override
  _ProjectSnippetCardState createState() => _ProjectSnippetCardState();
}

class _ProjectSnippetCardState extends State<ProjectSnippetCard> {
  // late VideoPlayerController _controller;

  // @override
  // void initState() {
  //   super.initState();
  //   _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoLink))
  //     ..initialize().then((_) {
  //       setState(() {});
  //       _controller.play();
  //       _controller.setLooping(true);
  //     });
  // }

  // @override
  // void dispose() {
  //   _controller.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => PropertyDetails(
              apartment: widget.apartment,
              heroTag: "hero-${widget.apartment.projectId}",
              nextApartment: widget.apartment,
            ),
          ),
        );
      },
      child: Container(
        height: 200,
        width: 150,
        margin: const EdgeInsets.only(right: 8),
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: Hero(
                tag: "hero-${widget.apartment.projectId}",
                // child: _controller.value.isInitialized
                //     ? AspectRatio(
                //         aspectRatio: _controller.value.aspectRatio,
                //         child: VideoPlayer(_controller),
                //       )
                //     : Shimmer.fromColors(
                //         baseColor: CustomColors.black25,
                //         highlightColor: CustomColors.white,
                //         child: Container(
                //           height: 200,
                //           width: 150,
                //           decoration: BoxDecoration(
                //             color: CustomColors.black25,
                //             borderRadius: BorderRadius.circular(10),
                //           ),
                //         ),
                //       ),
                child: Image.network(
                  widget.apartment.coverImage,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            //gradietn
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.transparent,
                      CustomColors.black.withOpacity(0.7)
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 8,
              left: 8,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.apartment.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.apartment.projectLocation,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
