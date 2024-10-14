import 'package:flutter/material.dart';
import 'package:re_portal_frontend/modules/search/widgets/photo_scrolling_gallery.dart';
import 'package:re_portal_frontend/modules/shared/widgets/colors.dart';

class PhotoGallery extends StatefulWidget {
  final List images;
  const PhotoGallery({super.key, required this.images});

  @override
  State<PhotoGallery> createState() => _PhotoGalleryState();
}

class _PhotoGalleryState extends State<PhotoGallery> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Photo Gallery'),
      ),
      body: ListView.builder(
        itemCount: widget.images.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PhotoScrollingGallery(
                    images: widget.images,
                    initPage: index,
                  ),
                ),
              );
            },
            child: Container(
              height: 200,
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                border: Border.all(
                  color: CustomColors.black25,
                ),
                boxShadow: const [
                  BoxShadow(
                    color: CustomColors.black25,
                    blurRadius: 4,
                    offset: Offset(0, 3),
                  ),
                ],
                image: DecorationImage(
                  image: NetworkImage(widget.images[index]),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
