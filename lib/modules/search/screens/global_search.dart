import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:re_portal_frontend/modules/home/widgets/custom_chip.dart';
import 'package:re_portal_frontend/modules/search/screens/search_apartments_results.dart';
import 'package:re_portal_frontend/modules/search/widgets/search_apartment.dart';
import 'package:re_portal_frontend/modules/shared/widgets/colors.dart';
import 'package:re_portal_frontend/modules/shared/widgets/custom_buttons.dart';
import 'package:re_portal_frontend/modules/shared/widgets/snackbars.dart';
import 'package:re_portal_frontend/riverpod/filters_rvpd.dart';
import 'package:re_portal_frontend/riverpod/home_data.dart';
import 'package:re_portal_frontend/riverpod/locality_list.dart';
import 'package:http/http.dart' as http;
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
      ref.read(filtersProvider.notifier).clearBuilderName();
      if (ref.watch(localityListProvider).isEmpty) {
        getLocalitiesList();
      }
      localities = ref.read(filtersProvider).selectedLocalities;
      ref.read(filtersProvider.notifier).clearAllFilters();
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
                  child: TextField(
                    controller: _searchController,
                    autofocus: true,
                    onChanged: (value) => setState(() {}),
                    onSubmitted: (value) {
                      ref.read(searchBarProvider.notifier).setSearchTerm(value);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SearchApartmentResults(),
                        ),
                      );
                    },
                    style: const TextStyle(fontSize: 14),
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 16),
                      hintText: 'Search from +1000 projects...',
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
                  if (_searchController.text.isEmpty && localities.isEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FutureBuilder<List<String>>(
                          future: SharedPreferences.getInstance().then(
                              (prefs) =>
                                  prefs.getStringList('searchHistory') ?? []),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const SizedBox.shrink();
                            } else if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            } else if (!snapshot.hasData ||
                                snapshot.data!.isEmpty) {
                              return const SizedBox.shrink();
                            } else {
                              final limitedSearchHistory =
                                  snapshot.data!.take(5).toList();
                              return Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.fromLTRB(4, 10, 4, 4),
                                    child: Text(
                                      "Recent Searches",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: CustomColors.primary,
                                      ),
                                    ),
                                  ),
                                  ListView.builder(
                                    padding: EdgeInsets.zero,
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: limitedSearchHistory.length,
                                    itemBuilder: (context, index) {
                                      final searchTerm =
                                          limitedSearchHistory[index];
                                      return ListTile(
                                        leading: const Icon(Icons.history),
                                        title: Text(searchTerm),
                                        onTap: () {
                                          ref
                                              .read(filtersProvider.notifier)
                                              .updateSelectedLocalities(
                                                  [searchTerm]);
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  const SearchApartmentResults(),
                                            ),
                                          );
                                        },
                                      );
                                    },
                                  ),
                                ],
                              );
                            }
                          },
                        ),
                      ],
                    ),
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
                        if (localities.isNotEmpty)
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
                        if (ref
                            .watch(localityListProvider.notifier)
                            .searchLocality(
                                _searchController.text.trim(), localities)
                            .isNotEmpty)
                          _searchController.text.trim().isEmpty
                              ? const SizedBox.shrink()
                              : ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  padding: EdgeInsets.zero,
                                  itemCount: ref
                                      .read(localityListProvider.notifier)
                                      .searchLocality(
                                          _searchController.text.trim(),
                                          localities)
                                      .length,
                                  itemBuilder: (context, index) {
                                    return GestureDetector(
                                      onTap: () async {
                                        // Add the locality to the search history in SharedPreferences
                                        SharedPreferences prefs =
                                            await SharedPreferences
                                                .getInstance();
                                        List<String> searchHistory =
                                            prefs.getStringList(
                                                    'searchHistory') ??
                                                [];
                                        final localityToAdd = ref
                                            .read(localityListProvider.notifier)
                                            .searchLocality(
                                              _searchController.text.trim(),
                                              localities,
                                            )[index];
                                        if (!searchHistory
                                            .contains(localityToAdd)) {
                                          searchHistory.insert(0,
                                              localityToAdd); // Add to the beginning of the list
                                          searchHistory = searchHistory
                                              .take(10)
                                              .toList(); // Keep only the 10 most recent
                                          await prefs.setStringList(
                                              'searchHistory', searchHistory);
                                        }

                                        final localityProvider = ref.read(
                                            localityListProvider.notifier);
                                        final searchedLocality =
                                            localityProvider.searchLocality(
                                          _searchController.text.trim(),
                                          localities,
                                        )[index];

                                        setState(() {
                                          final modifiableLocalities =
                                              List<String>.from(localities);
                                          if (modifiableLocalities
                                              .contains(searchedLocality)) {
                                            modifiableLocalities
                                                .remove(searchedLocality);
                                          } else if (modifiableLocalities
                                                  .length <
                                              4) {
                                            modifiableLocalities
                                                .add(searchedLocality);
                                            _searchController.clear();
                                          } else {
                                            errorSnackBar(context,
                                                "You can only select 4 localities");
                                          }
                                          localities = modifiableLocalities;
                                        });
                                      },
                                      child: Container(
                                        margin:
                                            const EdgeInsets.only(bottom: 4),
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: localities.contains(ref
                                                  .read(localityListProvider
                                                      .notifier)
                                                  .searchLocality(
                                                      _searchController.text
                                                          .trim(),
                                                      localities)[index])
                                              ? CustomColors.primary20
                                              : CustomColors.black10,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(ref
                                                .read(localityListProvider
                                                    .notifier)
                                                .searchLocality(
                                                    _searchController.text
                                                        .trim(),
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
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: ref
                                .watch(homePropertiesProvider.notifier)
                                .getApartmentsByName(
                                    _searchController.text.trim())
                                .length,
                            itemBuilder: (context, index) =>
                                SearchApartmentCard(
                              apartment: ref
                                  .watch(homePropertiesProvider.notifier)
                                  .getApartmentsByName(
                                      _searchController.text.trim())[index],
                            ),
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
                              ref
                                  .watch(homePropertiesProvider.notifier)
                                  .getBuilderNames(
                                      _searchController.text.trim())
                                  .length,
                              (index) => GestureDetector(
                                onTap: () {
                                  ref
                                      .read(filtersProvider.notifier)
                                      .updateBuilderName(ref
                                          .watch(
                                              homePropertiesProvider.notifier)
                                          .getBuilderNames(_searchController
                                              .text
                                              .trim())[index]
                                          .CompanyName);

                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const SearchApartmentResults(),
                                    ),
                                  );
                                },
                                child: Container(
                                  height: 80,
                                  width: 140,
                                  margin: const EdgeInsets.only(right: 10),
                                  decoration: BoxDecoration(
                                    color: CustomColors.black,
                                    borderRadius: BorderRadius.circular(10),
                                    image: DecorationImage(
                                      image: NetworkImage(ref
                                          .watch(
                                              homePropertiesProvider.notifier)
                                          .getBuilderNames(_searchController
                                              .text
                                              .trim())[index]
                                          .CompanyLogo),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  alignment: Alignment.center,
                                  child: Stack(
                                    children: [
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
                                            ref
                                                .watch(homePropertiesProvider
                                                    .notifier)
                                                .getBuilderNames(
                                                    _searchController.text
                                                        .trim())[index]
                                                .CompanyName,
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
                btnIcon: const Icon(
                  Icons.check,
                  color: CustomColors.white,
                ),
                onTap: () {
                  ref
                      .read(filtersProvider.notifier)
                      .updateSelectedLocalities(localities);
                  Navigator.push(
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
