import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:re_portal_frontend/modules/home/screens/appartment_filter.dart';
import 'package:re_portal_frontend/modules/home/screens/property_details.dart';
import 'package:re_portal_frontend/modules/home/screens/search_apartments.dart';
import 'package:re_portal_frontend/modules/home/widgets/builder_in_focus.dart';
import 'package:re_portal_frontend/modules/home/widgets/editors_choice_card.dart';
import 'package:re_portal_frontend/modules/home/widgets/lifestyle_properties.dart';
import 'package:re_portal_frontend/modules/home/widgets/new_properties_section.dart';
import 'package:re_portal_frontend/modules/home/widgets/property_stack_card.dart';
import 'package:re_portal_frontend/modules/home/widgets/ready_to_movein.dart';
import 'package:re_portal_frontend/modules/maps/google_maps_screen.dart';
import 'package:re_portal_frontend/modules/shared/models/appartment_model.dart';
import 'package:re_portal_frontend/modules/shared/widgets/colors.dart';
import 'package:re_portal_frontend/riverpod/home_data.dart';
import 'package:re_portal_frontend/riverpod/user_riverpod.dart';
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shimmer/shimmer.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  List<ApartmentModel> allApartments = [];
  bool loading = true;

  String formatBudget(double budget) {
    //return budget in k format or lakh and cr format
    if (budget < 100000) {
      return "${(budget / 1000).toStringAsFixed(00)}K";
    } else if (budget < 10000000) {
      return "${(budget / 100000).toStringAsFixed(1)}L";
    } else {
      return "${(budget / 10000000).toStringAsFixed(2)}Cr";
    }
  }

  Future<void> getApartments({
    Map<String, dynamic> params = const {},
  }) async {
    String baseUrl = dotenv.get('BASE_URL');
    String url = "$baseUrl/project/filterApartments";
    Uri uri = Uri.parse(url).replace(queryParameters: params);
    debugPrint("------------token${ref.watch(userProvider).token}");
    http.get(
      uri,
      headers: {
        "Authorization": "Bearer ${ref.watch(userProvider).token}",
      },
    ).then((response) async {
      if (response.statusCode == 200 || response.statusCode == 201) {
        List responseBody = jsonDecode(response.body)['apartments'];

        ref.watch(homePropertiesProvider.notifier).setApartments(
              responseBody.map((e) => ApartmentModel.fromJson(e)).toList(),
            );
        allApartments =
            responseBody.map((e) => ApartmentModel.fromJson(e)).toList();

        setState(() {
          loading = false;
        });
      }
    }).onError((error, stackTrace) {
      debugPrint("error: $error");
      setState(() {
        loading = false;
      });
    });
  }

  filterBottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
      isScrollControlled: true,
      backgroundColor: CustomColors.primary10,
      scrollControlDisabledMaxHeightRatio: 1,
      builder: (context) {
        return AppartmentFilter(apartmentList: allApartments);
      },
    );
  }

  apartmentBody() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        const Padding(
          padding: EdgeInsets.only(left: 10, bottom: 8),
          child: Text(
            "Select Properties",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        PropertyStackCard(
          apartments:
              ref.watch(homePropertiesProvider).apartments.sublist(0, 2),
        ),
        const Padding(
          padding: EdgeInsets.all(10),
          child: Text(
            "Editor’s Choice",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        EditorsChoiceCard(
          apartments:
              ref.watch(homePropertiesProvider).apartments.sublist(2, 5),
        ),
        BuilderInFocus(
          apartments:
              ref.watch(homePropertiesProvider).apartments.sublist(5, 8),
        ),
        NewPropertiesSection(
          apartments:
              ref.watch(homePropertiesProvider).apartments.sublist(8, 10),
        ),
        LifestyleProperties(
          lifestyleProperties:
              ref.watch(homePropertiesProvider).apartments.sublist(10, 12),
        ),
        ReadyToMovein(
          apartments:
              ref.watch(homePropertiesProvider).apartments.sublist(12, 14),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getApartments();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.primary10,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //appbar
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(top: 40, bottom: 4),
              decoration: const BoxDecoration(
                color: CustomColors.primary,
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(
                      Icons.arrow_back,
                      color: CustomColors.white,
                    ),
                  ),
                  Text(
                    ref.watch(homePropertiesProvider).propertyType,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: CustomColors.white,
                    ),
                  ),
                ],
              ),
            ),
            //top search bar
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    CustomColors.primary,
                    Color(0xFFCE4F32),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(20),
                ),
              ),
              child: Column(
                children: [
                  //search bar
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) =>
                              SearchApartment(apartments: allApartments),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                        color: CustomColors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.search),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              "Search for ${ref.watch(homePropertiesProvider).propertyType.toLowerCase()}",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 14,
                                color: CustomColors.black50,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => GoogleMapsScreen(
                                    apartment: ref
                                        .watch(homePropertiesProvider)
                                        .apartments[0],
                                  ),
                                ),
                              );
                            },
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4),
                              child: SvgPicture.string(
                                """<svg width="100%" height="100%" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg"> <path d="M20 12C20 16.4183 16.4183 20 12 20M20 12C20 7.58172 16.4183 4 12 4M20 12H22M12 20C7.58172 20 4 16.4183 4 12M12 20V22M4 12C4 7.58172 7.58172 4 12 4M4 12H2M12 4V2M15 12C15 13.6569 13.6569 15 12 15C10.3431 15 9 13.6569 9 12C9 10.3431 10.3431 9 12 9C13.6569 9 15 10.3431 15 12Z" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/> </svg>""",
                              ),
                            ),
                          ),
                          TextButton.icon(
                            style: TextButton.styleFrom(
                              backgroundColor: CustomColors.secondary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onPressed: () {
                              filterBottomSheet();
                            },
                            icon: SvgPicture.asset("assets/icons/filter.svg"),
                            label: const Text(
                              "Filters",
                              style: TextStyle(
                                color: CustomColors.white,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),

            //Best deals
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 10, bottom: 8),
                  child: Text(
                    "Best Deals",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                if (ref.watch(homePropertiesProvider).apartments.isNotEmpty)
                  Column(
                    children: [
                      FlutterCarousel.builder(
                        itemCount: min(
                            5,
                            ref
                                .watch(homePropertiesProvider)
                                .apartments
                                .length),
                        itemBuilder: (context, index, realIndex) =>
                            GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => PropertyDetails(
                                  apartment: ref
                                      .watch(homePropertiesProvider)
                                      .apartments[index],
                                  bestDeals: true,
                                  nextApartment: ref
                                          .watch(homePropertiesProvider)
                                          .apartments[
                                      (index + 1) %
                                          ref
                                              .watch(homePropertiesProvider)
                                              .apartments
                                              .length],
                                ),
                              ),
                            );
                          },
                          child: Stack(
                            children: [
                              Hero(
                                tag:
                                    "best-${ref.watch(homePropertiesProvider).apartments[index].apartmentID}",
                                child: Container(
                                  height: MediaQuery.of(context).size.width,
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                    color: CustomColors.black25,
                                    borderRadius: BorderRadius.circular(10),
                                    image: ref
                                            .watch(homePropertiesProvider)
                                            .apartments[index]
                                            .image
                                            .isNotEmpty
                                        ? DecorationImage(
                                            image: NetworkImage(ref
                                                .watch(homePropertiesProvider)
                                                .apartments[index]
                                                .image),
                                            fit: BoxFit.cover,
                                          )
                                        : null,
                                  ),
                                ),
                              ),
                              Container(
                                height: MediaQuery.of(context).size.width,
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
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
                                  padding: const EdgeInsets.all(8),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        ref
                                            .watch(homePropertiesProvider)
                                            .apartments[index]
                                            .apartmentName,
                                        style: const TextStyle(
                                          color: CustomColors.white,
                                          fontSize: 20,
                                          height: 1,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        "@ ${ref.watch(homePropertiesProvider).apartments[index].locality}",
                                        style: const TextStyle(
                                          color: CustomColors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        "₹${formatBudget(ref.watch(homePropertiesProvider).apartments[index].budget.toDouble())} onwards",
                                        style: const TextStyle(
                                          color: CustomColors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        options: CarouselOptions(
                          height: MediaQuery.of(context).size.width,
                          viewportFraction: 0.95,
                          enlargeCenterPage: true,
                          autoPlay: true,
                          autoPlayInterval: const Duration(seconds: 5),
                          autoPlayAnimationDuration:
                              const Duration(milliseconds: 1000),
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
              ],
            ),
            const SizedBox(height: 10),

            loading
                ? ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: 6,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Shimmer.fromColors(
                          baseColor: CustomColors.black10,
                          highlightColor: CustomColors.black25,
                          child: Container(
                            height: 150,
                            decoration: BoxDecoration(
                              color: CustomColors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      );
                    },
                  )
                : ref.watch(homePropertiesProvider).apartments.isEmpty
                    ? const SizedBox(
                        height: 500,
                        width: double.infinity,
                        child: Center(
                          child: Text(
                            "No apartments found",
                            textAlign: TextAlign.center,
                          ),
                        ),
                      )
                    : apartmentBody(),
          ],
        ),
      ),
    );
  }
}
