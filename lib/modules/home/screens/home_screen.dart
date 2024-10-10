import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:re_portal_frontend/modules/home/models/builder_data_model.dart';
import 'package:re_portal_frontend/modules/home/screens/best_deals_section.dart';
import 'package:re_portal_frontend/modules/search/screens/global_search.dart';
import 'package:re_portal_frontend/modules/search/screens/search_apartments_results.dart';
import 'package:re_portal_frontend/modules/home/widgets/builder_in_focus.dart';
import 'package:re_portal_frontend/modules/home/widgets/custom_chip.dart';
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
  List<BuilderDataModel> builderData = [];
  List<ApartmentModel> allApartments = [];
  List<ApartmentModel> bestDeals = [];
  List<ApartmentModel> selectedProperties = [];
  List<ApartmentModel> editorsChoice = [];
  List<ApartmentModel> builderInFocus = [];
  List<ApartmentModel> newProjects = [];
  List<ApartmentModel> readyToMoveIn = [];
  List<ApartmentModel> lifestyleProjects = [];
  bool loading = true;

  List<Map<String, dynamic>> categoryOptions = [
    {
      'title': 'Budget properties',
      'filter': {'maxBudget': '10000000'},
    },
    {
      'title': 'Standalone properties',
      'filter': {'projectType': 'Standalone'},
    },
    {
      'title': 'Family apartments',
      'filter': {'BHKType': '3BHK'},
    },
    {
      'title': 'Apartments in Boduppal',
      'filter': {'projectLocation': 'Boduppal'},
    },
  ];

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

        setState(() {
          loading = false;
        });
      }
    }).onError((error, stackTrace) {
      debugPrint("error: $error");
      debugPrint("stackTrace: $stackTrace");
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
        const SizedBox(height: 10),
        const Padding(
          padding: EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            "Select Properties",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        PropertyStackCard(
            cardWidth: MediaQuery.of(context).size.width * 0.9,
            apartments: ref.watch(homePropertiesProvider).selectedProperties),
        const Padding(
          padding: EdgeInsets.only(left: 4, top: 10),
          child: Text(
            "Editor's Choice",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        if (mounted)
          EditorsChoiceCard(
              apartments: ref.watch(homePropertiesProvider).editorsChoice),
        const NewLaunchSection(
          title: "New launch",
        ),
        if (mounted)
          BuilderInFocus(
              builderData: ref.watch(homePropertiesProvider).builderData),
        if (mounted) const LifestyleProperties(),
        const ReadyToMovein(),
        const SizedBox(height: 20),
      ],
    );
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (ref.watch(homePropertiesProvider).allApartments.isEmpty) {
        getApartments();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              padding: const EdgeInsets.all(2),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    CustomColors.primary,
                    Color(0xFFCE4F32),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Column(
                children: [
                  //search bar
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
                              upSlideTransition(
                                  context, const UserLocationProperties());
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
                                          openFilters: true),
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

                  Container(
                    padding: const EdgeInsets.only(top: 2),
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
                    child: ref.watch(filtersProvider).selectedLocalities.isEmpty
                        ? const SizedBox(
                            width: double.infinity,
                          )
                        : SizedBox(
                            width: double.infinity,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text(
                                  "Selected localities",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        height: 32,
                                        child: TextButton(
                                          style: TextButton.styleFrom(
                                            backgroundColor:
                                                CustomColors.secondary,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                            ),
                                          ),
                                          onPressed: () {
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    const SearchApartmentResults(
                                                        openFilters: true),
                                              ),
                                            );
                                          },
                                          child: const Text(
                                            "+ Add more",
                                            style: TextStyle(
                                              fontSize: 10,
                                              color: CustomColors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                      ...ref
                                          .watch(filtersProvider)
                                          .selectedLocalities
                                          .map((locality) {
                                        return CustomListChip(
                                          text: locality,
                                          isSelected: true,
                                          onTap: () {
                                            List<String> localities = ref
                                                .watch(filtersProvider)
                                                .selectedLocalities;
                                            localities.remove(locality);
                                            setState(() {
                                              ref
                                                  .read(
                                                      filtersProvider.notifier)
                                                  .updateSelectedLocalities(
                                                      localities);
                                              // getFilteredApartments();
                                            });
                                          },
                                        );
                                      }),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                  ),
                ],
              ),
            ),

            //category options
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(
                  categoryOptions.length,
                  (index) => GestureDetector(
                    onTap: () {
                      ref.read(filtersProvider.notifier).setAllFilters(
                          FiltersModel()
                              .fromJson(categoryOptions[index]['filter']));

                      rightSlideTransition(
                          context, const SearchApartmentResults());
                    },
                    child: Container(
                      height: 80,
                      width: 150,
                      margin: const EdgeInsets.fromLTRB(0, 8, 10, 0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        gradient: const LinearGradient(
                          colors: [
                            CustomColors.secondary50,
                            CustomColors.secondary,
                          ],
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        categoryOptions[index]['title'],
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: CustomColors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            //Best deals
            if (ref.watch(homePropertiesProvider).bestDeals.isNotEmpty)
              BestDealsSection(
                height: MediaQuery.of(context).size.width,
              ),
            const SizedBox(height: 10),

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
