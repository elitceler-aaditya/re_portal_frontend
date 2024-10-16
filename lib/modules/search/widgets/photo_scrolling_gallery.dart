import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class PhotoScrollingGallery extends StatelessWidget {
  final List images;
  final int initPage;
  const PhotoScrollingGallery(
      {super.key, required this.images, this.initPage = 0});

  @override
  Widget build(BuildContext context) {
    PageController pageController = PageController(initialPage: initPage);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Photo Gallery'),
      ),
      body: PhotoViewGallery.builder(
        pageController: pageController,
        scrollPhysics: const BouncingScrollPhysics(),
        backgroundDecoration: const BoxDecoration(color: Colors.white),
        builder: (BuildContext context, int index) {
          return PhotoViewGalleryPageOptions(
            imageProvider: NetworkImage(images[index]),
            minScale: PhotoViewComputedScale.contained,
            maxScale: PhotoViewComputedScale.covered * 2,
          );
        },
        itemCount: images.length,
        loadingBuilder: (context, event) => Center(
          child: CircularProgressIndicator(
            value: event == null
                ? 0
                : event.cumulativeBytesLoaded / event.expectedTotalBytes!,
          ),
        ),
      ),
    );
    ;
  }
}
