import 'package:flutter/material.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:photo_view/photo_view.dart';
import 'package:re_portal_frontend/modules/shared/models/apartment_details_model.dart';
import 'package:re_portal_frontend/modules/shared/widgets/colors.dart';
import 'package:re_portal_frontend/modules/shared/widgets/transitions.dart';
import 'package:shimmer/shimmer.dart';

class UnitPlanGallery extends StatefulWidget {
  final List<UnitPlanConfig> unitPlans;

  const UnitPlanGallery({
    super.key,
    required this.unitPlans,
  });

  @override
  State<UnitPlanGallery> createState() => _UnitPlanGalleryState();
}

class _UnitPlanGalleryState extends State<UnitPlanGallery>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late Map<String, List<UnitPlanConfig>> _groupedPlans;
  int _current = 0;
  late PageController _pageController;

  bool _isZoomedIn = false;

  @override
  void initState() {
    super.initState();
    _groupedPlans = _groupUnitPlansByBHK();
    _tabController = TabController(
      length: _groupedPlans.keys.length,
      vsync: this,
    );
    _pageController = PageController();
  }

  Map<String, List<UnitPlanConfig>> _groupUnitPlansByBHK() {
    final Map<String, List<UnitPlanConfig>> grouped = {};

    for (final plan in widget.unitPlans) {
      if (!grouped.containsKey(plan.bHKType)) {
        grouped[plan.bHKType] = [];
      }
      grouped[plan.bHKType]!.add(plan);
    }

    // Sort the BHK types for consistent ordering
    final Map<String, List<UnitPlanConfig>> sortedGrouped = Map.fromEntries(
        grouped.entries.toList()..sort((a, b) => a.key.compareTo(b.key)));

    return sortedGrouped;
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

  void _openImage(BuildContext context, String imageUrl) {
    upSlideTransition(context, ImageViewPage(imageUrl: imageUrl));
  }

  @override
  Widget build(BuildContext context) {
    final List<String> bhkTypes = _groupedPlans.keys.toList();

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white60,
          tabs: bhkTypes.map((bhk) => Tab(text: bhk)).toList(),
        ),
      ),
      body: bhkTypes.isEmpty
          ? const Center(
              child: Text(
                'No plans available',
                style: TextStyle(color: Colors.white),
              ),
            )
          : Stack(
              children: [
                GestureDetector(
                  onHorizontalDragEnd: (details) {
                    if (_isZoomedIn) return;
                    if (details.primaryVelocity == null) return;

                    final currentBhkType = bhkTypes[_tabController.index];
                    final plans = _groupedPlans[currentBhkType] ?? [];
                    if (plans.isEmpty) return;

                    final imageFiles = plans[_current].unitPlanConfigFiles;

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
                    children: bhkTypes.map((bhk) {
                      final plans = _groupedPlans[bhk] ?? [];

                      if (plans.isEmpty) {
                        return const Center(
                          child: Text(
                            'No plans available for this type',
                            style: TextStyle(color: Colors.white),
                          ),
                        );
                      }

                      if (_current >= plans.length) {
                        _current = 0;
                      }

                      final currentPlan = plans[_current];
                      final imageFiles = currentPlan.unitPlanConfigFiles;

                      if (imageFiles.isEmpty) {
                        return const Center(
                          child: Text(
                            'No images available for this plan',
                            style: TextStyle(color: Colors.white),
                          ),
                        );
                      }

                      return Container(
                        color: Colors.black,
                        child: Column(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 16.0),
                              child: AnimatedSwitcher(
                                duration: const Duration(milliseconds: 300),
                                child: Text(
                                  '${currentPlan.facing} facing  |  ${currentPlan.sizeInSqft} sq.ft',
                                  key: ValueKey<int>(_current),
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                ),
                              ),
                            ),
                            FlutterCarousel.builder(
                              itemCount: imageFiles.length,
                              options: CarouselOptions(
                                aspectRatio: 16 / 9,
                                height:
                                    MediaQuery.of(context).size.height * 0.6,
                                viewportFraction: 1,
                                initialPage: 0,
                                enlargeCenterPage: true,
                                onPageChanged: _handleCarouselPageChange,
                                showIndicator: true,
                                slideIndicator: const CircularSlideIndicator(
                                    slideIndicatorOptions:
                                        SlideIndicatorOptions(
                                  indicatorRadius: 4,
                                  itemSpacing: 16,
                                  currentIndicatorColor: Colors.white,
                                  indicatorBackgroundColor: Colors.white54,
                                )),
                              ),
                              itemBuilder: (context, index, realIndex) {
                                return GestureDetector(
                                  onTap: () =>
                                      _openImage(context, imageFiles[index]),
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 5.0),
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
                                            highlightColor:
                                                CustomColors.black10,
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
                                      errorBuilder:
                                          (context, error, stackTrace) {
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
                          ],
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

class ImageViewPage extends StatefulWidget {
  final String imageUrl;

  const ImageViewPage({super.key, required this.imageUrl});

  @override
  State<ImageViewPage> createState() => _ImageViewPageState();
}

class _ImageViewPageState extends State<ImageViewPage> {
  late PhotoViewController _photoViewController;

  @override
  void initState() {
    super.initState();
    _photoViewController = PhotoViewController();
  }

  void _toggleZoom(bool zoomin) {
    setState(() {
      if (zoomin) {
        _photoViewController.scale = (_photoViewController.scale! * 1.2);
      } else {
        _photoViewController.scale = (_photoViewController.scale! * 0.8);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 64,
            width: 64,
            child: IconButton(
              icon: const Icon(
                Icons.zoom_in,
                color: Colors.white,
              ),
              onPressed: () => _toggleZoom(true),
            ),
          ),
          SizedBox(
            height: 64,
            width: 64,
            child: IconButton(
              icon: const Icon(
                Icons.zoom_out,
                color: Colors.white,
              ),
              onPressed: () => _toggleZoom(false),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Image View', style: TextStyle(color: Colors.white)),
      ),
      body: Center(
        child: PhotoView(
          controller: _photoViewController,
          imageProvider: NetworkImage(widget.imageUrl),
          heroAttributes: const PhotoViewHeroAttributes(tag: "imageHero"),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _photoViewController.dispose();
    super.dispose();
  }
}
