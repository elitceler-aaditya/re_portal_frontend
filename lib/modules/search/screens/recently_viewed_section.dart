import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:re_portal_frontend/modules/home/screens/property_details.dart';
import 'package:re_portal_frontend/modules/shared/widgets/colors.dart';
import 'package:re_portal_frontend/riverpod/recently_viewed.dart';

class RecentlyViewedSection extends ConsumerStatefulWidget {
  final bool hideFirstProperty;
  const RecentlyViewedSection({super.key, this.hideFirstProperty = false});

  @override
  ConsumerState<RecentlyViewedSection> createState() =>
      _RecentlyViewedSectionState();
}

class _RecentlyViewedSectionState extends ConsumerState<RecentlyViewedSection> {
  String formatBudget(int budget) {
    if (budget < 100000) {
      return "₹${(budget / 1000).toStringAsFixed(00)}K";
    } else if (budget < 10000000) {
      return "₹${(budget / 100000).toStringAsFixed(1)}L";
    } else {
      return "₹${(budget / 10000000).toStringAsFixed(2)}Cr";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: CustomColors.white,
        borderRadius: BorderRadius.circular(6),
        boxShadow: [
          BoxShadow(
            color: CustomColors.black.withOpacity(0.2),
            blurRadius: 10,
            spreadRadius: 0,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(8, 0, 16, 8),
            child: Text(
              "Recently Viewed",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(
            height: 180,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: ref.watch(recentlyViewedProvider).length,
              itemBuilder: (context, index) {
                if (widget.hideFirstProperty && index == 0) {
                  return const SizedBox.shrink();
                }
                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => PropertyDetails(
                        apartment: ref.watch(recentlyViewedProvider)[index],
                        heroTag:
                            'recent-${ref.watch(recentlyViewedProvider)[index].projectId}',
                      ),
                    ));
                  },
                  child: Container(
                    height: 150,
                    width: MediaQuery.of(context).size.width * 0.4,
                    margin: const EdgeInsets.only(left: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: CustomColors.black25,
                    ),
                    clipBehavior: Clip.hardEdge,
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: Hero(
                            tag:
                                'recent-${ref.watch(recentlyViewedProvider)[index].projectId}',
                            child: Image.network(
                              ref
                                  .watch(recentlyViewedProvider)[index]
                                  .coverImage,
                              fit: BoxFit.fitHeight,
                            ),
                          ),
                        ),
                        Positioned.fill(
                          child: Container(
                            color: CustomColors.black.withOpacity(0.55),
                          ),
                        ),
                        Positioned(
                          bottom: 6,
                          left: 6,
                          right: 6,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                ref.watch(recentlyViewedProvider)[index].name,
                                style: const TextStyle(
                                  color: CustomColors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "${formatBudget(ref.watch(recentlyViewedProvider)[index].budget)} • ${ref.watch(recentlyViewedProvider)[index].configuration.first}",
                                style: const TextStyle(
                                  color: CustomColors.white,
                                  fontSize: 12,
                                ),
                              ),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.location_on,
                                    size: 14,
                                    color: CustomColors.primary,
                                  ),
                                  Text(
                                    ref
                                        .watch(recentlyViewedProvider)[index]
                                        .projectLocation,
                                    style: const TextStyle(
                                      color: CustomColors.white,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
