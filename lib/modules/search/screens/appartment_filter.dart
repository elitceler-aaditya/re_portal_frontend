import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:re_portal_frontend/modules/home/widgets/custom_chip.dart';
import 'package:re_portal_frontend/modules/home/widgets/filter_button.dart';
import 'package:re_portal_frontend/modules/shared/models/appartment_model.dart';
import 'package:re_portal_frontend/modules/shared/widgets/colors.dart';
import 'package:http/http.dart' as http;
import 'package:re_portal_frontend/riverpod/filters_rvpd.dart';
import 'package:re_portal_frontend/riverpod/home_data.dart';
import 'package:re_portal_frontend/riverpod/locality_list.dart';

class AppartmentFilter extends ConsumerStatefulWidget {
  const AppartmentFilter({
    super.key,
  });

  @override
  ConsumerState<AppartmentFilter> createState() => _AppartmentFilterState();
}

class _AppartmentFilterState extends ConsumerState<AppartmentFilter> {
  bool _loading = false;
  int? appartmentType;
  List<String> selectedConfigurations = [];

  double _minBudget = 0;
  double _maxBudget = 1;
  double _budgetSliderMin = 1;
  double _budgetSliderMax = 1;
  double _minFlatSize = 0;
  double _maxFlatSize = 1;
  double _flatSizeSliderMin = 1;
  double _flatSizeSliderMax = 1;
  List<String> localities = [];
  List<String> amenities = [];
  List<String> apartmentTypeList = [
    "Standalone",
    "Semi-gated",
    "Fully-gated",
  ];

  List<String> configurationList = [
    "1 BHK",
    "2 BHK",
    "3 BHK",
    "4 BHK",
    "5 BHK",
    "5+ BHK",
  ];

  List<String> typeList = [
    "New Project",
    "Ready To Move",
    "Under Construction",
  ];

  List saleTypeList = [
    {
      'label': "New sale",
      'filter': FiltersModel(newSaleType: 'true'),
    },
    {
      'label': "Resale",
      'filter': FiltersModel(resaleType: 'true'),
    },
  ];

  List postedByList = [
    {
      'label': "Posted By Builder",
      'filter': FiltersModel(postedByBuilder: 'true'),
    },
    {
      'label': "Posted By Owner",
      'filter': FiltersModel(postedByOwner: 'true'),
    },
    {
      'label': "Posted By Agent",
      'filter': FiltersModel(postedByAgent: 'true'),
    },
  ];

  List<String> basicAmenities = [
    'Parking',
    'Gym',
    'Pool',
    'Internet',
    'Laundry',
    'Pet-Friendly',
    'Balcony',
    'Storage',
    'Security',
    'Air Conditioning'
  ];
  final TextEditingController _localitySearchController =
      TextEditingController();
  final TextEditingController _amenitySearchController =
      TextEditingController();

  updateFilters() {
    ref.watch(filtersProvider.notifier).setAllFilters(
          FiltersModel(
            selectedLocalities: localities,
            apartmentType: appartmentType == null
                ? ''
                : apartmentTypeList[appartmentType!],
            amenities: amenities,
            selectedConfigurations: selectedConfigurations,
            minBudget: _budgetSliderMin,
            maxBudget: _budgetSliderMax,
            minFlatSize: _flatSizeSliderMin,
            maxFlatSize: _flatSizeSliderMax,
            newProject: ref.watch(filtersProvider).newProject,
            readyToMove: ref.watch(filtersProvider).readyToMove,
            underConstruction: ref.watch(filtersProvider).underConstruction,
            newSaleType: ref.watch(filtersProvider).newSaleType,
            resaleType: ref.watch(filtersProvider).resaleType,
            postedByBuilder: ref.watch(filtersProvider).postedByBuilder,
            postedByOwner: ref.watch(filtersProvider).postedByOwner,
            postedByAgent: ref.watch(filtersProvider).postedByAgent,
          ),
        );

    getFilteredApartments();
  }

  Future<void> getFilteredApartments() async {
    if (!mounted) return;
    setState(() {
      _loading = true;
    });
    try {
      Map<String, dynamic> params = {
        'minBudget': _minBudget == _budgetSliderMin
            ? '0'
            : _budgetSliderMin.toStringAsFixed(0),
        'maxBudget': _maxBudget == _budgetSliderMax
            ? '99999999'
            : _budgetSliderMax.toStringAsFixed(0),
        // 'minFlatSize': _flatSizeSliderMin.toStringAsFixed(0),
        // 'maxFlatSize': _flatSizeSliderMax.toStringAsFixed(0),
      };

      if (localities.isNotEmpty) {
        params['projectLocation'] = localities.join(',');
      }
      if (amenities.isNotEmpty) {
        params['amenities'] = amenities.join(',');
      }
      if (appartmentType != null &&
          appartmentType! < apartmentTypeList.length) {
        params['projectType'] = apartmentTypeList[appartmentType!];
      }
      if (selectedConfigurations.isNotEmpty) {
        params['BHKType'] = selectedConfigurations
            .map((config) => config.replaceAll(" ", ""))
            .join(',');
      }

      if (ref.watch(filtersProvider).newProject == 'true') {
        params['newProject'] = 'true';
      }
      if (ref.watch(filtersProvider).readyToMove == 'true') {
        params['readyToMove'] = 'true';
      }
      if (ref.watch(filtersProvider).underConstruction == 'true') {
        params['underConstruction'] = 'true';
      }
      if (ref.watch(filtersProvider).newSaleType == 'true') {
        params['newSaleType'] = 'true';
      }
      if (ref.watch(filtersProvider).resaleType == 'true') {
        params['resaleType'] = 'true';
      }
      if (ref.watch(filtersProvider).postedByBuilder == 'true') {
        params['postedByBuilder'] = 'true';
      }
      if (ref.watch(filtersProvider).postedByOwner == 'true') {
        params['postedByOwner'] = 'true';
      }
      if (ref.watch(filtersProvider).postedByAgent == 'true') {
        params['postedByAgent'] = 'true';
      }

      debugPrint("-----------params: $params");

      String baseUrl = dotenv.get('BASE_URL');
      String url = "$baseUrl/project/filterApartmentsNew";
      Uri uri = Uri.parse(url).replace(queryParameters: params);

      final response = await http.get(
        uri,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        if (responseData['projects'] is List) {
          List<dynamic> responseBody = responseData['projects'];
          if (mounted) {
            ref.read(homePropertiesProvider.notifier).setfilteredApartments(
                  responseBody.map((e) => ApartmentModel.fromJson(e)).toList(),
                );
            debugPrint("Filtered apartments count: ${responseBody.length}");
            Navigator.pop(context);
          }
        } else {
          throw Exception('Invalid response format: projects is not a List');
        }
      } else {
        throw Exception(
            'Failed to load filtered apartments: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint("Error in getFilteredApartments: $e");
      // Show error message to user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load apartments: $e')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  String formatBudget(double budget) {
    //return budget in km lac and cr
    if (budget < 1000) {
      return budget.toStringAsFixed(0);
    } else if (budget < 100000) {
      return "${(budget / 1000).toStringAsFixed(0)}K";
    } else if (budget < 10000000) {
      return "${(budget / 100000).toStringAsFixed(0)}L";
    } else {
      return "${(budget / 10000000).toStringAsFixed(0)}Cr";
    }
  }

  void initValues() {
    // min and max budget
    _minBudget = ref
        .watch(homePropertiesProvider)
        .allApartments
        .map((e) => e.budget)
        .reduce((value, element) => value < element ? value : element)
        .toDouble();
    _maxBudget = ref
        .watch(homePropertiesProvider)
        .allApartments
        .map((e) => e.budget)
        .reduce((value, element) => value > element ? value : element)
        .toDouble();
    //min and max flat size
    _minFlatSize = ref
        .watch(homePropertiesProvider)
        .allApartments
        .map((e) => double.parse(e.flatSize.toString()))
        .reduce((value, element) => value < element ? value : element);
    _maxFlatSize = ref
        .watch(homePropertiesProvider)
        .allApartments
        .map((e) => double.parse(e.flatSize.toString()))
        .reduce((value, element) => value > element ? value : element);

    localities = ref.watch(filtersProvider).selectedLocalities;
    int index = apartmentTypeList.indexWhere(
        (element) => element == ref.watch(filtersProvider).apartmentType);
    if (index != -1) {
      appartmentType = index;
    } else {
      // Handle case when ref.watch(filtersProvider).apartmentType is not in the list
    }
    amenities = ref.watch(filtersProvider).amenities;
    selectedConfigurations = ref.watch(filtersProvider).selectedConfigurations;
    _budgetSliderMin = ref.watch(filtersProvider).minBudget == 0
        ? _minBudget
        : ref.watch(filtersProvider).minBudget;
    _budgetSliderMax = ref.watch(filtersProvider).maxBudget == 0
        ? _maxBudget
        : ref.watch(filtersProvider).maxBudget;
    _flatSizeSliderMin = ref.watch(filtersProvider).minFlatSize == 0
        ? _minFlatSize
        : ref.watch(filtersProvider).minFlatSize;
    _flatSizeSliderMax = ref.watch(filtersProvider).maxFlatSize == 0
        ? _maxFlatSize
        : ref.watch(filtersProvider).maxFlatSize;
    setState(() {});
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      initValues();
      ref.read(filtersProvider.notifier).clearBuilderName();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 50),
                      const Text(
                        "Filters",
                        style: TextStyle(
                          color: CustomColors.primary,
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      RichText(
                        text: const TextSpan(
                          style: TextStyle(
                            color: CustomColors.secondary,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                          children: [
                            TextSpan(text: "You are searching in "),
                            TextSpan(
                              text: "Hyderabad",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      const Divider(
                        color: CustomColors.secondary,
                        height: 30,
                      ),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Localities",
                            style: TextStyle(
                              color: CustomColors.secondary,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            "Add upto 4 locations",
                            style: TextStyle(
                              color: CustomColors.black50,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      //search box
                      const SizedBox(height: 10),
                      SizedBox(
                        height: 44,
                        child: TextField(
                          controller: _localitySearchController,
                          onChanged: (value) {
                            setState(() {});
                          },
                          decoration: InputDecoration(
                            hintText: 'Search for localities',
                            hintStyle: const TextStyle(
                                color: CustomColors.black25,
                                fontWeight: FontWeight.w600),
                            prefixIcon: const Icon(Icons.search,
                                color: CustomColors.black50),
                            filled: true,
                            fillColor: CustomColors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide:
                                  const BorderSide(color: CustomColors.black25),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide:
                                  const BorderSide(color: CustomColors.black25),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide:
                                  const BorderSide(color: CustomColors.primary),
                            ),
                          ),
                          style: const TextStyle(
                            fontSize: 14,
                            color: CustomColors.black,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            ...localities.take(4).map(
                                  (e) => CustomListChip(
                                    text: e,
                                    isSelected: true,
                                    onTap: () {
                                      setState(() {
                                        localities.remove(e);
                                      });
                                    },
                                  ),
                                ),
                            if (_localitySearchController.text.isNotEmpty &&
                                localities.length < 4)
                              ...ref
                                  .watch(localityListProvider)
                                  .toSet()
                                  .where((e) => e.toLowerCase().contains(
                                      _localitySearchController.text
                                          .trim()
                                          .toLowerCase()))
                                  .where((e) => !localities.contains(e))
                                  .take(4 - localities.length)
                                  .map(
                                    (e) => CustomListChip(
                                      text: e,
                                      isSelected: false,
                                      onTap: () {
                                        setState(() {
                                          if (localities.length < 4) {
                                            localities.add(e);
                                            _localitySearchController.clear();
                                          }
                                        });
                                      },
                                    ),
                                  ),
                          ],
                        ),
                      ),

                      const Divider(
                        color: CustomColors.secondary,
                        height: 30,
                      ),

                      const Text(
                        "Apartment Types",
                        style: TextStyle(
                          color: CustomColors.secondary,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 6),

                      SizedBox(
                        height: 36,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              CustomRadioButton(
                                text: "All",
                                isSelected: appartmentType == null,
                                onTap: () {
                                  setState(() {
                                    appartmentType = null;
                                  });
                                },
                              ),
                              ...List.generate(
                                apartmentTypeList.length,
                                (index) => CustomRadioButton(
                                  text: apartmentTypeList[index],
                                  isSelected: appartmentType == index,
                                  onTap: () {
                                    //tap to unselect
                                    if (appartmentType == index) {
                                      setState(() {
                                        appartmentType = null;
                                      });
                                    } else {
                                      setState(() {
                                        appartmentType = index;
                                      });
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const Divider(
                        color: CustomColors.secondary,
                        height: 30,
                      ),

                      const Text(
                        "Amenities",
                        style: TextStyle(
                          color: CustomColors.secondary,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      //search box
                      const SizedBox(height: 6),
                      SizedBox(
                        height: 44,
                        child: TextField(
                          controller: _amenitySearchController,
                          onChanged: (value) {
                            setState(() {});
                          },
                          decoration: InputDecoration(
                            hintText: 'Search Amenities',
                            hintStyle: const TextStyle(
                                color: CustomColors.black25,
                                fontWeight: FontWeight.w600),
                            prefixIcon: const Icon(Icons.search,
                                color: CustomColors.black50),
                            filled: true,
                            fillColor: CustomColors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide:
                                  const BorderSide(color: CustomColors.black25),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide:
                                  const BorderSide(color: CustomColors.black25),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide:
                                  const BorderSide(color: CustomColors.primary),
                            ),
                          ),
                          style: const TextStyle(
                            fontSize: 14,
                            color: CustomColors.black,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            if (_amenitySearchController.text.isNotEmpty)
                              ...basicAmenities
                                  .where((e) => e.toLowerCase().contains(
                                      _amenitySearchController.text
                                          .trim()
                                          .toLowerCase()))
                                  .map(
                                    (e) => CustomListChip(
                                      text: e,
                                      isSelected: amenities.contains(e),
                                      onTap: () {
                                        setState(() {
                                          if (amenities.contains(e)) {
                                            amenities.remove(e);
                                          } else {
                                            amenities.add(e);
                                          }
                                        });
                                        _amenitySearchController.clear();
                                      },
                                    ),
                                  ),
                            if (_amenitySearchController.text.isEmpty)
                              ...amenities.map(
                                (e) => CustomListChip(
                                  text: e,
                                  isSelected: true,
                                  onTap: () {
                                    setState(() {
                                      amenities.remove(e);
                                    });
                                    _amenitySearchController.clear();
                                  },
                                ),
                              ),
                            if (_amenitySearchController.text.isEmpty)
                              ...basicAmenities
                                  .where((e) => !amenities.contains(e))
                                  .map(
                                    (e) => CustomListChip(
                                      text: e,
                                      isSelected: false,
                                      onTap: () {
                                        setState(() {
                                          if (amenities.contains(e)) {
                                            amenities.remove(e);
                                          } else {
                                            amenities.add(e);
                                          }
                                        });
                                        _amenitySearchController.clear();
                                      },
                                    ),
                                  ),
                          ],
                        ),
                      ),

                      const Divider(
                        color: CustomColors.secondary,
                        height: 30,
                      ),
                      const Text(
                        "Configuration",
                        style: TextStyle(
                          color: CustomColors.secondary,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 6),

                      SizedBox(
                        height: 36,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: configurationList.length,
                          itemBuilder: (context, index) {
                            return CustomRadioButton(
                              text: configurationList[index],
                              isSelected: selectedConfigurations
                                  .contains(configurationList[index]),
                              onTap: () {
                                setState(() {
                                  if (selectedConfigurations
                                      .contains(configurationList[index])) {
                                    selectedConfigurations = [];
                                  } else {
                                    selectedConfigurations = [
                                      configurationList[index]
                                    ];
                                  }
                                });
                              },
                            );
                          },
                        ),
                      ),

                      const Divider(
                        color: CustomColors.secondary,
                        height: 30,
                      ),
                      const Text(
                        "Type",
                        style: TextStyle(
                          color: CustomColors.secondary,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 6),

                      SizedBox(
                        height: 36,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: typeList.length,
                          itemBuilder: (context, index) {
                            return CustomRadioButton(
                              text: typeList[index],
                              isSelected:
                                  ref.watch(filtersProvider).newProject ==
                                              'true' &&
                                          index == 0 ||
                                      ref.watch(filtersProvider).readyToMove ==
                                              'true' &&
                                          index == 1 ||
                                      ref
                                                  .watch(filtersProvider)
                                                  .underConstruction ==
                                              'true' &&
                                          index == 2,
                              onTap: () {
                                setState(() {
                                  switch (index) {
                                    case 0:
                                      ref
                                          .read(filtersProvider.notifier)
                                          .updateNewProject(ref
                                                      .watch(filtersProvider)
                                                      .newProject ==
                                                  'true'
                                              ? 'false'
                                              : 'true');
                                      ref
                                          .read(filtersProvider.notifier)
                                          .updateReadyToMove('false');
                                      ref
                                          .read(filtersProvider.notifier)
                                          .updateUnderConstruction('false');
                                      break;
                                    case 1:
                                      ref
                                          .read(filtersProvider.notifier)
                                          .updateReadyToMove(ref
                                                      .watch(filtersProvider)
                                                      .readyToMove ==
                                                  'true'
                                              ? 'false'
                                              : 'true');
                                      ref
                                          .read(filtersProvider.notifier)
                                          .updateNewProject('false');
                                      ref
                                          .read(filtersProvider.notifier)
                                          .updateUnderConstruction('false');
                                      break;
                                    case 2:
                                      ref
                                          .read(filtersProvider.notifier)
                                          .updateUnderConstruction(ref
                                                      .watch(filtersProvider)
                                                      .underConstruction ==
                                                  'true'
                                              ? 'false'
                                              : 'true');
                                      ref
                                          .read(filtersProvider.notifier)
                                          .updateNewProject('false');
                                      ref
                                          .read(filtersProvider.notifier)
                                          .updateReadyToMove('false');
                                      break;
                                  }
                                });
                              },
                            );
                          },
                        ),
                      ),

                      const Divider(
                        color: CustomColors.secondary,
                        height: 30,
                      ),
                      const Text(
                        "Posted By",
                        style: TextStyle(
                          color: CustomColors.secondary,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 6),
                      SizedBox(
                        height: 36,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: postedByList.length,
                          itemBuilder: (context, index) {
                            return CustomRadioButton(
                              text: postedByList[index]['label'],
                              isSelected: (index == 0 &&
                                      ref
                                              .watch(filtersProvider)
                                              .postedByBuilder ==
                                          'true') ||
                                  (index == 1 &&
                                      ref
                                              .watch(filtersProvider)
                                              .postedByOwner ==
                                          'true') ||
                                  (index == 2 &&
                                      ref
                                              .watch(filtersProvider)
                                              .postedByAgent ==
                                          'true'),
                              onTap: () {
                                setState(() {
                                  if (index == 0) {
                                    ref
                                        .read(filtersProvider.notifier)
                                        .updatePostedByBuilder(ref
                                                    .watch(filtersProvider)
                                                    .postedByBuilder ==
                                                'true'
                                            ? 'false'
                                            : 'true');
                                  } else if (index == 1) {
                                    ref
                                        .read(filtersProvider.notifier)
                                        .updatePostedByOwner(ref
                                                    .watch(filtersProvider)
                                                    .postedByOwner ==
                                                'true'
                                            ? 'false'
                                            : 'true');
                                  } else if (index == 2) {
                                    ref
                                        .read(filtersProvider.notifier)
                                        .updatePostedByAgent(ref
                                                    .watch(filtersProvider)
                                                    .postedByAgent ==
                                                'true'
                                            ? 'false'
                                            : 'true');
                                  }
                                });
                              },
                            );
                          },
                        ),
                      ),

                      const Divider(
                        color: CustomColors.secondary,
                        height: 30,
                      ),

                      const Text(
                        "Sale Type",
                        style: TextStyle(
                          color: CustomColors.secondary,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 6),

                      SizedBox(
                        height: 36,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: saleTypeList.length,
                          itemBuilder: (context, index) {
                            return CustomRadioButton(
                              text: saleTypeList[index]['label'],
                              isSelected: (index == 0 &&
                                      ref.watch(filtersProvider).newSaleType ==
                                          'true') ||
                                  (index == 1 &&
                                      ref.watch(filtersProvider).resaleType ==
                                          'true'),
                              onTap: () {
                                setState(() {
                                  if (index == 0) {
                                    ref
                                        .read(filtersProvider.notifier)
                                        .updateNewSaleType(ref
                                                    .watch(filtersProvider)
                                                    .newSaleType ==
                                                'true'
                                            ? 'false'
                                            : 'true');
                                  } else if (index == 1) {
                                    ref
                                        .read(filtersProvider.notifier)
                                        .updateResaleType(ref
                                                    .watch(filtersProvider)
                                                    .resaleType ==
                                                'true'
                                            ? 'false'
                                            : 'true');
                                  }
                                });
                              },
                            );
                          },
                        ),
                      ),

                      const Divider(
                        color: CustomColors.secondary,
                        height: 30,
                      ),

                      const Text(
                        "Budget",
                        style: TextStyle(
                          color: CustomColors.secondary,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text("₹${formatBudget(_budgetSliderMin)}"),
                          Text("₹${formatBudget(_budgetSliderMax)}"),
                        ],
                      ),
                      SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          activeTrackColor: CustomColors.primary,
                          inactiveTrackColor: CustomColors.black10,
                          thumbColor: CustomColors.primary,
                          overlayColor: CustomColors.primary.withOpacity(0.2),
                          valueIndicatorColor: CustomColors.primary,
                          valueIndicatorTextStyle: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                        child: RangeSlider(
                          min: _minBudget,
                          max: _maxBudget,
                          divisions: ref
                              .watch(homePropertiesProvider)
                              .allApartments
                              .length,
                          labels: RangeLabels(
                            '₹${formatBudget(_budgetSliderMin)}',
                            '₹${formatBudget(_budgetSliderMax)}',
                          ),
                          values: RangeValues(_budgetSliderMin,
                              _budgetSliderMax), // Update the values to use _budgetSliderMin and _budgetSliderMax
                          onChanged: (RangeValues values) {
                            setState(() {
                              _budgetSliderMin = values.start;
                              _budgetSliderMax = values.end;
                            });
                          },
                        ),
                      ),

                      const Divider(
                        color: CustomColors.secondary,
                        height: 30,
                      ),
                      const Text(
                        "Flat Size",
                        style: TextStyle(
                          color: CustomColors.secondary,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text("${_flatSizeSliderMin.toInt()} sq.ft"),
                          Text("${_flatSizeSliderMax.toInt()} sq.ft"),
                        ],
                      ),
                      SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          activeTrackColor: CustomColors.primary,
                          inactiveTrackColor: CustomColors.black10,
                          thumbColor: CustomColors.primary,
                          overlayColor: CustomColors.primary.withOpacity(0.2),
                          valueIndicatorColor: CustomColors.primary,
                          valueIndicatorTextStyle: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                        child: RangeSlider(
                          min: _minFlatSize,
                          max: _maxFlatSize,
                          divisions: ref
                              .watch(homePropertiesProvider)
                              .allApartments
                              .length,
                          labels: RangeLabels(
                            '${_flatSizeSliderMin.toStringAsFixed(1)} sq.ft',
                            '${_flatSizeSliderMax.toInt()} sq.ft',
                          ),
                          values: RangeValues(
                              _flatSizeSliderMin, _flatSizeSliderMax),
                          onChanged: (RangeValues values) {
                            setState(() {
                              _flatSizeSliderMin = values.start;
                              _flatSizeSliderMax = values.end;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          height: 60,
          width: double.infinity,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                spreadRadius: 10,
              ),
            ],
            color: Colors.white,
          ),
          child: Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    height: 60,
                    width: double.infinity,
                    color: Colors.white,
                    child: const Center(
                      child: Text(
                        "Cancel",
                        style: TextStyle(
                          color: CustomColors.black,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    updateFilters();
                  },
                  child: Container(
                    height: 60,
                    width: double.infinity,
                    color: CustomColors.primary20,
                    child: Center(
                      child: _loading
                          ? const Center(
                              child: CircularProgressIndicator(
                                color: CustomColors.primary,
                              ),
                            )
                          : const Text(
                              "Apply",
                              style: TextStyle(
                                color: CustomColors.primary,
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
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
    );
  }
}
