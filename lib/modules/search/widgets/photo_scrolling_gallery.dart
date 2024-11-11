import 'package:flutter/material.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:re_portal_frontend/modules/shared/models/apartment_details_model.dart';
import 'package:re_portal_frontend/modules/shared/widgets/colors.dart';
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
  int _current = 0;
  late PageController _pageController;
  bool _isZoomedIn = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length:
          widget.unitPlans.length, // Use total length instead of grouped length
      vsync: this,
    );
    _pageController = PageController();
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
    // upSlideTransition(context, PhotoView( imageUrl));
  }

  @override
  Widget build(BuildContext context) {
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
          isScrollable: true,
          tabAlignment: TabAlignment.start,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white60,
          tabs:
              widget.unitPlans.map((plan) => Tab(text: plan.bHKType)).toList(),
        ),
      ),
      body: widget.unitPlans.isEmpty
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

                    final currentPlan = widget.unitPlans[_tabController.index];
                    final imageFiles = currentPlan.unitPlanConfigFiles;

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
                    children: widget.unitPlans.map((plan) {
                      final imageFiles = plan.unitPlanConfigFiles;

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
                                  '${plan.facing} facing  |  ${plan.sizeInSqft} sq.ft',
                                  key: ValueKey<String>(
                                      '${plan.bHKType}_${plan.sizeInSqft}'),
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
