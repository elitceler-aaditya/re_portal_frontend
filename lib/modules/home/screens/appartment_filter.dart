import 'package:flutter/material.dart';
import 'package:re_portal_frontend/modules/home/widgets/filter_button.dart';
import 'package:re_portal_frontend/modules/shared/widgets/colors.dart';

class AppartmentFilter extends StatefulWidget {
  const AppartmentFilter({super.key});

  @override
  State<AppartmentFilter> createState() => _AppartmentFilterState();
}

class _AppartmentFilterState extends State<AppartmentFilter> {
  int appartmentType = 0;
  int configurationType = 0;
  double _minBudget = 10.0;
  double _maxBudget = 300.0;

  double _minFlatSize = 50;
  double _maxFlatSize = 5000;

  String formatBudget(double budget) {
    //return budget in k format or lakh format
    if (budget < 100) {
      return "${budget.toStringAsFixed(0)}k";
    } else if (budget < 1000) {
      return "${(budget / 100).toStringAsFixed(2)}L";
    } else {
      return "${(budget / 100).toStringAsFixed(0)}L";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
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
                    Text("₹${formatBudget(10)}"),
                    Text("₹${formatBudget(300)}"),
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
                    min: 10.0,
                    max: 300.0,
                    divisions: 20,
                    labels: RangeLabels(
                      '₹${formatBudget(_minBudget)}',
                      '₹${formatBudget(_maxBudget)}',
                    ),
                    values: RangeValues(_minBudget, _maxBudget),
                    onChanged: (RangeValues values) {
                      setState(() {
                        _minBudget = values.start;
                        _maxBudget = values.end;
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
                    Text("${_minFlatSize.toStringAsFixed(1)} sq.ft"),
                    Text("${_maxFlatSize.toInt()}+ sq.ft"),
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
                    min: 50,
                    max: 5000,
                    divisions: 100,
                    labels: RangeLabels(
                      '${_minFlatSize.toInt()}',
                      '${_maxFlatSize.toInt()}',
                    ),
                    values: RangeValues(_minFlatSize, _maxFlatSize),
                    onChanged: (RangeValues values) {
                      setState(() {
                        _minFlatSize = values.start;
                        _maxFlatSize = values.end;
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
