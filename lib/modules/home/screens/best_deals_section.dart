import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:re_portal_frontend/modules/home/screens/property_details.dart';
import 'package:re_portal_frontend/modules/shared/widgets/colors.dart';
import 'package:re_portal_frontend/riverpod/home_data.dart';

class BestDealsSection extends ConsumerStatefulWidget {
  final double height;
  final bool showTitle;
  const BestDealsSection(
      {super.key, required this.height, this.showTitle = true});

  @override
  ConsumerState<BestDealsSection> createState() => _BestDealsSectionState();
}

class _BestDealsSectionState extends ConsumerState<BestDealsSection> {
  String formatBudget(int budget) {
    if (budget < 100000) {
      return "${(budget / 1000).toStringAsFixed(00)}K";
    } else if (budget < 10000000) {
      return "${(budget / 100000).toStringAsFixed(1)}L";
    } else {
      return "${(budget / 10000000).toStringAsFixed(2)}Cr";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: CustomColors.white,
        borderRadius: BorderRadius.circular(6),
      ),
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.showTitle) const SizedBox(height: 10),
          if (widget.showTitle)
            const Padding(
              padding: EdgeInsets.only(left: 8, bottom: 8),
              child: Text(
                "Best Deals",
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: "PlusJakartaSans",
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          FlutterCarousel.builder(
            itemCount:
                min(5, ref.watch(homePropertiesProvider).bestDeals.length),
            itemBuilder: (context, index, realIndex) => GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => PropertyDetails(
                      apartment:
                          ref.watch(homePropertiesProvider).bestDeals[index],
                      heroTag:
                          "best-${ref.watch(homePropertiesProvider).bestDeals[index].projectId}",
                      nextApartment: ref
                          .watch(homePropertiesProvider)
                          .bestDeals[(index +
                              1) %
                          ref.watch(homePropertiesProvider).bestDeals.length],
                    ),
                  ),
                );
              },
              child: Stack(
                children: [
                  Hero(
                    tag:
                        "best-${ref.watch(homePropertiesProvider).bestDeals[index].projectId}",
                    child: Container(
                      height: widget.height,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: CustomColors.black25,
                        image: ref
                                .watch(homePropertiesProvider)
                                .bestDeals[index]
                                .coverImage
                                .isNotEmpty
                            ? DecorationImage(
                                image: NetworkImage(ref
                                    .watch(homePropertiesProvider)
                                    .bestDeals[index]
                                    .coverImage),
                                fit: BoxFit.cover,
                              )
                            : null,
                      ),
                    ),
                  ),
                  Container(
                    height: widget.height,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          CustomColors.black.withOpacity(0),
                          CustomColors.black.withOpacity(0.8),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            ref
                                .watch(homePropertiesProvider)
                                .bestDeals[index]
                                .name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: CustomColors.white,
                              fontSize: 20,
                              height: 1,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "By ${ref.watch(homePropertiesProvider).bestDeals[index].companyName}",
                            style: const TextStyle(
                              color: CustomColors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(
                                Icons.location_on,
                                size: 16,
                                color: CustomColors.primary,
                              ),
                              const SizedBox(width: 2),
                              Text(
                                "${ref.watch(homePropertiesProvider).bestDeals[index].projectLocation} • ${ref.watch(homePropertiesProvider).bestDeals[index].configuration.take(2).join(", ")}${ref.watch(homePropertiesProvider).bestDeals[index].configuration.length > 2 ? ' +${ref.watch(homePropertiesProvider).bestDeals[index].configuration.length - 2} more' : ''}",
                                style: const TextStyle(
                                  color: CustomColors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          // Text(
                          //   "Price starts from ₹${formatBudget(ref.watch(homePropertiesProvider).bestDeals[index].budget)}",
                          //   style: const TextStyle(
                          //     color: CustomColors.white,
                          //     fontSize: 12,
                          //     fontWeight: FontWeight.w400,
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            options: CarouselOptions(
              height: widget.height,
              viewportFraction: 1,
              enlargeCenterPage: true,
              autoPlay: true,
              autoPlayInterval: const Duration(seconds: 5),
              autoPlayAnimationDuration: const Duration(milliseconds: 1000),
              autoPlayCurve: Curves.fastOutSlowIn,
              enableInfiniteScroll: true,
              initialPage: 0,
              reverse: false,
              scrollDirection: Axis.horizontal,
              showIndicator: true,
              floatingIndicator: false,
              slideIndicator: const CircularSlideIndicator(
                slideIndicatorOptions: SlideIndicatorOptions(
                  indicatorRadius: 4,
                  currentIndicatorColor: CustomColors.black,
                  indicatorBackgroundColor: CustomColors.black50,
                  itemSpacing: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
