import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:re_portal_frontend/modules/shared/models/appartment_model.dart';
import 'package:re_portal_frontend/modules/shared/widgets/colors.dart';
import 'package:http/http.dart' as http;
import 'package:re_portal_frontend/riverpod/compare_appartments.dart';
import 'package:url_launcher/url_launcher.dart';

class CompareProperties extends ConsumerStatefulWidget {
  const CompareProperties({super.key});

  @override
  ConsumerState<CompareProperties> createState() => _ComparePropertiesState();
}

class _ComparePropertiesState extends ConsumerState<CompareProperties> {
  formatPrice(double price) {
    //add k and lac
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
  Widget build(BuildContext context) {
    List<AppartmentModel> apartments = ref.watch(comparePropertyProvider);
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
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
            ),
            const SizedBox(height: 16),
            if (apartments.length >= 2)
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
                          apartments.length,
                          (index) => DataColumn(
                            label: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: 70,
                                  width: 120,
                                  margin: const EdgeInsets.all(4),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.network(
                                      apartments[index].image,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8),
                                  child: Text(
                                    apartments[index].apartmentName,
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
                            apartments.length,
                            (index) => DataCell(Text(
                                "${apartments[index].flatSize.toStringAsFixed(0)} sq.ft.")),
                          ),
                        ]),
                        DataRow(cells: [
                          const DataCell(Text('Approval')),
                          ...List.generate(
                            apartments.length,
                            (index) => const DataCell(
                              Text('RERA Approved'),
                            ),
                          ),
                        ]),
                        DataRow(cells: [
                          const DataCell(Text('Project size')),
                          ...List.generate(
                            apartments.length,
                            (index) => DataCell(
                                Text(apartments[index].flatSize.toString())),
                          ),
                        ]),
                        DataRow(cells: [
                          const DataCell(Text('Units')),
                          ...List.generate(
                            apartments.length,
                            (index) => DataCell(
                                Text(apartments[index].noOfFlats.toString())),
                          ),
                        ]),
                        DataRow(cells: [
                          const DataCell(Text('Floors')),
                          ...List.generate(
                            apartments.length,
                            (index) => DataCell(
                                Text(apartments[index].noOfFloor.toString())),
                          ),
                        ]),
                        DataRow(cells: [
                          const DataCell(Text('Configuration')),
                          ...List.generate(
                            apartments.length,
                            (index) => DataCell(Text(
                                apartments[index].configuration.toString())),
                          ),
                        ]),
                        DataRow(cells: [
                          const DataCell(Text('Possession')),
                          ...List.generate(
                            apartments.length,
                            (index) => DataCell(Text(DateFormat("MMM yyyy")
                                .format(DateTime.parse(
                                    apartments[index].possessionDate)))),
                          ),
                        ]),
                        DataRow(cells: [
                          const DataCell(Text('Base price')),
                          ...List.generate(
                            apartments.length,
                            (index) => DataCell(Text(
                                '₹${formatPrice(apartments[index].budget / apartments[index].flatSize)} per sq.ft.')),
                          ),
                        ]),
                        DataRow(cells: [
                          const DataCell(Text('Club size')),
                          ...List.generate(
                            apartments.length,
                            (index) => DataCell(Text(
                                apartments[index].clubhouseSize.toString())),
                          ),
                        ]),
                        DataRow(cells: [
                          const DataCell(Text('Open area')),
                          ...List.generate(
                            apartments.length,
                            (index) => DataCell(
                                Text(apartments[index].openSpace.toString())),
                          ),
                        ]),
                        DataRow(cells: [
                          const DataCell(Text(
                            'Cost',
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 16),
                          )),
                          ...List.generate(
                            apartments.length,
                            (index) => DataCell(Text(
                              formatBudget(apartments[index].budget),
                              style: const TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 16),
                            )),
                          ),
                        ]),
                        DataRow(cells: [
                          const DataCell(Text('Contact')),
                          ...List.generate(
                            apartments.length,
                            (index) => DataCell(
                              SizedBox(
                                height: 36,
                                width: 90,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    elevation: 0,
                                    backgroundColor:
                                        CustomColors.primary.withOpacity(0.1),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    padding: EdgeInsets.zero,
                                  ),
                                  onPressed: () {
                                    final Uri phoneUri = Uri(
                                      scheme: 'tel',
                                      path: apartments[index].companyPhone,
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
                            apartments.length,
                            (index) => DataCell(
                              SizedBox(
                                height: 36,
                                width: 90,
                                child: IconButton(
                                  onPressed: () {
                                    ref
                                        .read(comparePropertyProvider.notifier)
                                        .removeApartment(apartments[index]);
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
