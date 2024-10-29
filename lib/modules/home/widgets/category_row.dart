import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:re_portal_frontend/modules/shared/widgets/colors.dart';
import 'package:re_portal_frontend/riverpod/filters_rvpd.dart';
import 'package:re_portal_frontend/riverpod/search_bar.dart';

class CategoryRow extends ConsumerStatefulWidget {
  final Function()? onTap;
  final double cardHeight;
  const CategoryRow({super.key, this.onTap, this.cardHeight = 80});

  @override
  ConsumerState<CategoryRow> createState() => _CategoryRowState();
}

class _CategoryRowState extends ConsumerState<CategoryRow> {
  List<Map<String, dynamic>> categoryOptions = [
    {
      'title': 'Affordable Homes',
      'filter': FiltersModel(affordableHomes: 'true'),
    },
    {
      'title': 'Large Living Spaces',
      'filter': FiltersModel(largeLivingSpaces: 'true'),
    },
    {
      'title': 'Sustainable Living Homes',
      'filter': FiltersModel(sustainableLivingHomes: 'true'),
    },
    {
      'title': '2.5 BHK Homes',
      'filter': FiltersModel(twopointfiveBHKHomes: 'true'),
    },
    {
      'title': 'Large Balconies',
      'filter': FiltersModel(largeBalconies: 'true'),
    },
    {
      'title': 'Sky Villa Habitat',
      'filter': FiltersModel(skyVillaHabitat: 'true'),
    },
    {
      'title': 'Standalone Buildings',
      'filter': FiltersModel(standAloneBuildings: 'true'),
    },
    {
      'title': 'Skyscrapers',
      'filter': FiltersModel(skyScrapers: 'true'),
    },
    {
      'title': 'IGBC Certified Homes',
      'filter': FiltersModel(igbcCertifiedHomes: 'true'),
    },
    {
      'title': 'Semi-Gated Apartments',
      'filter': FiltersModel(semiGatedApartments: 'true'),
    },
    {
      'title': 'More Offers',
      'filter': FiltersModel(moreOffers: 'true'),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: CustomColors.white,
        borderRadius: BorderRadius.circular(6),
      ),
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 8, bottom: 8),
            child: Text(
              "Categories",
              style: TextStyle(
                fontSize: 16,
                fontFamily: "PlusJakartaSans",
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(
                categoryOptions.length,
                (index) => GestureDetector(
                  onTap: () {
                    ref.read(searchBarProvider.notifier).setSearchTerm(
                          categoryOptions[index]['title'],
                        );
                    ref.read(filtersProvider.notifier).setAllFilters(
                          categoryOptions[index]['filter'],
                        );

                    widget.onTap?.call();
                  },
                  child: Container(
                    height: widget.cardHeight,
                    width: 150,
                    margin: const EdgeInsets.only(left: 6),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      image: DecorationImage(
                        image: AssetImage(
                          "assets/images/category-${index + 1}.jpg",
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Stack(
                      children: [
                        Container(
                          height: double.infinity,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            gradient: LinearGradient(
                              colors: [
                                CustomColors.black.withOpacity(0),
                                CustomColors.black.withOpacity(0.77),
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 6,
                          left: 0,
                          right: 0,
                          child: Text(
                            categoryOptions[index]['title'],
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: CustomColors.white,
                              shadows: [
                                BoxShadow(
                                  color: CustomColors.white.withOpacity(0.5),
                                  blurRadius: 3,
                                  offset: const Offset(0, 0),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
