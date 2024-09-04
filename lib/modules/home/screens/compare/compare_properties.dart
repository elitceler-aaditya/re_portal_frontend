import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:re_portal_frontend/modules/home/screens/property_list.dart';
import 'package:re_portal_frontend/modules/shared/models/appartment_model.dart';
import 'package:re_portal_frontend/modules/shared/widgets/colors.dart';
import 'package:re_portal_frontend/modules/shared/widgets/snackbars.dart';
import 'package:re_portal_frontend/riverpod/bot_nav_bar.dart';
import 'package:re_portal_frontend/riverpod/compare_appartments.dart';
import 'package:re_portal_frontend/riverpod/user_riverpod.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

class CompareProperties extends ConsumerStatefulWidget {
  const CompareProperties({super.key});

  @override
  ConsumerState<CompareProperties> createState() => _ComparePropertiesState();
}

class _ComparePropertiesState extends ConsumerState<CompareProperties> {
  bool isCompare = false;
  List<AppartmentModel> _apartments = [];

  Future<void> getApartments({
    Map<String, dynamic> params = const {},
  }) async {
    String token = ref.watch(userProvider).token;
    String baseUrl = dotenv.get('BASE_URL');
    String url = "$baseUrl/project/filterApartments";
    Uri uri = Uri.parse(url).replace(queryParameters: params);

    http.get(
      uri,
      headers: {
        "Authorization": "Bearer $token",
      },
    ).then((response) async {
      if (response.statusCode == 200 || response.statusCode == 201) {
        List responseBody = jsonDecode(response.body)['apartments'];
        setState(() {
          _apartments = responseBody
              .map<AppartmentModel>((e) => AppartmentModel.fromJson(e))
              .toList();
        });
      }
    });
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getApartments();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<AppartmentModel> comparedProperties =
        ref.watch(comparePropertyProvider);
    return PopScope(
      canPop: true,
      onPopInvoked: (didPop) {
        ref.read(navBarIndexProvider.notifier).setNavBarIndex(0);
      },
      child: Scaffold(
        floatingActionButton: Visibility(
          visible: comparedProperties.length >= 2,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 36,
              width: 120,
              margin: const EdgeInsets.only(left: 20),
              child: FloatingActionButton(
                backgroundColor: CustomColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                onPressed: () {
                  setState(() {
                    isCompare = !isCompare;
                  });
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (!isCompare)
                      SvgPicture.asset(
                        "assets/icons/compare.svg",
                        color: CustomColors.white,
                      ),
                    Text(
                      isCompare ? 'Back' : 'Compare',
                      style: const TextStyle(
                        color: CustomColors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        body: !isCompare
            ? SafeArea(
                child: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 10),
                        const Text(
                          "Compare with similar Apartments",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const Text(
                          "Please select atleast 2 properties to compare",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: CustomColors.black50,
                          ),
                        ),
                        if (_apartments.isEmpty)
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: 6,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: Shimmer.fromColors(
                                  baseColor: CustomColors.black10,
                                  highlightColor: CustomColors.black25,
                                  child: Container(
                                    height: 150,
                                    decoration: BoxDecoration(
                                      color: CustomColors.white,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        if (_apartments.isNotEmpty)
                          PropertyList(
                            apartments: _apartments,
                            compare: true,
                          ),
                        const SizedBox(height: 60),
                      ],
                    ),
                  ),
                ),
              )
            : SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 16),
                    Expanded(
                      child: SingleChildScrollView(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                            headingRowHeight: 115,
                            columnSpacing: 24,
                            columns: [
                              const DataColumn(label: Text('')),
                              ...List.generate(
                                comparedProperties.length,
                                (index) => DataColumn(
                                  label: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        height: 70,
                                        width: 120,
                                        margin: const EdgeInsets.all(4),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          child: Image.network(
                                            comparedProperties[index].image,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 8),
                                        child: Text(
                                          comparedProperties[index]
                                              .apartmentName,
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                            rows: [
                              DataRow(cells: [
                                const DataCell(Text('Flat size')),
                                ...List.generate(
                                  comparedProperties.length,
                                  (index) => DataCell(Text(
                                      "${comparedProperties[index].flatSize.toStringAsFixed(0)} sq.ft.")),
                                ),
                              ]),
                              DataRow(cells: [
                                const DataCell(Text('Approval')),
                                ...List.generate(
                                  comparedProperties.length,
                                  (index) => const DataCell(
                                    Text('RERA Approved'),
                                  ),
                                ),
                              ]),
                              DataRow(cells: [
                                const DataCell(Text('Project size')),
                                ...List.generate(
                                  comparedProperties.length,
                                  (index) => DataCell(Text(
                                      comparedProperties[index]
                                          .flatSize
                                          .toString())),
                                ),
                              ]),
                              DataRow(cells: [
                                const DataCell(Text('Units')),
                                ...List.generate(
                                  comparedProperties.length,
                                  (index) => DataCell(Text(
                                      comparedProperties[index]
                                          .noOfFlats
                                          .toString())),
                                ),
                              ]),
                              DataRow(cells: [
                                const DataCell(Text('Floors')),
                                ...List.generate(
                                  comparedProperties.length,
                                  (index) => DataCell(Text(
                                      comparedProperties[index]
                                          .noOfFloor
                                          .toString())),
                                ),
                              ]),
                              DataRow(cells: [
                                const DataCell(Text('Configuration')),
                                ...List.generate(
                                  comparedProperties.length,
                                  (index) => DataCell(Text(
                                      comparedProperties[index]
                                          .configuration
                                          .toString())),
                                ),
                              ]),
                              DataRow(cells: [
                                const DataCell(Text('Possession')),
                                ...List.generate(
                                  comparedProperties.length,
                                  (index) => DataCell(Text(
                                      DateFormat("MMM yyyy").format(
                                          DateTime.parse(
                                              comparedProperties[index]
                                                  .possessionDate)))),
                                ),
                              ]),
                              DataRow(cells: [
                                const DataCell(Text('Base price')),
                                ...List.generate(
                                  comparedProperties.length,
                                  (index) => DataCell(Text(
                                      '₹${formatPrice(comparedProperties[index].budget / comparedProperties[index].flatSize)} per sq.ft.')),
                                ),
                              ]),
                              DataRow(cells: [
                                const DataCell(Text('Club size')),
                                ...List.generate(
                                  comparedProperties.length,
                                  (index) => DataCell(Text(
                                      comparedProperties[index]
                                          .clubhouseSize
                                          .toString())),
                                ),
                              ]),
                              DataRow(cells: [
                                const DataCell(Text('Open area')),
                                ...List.generate(
                                  comparedProperties.length,
                                  (index) => DataCell(Text(
                                      comparedProperties[index]
                                          .openSpace
                                          .toString())),
                                ),
                              ]),
                              DataRow(cells: [
                                const DataCell(Text(
                                  'Cost',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16),
                                )),
                                ...List.generate(
                                  comparedProperties.length,
                                  (index) => DataCell(Text(
                                    formatBudget(
                                        comparedProperties[index].budget),
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16),
                                  )),
                                ),
                              ]),
                              DataRow(cells: [
                                const DataCell(Text('Contact')),
                                ...List.generate(
                                  comparedProperties.length,
                                  (index) => DataCell(
                                    SizedBox(
                                      height: 36,
                                      width: 90,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          elevation: 0,
                                          backgroundColor: CustomColors.primary
                                              .withOpacity(0.1),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(6),
                                          ),
                                          padding: EdgeInsets.zero,
                                        ),
                                        onPressed: () {
                                          final Uri phoneUri = Uri(
                                            scheme: 'tel',
                                            path: comparedProperties[index]
                                                .companyPhone,
                                          );
                                          launchUrl(phoneUri);
                                        },
                                        child: const Text(
                                          'Contact',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 12),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ]),
                              DataRow(cells: [
                                const DataCell(Text('')),
                                ...List.generate(
                                  comparedProperties.length,
                                  (index) => DataCell(
                                    SizedBox(
                                      height: 36,
                                      width: 90,
                                      child: IconButton(
                                        onPressed: () {
                                          ref
                                              .read(comparePropertyProvider
                                                  .notifier)
                                              .removeApartment(
                                                  comparedProperties[index]);
                                          if (ref
                                                  .read(comparePropertyProvider)
                                                  .length <
                                              2) {
                                            setState(() {
                                              isCompare = false;
                                            });
                                          }
                                        },
                                        icon: const Icon(
                                          Icons.close,
                                          color: CustomColors.red,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ]),
                              DataRow(cells: [
                                const DataCell(Text('')),
                                ...List.generate(
                                  comparedProperties.length,
                                  (index) => const DataCell(Text('')),
                                ),
                              ]),
                            ],
                          ),
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
