import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:re_portal_frontend/modules/home/models/compare_property_data.dart';
import 'package:re_portal_frontend/modules/shared/models/appartment_model.dart';
import 'package:re_portal_frontend/modules/shared/widgets/colors.dart';
import 'package:url_launcher/url_launcher.dart';

class FixedColumnDataTable extends ConsumerStatefulWidget {
  final List<ApartmentModel> comparedProperties;
  final List<ComparePropertyData> comparedPropertyData;
  final bool isFixedColumnVisible;
  final Function() onHideFixedColumn;
  final ScrollController horizontalController;

  const FixedColumnDataTable(
      {super.key,
      required this.comparedProperties,
      required this.comparedPropertyData,
      this.isFixedColumnVisible = true,
      required this.horizontalController,
      required this.onHideFixedColumn});

  @override
  ConsumerState<FixedColumnDataTable> createState() =>
      _FixedColumnDataTableState();
}

class _FixedColumnDataTableState extends ConsumerState<FixedColumnDataTable> {
  formatPrice(double price) {
    if (price > 1000000) {
      return '${(price / 1000000).toStringAsFixed(0)} Lac';
    } else if (price > 1000) {
      return '${(price / 1000).toStringAsFixed(0)} K';
    } else {
      return price.toStringAsFixed(0);
    }
  }

  formatBudget(int budget) {
    if (budget < 10000000) {
      return "${(budget / 100000).toStringAsFixed(2)} L";
    } else {
      return "${(budget / 10000000).toStringAsFixed(2)} Cr";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Fixed Column

            Animate(
              target: widget.isFixedColumnVisible ? 1 : 0,
              effects: const [
                SlideEffect(
                    duration: Duration(milliseconds: 800),
                    curve: Curves.easeInOut,
                    begin: Offset(-1, 0),
                    end: Offset(0, 0))
              ],
              child: SingleChildScrollView(
                child: DataTable(
                  headingRowHeight: 83,
                  columnSpacing: 1,
                  dataRowMinHeight: 32,
                  dataRowMaxHeight: 32,
                  columns: [
                    DataColumn(
                      label: TextButton.icon(
                        style: TextButton.styleFrom(
                          backgroundColor: CustomColors.primary10,
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                        ),
                        onPressed: widget.onHideFixedColumn,
                        icon: widget.isFixedColumnVisible
                            ? const Icon(Icons.arrow_back, size: 20)
                            : const Icon(Icons.arrow_forward, size: 20),
                        label: widget.isFixedColumnVisible
                            ? const Text(
                                "Hide",
                                style: TextStyle(color: CustomColors.primary),
                              )
                            : const Text(
                                "Show",
                                style: TextStyle(color: CustomColors.primary),
                              ),
                      ),
                    )
                  ],
                  rows: _buildFixedColumnRows(),
                ),
              ),
            ),
            // Scrollable Columns
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                controller: widget.horizontalController,
                child: SingleChildScrollView(
                  child: DataTable(
                    headingRowHeight: 115,
                    columnSpacing: 16,
                    dataRowMinHeight: 32,
                    dataRowMaxHeight: 32,
                    columns: _buildScrollableColumns(),
                    // rows: [],
                    rows: _buildScrollableRows(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  List<DataColumn> _buildScrollableColumns() {
    return widget.comparedProperties
        .map((prop) => DataColumn(
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
                        prop.coverImage,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      prop.name,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ))
        .toList();
  }

  List<DataRow> _buildFixedColumnRows() {
    List attributes = [
      'Name',
      'Type',
      'Flat size',
      'Approval',
      'Project size',
      'Flat size',
      'Units',
      'Floors',
      'Configuration',
      'Possession',
      'Base price',
      'Club size',
      'Open area'
    ];
    return [
      ...List<DataRow>.generate(
        attributes.length,
        (index) {
          final rowColor =
              index % 2 == 0 ? CustomColors.primary10 : CustomColors.primary20;

          return DataRow(
            color: WidgetStateProperty.all(rowColor),
            cells: [
              DataCell(
                Text(
                  attributes[index],
                  style: const TextStyle(fontSize: 12),
                ),
              ),
            ],
          );
        },
      ),
      const DataRow(cells: [
        DataCell(Text('Cost',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)))
      ], color: WidgetStatePropertyAll(CustomColors.primary20)),
      const DataRow(
          cells: [DataCell(Text('Contact'))],
          color: WidgetStatePropertyAll(CustomColors.primary10)),
      const DataRow(
          cells: [DataCell(Text(''))],
          color: WidgetStatePropertyAll(CustomColors.white)),
    ];
  }

  List<DataRow> _buildScrollableRows() {
    List<String Function(ComparePropertyData)> attributes = [
      (ComparePropertyData prop) => prop.name,
      (ComparePropertyData prop) => prop.projectType,
      (ComparePropertyData prop) => "${prop.flatSizes.toString()} sq.ft.",
      (ComparePropertyData prop) =>
          prop.rERAApproval ? 'RERA Approved' : 'Not Approved',
      (ComparePropertyData prop) => prop.projectSize,
      (ComparePropertyData prop) => prop.flatSizes.toString(),
      (ComparePropertyData prop) => prop.noOfTowers,
      (ComparePropertyData prop) => prop.noOfFloors,
      (ComparePropertyData prop) =>
          prop.unitPlanConfigs.map((config) => config.BHKType).join(', '),
      (ComparePropertyData prop) => prop.projectPossession.substring(0, 10),
      (ComparePropertyData prop) =>
          '₹${prop.pricePerSquareFeetRate} per sq.ft.',
      (ComparePropertyData prop) => prop.clubhousesize,
      (ComparePropertyData prop) => prop.totalOpenSpace,
    ];
    return [
      ...List<DataRow>.generate(
        attributes.length,
        (index) => DataRow(
          cells: List.generate(
            widget.comparedPropertyData.length,
            (cellIndex) => DataCell(
              Text(
                attributes[index](widget.comparedPropertyData[cellIndex]),
                style: const TextStyle(fontSize: 12),
              ),
            ),
          ),
          color: WidgetStateProperty.all(
            index % 2 == 0 ? CustomColors.primary20 : CustomColors.primary10,
          ),
        ),
      ),
      DataRow(
        cells: List.generate(
          widget.comparedPropertyData.length,
          (index) => DataCell(
            Text(
              formatBudget(widget.comparedPropertyData[index].budget),
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
          ),
        ),
        color: const MaterialStatePropertyAll(CustomColors.primary10),
      ),
      DataRow(
        cells: List.generate(
          widget.comparedProperties.length,
          (index) => DataCell(
            SizedBox(
              height: 36,
              width: 90,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: CustomColors.primary.withOpacity(0.1),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6)),
                  padding: EdgeInsets.zero,
                ),
                onPressed: () {
                  final Uri phoneUri = Uri(
                      scheme: 'tel',
                      path: widget.comparedProperties[index].builderID);
                  launchUrl(phoneUri);
                },
                child: const Text(
                  'Contact',
                  style: TextStyle(
                      color: CustomColors.primary,
                      fontWeight: FontWeight.w600,
                      fontSize: 12),
                ),
              ),
            ),
          ),
        ),
        color: const MaterialStatePropertyAll(CustomColors.primary10),
      ),
    ];
  }

  DataRow _buildDataRow(String Function(ComparePropertyData) getValue,
      [TextStyle? style, Color? color]) {
    return DataRow(
      cells: widget.comparedPropertyData
          .map(
            (prop) => DataCell(
              Text(getValue(prop), style: style),
            ),
          )
          .toList(),
      color: WidgetStatePropertyAll(color),
    );
  }

  List<DataCell> _buildContactButtons() {
    return widget.comparedProperties.map((prop) {
      return DataCell(
        SizedBox(
          height: 36,
          width: 90,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              elevation: 0,
              backgroundColor: CustomColors.primary.withOpacity(0.1),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6)),
              padding: EdgeInsets.zero,
            ),
            onPressed: () {
              final Uri phoneUri = Uri(scheme: 'tel', path: prop.builderID);
              launchUrl(phoneUri);
            },
            child: const Text(
              'Contact',
              style: TextStyle(
                  color: CustomColors.primary,
                  fontWeight: FontWeight.w600,
                  fontSize: 12),
            ),
          ),
        ),
      );
    }).toList();
  }
}
