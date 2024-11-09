import 'package:flutter/material.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:photo_view/photo_view.dart';
import 'package:shimmer/shimmer.dart';

import 'package:re_portal_frontend/modules/shared/models/apartment_details_model.dart';
import 'package:re_portal_frontend/modules/shared/widgets/colors.dart';
import 'package:re_portal_frontend/modules/shared/widgets/transitions.dart';

class ProjectImageGallery extends StatefulWidget {
  final List<ProjectImageModel> projectImages;
  final int tabIndex;
  final int photoIndex;

  const ProjectImageGallery({
    super.key,
    required this.projectImages,
    this.tabIndex = 0,
    this.photoIndex = 0,
  });

  @override
  State<ProjectImageGallery> createState() => _ProjectImageGalleryState();
}

class _ProjectImageGalleryState extends State<ProjectImageGallery>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late Map<String, List<ProjectImageModel>> _groupedImages;
  int _current = 0;
  late PageController _pageController;

  bool _isZoomedIn = false;

  @override
  void initState() {
    super.initState();

    _groupedImages = _groupProjectImagesByTitle();
    _tabController = TabController(
      length: _groupedImages.keys.length,
      initialIndex: widget.tabIndex,
      vsync: this,
    );
    _pageController = PageController();
  }

  Map<String, List<ProjectImageModel>> _groupProjectImagesByTitle() {
    final Map<String, List<ProjectImageModel>> grouped = {};

    for (final image in widget.projectImages) {
      if (!grouped.containsKey(image.title)) {
        grouped[image.title] = [];
      }
      grouped[image.title]!.add(image);
    }

    return grouped;
  }

  void _handleCarouselPageChange(int index, CarouselPageChangedReason reason) {
    if (!_isZoomedIn) {
      setState(() {
        _current = index;
      });
    } else {
      setState(() {
        _isZoomedIn = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<String> titles = _groupedImages.keys.toList();

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        bottom: TabBar(
          tabAlignment: TabAlignment.start,
          controller: _tabController,
          indicatorColor: Colors.white,
          isScrollable: true,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white60,
          tabs: titles.map((title) => Tab(text: title)).toList(),
        ),
      ),
      body: titles.isEmpty
          ? const Center(
              child: Text(
                'No images available',
                style: TextStyle(color: Colors.white),
              ),
            )
          : Stack(
              children: [
                GestureDetector(
                  onHorizontalDragEnd: (details) {
                    if (_isZoomedIn) return;
                    if (details.primaryVelocity == null) return;

                    final currentTitle = titles[_tabController.index];
                    final images = _groupedImages[currentTitle] ?? [];
                    if (images.isEmpty) return;

                    final imageFiles = images[_current].images;

                    if (_current == imageFiles.length - 1 &&
                        details.primaryVelocity! < 0 &&
                        _tabController.index < _tabController.length - 1) {
                      _tabController.animateTo(_tabController.index + 1);
                      setState(() {
                        _current = 0;
                      });
                    } else if (_current == 0 &&
                        details.primaryVelocity! > 0 &&
                        _tabController.index > 0) {
                      _tabController.animateTo(_tabController.index - 1);
                      setState(() {
                        _current = 0;
                      });
                    }
                  },
                  child: TabBarView(
                    controller: _tabController,
                    children: titles.map((title) {
                      final images = _groupedImages[title] ?? [];

                      if (images.isEmpty) {
                        return const Center(
                          child: Text(
                            'No images available for this title',
                            style: TextStyle(color: Colors.white),
                          ),
                        );
                      }

                      if (_current >= images.length) {
                        _current = 0;
                      }

                      final currentImage = images[_current];
                      final imageFiles = currentImage.images;

                      if (imageFiles.isEmpty) {
                        return const Center(
                          child: Text(
                            'No images available for this image',
                            style: TextStyle(color: Colors.white),
                          ),
                        );
                      }

                      return Container(
                        color: Colors.black,
                        child: FlutterCarousel.builder(
                          itemCount: imageFiles.length,
                          options: CarouselOptions(
                            height: MediaQuery.of(context).size.height * 0.6,
                            viewportFraction: 1,
                            // initialPage: widget.photoIndex,
                            onPageChanged: _handleCarouselPageChange,
                            showIndicator: true,
                            slideIndicator: const CircularSlideIndicator(
                              slideIndicatorOptions: SlideIndicatorOptions(
                                indicatorRadius: 4,
                                itemSpacing: 16,
                                currentIndicatorColor: Colors.white,
                                indicatorBackgroundColor: Colors.white54,
                              ),
                            ),
                          ),
                          itemBuilder: (context, index, realIndex) {
                            return GestureDetector(
                              onTap: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => Scaffold(
                                    appBar: AppBar(
                                      backgroundColor: Colors.black,
                                      automaticallyImplyLeading: true,
                                      iconTheme: const IconThemeData(
                                          color: Colors.white),
                                    ),
                                    body: PhotoView(
                                      imageProvider:
                                          NetworkImage(imageFiles[index]),
                                      minScale:
                                          PhotoViewComputedScale.contained,
                                      maxScale: PhotoViewComputedScale.covered,
                                      // enableRotation: true,
                                      enablePanAlways: true,
                                    ),
                                  ),
                                ),
                              ),
                              child: Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 5.0),
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Image.network(
                                  imageFiles[index],
                                  loadingBuilder:
                                      (context, child, loadingProgress) {
                                    if (loadingProgress == null) {
                                      return child;
                                    } else {
                                      return Shimmer.fromColors(
                                        baseColor: CustomColors.black25,
                                        highlightColor: CustomColors.black10,
                                        child: Container(
                                          height: 100,
                                          width: 320,
                                          decoration: BoxDecoration(
                                            color: Colors.black,
                                            borderRadius:
                                                BorderRadius.circular(16),
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Center(
                                      child: Row(
                                        children: [
                                          Icon(Icons.error),
                                          SizedBox(width: 4),
                                          Text("Error loading image")
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    _pageController.dispose();
    super.dispose();
  }
}
