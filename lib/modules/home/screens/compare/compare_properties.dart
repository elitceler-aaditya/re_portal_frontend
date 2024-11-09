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
  final bool isPop;
  const CompareProperties({super.key, this.isPop = false});

  @override
  ConsumerState<CompareProperties> createState() => _ComparePropertiesState();
}

class _ComparePropertiesState extends ConsumerState<CompareProperties> {
  bool _isFixedColumnVisible = true;
  bool _isLoading = true;
  final ScrollController _horizontalController = ScrollController();

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
      if (ref.watch(comparePropertyProvider).isNotEmpty) {
        getPropertyData();
      }
    });
    _horizontalController.addListener(() {
      if (_horizontalController.position.pixels <= 0) {
        setState(() {
          _isFixedColumnVisible = true;
        });
      } else {
        setState(() {
          _isFixedColumnVisible = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    List<ApartmentModel> comparedProperties =
        ref.watch(comparePropertyProvider);
    return PopScope(
      canPop: widget.isPop,
      onPopInvokedWithResult: (didPop, results) {
        if (!didPop) ref.read(navBarIndexProvider.notifier).setNavBarIndex(0);
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: IconButton(
            onPressed: () {
              if (widget.isPop) {
                Navigator.pop(context);
              } else {
                ref.read(navBarIndexProvider.notifier).setNavBarIndex(0);
              }
            },
            icon: const Icon(Icons.arrow_back),
          ),
          flexibleSpace: Container(
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
          ),
          backgroundColor: Colors.transparent,
        ),
        body: comparedProperties.isEmpty
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
                        "Please select atleast 1 property to compare",
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
                : Stack(
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: SingleChildScrollView(
                              child: FixedColumnDataTable(
                                comparedProperties: comparedProperties,
                                isFixedColumnVisible: _isFixedColumnVisible,
                                comparedPropertyData: _comparedProperties,
                                horizontalController: _horizontalController,
                                onHideFixedColumn: () {
                                  setState(() {
                                    _isFixedColumnVisible =
                                        !_isFixedColumnVisible;
                                  });
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                      Positioned(
                        top: 20,
                        left: 0,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _isFixedColumnVisible = !_isFixedColumnVisible;
                            });
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            width: _isFixedColumnVisible ? 100 : 24,
                            height: 40,
                            decoration: BoxDecoration(
                              color: CustomColors.black.withOpacity(0.5),
                              borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(10),
                                bottomRight: Radius.circular(10),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(
                                  _isFixedColumnVisible
                                      ? Icons.keyboard_arrow_left
                                      : Icons.keyboard_arrow_right,
                                  color: CustomColors.white,
                                ),
                                if (_isFixedColumnVisible)
                                  const Text(
                                    "Specs",
                                    style: TextStyle(
                                      color: CustomColors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
      ),
    );
  }
}
