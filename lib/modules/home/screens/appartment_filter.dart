import 'package:flutter/material.dart';
import 'package:re_portal_frontend/modules/home/widgets/filter_button.dart';
import 'package:re_portal_frontend/modules/shared/models/appartment_model.dart';
import 'package:re_portal_frontend/modules/shared/widgets/colors.dart';

class AppartmentFilter extends StatefulWidget {
  final List<ApartmentModel> apartmentList;
  const AppartmentFilter({super.key, required this.apartmentList});

  @override
  State<AppartmentFilter> createState() => _AppartmentFilterState();
}

class _AppartmentFilterState extends State<AppartmentFilter> {
  bool _loading = true;
  int appartmentType = 0;
  int configurationType = 0;
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
    //get all localities
    setState(() {
      localities = widget.apartmentList.map((e) => e.locality).toList();
      amenities = widget.apartmentList.map((e) => e.amenities).toList();
      //min and max budget
      _minBudget = widget.apartmentList
          .map((e) => e.budget)
          .reduce((value, element) => value < element ? value : element)
          .toDouble();
      _maxBudget = widget.apartmentList
          .map((e) => e.budget)
          .reduce((value, element) => value > element ? value : element)
          .toDouble();

      //min and max flat size
      _minFlatSize = widget.apartmentList
          .map((e) => e.flatSize)
          .reduce((value, element) => value < element ? value : element)
          .toDouble();
      _maxFlatSize = widget.apartmentList
          .map((e) => e.flatSize)
          .reduce((value, element) => value > element ? value : element)
          .toDouble();

      _budgetSliderMin = _minBudget;
      _budgetSliderMax = _maxBudget;
      _flatSizeSliderMin = _minFlatSize;
      _flatSizeSliderMax = _maxFlatSize;

      _loading = false;
    });
  }

  @override
  void initState() {
    initValues();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _loading
        ? const Center(
            child: SizedBox(
              height: 100,
              width: 100,
              child: CircularProgressIndicator(
                color: CustomColors.primary,
              ),
            ),
          )
        : Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Padding(
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

                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            CustomRadioButton(
                              text: "Standalone",
                              isSelected: appartmentType == 0,
                              onTap: () {
                                setState(() {
                                  appartmentType = 0;
                                });
                              },
                            ),
                            CustomRadioButton(
                              text: "Semi-gated",
                              isSelected: appartmentType == 1,
                              onTap: () {
                                setState(() {
                                  appartmentType = 1;
                                });
                              },
                            ),
                            CustomRadioButton(
                              text: "Fully-gated",
                              isSelected: appartmentType == 2,
                              onTap: () {
                                setState(() {
                                  appartmentType = 2;
                                });
                              },
                            ),
                          ],
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

                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            CustomRadioButton(
                              text: "1 BHK",
                              isSelected: configurationType == 0,
                              onTap: () {
                                setState(() {
                                  configurationType = 0;
                                });
                              },
                            ),
                            CustomRadioButton(
                              text: "2 BHK",
                              isSelected: configurationType == 1,
                              onTap: () {
                                setState(() {
                                  configurationType = 1;
                                });
                              },
                            ),
                            CustomRadioButton(
                              text: "3 BHK",
                              isSelected: configurationType == 2,
                              onTap: () {
                                setState(() {
                                  configurationType = 2;
                                });
                              },
                            ),
                            CustomRadioButton(
                              text: "4 BHK",
                              isSelected: configurationType == 3,
                              onTap: () {
                                setState(() {
                                  configurationType = 3;
                                });
                              },
                            ),
                            CustomRadioButton(
                              text: "4+ BHK",
                              isSelected: configurationType == 4,
                              onTap: () {
                                setState(() {
                                  configurationType = 4;
                                });
                              },
                            ),
                          ],
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
                          Text("₹${formatBudget(_minBudget)}"),
                          Text("₹${formatBudget(_maxBudget)}"),
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
                          Text("${_minFlatSize.toInt()} sq.ft"),
                          Text("${_maxFlatSize.toInt()} sq.ft"),
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
                          Navigator.pop(context);
                        },
                        child: Container(
                          height: 60,
                          width: double.infinity,
                          color: CustomColors.primary20,
                          child: const Center(
                            child: Text(
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
