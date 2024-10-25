import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:re_portal_frontend/modules/home/screens/best_deals_section.dart';
import 'package:re_portal_frontend/modules/home/screens/compare/compare_properties.dart';
import 'package:re_portal_frontend/modules/home/screens/project_snippets.dart';
import 'package:re_portal_frontend/modules/home/widgets/text_switcher.dart';
import 'package:re_portal_frontend/modules/onboarding/screens/login_screen.dart';
import 'package:re_portal_frontend/modules/search/screens/global_search.dart';
import 'package:re_portal_frontend/modules/search/screens/recently_viewed_section.dart';
import 'package:re_portal_frontend/modules/search/screens/user_location_properties.dart';
import 'package:re_portal_frontend/modules/search/widgets/budget_homes.dart';
import 'package:re_portal_frontend/modules/home/widgets/custom_chip.dart';
import 'package:re_portal_frontend/modules/search/widgets/editors_choice_card.dart';
import 'package:re_portal_frontend/modules/search/widgets/location_homes_screen.dart';
import 'package:re_portal_frontend/modules/home/widgets/new_properties_section.dart';
import 'package:re_portal_frontend/modules/home/widgets/property_card.dart';
import 'package:re_portal_frontend/modules/home/widgets/property_grid_view.dart';
import 'package:re_portal_frontend/modules/home/widgets/ready_to_movein.dart';
import 'package:re_portal_frontend/modules/search/widgets/ultra_luxury_homes.dart';
import 'package:re_portal_frontend/modules/search/screens/appartment_filter.dart';
import 'package:re_portal_frontend/modules/shared/models/appartment_model.dart';
import 'package:re_portal_frontend/modules/shared/widgets/colors.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:re_portal_frontend/modules/shared/widgets/snackbars.dart';
import 'package:re_portal_frontend/modules/shared/widgets/transitions.dart';
import 'package:re_portal_frontend/riverpod/compare_appartments.dart';
import 'package:re_portal_frontend/riverpod/filters_rvpd.dart';
import 'package:re_portal_frontend/riverpod/home_data.dart';
import 'package:re_portal_frontend/riverpod/locality_list.dart';
import 'package:re_portal_frontend/riverpod/recently_viewed.dart';
import 'package:re_portal_frontend/riverpod/search_bar.dart';
import 'package:re_portal_frontend/riverpod/user_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:visibility_detector/visibility_detector.dart';

class SearchApartmentResults extends ConsumerStatefulWidget {
  final bool openFilters;
  const SearchApartmentResults({super.key, this.openFilters = false});

  @override
  ConsumerState<SearchApartmentResults> createState() =>
      _SearchApartmentState();
}

class _SearchApartmentState extends ConsumerState<SearchApartmentResults> {
  List<ApartmentModel> allApartments = [];
  List<ApartmentModel> snippets = [];
  List<String> videoLinks = [];
  final List<GlobalKey> _globalKeys = List.generate(50, (index) => GlobalKey());
  bool loading = false;
  OverlayEntry? _overlayEntry;
  bool _isOverlayVisible = false;
  bool isListview = true;
  bool displayAds = true;
  bool showScrollUpButton = false;
  int currentPage = 1;
  final ScrollController _masterScrollController = ScrollController();
  Timer? _timer;
  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  List<String> searchOptions = [
    "project",
    "loction",
    "builder name",
  ];
  int searchOptionsIndex = 0;
  bool isEndReached = false;
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
  ];

  void _toggleOverlay(
      BuildContext context, ApartmentModel apartment, GlobalKey globalKey) {
    if (_isOverlayVisible) {
      _removeOverlay();
    } else {
      _showOverlay(context, apartment, globalKey);
    }
  }

  String formatBudget(int budget) {
    if (budget < 100000) {
      return "₹${(budget / 1000).toStringAsFixed(00)}K";
    } else if (budget < 10000000) {
      return "₹${(budget / 100000).toStringAsFixed(1)}L";
    } else {
      return "₹${(budget / 10000000).toStringAsFixed(2)}Cr";
    }
  }

  Widget _buildOption(
      Widget icon, String text, VoidCallback onTap, Color? color) {
    return InkWell(
      onTap: () {
        _removeOverlay();
        onTap();
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(100),
        ),
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: Row(
          children: [
            icon,
            const SizedBox(width: 12),
            Text(text, style: TextStyle(color: color)),
          ],
        ),
      ),
    );
  }

  void _showOverlay(
      BuildContext context, ApartmentModel apartment, GlobalKey globalKey) {
    GlobalKey contactButtonKey = globalKey;
    final RenderBox renderBox =
        contactButtonKey.currentContext!.findRenderObject() as RenderBox;
    final Offset position = renderBox.localToGlobal(Offset.zero);

    _overlayEntry = OverlayEntry(
      builder: (context) => Stack(
        children: [
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.5),
            ),
          ),
          Positioned.fill(
            child: GestureDetector(
              onTap: _removeOverlay,
              child: Container(
                color: Colors.transparent,
              ),
            ),
          ),
          Positioned(
            left: position.dx - 150,
            top: position.dy - 130,
            child: Material(
              color: Colors.transparent,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    _buildOption(
                      SvgPicture.asset("assets/icons/phone.svg",
                          color: CustomColors.blue),
                      'Call now',
                      () {
                        launchUrl(Uri.parse("tel:${apartment.companyPhone}"))
                            .then(
                          (value) => _removeOverlay(),
                        );
                      },
                      CustomColors.blue,
                    ),
                    _buildOption(
                      SizedBox(
                        height: 20,
                        width: 20,
                        child: SvgPicture.asset(
                          "assets/icons/whatsapp.svg",
                          color: CustomColors.green,
                        ),
                      ),
                      'Chat on Whatsapp',
                      () {
                        launchUrl(Uri.parse(
                                'https://wa.me/+91${apartment.companyPhone}?text=${Uri.encodeComponent("Hello, I'm interested in your property")}'))
                            .then(
                          (value) => _removeOverlay(),
                        );
                      },
                      CustomColors.green,
                    ),
                    _buildOption(
                      SizedBox(
                          height: 20,
                          width: 20,
                          child: SvgPicture.asset(
                            "assets/icons/phone_incoming.svg",
                            color: CustomColors.primary,
                          )),
                      'Request call back',
                      () => _removeOverlay(),
                      CustomColors.primary,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
    setState(() {
      _isOverlayVisible = true;
    });
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    if (mounted) {
      setState(() {
        _isOverlayVisible = false;
      });
    }
  }

  filterBottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
      isScrollControlled: true,
      backgroundColor: CustomColors.white,
      scrollControlDisabledMaxHeightRatio: 1,
      builder: (context) {
        return const AppartmentFilter();
      },
    ).then((value) {
      FocusManager.instance.primaryFocus?.unfocus();
      Future.delayed(const Duration(milliseconds: 500), () {
        _masterScrollController.animateTo(
          400,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      });
      setState(() {
        isEndReached = false;
        currentPage = 1;
      });
    });
  }

  void _showSortBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: CustomColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const ListTile(
                title: Text(
                  'SORT BY',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: CustomColors.black,
                  ),
                ),
              ),
              const Divider(height: 1),
              ListTile(
                title: const Text('Popularity'),
                onTap: () {
                  if (ref
                      .watch(homePropertiesProvider)
                      .filteredApartments
                      .isNotEmpty) {
                    ref
                        .read(homePropertiesProvider.notifier)
                        .sortFilteredApartments(0);
                  }
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Price - low to high'),
                onTap: () {
                  if (ref
                      .watch(homePropertiesProvider)
                      .filteredApartments
                      .isNotEmpty) {
                    ref
                        .read(homePropertiesProvider.notifier)
                        .sortFilteredApartments(1);
                  }
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Price - high to low'),
                onTap: () {
                  if (ref
                      .watch(homePropertiesProvider)
                      .filteredApartments
                      .isNotEmpty) {
                    ref
                        .read(homePropertiesProvider.notifier)
                        .sortFilteredApartments(2);
                  }
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Price per sq.ft - high to low'),
                onTap: () {
                  if (ref
                      .watch(homePropertiesProvider)
                      .filteredApartments
                      .isNotEmpty) {
                    ref
                        .read(homePropertiesProvider.notifier)
                        .sortFilteredApartments(3);
                  }
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Price per sq.ft - low to high'),
                onTap: () {
                  if (ref
                      .watch(homePropertiesProvider)
                      .filteredApartments
                      .isNotEmpty) {
                    ref
                        .read(homePropertiesProvider.notifier)
                        .sortFilteredApartments(4);
                  }
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Posession - earliest to furthest'),
                onTap: () {
                  if (ref
                      .watch(homePropertiesProvider)
                      .filteredApartments
                      .isNotEmpty) {
                    ref
                        .read(homePropertiesProvider.notifier)
                        .sortFilteredApartments(5);
                  }
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Posession - furthest to earliest'),
                onTap: () {
                  if (ref
                      .watch(homePropertiesProvider)
                      .filteredApartments
                      .isNotEmpty) {
                    ref
                        .read(homePropertiesProvider.notifier)
                        .sortFilteredApartments(6);
                  }
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> getMoreProjects({
    Map<String, dynamic> params = const {},
  }) async {
    debugPrint("-----------getting page ${currentPage + 1}-----------");
    String baseUrl = dotenv.get('BASE_URL');
    String url = "$baseUrl/project/filterApartmentsNew";
    Uri uri = Uri.parse(url).replace(queryParameters: params);
    debugPrint("-----------params: $params");

    http.get(
      uri,
      headers: {
        "Authorization": "Bearer ${ref.watch(userProvider).token}",
      },
    ).then((response) async {
      if (response.statusCode == 200 || response.statusCode == 201) {
        Map<String, dynamic> responseData = jsonDecode(response.body);
        currentPage = responseData['currentPage'];
        debugPrint("---------page $currentPage data: $responseData");
        if (responseData['projects'] is List) {
          List<dynamic> responseBody = responseData['projects'];
          List<ApartmentModel> moreApartments = responseBody
              .map((e) => ApartmentModel.fromJson(e as Map<String, dynamic>))
              .toList();
          if (moreApartments.isEmpty) {
            isEndReached = true;
          }
          _globalKeys.addAll(
              List.generate(moreApartments.length, (index) => GlobalKey()));
          ref
              .watch(homePropertiesProvider.notifier)
              .addFilteredApartments(moreApartments);
        } else {
          debugPrint("Error: projects is not a List");
          allApartments = [];
        }
      }
    }).onError((error, stackTrace) {
      debugPrint("error: $error");
      debugPrint("stackTrace: $stackTrace");
      setState(() {
        loading = false;
      });
    });
  }

  Future<void> getFilteredApartments({
    Map<String, dynamic> params = const {},
    bool useDefaultParams = false,
  }) async {
    Map<String, dynamic> defaultParams = ref.watch(filtersProvider).toJson();
    defaultParams['page'] = "1";

    debugPrint(
        "-----------------params: ${useDefaultParams ? defaultParams : params}");
    try {
      String baseUrl = dotenv.get('BASE_URL');
      String url = "$baseUrl/project/filterApartmentsNew";
      Uri uri = Uri.parse(url)
          .replace(queryParameters: useDefaultParams ? defaultParams : params);

      final response = await http.get(
        uri,
        headers: {
          "Authorization": "Bearer ${ref.watch(userProvider).token}",
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        Map<String, dynamic> responseData = jsonDecode(response.body);
        List responseBody = responseData['projects'] ?? [];
        if (mounted) {
          debugPrint("-----------------responseData: $responseData");
          ref
              .read(filtersProvider.notifier)
              .updateTotalCount(responseData['totalCount']);
          ref.read(homePropertiesProvider.notifier).setfilteredApartments(
                responseBody.map((e) => ApartmentModel.fromJson(e)).toList(),
              );
        }
      } else {
        throw Exception('Failed to load filtered apartments');
      }
    } catch (e) {
      debugPrint("Error in getFilteredApartments: $e");
      // Handle error (e.g., show error message to user)
    } finally {
      if (mounted) {
        setState(() {
          loading = false;
        });
      }
    }
  }

  void getLocalitiesList() async {
    String baseUrl = dotenv.get('BASE_URL');
    String url = "$baseUrl/user/getLocations";
    Uri uri = Uri.parse(url);

    try {
      final response = await http.get(uri);
      if (response.statusCode == 200 || response.statusCode == 201) {
        Map<String, dynamic> responseData = jsonDecode(response.body);
        List<dynamic> responseBody = responseData['data'];
        List<String> localities =
            responseBody.map((item) => item.toString()).toList();
        ref.read(localityListProvider.notifier).setLocalities(localities);
      } else {
        throw Exception('Failed to load localities');
      }
    } catch (error, stackTrace) {
      debugPrint("error: $error");
      debugPrint("stackTrace: $stackTrace");
    }
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Map<String, dynamic> params = ref.watch(filtersProvider).toJson();
      params['page'] = "1";
      if (ref.watch(localityListProvider).isEmpty) {
        getLocalitiesList();
      }
      getFilteredApartments(params: params);
      if (widget.openFilters) {
        filterBottomSheet();
      } else {
        _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
          if (mounted) {
            setState(() {
              searchOptionsIndex =
                  (searchOptionsIndex + 1) % searchOptions.length;
            });
          } else {
            timer.cancel();
          }
        });
      }
    });
  }

  @override
  void dispose() {
    if (_isOverlayVisible) {
      _overlayEntry?.remove();
      _overlayEntry = null;
      _timer?.cancel();
      _masterScrollController.removeListener(() {});
    }
    _scaffoldMessengerKey.currentState?.clearSnackBars();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.black10,
      key: _scaffoldMessengerKey,
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 64, width: 64),
          if (ref.watch(comparePropertyProvider).isNotEmpty)
            TextButton.icon(
              style: TextButton.styleFrom(
                backgroundColor: CustomColors.green50,
              ),
              onPressed: () {
                upSlideTransition(
                    context, const CompareProperties(isPop: true));
              },
              icon: SvgPicture.asset(
                "assets/icons/compare_active.svg",
                color: CustomColors.black,
              ),
              label: Text(
                "${ref.watch(comparePropertyProvider).length} properties",
                style: const TextStyle(
                  color: CustomColors.black,
                ),
              ),
            ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 400),
            height: showScrollUpButton ? 50 : 0,
            width: showScrollUpButton ? 50 : 0,
            child: FloatingActionButton(
              onPressed: () {
                _masterScrollController
                    .animateTo(
                  0,
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeIn,
                )
                    .then((value) {
                  setState(() {
                    showScrollUpButton = false;
                  });
                });
              },
              child: showScrollUpButton ? const Icon(Icons.arrow_upward) : null,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        controller: _masterScrollController,
        child: Column(
          children: [
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
                  const Text(
                    "Search",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: CustomColors.white,
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => const GlobalSearch(),
                  ),
                );
              },
              child: Container(
                color: CustomColors.primary,
                child: Container(
                  height: 50,
                  margin: const EdgeInsets.all(6),
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
                          padding: const EdgeInsets.symmetric(horizontal: 4),
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
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    CustomColors.primary,
                    CustomColors.primary50,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: ref.watch(filtersProvider).toJson().isNotEmpty
                  ? Container(
                      padding: const EdgeInsets.fromLTRB(2, 0, 0, 2),
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            "Selected Filters",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: CustomColors.white,
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
                                      backgroundColor: CustomColors.secondary,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                    ),
                                    onPressed: () {
                                      filterBottomSheet();
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
                                    .map(
                                      (loc) => CustomListChip(
                                        text: loc,
                                        onTap: () {
                                          List<String> localities = ref
                                              .read(filtersProvider)
                                              .selectedLocalities;
                                          localities.remove(loc);
                                          ref
                                              .read(filtersProvider.notifier)
                                              .updateSelectedLocalities(
                                                  localities);
                                          getFilteredApartments(
                                              useDefaultParams: true);
                                        },
                                      ),
                                    ),
                                if (ref
                                    .watch(filtersProvider)
                                    .apartmentType
                                    .isNotEmpty)
                                  CustomListChip(
                                    text: ref
                                        .watch(filtersProvider)
                                        .apartmentType,
                                    onTap: () {
                                      ref
                                          .read(filtersProvider.notifier)
                                          .updateFilters(
                                            ref
                                                .read(filtersProvider)
                                                .copyWith(apartmentType: ''),
                                          );
                                      getFilteredApartments(
                                          useDefaultParams: true);
                                    },
                                  ),
                                ...ref.watch(filtersProvider).amenities.map(
                                      (amenity) => CustomListChip(
                                        text: amenity,
                                        onTap: () {
                                          List<String> updatedAmenities =
                                              List.from(ref
                                                  .read(filtersProvider)
                                                  .amenities);
                                          updatedAmenities.remove(amenity);
                                          ref
                                              .read(filtersProvider.notifier)
                                              .updateFilters(
                                                ref
                                                    .read(filtersProvider)
                                                    .copyWith(
                                                        amenities:
                                                            updatedAmenities),
                                              );
                                          getFilteredApartments(
                                              useDefaultParams: true);
                                        },
                                      ),
                                    ),
                                ...ref
                                    .watch(filtersProvider)
                                    .selectedConfigurations
                                    .map(
                                      (config) => CustomListChip(
                                        text: config,
                                        onTap: () {
                                          List<String> updatedConfigs =
                                              List.from(ref
                                                  .read(filtersProvider)
                                                  .selectedConfigurations);
                                          updatedConfigs.remove(config);
                                          ref
                                              .read(filtersProvider.notifier)
                                              .updateFilters(
                                                ref
                                                    .read(filtersProvider)
                                                    .copyWith(
                                                        selectedConfigurations:
                                                            updatedConfigs),
                                              );
                                          getFilteredApartments(
                                              useDefaultParams: true);
                                        },
                                      ),
                                    ),
                                if (ref
                                    .watch(filtersProvider)
                                    .builderName
                                    .isNotEmpty)
                                  CustomListChip(
                                    text:
                                        "Builder: ${ref.watch(filtersProvider).builderName}",
                                    onTap: () {
                                      ref
                                          .read(filtersProvider.notifier)
                                          .updateBuilderName('');
                                      getFilteredApartments(
                                          useDefaultParams: true);
                                    },
                                  ),
                                if (ref.watch(filtersProvider).minBudget != 0)
                                  CustomListChip(
                                    text:
                                        "Budget (min): ${formatBudget(ref.watch(filtersProvider).minBudget.toInt())}",
                                    onTap: () {
                                      ref
                                          .read(filtersProvider.notifier)
                                          .updateMinBudget(0);
                                      getFilteredApartments(
                                          useDefaultParams: true);
                                    },
                                  ),
                                if (ref.watch(filtersProvider).maxBudget != 0)
                                  CustomListChip(
                                    text:
                                        "Budget (max): ${formatBudget(ref.watch(filtersProvider).maxBudget.toInt())}",
                                    onTap: () {
                                      ref
                                          .read(filtersProvider.notifier)
                                          .updateMaxBudget(0);
                                      getFilteredApartments(
                                          useDefaultParams: true);
                                    },
                                  ),
                                if (ref.watch(filtersProvider).minFlatSize != 0)
                                  CustomListChip(
                                    text:
                                        "Flat Size (min): ${(ref.watch(filtersProvider).minFlatSize / 100).round() * 100} sq.ft.",
                                    onTap: () {
                                      ref
                                          .read(filtersProvider.notifier)
                                          .updateMinFlatSize(0);
                                      getFilteredApartments(
                                          useDefaultParams: true);
                                    },
                                  ),
                                if (ref.watch(filtersProvider).maxFlatSize != 0)
                                  CustomListChip(
                                    text:
                                        "Flat Size (max): ${((ref.watch(filtersProvider).maxFlatSize / 100).round() * 100).toInt()} sq.ft.",
                                    onTap: () {
                                      ref
                                          .read(filtersProvider.notifier)
                                          .updateMaxFlatSize(0);
                                      getFilteredApartments(
                                          useDefaultParams: true);
                                    },
                                  ),
                                if (ref.watch(filtersProvider).newProject ==
                                    'true')
                                  CustomListChip(
                                    text: 'New Project',
                                    onTap: () {
                                      ref
                                          .read(filtersProvider.notifier)
                                          .updateFilters(ref
                                              .read(filtersProvider)
                                              .copyWith(newProject: ''));
                                      getFilteredApartments(
                                          useDefaultParams: true);
                                    },
                                  ),
                                if (ref.watch(filtersProvider).readyToMove ==
                                    'true')
                                  CustomListChip(
                                    text: 'Ready to Move',
                                    onTap: () {
                                      ref
                                          .read(filtersProvider.notifier)
                                          .updateFilters(ref
                                              .read(filtersProvider)
                                              .copyWith(readyToMove: ''));
                                      getFilteredApartments(
                                          useDefaultParams: true);
                                    },
                                  ),
                                if (ref
                                        .watch(filtersProvider)
                                        .underConstruction ==
                                    'true')
                                  CustomListChip(
                                    text: 'Under Construction',
                                    onTap: () {
                                      ref
                                          .read(filtersProvider.notifier)
                                          .updateFilters(ref
                                              .read(filtersProvider)
                                              .copyWith(underConstruction: ''));
                                      getFilteredApartments(
                                          useDefaultParams: true);
                                    },
                                  ),
                                if (ref
                                        .watch(filtersProvider)
                                        .postedByBuilder ==
                                    'true')
                                  CustomListChip(
                                    text: 'Posted by Builder',
                                    onTap: () {
                                      ref
                                          .read(filtersProvider.notifier)
                                          .updateFilters(ref
                                              .read(filtersProvider)
                                              .copyWith(postedByBuilder: ''));
                                      getFilteredApartments(
                                          useDefaultParams: true);
                                    },
                                  ),
                                if (ref.watch(filtersProvider).postedByOwner ==
                                    'true')
                                  CustomListChip(
                                    text: 'Posted by Owner',
                                    onTap: () {
                                      ref
                                          .read(filtersProvider.notifier)
                                          .updateFilters(ref
                                              .read(filtersProvider)
                                              .copyWith(postedByOwner: ''));
                                      getFilteredApartments(
                                          useDefaultParams: true);
                                    },
                                  ),
                                if (ref.watch(filtersProvider).postedByAgent ==
                                    'true')
                                  CustomListChip(
                                    text: 'Posted by Agent',
                                    onTap: () {
                                      ref
                                          .read(filtersProvider.notifier)
                                          .updateFilters(ref
                                              .read(filtersProvider)
                                              .copyWith(postedByAgent: ''));
                                      getFilteredApartments(
                                          useDefaultParams: true);
                                    },
                                  ),
                                if (ref.watch(filtersProvider).newSaleType ==
                                    'true')
                                  CustomListChip(
                                    text: 'New Sale',
                                    onTap: () {
                                      ref
                                          .read(filtersProvider.notifier)
                                          .updateFilters(ref
                                              .read(filtersProvider)
                                              .copyWith(newSaleType: ''));
                                      getFilteredApartments(
                                          useDefaultParams: true);
                                    },
                                  ),
                                if (ref.watch(filtersProvider).resaleType ==
                                    'true')
                                  CustomListChip(
                                    text: 'Resale',
                                    onTap: () {
                                      ref
                                          .read(filtersProvider.notifier)
                                          .updateFilters(ref
                                              .read(filtersProvider)
                                              .copyWith(resaleType: ''));
                                      getFilteredApartments(
                                          useDefaultParams: true);
                                    },
                                  ),
                                if (ref
                                        .watch(filtersProvider)
                                        .affordableHomes ==
                                    'true')
                                  CustomListChip(
                                    text: 'Affordable Homes',
                                    onTap: () {
                                      ref
                                          .read(filtersProvider.notifier)
                                          .updateFilters(ref
                                              .read(filtersProvider)
                                              .copyWith(affordableHomes: ''));
                                      getFilteredApartments(
                                          useDefaultParams: true);
                                    },
                                  ),
                                if (ref
                                        .watch(filtersProvider)
                                        .largeLivingSpaces ==
                                    'true')
                                  CustomListChip(
                                    text: 'Large Living Space',
                                    onTap: () {
                                      ref
                                          .read(filtersProvider.notifier)
                                          .updateFilters(ref
                                              .read(filtersProvider)
                                              .copyWith(largeLivingSpaces: ''));
                                      getFilteredApartments(
                                          useDefaultParams: true);
                                    },
                                  ),
                                if (ref
                                        .watch(filtersProvider)
                                        .sustainableLivingHomes ==
                                    'true')
                                  CustomListChip(
                                    text: 'Sustainable',
                                    onTap: () {
                                      ref
                                          .read(filtersProvider.notifier)
                                          .updateFilters(ref
                                              .read(filtersProvider)
                                              .copyWith(
                                                  sustainableLivingHomes: ''));
                                      getFilteredApartments(
                                          useDefaultParams: true);
                                    },
                                  ),
                                if (ref
                                        .watch(filtersProvider)
                                        .twopointfiveBHKHomes ==
                                    'true')
                                  CustomListChip(
                                    text: '2.5 BHK',
                                    onTap: () {
                                      ref
                                          .read(filtersProvider.notifier)
                                          .updateFilters(ref
                                              .read(filtersProvider)
                                              .copyWith(
                                                  twopointfiveBHKHomes: ''));
                                      getFilteredApartments(
                                          useDefaultParams: true);
                                    },
                                  ),
                                if (ref.watch(filtersProvider).largeBalconies ==
                                    'true')
                                  CustomListChip(
                                    text: 'Large Balcony',
                                    onTap: () {
                                      ref
                                          .read(filtersProvider.notifier)
                                          .updateFilters(ref
                                              .read(filtersProvider)
                                              .copyWith(largeBalconies: ''));
                                      getFilteredApartments(
                                          useDefaultParams: true);
                                    },
                                  ),
                                if (ref
                                        .watch(filtersProvider)
                                        .skyVillaHabitat ==
                                    'true')
                                  CustomListChip(
                                    text: 'Sky Villa Habitat',
                                    onTap: () {
                                      ref
                                          .read(filtersProvider.notifier)
                                          .updateFilters(ref
                                              .read(filtersProvider)
                                              .copyWith(skyVillaHabitat: ''));
                                      getFilteredApartments(
                                          useDefaultParams: true);
                                    },
                                  ),
                                if (ref
                                        .watch(filtersProvider)
                                        .standAloneBuildings ==
                                    'true')
                                  CustomListChip(
                                    text: 'Standalone Buildings',
                                    onTap: () {
                                      ref
                                          .read(filtersProvider.notifier)
                                          .updateFilters(ref
                                              .read(filtersProvider)
                                              .copyWith(
                                                  standAloneBuildings: ''));
                                      getFilteredApartments(
                                          useDefaultParams: true);
                                    },
                                  ),
                                if (ref.watch(filtersProvider).skyScrapers ==
                                    'true')
                                  CustomListChip(
                                    text: 'Skyscrapers',
                                    onTap: () {
                                      ref
                                          .read(filtersProvider.notifier)
                                          .updateFilters(ref
                                              .read(filtersProvider)
                                              .copyWith(skyScrapers: ''));
                                      getFilteredApartments(
                                          useDefaultParams: true);
                                    },
                                  ),
                                GestureDetector(
                                  onTap: () {
                                    ref
                                        .read(filtersProvider.notifier)
                                        .clearAllFilters();
                                    getFilteredApartments(
                                        useDefaultParams: true);
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    alignment: Alignment.center,
                                    height: 32,
                                    child: const Text(
                                      "clear",
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: CustomColors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  : const SizedBox(
                      width: double.infinity,
                    ),
            ),
            if (ref.watch(homePropertiesProvider).bestDeals.isNotEmpty)
              const BestDealsSection(height: 250, showTitle: false),
            loading
                ? SizedBox(
                    width: double.infinity,
                    child: ListView.builder(
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      itemCount: 10,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 8,
                            horizontal: 16,
                          ),
                          child: Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: Container(
                              height: 150,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  )
                : ref.watch(homePropertiesProvider).filteredApartments.isEmpty
                    ? SizedBox(
                        height: MediaQuery.of(context).size.height * 0.7,
                        child: const Center(
                          child: Text(
                            "No results found\nPlease try again with different filters",
                            textAlign: TextAlign.center,
                          ),
                        ),
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: CustomColors.white,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            margin: const EdgeInsets.only(top: 4),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 10),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      height: 36,
                                      width: 80,
                                      child: TextButton.icon(
                                        style: TextButton.styleFrom(
                                          padding: EdgeInsets.zero,
                                          backgroundColor: CustomColors.primary,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(6),
                                          ),
                                          side: const BorderSide(
                                            color: CustomColors.primary,
                                          ),
                                        ),
                                        onPressed: () {
                                          _showSortBottomSheet(context);
                                        },
                                        icon: const Icon(
                                          Icons.filter_list,
                                          size: 20,
                                          color: CustomColors.white,
                                        ),
                                        label: const Text(
                                          "Sort",
                                          style: TextStyle(
                                            color: CustomColors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        setState(() {
                                          isListview = !isListview;
                                        });
                                      },
                                      icon: isListview
                                          ? const Icon(
                                              Icons.grid_view_outlined,
                                              color: CustomColors.primary,
                                              size: 28,
                                            )
                                          : const Icon(
                                              Icons.list,
                                              color: CustomColors.primary,
                                              size: 28,
                                            ),
                                    )
                                  ],
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 2),
                                  child: !isListview
                                      ? PropertyGridView(
                                          sortedApartments: ref
                                              .watch(homePropertiesProvider)
                                              .filteredApartments,
                                          globalKeys: _globalKeys,
                                        )
                                      : ListView.builder(
                                          shrinkWrap: true,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          padding: EdgeInsets.zero,
                                          itemCount: ref
                                                      .watch(
                                                          homePropertiesProvider)
                                                      .filteredApartments
                                                      .length >
                                                  4
                                              ? ref
                                                      .watch(
                                                          homePropertiesProvider)
                                                      .filteredApartments
                                                      .length +
                                                  1
                                              : ref
                                                  .watch(homePropertiesProvider)
                                                  .filteredApartments
                                                  .length,
                                          itemBuilder: (context, index) {
                                            if (displayAds) {
                                              if (index % 5 == 4) {
                                                List<Widget> widgetList = [
                                                  VisibilityDetector(
                                                    key: const Key(
                                                        'project-snippets'),
                                                    onVisibilityChanged:
                                                        (visibilityInfo) {
                                                      if (visibilityInfo
                                                              .visibleFraction >
                                                          0) {
                                                        setState(() {
                                                          showScrollUpButton =
                                                              true;
                                                        });
                                                        debugPrint(
                                                            'showScrollUpButton: $showScrollUpButton');
                                                      }
                                                    },
                                                    child:
                                                        const ProjectSnippets(
                                                            leftPadding: false),
                                                  ),
                                                  Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      const Text(
                                                        "New Launches",
                                                        style: TextStyle(
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      const SizedBox(height: 8),
                                                      EditorsChoiceCard(
                                                        apartments: ref
                                                            .watch(
                                                                homePropertiesProvider)
                                                            .newProjects,
                                                        leftPadding: false,
                                                      ),
                                                      const SizedBox(
                                                          height: 10),
                                                    ],
                                                  ),
                                                  const BudgetHomes(),
                                                  const LocationHomes(),
                                                  const ReadyToMovein(),
                                                  const UltraLuxuryHomes(
                                                      leftPadding: false),
                                                  const NewLaunchSection(
                                                      title: "Editor's Choice"),
                                                ];
                                                int adsIndex = index ~/ 5;
                                                return widgetList[adsIndex %
                                                    widgetList.length];
                                              }
                                            }
                                            {
                                              int listIndex =
                                                  index - (index ~/ 5);

                                              return PropertyCard(
                                                apartment: ref
                                                    .watch(
                                                        homePropertiesProvider)
                                                    .filteredApartments[listIndex],
                                                nextApartment: ref
                                                        .watch(
                                                            homePropertiesProvider)
                                                        .filteredApartments
                                                        .isNotEmpty
                                                    ? ref
                                                        .watch(
                                                            homePropertiesProvider)
                                                        .filteredApartments
                                                        .first
                                                    : null,
                                                isCompare: true,
                                                onCallPress: (context) {
                                                  if (ref
                                                      .watch(userProvider)
                                                      .token
                                                      .isEmpty) {
                                                    errorSnackBar(context,
                                                        'Please login first');
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            const LoginScreen(
                                                          goBack: true,
                                                        ),
                                                      ),
                                                    );
                                                  } else {
                                                    _toggleOverlay(
                                                        context,
                                                        ref
                                                                .watch(
                                                                    homePropertiesProvider)
                                                                .filteredApartments[
                                                            listIndex],
                                                        _globalKeys[listIndex]);
                                                  }
                                                },
                                                globalKey:
                                                    _globalKeys[listIndex],
                                              );
                                            }
                                          },
                                        ),
                                ),
                                if (!isEndReached)
                                  VisibilityDetector(
                                    key: const Key('load-more-detector'),
                                    onVisibilityChanged: (visibilityInfo) {
                                      if (visibilityInfo.visibleFraction > 0) {
                                        Map<String, dynamic> params =
                                            ref.watch(filtersProvider).toJson();
                                        params['page'] =
                                            (currentPage + 1).toString();
                                        getMoreProjects(params: params);
                                      }
                                    },
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 16.0),
                                            child: Shimmer.fromColors(
                                              baseColor: Colors.grey[300]!,
                                              highlightColor: Colors.grey[100]!,
                                              child: Container(
                                                height: 150,
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 16.0),
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        if (!isListview)
                                          Expanded(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 16.0),
                                              child: Shimmer.fromColors(
                                                baseColor: Colors.grey[300]!,
                                                highlightColor:
                                                    Colors.grey[100]!,
                                                child: Container(
                                                  height: 150,
                                                  margin: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 16.0),
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          if (displayAds &&
                              (ref.watch(filtersProvider).totalCount ==
                                      ref
                                          .watch(homePropertiesProvider)
                                          .filteredApartments
                                          .length ||
                                  isEndReached))
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (ref
                                        .watch(homePropertiesProvider)
                                        .filteredApartments
                                        .length <=
                                    5)
                                  Container(
                                    width: double.infinity,
                                    margin: const EdgeInsets.only(top: 4),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10),
                                    decoration: BoxDecoration(
                                      color: CustomColors.white,
                                      borderRadius: BorderRadius.circular(6),
                                      boxShadow: [
                                        BoxShadow(
                                          color: CustomColors.black
                                              .withOpacity(0.2),
                                          blurRadius: 10,
                                          spreadRadius: 0,
                                          offset: const Offset(0, 0),
                                        ),
                                      ],
                                    ),
                                    child: const ProjectSnippets(),
                                  ),
                                if (ref
                                        .watch(homePropertiesProvider)
                                        .filteredApartments
                                        .length <=
                                    9)
                                  Container(
                                    width: double.infinity,
                                    margin: const EdgeInsets.only(top: 4),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10),
                                    decoration: BoxDecoration(
                                      color: CustomColors.white,
                                      borderRadius: BorderRadius.circular(6),
                                      boxShadow: [
                                        BoxShadow(
                                          color: CustomColors.black
                                              .withOpacity(0.2),
                                          blurRadius: 10,
                                          spreadRadius: 0,
                                          offset: const Offset(0, 0),
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Padding(
                                          padding: EdgeInsets.only(
                                              left: 10, bottom: 10),
                                          child: Text(
                                            "New Launches",
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        EditorsChoiceCard(
                                            apartments: ref
                                                .watch(homePropertiesProvider)
                                                .newProjects),
                                      ],
                                    ),
                                  ),
                                if (ref
                                        .watch(homePropertiesProvider)
                                        .filteredApartments
                                        .length <=
                                    13)
                                  Container(
                                      width: double.infinity,
                                      margin: const EdgeInsets.only(top: 16),
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10),
                                      decoration: BoxDecoration(
                                        color: CustomColors.white,
                                        borderRadius: BorderRadius.circular(6),
                                        boxShadow: [
                                          BoxShadow(
                                            color: CustomColors.black
                                                .withOpacity(0.2),
                                            blurRadius: 10,
                                            spreadRadius: 0,
                                            offset: const Offset(0, 0),
                                          ),
                                        ],
                                      ),
                                      child: const BudgetHomes()),
                                if (ref
                                        .watch(homePropertiesProvider)
                                        .filteredApartments
                                        .length <=
                                    17)
                                  const LocationHomes(),
                                if (ref
                                        .watch(homePropertiesProvider)
                                        .filteredApartments
                                        .length <=
                                    21)
                                  const ReadyToMovein(),
                                if (ref
                                        .watch(homePropertiesProvider)
                                        .filteredApartments
                                        .length <=
                                    25)
                                  const UltraLuxuryHomes(),
                                if (ref
                                        .watch(homePropertiesProvider)
                                        .filteredApartments
                                        .length <=
                                    29)
                                  const NewLaunchSection(
                                      title: "Editor's Choice"),
                              ],
                            ),
                          if (ref.watch(recentlyViewedProvider).isNotEmpty)
                            const RecentlyViewedSection(),
                          Container(
                            decoration: BoxDecoration(
                              color: CustomColors.white,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            margin: const EdgeInsets.only(top: 4),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 10,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 370,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(4, 0, 16, 0),
                                        child: Text(
                                          "Explore projects in other locations",
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      SizedBox(
                                        height: 340,
                                        width: double.infinity,
                                        child: SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: Wrap(
                                            direction: Axis.vertical,
                                            runSpacing: 6,
                                            spacing: 6,
                                            children: [
                                              ...List.generate(
                                                ref
                                                    .watch(localityListProvider)
                                                    .length,
                                                (index) => GestureDetector(
                                                  onTap: () {
                                                    ref
                                                        .read(filtersProvider
                                                            .notifier)
                                                        .updateSelectedLocalities([
                                                      ref.watch(
                                                              localityListProvider)[
                                                          index]
                                                    ]);

                                                    getFilteredApartments(
                                                        useDefaultParams: true);
                                                    Future.delayed(
                                                      const Duration(
                                                          milliseconds: 500),
                                                      () {
                                                        _masterScrollController
                                                            .animateTo(
                                                          0,
                                                          duration:
                                                              const Duration(
                                                                  milliseconds:
                                                                      500),
                                                          curve:
                                                              Curves.easeInOut,
                                                        );
                                                      },
                                                    );
                                                  },
                                                  child: Container(
                                                    height: 80,
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.35,
                                                    clipBehavior: Clip.hardEdge,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      gradient:
                                                          const LinearGradient(
                                                        colors: [
                                                          CustomColors.black50,
                                                          CustomColors.black75
                                                        ],
                                                        begin:
                                                            Alignment.topLeft,
                                                        end: Alignment
                                                            .bottomRight,
                                                      ),
                                                    ),
                                                    child: Stack(
                                                      children: [
                                                        Positioned.fill(
                                                          child: Image.asset(
                                                            "assets/images/locations_bg.jpg",
                                                            fit: BoxFit.cover,
                                                          ),
                                                        ),
                                                        Positioned.fill(
                                                          child: Container(
                                                            color: CustomColors
                                                                .black
                                                                .withOpacity(
                                                                    0.6),
                                                          ),
                                                        ),
                                                        Container(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8),
                                                          alignment:
                                                              Alignment.center,
                                                          child: Text(
                                                            ref.watch(
                                                                    localityListProvider)[
                                                                index],
                                                            textAlign: TextAlign
                                                                .center,
                                                            style:
                                                                const TextStyle(
                                                              color:
                                                                  CustomColors
                                                                      .white,
                                                              fontSize: 12,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                const Padding(
                                  padding: EdgeInsets.fromLTRB(4, 16, 16, 8),
                                  child: Text(
                                    "Categories",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ), //category options
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 2),
                                    child: Row(
                                      children: List.generate(
                                        categoryOptions.length,
                                        (index) => GestureDetector(
                                          onTap: () {
                                            displayAds = false;
                                            ref
                                                .read(
                                                    searchBarProvider.notifier)
                                                .setSearchTerm(
                                                  categoryOptions[index]
                                                      ['title'],
                                                );
                                            List<String> location = ref
                                                .read(filtersProvider)
                                                .selectedLocalities;
                                            ref
                                                .read(filtersProvider.notifier)
                                                .setAllFilters(
                                                  categoryOptions[index]
                                                      ['filter'],
                                                );

                                            ref
                                                .read(filtersProvider.notifier)
                                                .updateSelectedLocalities(
                                                    location);
                                            loading = true;

                                            Future.delayed(
                                                const Duration(
                                                    milliseconds: 500), () {
                                              getFilteredApartments(
                                                  useDefaultParams: true);
                                            });

                                            _masterScrollController.animateTo(
                                              0,
                                              duration: const Duration(
                                                  milliseconds: 500),
                                              curve: Curves.easeInOut,
                                            );
                                          },
                                          child: Container(
                                            height: 80,
                                            clipBehavior: Clip.hardEdge,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.4,
                                            margin: const EdgeInsets.fromLTRB(
                                                0, 0, 10, 0),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(8),
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
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            3),
                                                    gradient: LinearGradient(
                                                      colors: [
                                                        CustomColors.black
                                                            .withOpacity(0),
                                                        CustomColors.black
                                                            .withOpacity(0.77),
                                                      ],
                                                      begin:
                                                          Alignment.topCenter,
                                                      end: Alignment
                                                          .bottomCenter,
                                                    ),
                                                  ),
                                                ),
                                                Positioned(
                                                  bottom: 6,
                                                  left: 6,
                                                  right: 6,
                                                  child: Text(
                                                    categoryOptions[index]
                                                        ['title'],
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      color: CustomColors.white,
                                                      shadows: [
                                                        BoxShadow(
                                                          color: CustomColors
                                                              .white
                                                              .withOpacity(0.5),
                                                          blurRadius: 3,
                                                          offset: const Offset(
                                                              0, 0),
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
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
