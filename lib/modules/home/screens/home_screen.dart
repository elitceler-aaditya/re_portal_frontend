import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:re_portal_frontend/modules/home/models/builder_data_model.dart';
import 'package:re_portal_frontend/modules/home/screens/best_deals_section.dart';
import 'package:re_portal_frontend/modules/home/widgets/builder_in_focus.dart';
import 'package:re_portal_frontend/modules/home/widgets/category_row.dart';
import 'package:re_portal_frontend/modules/home/widgets/limelight.dart';
import 'package:re_portal_frontend/modules/home/widgets/sponsored_ads.dart';
import 'package:re_portal_frontend/modules/home/widgets/text_switcher.dart';
import 'package:re_portal_frontend/modules/search/screens/global_search.dart';
import 'package:re_portal_frontend/modules/search/screens/search_apartments_results.dart';
import 'package:re_portal_frontend/modules/search/screens/user_location_properties.dart';
import 'package:re_portal_frontend/modules/search/widgets/editors_choice_card.dart';
import 'package:re_portal_frontend/modules/home/widgets/lifestyle_properties.dart';
import 'package:re_portal_frontend/modules/home/widgets/new_properties_section.dart';
import 'package:re_portal_frontend/modules/home/widgets/property_stack_card.dart';
import 'package:re_portal_frontend/modules/home/widgets/ready_to_movein.dart';
import 'package:re_portal_frontend/modules/shared/models/appartment_model.dart';
import 'package:re_portal_frontend/modules/shared/widgets/colors.dart';
import 'package:re_portal_frontend/modules/shared/widgets/transitions.dart';
import 'package:re_portal_frontend/riverpod/filters_rvpd.dart';
import 'package:re_portal_frontend/riverpod/home_data.dart';
import 'package:re_portal_frontend/riverpod/location_homes.dart';
import 'package:re_portal_frontend/riverpod/user_riverpod.dart';
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shimmer/shimmer.dart';
import 'package:visibility_detector/visibility_detector.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  List<BuilderDataModel> builderData = [];
  List<ApartmentModel> allApartments = [];
  List<ApartmentModel> bestDeals = [];
  List<ApartmentModel> selectedProperties = [];
  List<ApartmentModel> editorsChoice = [];
  List<ApartmentModel> builderInFocus = [];
  List<ApartmentModel> newProjects = [];
  List<ApartmentModel> readyToMoveIn = [];
  List<ApartmentModel> lifestyleProjects = [];
  List<ApartmentModel> limelight = [];
  List<ApartmentModel> sponsoredAd = [];
  bool loading = true;
  final ScrollController _masterScrollController = ScrollController();
  bool showScrollUpButton = false;

  void getLocationHomes(double lat, double long) async {
    debugPrint("-----------------getting location homes");
    String baseUrl = dotenv.get('BASE_URL');
    String url = "$baseUrl/user/getPopularLocalities";
    Uri uri = Uri.parse(url).replace(queryParameters: {
      "latitude": lat.toString(),
      "longitude": long.toString(),
    });

    try {
      final response = await http.get(uri);
      if (response.statusCode == 200 || response.statusCode == 201) {
        Map<String, dynamic> responseData = jsonDecode(response.body);

        ref
            .read(locationHomesProvider.notifier)
            .setLocationHomesData(responseData);
      } else {
        getLocationHomes(17.4699, 78.2236);
        throw Exception('Error ${response.statusCode}: ${response.body}');
      }
    } catch (error, stackTrace) {
      getLocationHomes(17.4699, 78.2236);

      debugPrint("error: $error");
      debugPrint("stackTrace: $stackTrace");
    }
  }

  String formatBudget(int budget) {
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
    String url = "$baseUrl/user/getUserHomepageData";
    Uri uri = Uri.parse(url).replace(queryParameters: params);
    http.get(
      uri,
      headers: {
        "Authorization": "Bearer ${ref.watch(userProvider).token}",
      },
    ).then((response) async {
      if (response.statusCode == 200 || response.statusCode == 201) {
        Map responseBody = jsonDecode(response.body)['properties'];

        builderData = (responseBody['builderData'] as List<dynamic>)
            .map((e) => BuilderDataModel.fromJson(e as Map<String, dynamic>))
            .toList();

        bestDeals = (responseBody['bestDeals'] as List<dynamic>)
            .map((e) => ApartmentModel.fromJson(e as Map<String, dynamic>))
            .toList();
        selectedProperties =
            (responseBody['selectedProperties'] as List<dynamic>)
                .map((e) => ApartmentModel.fromJson(e as Map<String, dynamic>))
                .toList();
        editorsChoice =
            (responseBody['editorsChoice']['appointments'] as List<dynamic>)
                .map((e) => ApartmentModel.fromJson(e as Map<String, dynamic>))
                .toList();
        builderInFocus =
            (responseBody['builderInFocus']['appointments'] as List<dynamic>)
                .map((e) => ApartmentModel.fromJson(e as Map<String, dynamic>))
                .toList();
        newProjects = (responseBody['newProjects'] as List<dynamic>)
            .map((e) => ApartmentModel.fromJson(e as Map<String, dynamic>))
            .toList();
        readyToMoveIn = (responseBody['readyToMoveIn'] as List<dynamic>)
            .map((e) => ApartmentModel.fromJson(e as Map<String, dynamic>))
            .toList();
        lifestyleProjects = (responseBody['lifestyleProjects'] as List<dynamic>)
            .map((e) => ApartmentModel.fromJson(e as Map<String, dynamic>))
            .toList();
        limelight = (responseBody['limelight'] as List<dynamic>)
            .map((e) => ApartmentModel.fromJson(e as Map<String, dynamic>))
            .toList();
        sponsoredAd = (responseBody['sponsoredAd'] as List<dynamic>)
            .map((e) => ApartmentModel.fromJson(e as Map<String, dynamic>))
            .toList();

        allApartments = [
          ...bestDeals,
          ...selectedProperties,
          ...editorsChoice,
          ...builderInFocus,
          ...newProjects,
          ...readyToMoveIn,
          ...lifestyleProjects,
        ];
        ref.watch(homePropertiesProvider.notifier).setBuilderData(builderData);
        ref.watch(homePropertiesProvider.notifier).setBestDeals(bestDeals);
        ref
            .watch(homePropertiesProvider.notifier)
            .setSelectedProperties(selectedProperties);
        ref
            .watch(homePropertiesProvider.notifier)
            .setEditorsChoice(editorsChoice);
        ref
            .watch(homePropertiesProvider.notifier)
            .setBuilderInFocus(builderInFocus);
        ref.watch(homePropertiesProvider.notifier).setNewProjects(newProjects);
        ref
            .watch(homePropertiesProvider.notifier)
            .setReadyToMoveIn(readyToMoveIn);
        ref
            .watch(homePropertiesProvider.notifier)
            .setLifestyleProjects(lifestyleProjects);
        ref
            .watch(homePropertiesProvider.notifier)
            .setAllApartments(allApartments);
        ref.watch(homePropertiesProvider.notifier).setSponsoredAd(sponsoredAd);
        ref.watch(homePropertiesProvider.notifier).setLimelight(limelight);

        setState(() {
          loading = false;
        });
      }
    }).onError((error, stackTrace) {
      setState(() {
        loading = false;
      });
    });
  }

  apartmentBody() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: CustomColors.white,
            borderRadius: BorderRadius.circular(6),
          ),
          margin: const EdgeInsets.only(top: 4),
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 8, bottom: 8),
                child: Text(
                  "Select Properties",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              PropertyStackCard(
                  cardHeight: 300,
                  cardWidth: MediaQuery.of(context).size.width * 0.9,
                  apartments:
                      ref.watch(homePropertiesProvider).selectedProperties),
            ],
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: CustomColors.white,
            borderRadius: BorderRadius.circular(6),
          ),
          margin: const EdgeInsets.only(top: 4),
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              VisibilityDetector(
                key: const Key('editors-choice-detector'),
                onVisibilityChanged: (visibilityInfo) {
                  if (visibilityInfo.visibleFraction >= 0) {
                    setState(() {
                      showScrollUpButton = true;
                    });
                  }
                },
                child: const Padding(
                  padding: EdgeInsets.fromLTRB(8, 0, 0, 8),
                  child: Text(
                    "Editor's Choice",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              EditorsChoiceCard(
                apartments: ref.watch(homePropertiesProvider).editorsChoice,
              ),
            ],
          ),
        ),
        const NewLaunchSection(title: "New launches"),
        if (mounted)
          BuilderInFocus(
              builderData: ref.watch(homePropertiesProvider).builderData),
        if (mounted) const LifestyleProperties(),
        const ReadyToMovein(),
        Container(
          decoration: BoxDecoration(
            color: CustomColors.white,
            borderRadius: BorderRadius.circular(6),
          ),
          margin: const EdgeInsets.only(top: 4),
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: const Limelight(),
        ),
        Container(
          decoration: BoxDecoration(
            color: CustomColors.white,
            borderRadius: BorderRadius.circular(6),
          ),
          margin: const EdgeInsets.only(top: 4),
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: const SponsoredAds(),
        ),
        const SizedBox(height: 5),
      ],
    );
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(filtersProvider.notifier).clearBuilderName();
      if (ref.watch(homePropertiesProvider).allApartments.isEmpty) {
        getApartments();
      }
      if (ref.watch(locationHomesProvider) == null) {
        getLocationHomes(17.463, 78.286);
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _masterScrollController.dispose();
    showScrollUpButton = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: showScrollUpButton
          ? AnimatedContainer(
              duration: const Duration(milliseconds: 400),
              height: showScrollUpButton ? 50 : 0,
              width: showScrollUpButton ? 50 : 0,
              child: FloatingActionButton(
                backgroundColor: CustomColors.primary.withOpacity(0.7),
                onPressed: () {
                  _masterScrollController
                      .animateTo(0,
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeInOut)
                      .then((v) {
                    setState(() {
                      showScrollUpButton = false;
                    });
                  });
                },
                child: showScrollUpButton
                    ? const Icon(
                        Icons.arrow_upward,
                        weight: 5,
                        size: 30,
                        color: CustomColors.white,
                      )
                    : null,
              ),
            )
          : null,
      backgroundColor: CustomColors.black10,
      body: SingleChildScrollView(
        controller: _masterScrollController,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //appbar
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(top: 36),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Color(0xFFFCCBAE),
                    Color(0xFFF87988),
                  ],
                ),
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(
                      Icons.arrow_back,
                      color: CustomColors.black,
                    ),
                  ),
                  VisibilityDetector(
                    key: const Key('property-type-detector'),
                    onVisibilityChanged: (visibilityInfo) {
                      if (visibilityInfo.visibleFraction >= 0) {
                        setState(() {
                          showScrollUpButton = false;
                        });
                      }
                    },
                    child: Text(
                      ref.watch(homePropertiesProvider).propertyType,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: CustomColors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            //top search bar
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Color(0xFFFCCBAE),
                    Color(0xFFF87988),
                  ],
                ),
              ),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      if (ref
                          .watch(homePropertiesProvider)
                          .allApartments
                          .isNotEmpty) {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const GlobalSearch(),
                          ),
                        );
                      } else {
                        debugPrint("loading");
                      }
                    },
                    child: Container(
                      height: 50,
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                        color: CustomColors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.search),
                          const SizedBox(width: 4),
                          const Text(
                            "Search for ",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black54,
                            ),
                          ),
                          const SelfContainedAnimatedTextSwitcher(),
                          const Spacer(),
                          GestureDetector(
                            onTap: () {
                              upSlideTransition(
                                context,
                                const UserLocationProperties(),
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
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const SearchApartmentResults(
                                    openFilters: true,
                                  ),
                                ),
                              );
                            },
                            icon: SvgPicture.asset("assets/icons/filter.svg"),
                            label: const Text(
                              "Filters",
                              style: TextStyle(
                                color: CustomColors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                ],
              ),
            ),
            //category options
            CategoryRow(
              onTap: () =>
                  rightSlideTransition(context, const SearchApartmentResults()),
            ),
            const SizedBox(height: 4),

            //Best deals
            if (ref.watch(homePropertiesProvider).bestDeals.isNotEmpty)
              BestDealsSection(
                height: MediaQuery.of(context).size.width + 50,
              ),

            (loading && ref.watch(homePropertiesProvider).allApartments.isEmpty)
                ? ListView.builder(
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
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
                : ref.watch(homePropertiesProvider).allApartments.isEmpty
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
