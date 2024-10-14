import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:re_portal_frontend/modules/home/screens/best_deals_section.dart';
import 'package:re_portal_frontend/modules/search/screens/global_search.dart';
import 'package:re_portal_frontend/modules/home/screens/project_snippets.dart';
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
import 'package:re_portal_frontend/modules/shared/widgets/transitions.dart';
import 'package:re_portal_frontend/riverpod/filters_rvpd.dart';
import 'package:re_portal_frontend/riverpod/home_data.dart';
import 'package:re_portal_frontend/riverpod/locality_list.dart';
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
  final TextEditingController _searchController = TextEditingController();
  List<ApartmentModel> allApartments = [];
  List<ApartmentModel> snippets = [];
  List<String> videoLinks = [];
  final List<GlobalKey> _globalKeys = List.generate(50, (index) => GlobalKey());
  bool loading = false;
  OverlayEntry? _overlayEntry;
  bool _isOverlayVisible = false;
  bool isListview = true;
  bool pricePerSqFt = false;
  int currentPage = 1;
  final ScrollController _masterScrollController = ScrollController();
  Timer? _timer;

  List<String> searchOptions = [
    "project",
    "loction",
    "builder name",
  ];
  int searchOptionsIndex = 0;
  bool isEndReached = false;

  void _toggleOverlay(
      BuildContext context, ApartmentModel apartment, GlobalKey globalKey) {
    if (_isOverlayVisible) {
      _removeOverlay();
    } else {
      _showOverlay(context, apartment, globalKey);
    }
  }

  Widget _buildOption(Widget icon, String text, VoidCallback onTap) {
    return InkWell(
      onTap: () {
        _removeOverlay();
        onTap();
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: Row(
          children: [
            icon,
            const SizedBox(width: 12),
            Text(text),
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
    final Size size = renderBox.size;
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
            left: position.dx - 200,
            top: position.dy + size.height,
            child: Material(
              color: Colors.transparent,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildOption(
                      SvgPicture.asset("assets/icons/phone.svg"),
                      'Call now',
                      () {
                        launchUrl(Uri.parse("tel:${apartment.companyPhone}"))
                            .then(
                          (value) => _removeOverlay(),
                        );
                      },
                    ),
                    _buildOption(
                        SizedBox(
                            height: 20,
                            width: 20,
                            child: SvgPicture.asset(
                              "assets/icons/whatsapp.svg",
                            )),
                        'Chat on Whatsapp', () {
                      launchUrl(Uri.parse(
                              'https://wa.me/+91${apartment.companyPhone}?text=${Uri.encodeComponent("Hello, I'm interested in your property")}'))
                          .then(
                        (value) => _removeOverlay(),
                      );
                    }),
                    _buildOption(
                        SizedBox(
                            height: 20,
                            width: 20,
                            child: SvgPicture.asset(
                              "assets/icons/phone_incoming.svg",
                            )),
                        'Request call back',
                        () => _removeOverlay()),
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
                  pricePerSqFt = false;
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
                  pricePerSqFt = false;

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
                  pricePerSqFt = false;

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
                  pricePerSqFt = true;
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
                  pricePerSqFt = true;
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
  }) async {
    debugPrint("-----------------params: $params");
    try {
      String baseUrl = dotenv.get('BASE_URL');
      String url = "$baseUrl/project/filterApartmentsNew";
      Uri uri = Uri.parse(url).replace(queryParameters: params);

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
    _searchController.dispose();
    if (_isOverlayVisible) {
      _overlayEntry?.remove();
      _overlayEntry = null;
      _timer?.cancel();
    }
    super.dispose();
  }

  void _filterApartments(String searchTerm) {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: loading
          ? SizedBox(
              width: double.infinity,
              child: ListView.builder(
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
          : SingleChildScrollView(
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
                        if (_searchController.text.trim().isNotEmpty)
                          Text(
                            '"${_searchController.text.trim()}"',
                            style: const TextStyle(
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
                      if (ref
                          .watch(homePropertiesProvider)
                          .allApartments
                          .isNotEmpty) {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => const GlobalSearch(),
                          ),
                        );
                      } else {
                        debugPrint("loading");
                      }
                    },
                    child: Container(
                      color: CustomColors.primary,
                      child: Container(
                        height: 50,
                        margin: const EdgeInsets.all(4),
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
                  ),
                  Container(
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
                    child: (_searchController.text.trim().isNotEmpty ||
                            ref
                                .watch(filtersProvider)
                                .selectedLocalities
                                .isNotEmpty)
                        ? Container(
                            padding: const EdgeInsets.fromLTRB(2, 0, 0, 2),
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

                                              Map<String, dynamic> params = ref
                                                  .watch(filtersProvider)
                                                  .toJson();
                                              params['page'] = "1";
                                              getFilteredApartments(
                                                  params: params);
                                            });
                                          },
                                        );
                                      }),
                                      if (_searchController.text
                                          .trim()
                                          .isNotEmpty)
                                        ...ref
                                            .read(localityListProvider)
                                            .where((locality) => locality
                                                .toLowerCase()
                                                .contains(_searchController.text
                                                    .toLowerCase()))
                                            .where((locality) => !ref
                                                .watch(filtersProvider)
                                                .selectedLocalities
                                                .contains(locality))
                                            .map((locality) {
                                          return CustomListChip(
                                            text: locality,
                                            isSelected: false,
                                            onTap: () {
                                              ref
                                                  .read(
                                                      filtersProvider.notifier)
                                                  .updateSelectedLocalities(
                                                      [locality]);
                                              getFilteredApartments(params: {
                                                'page': "1",
                                                "projectLocation": locality
                                              }).then((value) {
                                                _searchController.clear();
                                                FocusScope.of(context)
                                                    .unfocus();
                                                Future.delayed(
                                                    const Duration(
                                                        milliseconds: 500), () {
                                                  _masterScrollController
                                                      .animateTo(
                                                    400,
                                                    duration: const Duration(
                                                        milliseconds: 500),
                                                    curve: Curves.easeInOut,
                                                  );
                                                });
                                              });
                                            },
                                          );
                                        }),
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
                    const BestDealsSection(height: 200, showTitle: false),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 36,
                          width: 80,
                          child: TextButton.icon(
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              backgroundColor: CustomColors.primary10,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6),
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
                              color: CustomColors.primary,
                            ),
                            label: const Text(
                              "Sort",
                              style: TextStyle(
                                color: CustomColors.primary,
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
                                  size: 28,
                                )
                              : const Icon(
                                  Icons.list,
                                  size: 28,
                                ),
                        )
                      ],
                    ),
                  ),
                  ref.watch(homePropertiesProvider).filteredApartments.isEmpty
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
                          children: [
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
                                                  .watch(homePropertiesProvider)
                                                  .filteredApartments
                                                  .length >
                                              4
                                          ? ref
                                                  .watch(homePropertiesProvider)
                                                  .filteredApartments
                                                  .length +
                                              1
                                          : ref
                                              .watch(homePropertiesProvider)
                                              .filteredApartments
                                              .length,
                                      itemBuilder: (context, index) {
                                        if (index % 5 == 0 && index != 0) {
                                          List<Widget> widgetList = [
                                            const NewLaunchSection(
                                                title: "Editor's Choice"),
                                            const ProjectSnippets(),
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const Padding(
                                                  padding: EdgeInsets.all(10),
                                                  child: Text(
                                                    "New Launches",
                                                    style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                                EditorsChoiceCard(
                                                    apartments: ref
                                                        .watch(
                                                            homePropertiesProvider)
                                                        .newProjects),
                                              ],
                                            ),
                                            const BudgetHomes(),
                                            const LocationHomes(),
                                            const ReadyToMovein(),
                                            const UltraLuxuryHomes(),
                                          ];
                                          int adsIndex = index ~/ 5;
                                          return widgetList[
                                              adsIndex % widgetList.length];
                                        }
                                        {
                                          int listIndex = index - (index ~/ 5);

                                          return PropertyCard(
                                            apartment: ref
                                                .watch(homePropertiesProvider)
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
                                              _toggleOverlay(
                                                  context,
                                                  ref
                                                          .watch(
                                                              homePropertiesProvider)
                                                          .filteredApartments[
                                                      listIndex],
                                                  _globalKeys[listIndex]);
                                            },
                                            globalKey: _globalKeys[listIndex],
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
                                            margin: const EdgeInsets.symmetric(
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
                                  ],
                                ),
                              ),
                            if (ref.watch(filtersProvider).totalCount ==
                                    ref
                                        .watch(homePropertiesProvider)
                                        .filteredApartments
                                        .length ||
                                isEndReached)
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (ref
                                          .watch(homePropertiesProvider)
                                          .filteredApartments
                                          .length <=
                                      5)
                                    const ProjectSnippets(),
                                  if (ref
                                          .watch(homePropertiesProvider)
                                          .filteredApartments
                                          .length <=
                                      9)
                                    Column(
                                      children: [
                                        const Padding(
                                          padding: EdgeInsets.all(10),
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
                                  if (ref
                                          .watch(homePropertiesProvider)
                                          .filteredApartments
                                          .length <=
                                      13)
                                    const BudgetHomes(),
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
                                  SizedBox(
                                    height: 150,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Padding(
                                          padding: EdgeInsets.fromLTRB(
                                              16, 10, 16, 0),
                                          child: Text(
                                            "Explore Locations",
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Expanded(
                                          child: SingleChildScrollView(
                                            scrollDirection: Axis.horizontal,
                                            child: Row(
                                              children: [
                                                const SizedBox(width: 10),
                                                ...List.generate(
                                                  ref
                                                      .watch(
                                                          localityListProvider)
                                                      .length,
                                                  (index) => GestureDetector(
                                                    onTap: () {
                                                      //add locality to filters
                                                      ref
                                                          .read(filtersProvider
                                                              .notifier)
                                                          .updateSelectedLocalities([
                                                        ref.watch(
                                                                localityListProvider)[
                                                            index]
                                                      ]);
                                                      Map<String, dynamic>
                                                          params = ref
                                                              .watch(
                                                                  filtersProvider)
                                                              .toJson();
                                                      params['page'] = "1";
                                                      getFilteredApartments(
                                                          params: params);
                                                      Future.delayed(
                                                          const Duration(
                                                              milliseconds:
                                                                  500), () {
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
                                                      });
                                                    },
                                                    child: Container(
                                                      height: double.infinity,
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.4,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        // color: CustomColors.black25,
                                                        gradient:
                                                            const LinearGradient(
                                                          colors: [
                                                            CustomColors
                                                                .black50,
                                                            CustomColors.black75
                                                          ],
                                                          begin:
                                                              Alignment.topLeft,
                                                          end: Alignment
                                                              .bottomRight,
                                                        ),
                                                      ),
                                                      margin:
                                                          const EdgeInsets.only(
                                                              right: 10),
                                                      child: Container(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8),
                                                        alignment:
                                                            Alignment.center,
                                                        child: Text(
                                                          ref.watch(
                                                                  localityListProvider)[
                                                              index],
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: const TextStyle(
                                                              color:
                                                                  CustomColors
                                                                      .white,
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(width: 10),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
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
