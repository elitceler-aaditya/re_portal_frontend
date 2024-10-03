import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:re_portal_frontend/modules/home/screens/ads_section.dart';
import 'package:re_portal_frontend/modules/home/screens/appartment_filter.dart';
import 'package:re_portal_frontend/modules/home/screens/best_deals_section.dart';
import 'package:re_portal_frontend/modules/home/screens/project_snippets.dart';
import 'package:re_portal_frontend/modules/home/widgets/property_card.dart';
import 'package:re_portal_frontend/modules/shared/models/appartment_model.dart';
import 'package:re_portal_frontend/modules/shared/widgets/colors.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:re_portal_frontend/riverpod/home_data.dart';
import 'package:re_portal_frontend/riverpod/user_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:visibility_detector/visibility_detector.dart';

class SearchApartment extends ConsumerStatefulWidget {
  const SearchApartment({super.key});

  @override
  ConsumerState<SearchApartment> createState() => _SearchApartmentState();
}

class _SearchApartmentState extends ConsumerState<SearchApartment> {
  final TextEditingController _searchController = TextEditingController();
  List<ApartmentModel> allApartments = [];
  List<ApartmentModel> snippets = [];
  List<String> videoLinks = [];
  bool loading = true;
  OverlayEntry? _overlayEntry;
  bool _isOverlayVisible = false;
  String searchPrefix = "";
  bool isListview = true;
  bool isMoreLoading = false;
  int currentPage = 0;
  int totalCount = 0;

  List<String> searchOptions = ["properties", "apartments", "plots", "flats"];
  int searchOptionsIndex = 0;

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
    setState(() {
      _isOverlayVisible = false;
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
                  ref
                      .read(homePropertiesProvider.notifier)
                      .sortFilteredApartments(2);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Price - low to high'),
                onTap: () {
                  ref
                      .read(homePropertiesProvider.notifier)
                      .sortFilteredApartments(0);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Price - high to low'),
                onTap: () {
                  ref
                      .read(homePropertiesProvider.notifier)
                      .sortFilteredApartments(1);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> getAllProjects({
    Map<String, dynamic> params = const {},
  }) async {
    String baseUrl = dotenv.get('BASE_URL');
    String url = "$baseUrl/project/filterApartmentsNew";
    Uri uri = Uri.parse(url).replace(queryParameters: params);
    http.get(
      uri,
      headers: {
        "Authorization": "Bearer ${ref.watch(userProvider).token}",
      },
    ).then((response) async {
      if (response.statusCode == 200 || response.statusCode == 201) {
        Map<String, dynamic> responseData = jsonDecode(response.body);
        currentPage = responseData['currentPage'];
        totalCount = responseData['totalCount'];
        if (responseData['projects'] is List) {
          List<dynamic> responseBody = responseData['projects'];
          allApartments = responseBody
              .map((e) => ApartmentModel.fromJson(e as Map<String, dynamic>))
              .toList();
          ref
              .watch(homePropertiesProvider.notifier)
              .setfilteredApartments(allApartments);
        } else {
          // Handle the case where 'properties' is not a List
          debugPrint("Error: projects is not a List");
          allApartments = [];
        }

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

  Future<void> getMoreProjects({
    Map<String, dynamic> params = const {},
  }) async {
    debugPrint("-----------getting page ${currentPage + 1}-----------");
    String baseUrl = dotenv.get('BASE_URL');
    String url = "$baseUrl/project/filterApartmentsNew";
    Uri uri = Uri.parse(url).replace(queryParameters: params);

    http.get(
      uri,
      headers: {
        "Authorization": "Bearer ${ref.watch(userProvider).token}",
      },
    ).then((response) async {
      if (response.statusCode == 200 || response.statusCode == 201) {
        setState(() {
          isMoreLoading = false;
        });
        Map<String, dynamic> responseData = jsonDecode(response.body);
        currentPage = responseData['currentPage'];
        if (responseData['projects'] is List) {
          List<dynamic> responseBody = responseData['projects'];
          List<ApartmentModel> moreApartments = responseBody
              .map((e) => ApartmentModel.fromJson(e as Map<String, dynamic>))
              .toList();
          ref
              .watch(homePropertiesProvider.notifier)
              .addFilteredApartments(moreApartments);
        } else {
          debugPrint("Error: projects is not a List");
          allApartments = [];
        }

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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getAllProjects(
        params: {"page": "1"},
      );
    });

    Timer.periodic(const Duration(seconds: 5), (timer) {
      setState(() {
        searchOptionsIndex = (searchOptionsIndex + 1) % searchOptions.length;
      });
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _searchController.dispose();
      
      _removeOverlay();
    });
    super.dispose();
  }

  void _filterApartments(String searchTerm) {
    setState(() {
      ref
          .read(homePropertiesProvider.notifier)
          .setfilteredApartments(allApartments.where((apartment) {
            if (apartment.name
                .toLowerCase()
                .contains(searchTerm.toLowerCase())) {
              setState(() {
                searchPrefix = "by name - ";
              });
              return apartment.name
                  .toLowerCase()
                  .contains(searchTerm.toLowerCase());
            }
            if (apartment.projectLocation
                .toLowerCase()
                .contains(searchTerm.toLowerCase())) {
              setState(() {
                searchPrefix = "by location - ";
              });
              return apartment.projectLocation
                  .toLowerCase()
                  .contains(searchTerm.toLowerCase());
            }
            return false;
          }).toList());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
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
                            " $searchPrefix ${_searchController.text.trim()}",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: CustomColors.white,
                            ),
                          ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
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
                            child: TextField(
                              controller: _searchController,
                              onChanged: _filterApartments,
                              style: const TextStyle(
                                fontSize: 14,
                              ),
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.zero,
                                hintText:
                                    'Search ${searchOptions[searchOptionsIndex]}...',
                                hintStyle: const TextStyle(
                                  color: CustomColors.black50,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                          ),
                          if (_searchController.text.trim().isEmpty)
                            GestureDetector(
                              onTap: () {},
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 4),
                                child: SvgPicture.string(
                                  """<svg width="100%" height="100%" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg"> <path d="M20 12C20 16.4183 16.4183 20 12 20M20 12C20 7.58172 16.4183 4 12 4M20 12H22M12 20C7.58172 20 4 16.4183 4 12M12 20V22M4 12C4 7.58172 7.58172 4 12 4M4 12H2M12 4V2M15 12C15 13.6569 13.6569 15 12 15C10.3431 15 9 13.6569 9 12C9 10.3431 10.3431 9 12 9C13.6569 9 15 10.3431 15 12Z" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/> </svg>""",
                                ),
                              ),
                            ),
                          if (_searchController.text.trim().isEmpty)
                            TextButton.icon(
                              style: TextButton.styleFrom(
                                backgroundColor: CustomColors.secondary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              onPressed: () {
                                //remove focus from search bar
                                FocusManager.instance.primaryFocus?.unfocus();
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
                  if (ref.watch(homePropertiesProvider).bestDeals.isNotEmpty)
                    const BestDealsSection(
                      height: 200,
                    ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          "All properties",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
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
                              Icons.sort,
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
                        // IconButton(
                        //   onPressed: () {
                        //     setState(() {
                        //       isListview = !isListview;
                        //     });
                        //   },
                        //   icon: isListview
                        //       ? const Icon(
                        //           Icons.grid_view_outlined,
                        //           size: 28,
                        //         )
                        //       : const Icon(
                        //           Icons.list,
                        //           size: 28,
                        //         ),
                        // )
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
                      : Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            padding: EdgeInsets.zero,
                            itemCount: ref
                                    .watch(homePropertiesProvider)
                                    .filteredApartments
                                    .length +
                                (ref
                                        .watch(homePropertiesProvider)
                                        .filteredApartments
                                        .length ~/
                                    4),
                            itemBuilder: (context, index) {
                              if (index % 4 == 0 && index != 0) {
                                int adsIndex = index ~/ 4;
                                return adsIndex % 3 == 1
                                    ? const ProjectSnippets()
                                    : const AdsSection();
                              } else {
                                int listIndex = index - (index ~/ 4);
                                return VisibilityDetector(
                                  key: GlobalKey(),
                                  onVisibilityChanged: (visibility) {
                                    if (visibility.visibleFraction > 0.2) {
                                      // Check if this is the last item in the list
                                      if ((listIndex ==
                                              ref
                                                      .watch(
                                                          homePropertiesProvider)
                                                      .filteredApartments
                                                      .length -
                                                  1) &&
                                          ref
                                                  .watch(homePropertiesProvider)
                                                  .filteredApartments
                                                  .length <
                                              totalCount) {
                                        if (!isMoreLoading) {
                                          setState(() {
                                            isMoreLoading = true;
                                          });
                                          getMoreProjects(
                                            params: {
                                              "page":
                                                  (currentPage + 1).toString(),
                                            },
                                          );
                                        }
                                      }
                                    }
                                  },
                                  child: PropertyCard(
                                    apartment: ref
                                        .watch(homePropertiesProvider)
                                        .filteredApartments[listIndex],
                                    nextApartment: listIndex + 1 <
                                            ref
                                                .watch(homePropertiesProvider)
                                                .filteredApartments
                                                .length
                                        ? ref
                                            .watch(homePropertiesProvider)
                                            .filteredApartments[listIndex + 1]
                                        : ref
                                            .watch(homePropertiesProvider)
                                            .filteredApartments
                                            .first,
                                    isCompare: true,
                                    onCallPress: (context) {
                                      _toggleOverlay(
                                          context,
                                          ref
                                              .watch(homePropertiesProvider)
                                              .filteredApartments[listIndex],
                                          GlobalKey());
                                    },
                                    globalKey: GlobalKey(),
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                  if (isMoreLoading)
                    Shimmer.fromColors(
                      baseColor: CustomColors.black25,
                      highlightColor: CustomColors.black50,
                      child: Container(
                        height: 200,
                        width: double.infinity,
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                ],
              ),
            ),
    );
  }
}
