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
import 'package:re_portal_frontend/riverpod/user_riverpod.dart';

class AppartmentFilter extends ConsumerStatefulWidget {
  final List<ApartmentModel> apartmentList;
  const AppartmentFilter({super.key, required this.apartmentList});

  @override
  ConsumerState<AppartmentFilter> createState() => _AppartmentFilterState();
}

class _AppartmentFilterState extends ConsumerState<AppartmentFilter> {
  bool _loading = false;
  int appartmentType = 0;
  List<String> selectedConfigurations = [];
  final double _minBudget = 0;
  final double _maxBudget = 1;
  double _budgetSliderMin = 1;
  double _budgetSliderMax = 1;
  final double _minFlatSize = 0;
  final double _maxFlatSize = 1;
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
    "4+ BHK"
  ];

  updateFilters() {
    ref.watch(filtersProvider.notifier).setAllFilters(
          FiltersModel(
            selectedLocalities: localities,
            apartmentType: apartmentTypeList[appartmentType],
            amenities: amenities,
            selectedConfigurations: selectedConfigurations,
            minBudget: _budgetSliderMin,
            maxBudget: _budgetSliderMax,
            minFlatSize: _flatSizeSliderMin,
            maxFlatSize: _flatSizeSliderMax,
          ),
        );

    getFilteredApartments();
  }

  Future<void> getFilteredApartments() async {
    setState(() {
      _loading = true;
    });
    Map<String, dynamic> params = {
      'budgetMin': _budgetSliderMin.toString(),
      'budgetMax': _budgetSliderMax.toString(),
      'flatSizeMin': _flatSizeSliderMin.toString(),
      'flatSizeMax': _flatSizeSliderMax.toString(),
    };

    if (localities.isNotEmpty) {
      params['locality'] = localities.join(',');
    }
    if (amenities.isNotEmpty) {
      params['amenities'] = amenities.join(',');
    }
    if (appartmentType != 0) {
      params['apartmentType'] = apartmentTypeList[appartmentType];
    }
    if (selectedConfigurations.isNotEmpty) {
      params['configuration'] = selectedConfigurations;
    }

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
      }
      Navigator.pop(context);
      setState(() {
        _loading = false;
      });
    }).catchError((error) {
      debugPrint("------------error$error");
    });
    setState(() {
      _loading = false;
    });
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
    //min and max budget
    // _minBudget = widget.apartmentList
    //     .map((e) => e.budget)
    //     .reduce((value, element) => value < element ? value : element)
    //     .toDouble();
    // _maxBudget = widget.apartmentList
    //     .map((e) => e.budget)
    //     .reduce((value, element) => value > element ? value : element)
    //     .toDouble();
    // //min and max flat size
    // _minFlatSize = widget.apartmentList
    //     .map((e) => e.flatSize)
    //     .reduce((value, element) => value < element ? value : element)
    //     .toDouble();
    // _maxFlatSize = widget.apartmentList
    //     .map((e) => e.flatSize)
    //     .reduce((value, element) => value > element ? value : element)
    //     .toDouble();

    localities = ref.watch(filtersProvider).selectedLocalities;
    appartmentType = apartmentTypeList.indexWhere(
        (element) => element == ref.watch(filtersProvider).apartmentType);
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
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
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
                    decoration: InputDecoration(
                      hintText: 'Search for localities',
                      hintStyle: const TextStyle(
                          color: CustomColors.black25,
                          fontWeight: FontWeight.w600),
                      prefixIcon:
                          const Icon(Icons.search, color: CustomColors.black50),
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
                      ...localities.map(
                        (e) => CustomListChip(
                          text: e,
                          isSelected: true,
                          onTap: () {
                            localities.remove(e);
                            setState(() {});
                          },
                        ),
                      ),
                      // ...widget.apartmentList
                      //     .map((e) => e.locality.trim())
                      //     .where((e) => !localities.contains(e))
                      //     .toSet()
                      //     .map(
                      //       (e) => CustomListChip(
                      //         text: e,
                      //         isSelected: false,
                      //         onTap: () {
                      //           if (localities.contains(e)) {
                      //             localities.remove(e);
                      //           } else {
                      //             localities.add(e);
                      //           }
                      //           setState(() {});
                      //         },
                      //       ),
                      //     ),
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
                  height: 30,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: apartmentTypeList.length,
                    itemBuilder: (context, index) {
                      return CustomRadioButton(
                        text: apartmentTypeList[index],
                        isSelected: appartmentType == index,
                        onTap: () {
                          setState(() {
                            appartmentType = index;
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
                    decoration: InputDecoration(
                      hintText: 'Search Amenities',
                      hintStyle: const TextStyle(
                          color: CustomColors.black25,
                          fontWeight: FontWeight.w600),
                      prefixIcon:
                          const Icon(Icons.search, color: CustomColors.black50),
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
                      ...amenities.map(
                        (e) => CustomListChip(
                          text: e,
                          isSelected: true,
                          onTap: () {
                            amenities.remove(e);
                            setState(() {});
                          },
                        ),
                      ),
                      // ...widget.apartmentList
                      //     .map((e) => e.amenities)
                      //     .join(',')
                      //     .split(',')
                      //     .map((amenity) => amenity.trim())
                      //     .where((e) => e.isNotEmpty)
                      //     .where((e) => !amenities.contains(e))
                      //     .toSet()
                      //     .map(
                      //       (e) => CustomListChip(
                      //         text: e,
                      //         isSelected: false,
                      //         onTap: () {
                      //           if (amenities.contains(e)) {
                      //             amenities.remove(e);
                      //           } else {
                      //             amenities.add(e);
                      //           }
                      //           setState(() {});
                      //         },
                      //       ),
                      //     ),
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
                  height: 30,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 5,
                    itemBuilder: (context, index) {
                      return CustomRadioButton(
                        text: configurationList[index],
                        isSelected: selectedConfigurations
                            .contains(configurationList[index]),
                        onTap: () {
                          setState(() {
                            if (selectedConfigurations
                                .contains(configurationList[index])) {
                              selectedConfigurations
                                  .remove(configurationList[index]);
                            } else {
                              selectedConfigurations
                                  .add(configurationList[index]);
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
                    divisions: widget.apartmentList.length,
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
                    divisions: widget.apartmentList.length,
                    labels: RangeLabels(
                      '${_flatSizeSliderMin.toStringAsFixed(1)} sq.ft',
                      '${_flatSizeSliderMax.toInt()} sq.ft',
                    ),
                    values: RangeValues(_flatSizeSliderMin, _flatSizeSliderMax),
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
      ),
    );
  }
}
