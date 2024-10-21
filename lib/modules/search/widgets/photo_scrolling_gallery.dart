import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:re_portal_frontend/modules/shared/widgets/colors.dart';

class PhotoScrollingGallery extends StatefulWidget {
  final List<String> allImages;
  final List<String> labels;
  final List<double> breakPoints;
  final int galleryIndex;
  final String image;

  const PhotoScrollingGallery({
    super.key,
    required this.allImages,
    required this.labels,
    required this.breakPoints,
    required this.galleryIndex,
    required this.image,
  });

  @override
  State<PhotoScrollingGallery> createState() => _PhotoScrollingGalleryState();
}

class _PhotoScrollingGalleryState extends State<PhotoScrollingGallery> {
  int galleryIndex = 0;
  PageController? galleryController;

  @override
  void initState() {
    super.initState();
    galleryIndex = widget.galleryIndex;
    galleryController =
        PageController(initialPage: widget.allImages.indexOf(widget.image));
  }

  @override
  void dispose() {
    galleryController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("--------images: ${widget.allImages}");
    debugPrint("--------labels: ${widget.labels}");
    debugPrint("--------breakpoints: ${widget.breakPoints}");
    return Scaffold(
      backgroundColor: CustomColors.black,
      body: Stack(
        children: [
          PageView.builder(
            controller: galleryController,
            itemCount: widget.allImages.length,
            itemBuilder: (context, imageIndex) {
              return PhotoView(
                imageProvider: NetworkImage(
                  widget.allImages[imageIndex].trim(),
                ),
                minScale: PhotoViewComputedScale.contained,
                maxScale: PhotoViewComputedScale.covered * 4,
                initialScale: PhotoViewComputedScale.contained,
                backgroundDecoration:
                    const BoxDecoration(color: CustomColors.black),
                loadingBuilder: (context, event) => const Center(
                  child: CircularProgressIndicator(),
                ),
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.error),
                filterQuality: FilterQuality.high,
                heroAttributes:
                    PhotoViewHeroAttributes(tag: "image_$imageIndex"),
                gestureDetectorBehavior: HitTestBehavior.opaque,
              );
            },
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: MediaQuery.of(context).padding.top + 60,
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top,
                left: 0,
                right: 10,
              ),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
              ),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.arrow_back,
                        color: CustomColors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).padding.top + 70,
            left: 0,
            right: 0,
            child: Container(
              height: 50,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    ...List.generate(
                      widget.labels.length,
                      (index) => widget.labels[index].isEmpty
                          ? const SizedBox()
                          : Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: TextButton(
                                style: TextButton.styleFrom(
                                  backgroundColor: galleryIndex == index
                                      ? CustomColors.primary20
                                      : Colors.transparent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  side: BorderSide(
                                    color: CustomColors.white.withOpacity(0.2),
                                  ),
                                ),
                                onPressed: () {
                                  setState(() {
                                    galleryIndex = index;
                                  });
                                  galleryController?.animateTo(
                                    index == 0
                                        ? 0
                                        : MediaQuery.of(context).size.width *
                                            widget.breakPoints[index],
                                    duration: const Duration(milliseconds: 500),
                                    curve: Curves.easeInOut,
                                  );
                                },
                                child: Text(
                                  widget.labels[index],
                                  style: TextStyle(
                                    color: galleryIndex == index
                                        ? CustomColors.primary
                                        : CustomColors.black50,
                                  ),
                                ),
                              ),
                            ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
