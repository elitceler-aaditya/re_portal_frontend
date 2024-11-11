import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:re_portal_frontend/modules/home/widgets/custom_chip.dart';
import 'package:re_portal_frontend/modules/search/models/search_result_model.dart';
import 'package:re_portal_frontend/modules/search/screens/recently_viewed_section.dart';
import 'package:re_portal_frontend/modules/search/widgets/search_apartment.dart';
import 'package:re_portal_frontend/modules/shared/widgets/colors.dart';
import 'package:re_portal_frontend/modules/shared/widgets/custom_buttons.dart';
import 'package:re_portal_frontend/modules/shared/widgets/snackbars.dart';
import 'package:re_portal_frontend/riverpod/bot_nav_bar.dart';
import 'package:re_portal_frontend/riverpod/filters_rvpd.dart';
import 'package:re_portal_frontend/riverpod/home_data.dart';
import 'package:http/http.dart' as http;
import 'package:re_portal_frontend/riverpod/recently_viewed.dart';
import 'package:re_portal_frontend/riverpod/search_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GlobalSearch extends ConsumerStatefulWidget {
  const GlobalSearch({super.key});

  @override
  ConsumerState<GlobalSearch> createState() => _GlobalSearchState();
}

class _GlobalSearchState extends ConsumerState<GlobalSearch> {
  final TextEditingController _searchController = TextEditingController();
  List<String> localities = [];
  List<String> recentSearchLocalities = [];
  List<String> recentSearchProjects = [];
  List<String> recentSearchBuilders = [];
  SearchResultModel searchResults =
      SearchResultModel(projects: [], builders: [], locations: []);

  setRecentSearches() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    recentSearchLocalities =
        prefs.getStringList('searchHistory_location') ?? [];
    recentSearchProjects = prefs.getStringList('searchHistory_projects') ?? [];
    recentSearchBuilders = prefs.getStringList('searchHistory_builder') ?? [];
    setState(() {});
  }

  Future<void> globalSearch(String searchTerm) async {
    String baseUrl = dotenv.get('BASE_URL');
    String url = "$baseUrl/project/globalSearchApartments";
    Uri uri = Uri.parse(url);

    try {
      debugPrint("---------pinging: $uri");
      final response = await http.get(
        Uri.parse(
            '$baseUrl/project/globalSearchApartments?searchTerm=$searchTerm'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        Map<String, dynamic> responseData = jsonDecode(response.body);
        debugPrint("---------responseData: $responseData");
        searchResults = SearchResultModel.fromJson(responseData);
      } else {
        throw Exception('${response.statusCode}: ${response.body}');
      }
    } catch (error) {
      debugPrint("-------------error: $error");
      // debugPrint("stackTrace: $stackTrace");
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(filtersProvider.notifier).clearAllFilters();
      localities = ref.read(filtersProvider).selectedLocalities;
      setRecentSearches();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.black10,
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 40, bottom: 4),
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
                Text(
                  ref.watch(homePropertiesProvider).propertyType,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: CustomColors.black,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(8),
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
                  child: TextField(
                    controller: _searchController,
                    autofocus: true,
                    onChanged: (value) => globalSearch(value),
                    onSubmitted: (value) {
                      ref.read(searchBarProvider.notifier).setSearchTerm(value);
                      ref.read(navBarIndexProvider.notifier).setNavBarIndex(1);
                      Navigator.pop(context);
                    },
                    style: const TextStyle(fontSize: 14),
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 16),
                      hintText: 'Search from 1000+ projects...',
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
                if (_searchController.text.trim().isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(left: 10, top: 6, bottom: 0),
                    child: Text(
                      "Searching for - '${_searchController.text.trim()}'",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: CustomColors.black,
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
                  if (_searchController.text.trim().isNotEmpty &&
                      searchResults.builders.isEmpty &&
                      searchResults.projects.isEmpty &&
                      searchResults.locations.isEmpty)
                    Container(
                      height: 50,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Center(
                        child: Text(
                          "No results found for - '${_searchController.text.trim()}'",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                            color: CustomColors.black,
                          ),
                        ),
                      ),
                    ),
                  // if (ref
                  //         .watch(localityListProvider.notifier)
                  //         .searchLocality(
                  //             _searchController.text.trim(), localities)
                  //         .isNotEmpty &&
                  //     localities.isNotEmpty)
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: CustomColors.white,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    margin: const EdgeInsets.only(top: 4, bottom: 4),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (localities.isNotEmpty)
                          const Padding(
                            padding: EdgeInsets.fromLTRB(8, 0, 4, 4),
                            child: Text(
                              "Localities",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: CustomColors.primary,
                              ),
                            ),
                          ),
                        if (localities.isNotEmpty)
                          SizedBox(
                            height: 40,
                            child: ListView.builder(
                              shrinkWrap: true,
                              padding: EdgeInsets.zero,
                              scrollDirection: Axis.horizontal,
                              itemCount: localities.length,
                              itemBuilder: (context, index) {
                                return CustomListChip(
                                  text: localities[index],
                                  onTap: () {
                                    setState(() {
                                      localities.removeAt(index);
                                    });
                                  },
                                );
                              },
                            ),
                          ),
                        if (_searchController.text.trim().isNotEmpty &&
                            searchResults.locations.isNotEmpty)
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            padding: EdgeInsets.zero,
                            itemCount: searchResults.locations.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () async {
                                  // Add the locality to the search history in SharedPreferences
                                  SharedPreferences prefs =
                                      await SharedPreferences.getInstance();
                                  List<String> searchHistory =
                                      prefs.getStringList(
                                              'searchHistory_location') ??
                                          [];
                                  final localityToAdd =
                                      searchResults.locations[index];

                                  searchHistory.remove(localityToAdd);
                                  searchHistory.insert(0, localityToAdd);
                                  searchHistory =
                                      searchHistory.take(10).toList();
                                  await prefs.setStringList(
                                      'searchHistory_location', searchHistory);

                                  setState(() {
                                    final modifiableLocalities =
                                        List<String>.from(localities);
                                    if (modifiableLocalities
                                        .contains(localityToAdd)) {
                                      modifiableLocalities
                                          .remove(localityToAdd);
                                    } else if (modifiableLocalities.length <
                                        4) {
                                      modifiableLocalities.add(localityToAdd);
                                      _searchController.clear();
                                    } else {
                                      errorSnackBar(context,
                                          "You can only select 4 localities");
                                    }
                                    localities = modifiableLocalities;
                                  });
                                  setRecentSearches();
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(bottom: 4),
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: localities.contains(
                                            searchResults.locations[index])
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
                                      Text(searchResults.locations[index]),
                                      Icon(
                                        localities.contains(
                                                searchResults.locations[index])
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
                  ),
                  if (_searchController.text.trim().isEmpty &&
                      localities.isEmpty &&
                      (recentSearchLocalities.isNotEmpty ||
                          recentSearchProjects.isNotEmpty ||
                          recentSearchBuilders.isNotEmpty))
                    Container(
                      decoration: BoxDecoration(
                        color: CustomColors.white,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      margin: const EdgeInsets.only(bottom: 4),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.fromLTRB(8, 0, 4, 0),
                            child: Text(
                              "Recent Searches",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: CustomColors.primary,
                              ),
                            ),
                          ),

                          //localities
                          ...List.generate(
                            recentSearchLocalities.take(8).length,
                            (index) => ListTile(
                              contentPadding:
                                  const EdgeInsets.only(left: 16, right: 6),
                              leading: const Icon(Icons.history),
                              title: Text(recentSearchLocalities[index]),
                              onTap: () {
                                ref
                                    .read(filtersProvider.notifier)
                                    .updateSelectedLocalities(
                                        [recentSearchLocalities[index]]);
                                setState(() {
                                  localities = List<String>.from(localities)
                                    ..removeWhere((element) =>
                                        element ==
                                        recentSearchLocalities[index])
                                    ..add(recentSearchLocalities[index]);
                                });
                              },
                              trailing: IconButton(
                                onPressed: () async {
                                  final prefs =
                                      await SharedPreferences.getInstance();
                                  recentSearchLocalities.removeAt(index);
                                  await prefs.setStringList(
                                      'searchHistory_location',
                                      recentSearchLocalities);
                                  setState(() {});
                                },
                                icon: const Icon(Icons.close, size: 20),
                              ),
                            ),
                          ),

                          //projects
                          ...List.generate(
                            recentSearchProjects.take(8).length,
                            (index) => ListTile(
                              contentPadding:
                                  const EdgeInsets.only(left: 16, right: 6),
                              leading: const Icon(Icons.location_city),
                              title: Text(recentSearchProjects[index]),
                              onTap: () {
                                setState(() {
                                  _searchController.text =
                                      recentSearchProjects[index];
                                  globalSearch(recentSearchProjects[index]);
                                });
                              },
                              trailing: IconButton(
                                onPressed: () async {
                                  final prefs =
                                      await SharedPreferences.getInstance();
                                  recentSearchProjects.removeAt(index);
                                  await prefs.setStringList(
                                      'searchHistory_projects',
                                      recentSearchProjects);
                                  setState(() {});
                                },
                                icon: const Icon(Icons.close, size: 20),
                              ),
                            ),
                          ),

                          //builders
                          ...List.generate(
                            recentSearchBuilders.take(8).length,
                            (index) => ListTile(
                              contentPadding:
                                  const EdgeInsets.only(left: 16, right: 6),
                              leading:
                                  const Icon(Icons.real_estate_agent_outlined),
                              title: Text(recentSearchBuilders[index]),
                              onTap: () {
                                setState(() {
                                  _searchController.text =
                                      recentSearchBuilders[index];
                                  globalSearch(recentSearchBuilders[index]);
                                });
                              },
                              trailing: IconButton(
                                onPressed: () async {
                                  final prefs =
                                      await SharedPreferences.getInstance();
                                  recentSearchBuilders.removeAt(index);
                                  await prefs.setStringList(
                                      'searchHistory_builder',
                                      recentSearchBuilders);
                                  setState(() {});
                                },
                                icon: const Icon(Icons.close, size: 20),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  if (_searchController.text.trim().isEmpty
                      ? ref
                          .watch(homePropertiesProvider.notifier)
                          .getApartmentsByName(_searchController.text.trim())
                          .isNotEmpty
                      : searchResults.projects.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: CustomColors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: const [
                          BoxShadow(
                            color: CustomColors.black10,
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.fromLTRB(8, 0, 4, 4),
                            child: Text(
                              "Search by project name",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: CustomColors.primary,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 100,
                            child: _searchController.text.trim().isEmpty
                                ? ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: ref
                                        .watch(homePropertiesProvider.notifier)
                                        .getApartmentsByName(
                                            _searchController.text.trim())
                                        .length,
                                    itemBuilder: (context, index) =>
                                        SearchApartmentCard(
                                      apartment: ref
                                          .watch(
                                              homePropertiesProvider.notifier)
                                          .getApartmentsByName(_searchController
                                              .text
                                              .trim())[index],
                                    ),
                                  )
                                : ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: searchResults.projects.length,
                                    itemBuilder: (context, index) =>
                                        SearchApartmentCard(
                                      apartment: searchResults.projects[index],
                                    ),
                                  ),
                          ),
                        ],
                      ),
                    ),
                  if (_searchController.text.trim().isEmpty
                      ? ref
                          .watch(homePropertiesProvider.notifier)
                          .getApartmentsByBuilderName(
                              _searchController.text.trim())
                          .isNotEmpty
                      : searchResults.builders.isNotEmpty)
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
                          const SizedBox(width: double.infinity),
                          const Padding(
                            padding: EdgeInsets.fromLTRB(8, 0, 4, 4),
                            child: Text(
                              "Search by builder name",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: CustomColors.primary,
                              ),
                            ),
                          ),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: List.generate(
                                _searchController.text.trim().isEmpty
                                    ? ref
                                        .watch(homePropertiesProvider.notifier)
                                        .getBuilderNames("")
                                        .length
                                    : searchResults.builders.length,
                                (index) => GestureDetector(
                                  onTap: () async {
                                    SharedPreferences prefs =
                                        await SharedPreferences.getInstance();
                                    List<String> searchHistory =
                                        prefs.getStringList(
                                                'searchHistory_builder') ??
                                            [];
                                    String companyName = _searchController.text
                                            .trim()
                                            .isEmpty
                                        ? ref
                                            .watch(
                                                homePropertiesProvider.notifier)
                                            .getBuilderNames("")[index]
                                            .CompanyName
                                        : searchResults.builders[index].name;

                                    if (!searchHistory.contains(companyName)) {
                                      searchHistory.insert(0, companyName);
                                      searchHistory =
                                          searchHistory.take(5).toList();
                                      await prefs.setStringList(
                                          'searchHistory_builder',
                                          searchHistory);
                                    }

                                    ref
                                        .read(filtersProvider.notifier)
                                        .updateBuilderName(companyName);
                                    ref
                                        .read(navBarIndexProvider.notifier)
                                        .setNavBarIndex(1);
                                    Navigator.pop(context);
                                  },
                                  child: Container(
                                    height: 80,
                                    width: 140,
                                    margin: const EdgeInsets.only(left: 10),
                                    decoration: BoxDecoration(
                                      color: CustomColors.black,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    alignment: Alignment.center,
                                    child: Stack(
                                      children: [
                                        Positioned.fill(
                                          child: Image.network(
                                            _searchController.text
                                                    .trim()
                                                    .isEmpty
                                                ? ref
                                                    .watch(
                                                        homePropertiesProvider
                                                            .notifier)
                                                    .getBuilderNames("")[index]
                                                    .CompanyLogo
                                                : searchResults
                                                        .builders[index].logo ??
                                                    "",
                                            fit: BoxFit.cover,
                                            errorBuilder:
                                                (context, error, stack) =>
                                                    const SizedBox.shrink(),
                                            loadingBuilder: (context, child,
                                                    loadingProgress) =>
                                                loadingProgress == null
                                                    ? child
                                                    : const SizedBox.shrink(),
                                          ),
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                            color: CustomColors.black
                                                .withOpacity(0.75),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(4),
                                          child: Center(
                                            child: Text(
                                              _searchController.text
                                                      .trim()
                                                      .isEmpty
                                                  ? ref
                                                      .watch(
                                                          homePropertiesProvider
                                                              .notifier)
                                                      .getBuilderNames(
                                                          "")[index]
                                                      .CompanyName
                                                  : searchResults
                                                      .builders[index].name,
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(
                                                color: CustomColors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14,
                                              ),
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
                    ),
                  if (ref.watch(recentlyViewedProvider).isNotEmpty)
                    const RecentlyViewedSection(),
                  const SizedBox(height: 10)
                ],
              ),
            ),
          ),
          if (localities.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(10),
              child: CustomPrimaryButton(
                title: 'Apply',
                btnColor: CustomColors.primary,
                btnTextColor: CustomColors.white,
                btnIcon: const Icon(
                  Icons.check,
                  color: CustomColors.white,
                ),
                onTap: () {
                  ref
                      .read(filtersProvider.notifier)
                      .updateSelectedLocalities(localities);
                  ref.read(navBarIndexProvider.notifier).setNavBarIndex(1);
                  Navigator.pop(context);
                },
              ),
            )
        ],
      ),
    );
  }
}
