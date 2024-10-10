import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:re_portal_frontend/modules/search/screens/search_apartments_results.dart';
import 'package:re_portal_frontend/modules/home/widgets/property_stack_card.dart';
import 'package:re_portal_frontend/modules/shared/widgets/colors.dart';
import 'package:re_portal_frontend/modules/shared/widgets/custom_buttons.dart';
import 'package:re_portal_frontend/modules/shared/widgets/snackbars.dart';
import 'package:re_portal_frontend/modules/shared/widgets/transitions.dart';
import 'package:re_portal_frontend/riverpod/filters_rvpd.dart';
import 'package:re_portal_frontend/riverpod/home_data.dart';
import 'package:re_portal_frontend/riverpod/locality_list.dart';
import 'package:http/http.dart' as http;

class GlobalSearch extends ConsumerStatefulWidget {
  const GlobalSearch({super.key});

  @override
  ConsumerState<GlobalSearch> createState() => _GlobalSearchState();
}

class _GlobalSearchState extends ConsumerState<GlobalSearch> {
  final TextEditingController _searchController = TextEditingController();
  int searchOptionsIndex = 0;
  List<String> localities = [];

  List<String> searchOptions = [
    "project",
    "loction",
    "builder name",
  ];

  void _filterApartments(String searchTerm) {
    setState(() {});
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
      if (ref.watch(localityListProvider).isEmpty) {
        getLocalitiesList();
      }
      localities = ref.read(filtersProvider).selectedLocalities;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
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
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //search bar
                Container(
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
                        child: TextField(
                          controller: _searchController,
                          autofocus: true,
                          onChanged: _filterApartments,
                          style: const TextStyle(fontSize: 14),
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
                    ],
                  ),
                ),
                if (_searchController.text.trim().isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(left: 10, top: 4, bottom: 4),
                    child: Text(
                      "Searching for - '${_searchController.text.trim()}'",
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: CustomColors.white,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(width: double.infinity),
                  if (ref
                          .read(localityListProvider.notifier)
                          .searchLocality(
                              _searchController.text.trim(), localities)
                          .isEmpty &&
                      ref
                          .watch(homePropertiesProvider.notifier)
                          .getApartmentsByName(_searchController.text.trim())
                          .isEmpty &&
                      ref
                          .watch(homePropertiesProvider.notifier)
                          .getApartmentsByBuilderName(
                              _searchController.text.trim())
                          .isEmpty)
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.5,
                      child: Center(
                        child: Text(
                          "No results found for - '${_searchController.text.trim()}'",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                            color: CustomColors.black,
                          ),
                        ),
                      ),
                    ),
                  if (ref
                      .read(localityListProvider.notifier)
                      .searchLocality(_searchController.text.trim(), localities)
                      .isNotEmpty)
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.fromLTRB(4, 10, 4, 4),
                          child: Text(
                            "Localities",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: CustomColors.primary,
                            ),
                          ),
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.zero,
                          itemCount: localities.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  localities.removeAt(index);
                                });
                              },
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 4),
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: CustomColors.primary20,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(localities[index]),
                                    const Icon(
                                      Icons.close,
                                      size: 18,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                        if (ref
                            .read(localityListProvider.notifier)
                            .searchLocality(
                                _searchController.text.trim(), localities)
                            .isNotEmpty)
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            padding: EdgeInsets.zero,
                            itemCount: ref
                                .read(localityListProvider.notifier)
                                .searchLocality(
                                    _searchController.text.trim(), localities)
                                .length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    if (!localities.contains(ref
                                        .read(localityListProvider.notifier)
                                        .searchLocality(
                                            _searchController.text.trim(),
                                            localities)[index])) {
                                      if (localities.length >= 4) {
                                        errorSnackBar(context,
                                            "You can only select 4 localities");
                                      } else {
                                        localities.add(ref
                                            .read(localityListProvider.notifier)
                                            .searchLocality(
                                                _searchController.text.trim(),
                                                localities)[index]);
                                        _searchController.clear();
                                      }
                                    } else {
                                      localities.remove(ref
                                          .read(localityListProvider.notifier)
                                          .searchLocality(
                                              _searchController.text.trim(),
                                              localities)[index]);
                                    }
                                  });
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(bottom: 4),
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: localities.contains(ref
                                            .read(localityListProvider.notifier)
                                            .searchLocality(
                                                _searchController.text.trim(),
                                                localities)[index])
                                        ? CustomColors.primary20
                                        : CustomColors.black10,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(ref
                                          .read(localityListProvider.notifier)
                                          .searchLocality(
                                              _searchController.text.trim(),
                                              localities)[index]),
                                      Icon(
                                        localities.contains(ref
                                                .read(localityListProvider
                                                    .notifier)
                                                .searchLocality(
                                                    _searchController.text
                                                        .trim(),
                                                    localities)[index])
                                            ? Icons.check
                                            : Icons.add,
                                        size: 18,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                      ],
                    ),
                  if (ref
                      .watch(homePropertiesProvider.notifier)
                      .getApartmentsByName(_searchController.text.trim())
                      .isNotEmpty)
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.fromLTRB(4, 14, 4, 4),
                          child: Text(
                            "Search by property name",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: CustomColors.primary,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 150,
                          child: PropertyStackCard(
                            cardWidth: MediaQuery.of(context).size.width * 0.7,
                            apartments: ref
                                .watch(homePropertiesProvider.notifier)
                                .getApartmentsByName(
                                    _searchController.text.trim()),
                          ),
                        ),
                      ],
                    ),
                  if (ref
                      .watch(homePropertiesProvider.notifier)
                      .getApartmentsByBuilderName(_searchController.text.trim())
                      .isNotEmpty)
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.fromLTRB(4, 14, 4, 4),
                          child: Text(
                            "Search by builder's name",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: CustomColors.primary,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 150,
                          child: PropertyStackCard(
                            cardWidth: MediaQuery.of(context).size.width * 0.7,
                            apartments: ref
                                .watch(homePropertiesProvider.notifier)
                                .getApartmentsByBuilderName(
                                    _searchController.text.trim()),
                            showCompanyName: true,
                          ),
                        ),
                      ],
                    ),
                  const SizedBox(height: 10)
                ],
              ),
            ),
          ),
          if (localities.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(10),
              child: CustomPrimaryButton(
                title: 'Search',
                btnIcon: const Icon(
                  Icons.search,
                  color: CustomColors.white,
                ),
                onTap: () {
                  ref
                      .read(filtersProvider.notifier)
                      .updateSelectedLocalities(localities);
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SearchApartmentResults(
                              openFilters: false)));
                },
              ),
            )
        ],
      ),
    );
  }
}
