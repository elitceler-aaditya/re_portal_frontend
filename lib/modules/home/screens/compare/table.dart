import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:re_portal_frontend/modules/home/models/compare_property_data.dart';
import 'package:re_portal_frontend/modules/shared/models/appartment_model.dart';
import 'package:re_portal_frontend/modules/shared/widgets/colors.dart';
import 'package:url_launcher/url_launcher.dart';

class FixedColumnDataTable extends ConsumerStatefulWidget {
  final List<ApartmentModel> comparedProperties;
  final List<ComparePropertyData> comparedPropertyData;
  final bool isFixedColumnVisible;

  const FixedColumnDataTable(
      {super.key,
      required this.comparedProperties,
      required this.comparedPropertyData,
      this.isFixedColumnVisible = true});

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

  final ScrollController _horizontalController = ScrollController();
  final ScrollController _verticalController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Fixed Column
            if (widget.isFixedColumnVisible)
              SingleChildScrollView(
                controller: _verticalController,
                child: DataTable(
                  headingRowHeight: 75,
                  columnSpacing: 2,
                  dataRowMinHeight: 40,
                  dataRowMaxHeight: 40,
                  columns: const [DataColumn(label: Text(''))],
                  rows: _buildFixedColumnRows(),
                ),
              ),
            // Scrollable Columns
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                controller: _horizontalController,
                child: SingleChildScrollView(
                  controller: _verticalController,
                  child: DataTable(
                    headingRowHeight: 115,
                    columnSpacing: 16,
                    dataRowMinHeight: 40,
                    dataRowMaxHeight: 40,
                    columns: _buildScrollableColumns(),
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
            color: MaterialStateProperty.all(rowColor),
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
          color: WidgetStatePropertyAll(CustomColors.primary10)),
    ];
  }

  List<DataRow> _buildScrollableRows() {
    List attributes = [
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
        (index) => _buildDataRow(
          attributes[index],
          const TextStyle(fontSize: 12),
          index % 2 == 0 ? CustomColors.primary20 : CustomColors.primary10,
        ),
      ),
      _buildDataRow(
        (prop) => formatBudget(prop.budget),
        const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        CustomColors.primary10,
      ),
      DataRow(
          cells: _buildContactButtons(),
          color: const WidgetStatePropertyAll(CustomColors.primary10)),
    ];
  }

  DataRow _buildDataRow(String Function(ComparePropertyData) getValue,
      [TextStyle? style, Color? color]) {
    return DataRow(
        cells: widget.comparedPropertyData
            .map((prop) => DataCell(Text(getValue(prop), style: style)))
            .toList(),
        color: WidgetStatePropertyAll(color));
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
