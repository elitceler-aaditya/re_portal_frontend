import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:re_portal_frontend/modules/home/models/gallery_image_model.dart';

class PhotoScrollingGallery extends StatefulWidget {
  final List<GalleryImageModel> images;
  final String image;

  const PhotoScrollingGallery({
    super.key,
    required this.images,
    this.image = '',
  });

  @override
  State<PhotoScrollingGallery> createState() => _PhotoScrollingGalleryState();
}

class _PhotoScrollingGalleryState extends State<PhotoScrollingGallery> {
  late PageController _pageController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _currentIndex =
        widget.images.indexWhere((element) => element.imageUrl == widget.image);
    _currentIndex = _currentIndex != -1 ? _currentIndex : 0;
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("----image: ${widget.image}");
    debugPrint("----images: ${widget.images}");
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          widget.images[_currentIndex].title,
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: PhotoViewGallery.builder(
        pageController: _pageController,
        scrollPhysics: const BouncingScrollPhysics(),
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        backgroundDecoration: const BoxDecoration(color: Colors.black),
        builder: (BuildContext context, int index) {
          return PhotoViewGalleryPageOptions(
            imageProvider: NetworkImage(widget.images[index].imageUrl),
            minScale: PhotoViewComputedScale.contained,
            maxScale: PhotoViewComputedScale.covered * 2,
          );
        },
        itemCount: widget.images.length,
        loadingBuilder: (context, event) => Center(
          child: CircularProgressIndicator(
            value: event == null
                ? 0
                : event.cumulativeBytesLoaded / event.expectedTotalBytes!,
          ),
        ),
      ),
    );
  }
}
