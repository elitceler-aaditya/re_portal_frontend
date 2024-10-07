import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:re_portal_frontend/modules/home/models/compare_property_data.dart';
import 'package:re_portal_frontend/modules/home/screens/compare/table.dart';
import 'package:re_portal_frontend/modules/shared/models/appartment_model.dart';
import 'package:re_portal_frontend/modules/shared/widgets/colors.dart';
import 'package:re_portal_frontend/riverpod/bot_nav_bar.dart';
import 'package:re_portal_frontend/riverpod/compare_appartments.dart';
import 'package:http/http.dart' as http;

class CompareProperties extends ConsumerStatefulWidget {
  const CompareProperties({super.key});

  @override
  ConsumerState<CompareProperties> createState() => _ComparePropertiesState();
}

class _ComparePropertiesState extends ConsumerState<CompareProperties> {
  bool _isFixedColumnVisible = true;
  bool _isLoading = true;
  List<ComparePropertyData> _comparedProperties = [];

  void getPropertyData() async {
    setState(() {
      _isLoading = true;
    });

    String baseUrl = dotenv.get('BASE_URL');
    String url = "$baseUrl/project/compareApartments";
    Uri uri = Uri.parse(url).replace(queryParameters: {
      "ids": ref
          .watch(comparePropertyProvider)
          .map((e) => e.apartmentID)
          .join(","),
    });

    try {
      final response = await http.get(uri);
      if (response.statusCode == 200 || response.statusCode == 201) {
        List<dynamic> responseBody = jsonDecode(response.body)['apartments'];
        _comparedProperties =
            responseBody.map((e) => ComparePropertyData.fromJson(e)).toList();
      } else {
        throw Exception(response.body);
      }
      setState(() {
        _isLoading = false;
      });
    } catch (error, stackTrace) {
      debugPrint("error: $error");
      debugPrint("stackTrace: $stackTrace");
      setState(() {
        _isLoading = false;
      });
    }
  }

  formatPrice(double price) {
    if (price > 1000000) {
      return '${(price / 1000000).toStringAsFixed(0)} Lac';
    } else if (price > 1000) {
      return '${(price / 1000).toStringAsFixed(0)} K';
    } else {
      return price.toStringAsFixed(0);
    }
  }

  formatBudget(double budget) {
    if (budget < 10000000) {
      return "${(budget / 100000).toStringAsFixed(2)} L";
    } else {
      return "${(budget / 10000000).toStringAsFixed(2)} Cr";
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getPropertyData();
    });
  }

  @override
  Widget build(BuildContext context) {
    List<ApartmentModel> comparedProperties =
        ref.watch(comparePropertyProvider);
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, results) {
        if (!didPop) ref.read(navBarIndexProvider.notifier).setNavBarIndex(0);
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: IconButton(
            onPressed: () {
              ref.read(navBarIndexProvider.notifier).setNavBarIndex(0);
            },
            icon: const Icon(Icons.arrow_back),
          ),
          backgroundColor: CustomColors.primary10,
          actions: [
            IconButton(
              onPressed: () {
                setState(() {
                  _isFixedColumnVisible = !_isFixedColumnVisible;
                });
              },
              icon: _isFixedColumnVisible
                  ? const Icon(
                      Icons.visibility,
                      color: CustomColors.primary,
                    )
                  : const Icon(
                      Icons.visibility_off,
                      color: CustomColors.primary,
                    ),
            ),
          ],
        ),
        body: comparedProperties.length < 2
            ? const SafeArea(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Compare with similar Apartments",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        "Please select atleast 2 properties to compare",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: CustomColors.black50,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : _isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : SafeArea(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            child: FixedColumnDataTable(
                              comparedProperties: comparedProperties,
                              isFixedColumnVisible: _isFixedColumnVisible,
                              comparedPropertyData: _comparedProperties,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
      ),
    );
  }
}
