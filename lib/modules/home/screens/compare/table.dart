import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:re_portal_frontend/modules/home/models/compare_property_data.dart';
import 'package:re_portal_frontend/modules/shared/models/appartment_model.dart';
import 'package:re_portal_frontend/modules/shared/widgets/colors.dart';

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
    'Open area',
    'Cost',
    ''
  ];
  formatBudget(int budget) {
    if (budget < 10000000) {
      return "₹${(budget / 100000).toStringAsFixed(2)} L";
    } else {
      return "₹${(budget / 10000000).toStringAsFixed(2)} Cr";
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
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: widget.isFixedColumnVisible ? 150 : 0,
              curve: Curves.easeInOut,
              child: !widget.isFixedColumnVisible
                  ? const SizedBox()
                  : Column(
                      children: [
                        Container(
                          height: 79,
                          width: double.infinity,
                          color: CustomColors.white,
                          child: Center(
                            child: TextButton.icon(
                              style: TextButton.styleFrom(
                                backgroundColor: CustomColors.primary10,
                              ),
                              onPressed: widget.onHideFixedColumn,
                              icon: Icon(
                                widget.isFixedColumnVisible
                                    ? Icons.arrow_back
                                    : Icons.arrow_forward,
                                color: CustomColors.primary,
                              ),
                              label: Text(
                                widget.isFixedColumnVisible ? 'Hide' : 'Show',
                                style: const TextStyle(
                                  color: CustomColors.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                        ...List.generate(
                          15,
                          (index) => Container(
                            height: 36,
                            width: double.infinity,
                            color: index % 2 == 0
                                ? CustomColors.white
                                : CustomColors.primary10,
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8),
                              child: Text(
                                attributes[index],
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
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
                    dataRowMinHeight: 36,
                    dataRowMaxHeight: 36,
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

  List<DataRow> _buildScrollableRows() {
    final propertyFields = [
      (ComparePropertyData d) => d.projectType,
      (ComparePropertyData d) => d.flatSizes.toString(),
      (ComparePropertyData d) => d.rERAApproval ? 'Yes' : 'No',
      (ComparePropertyData d) => d.projectSize,
      (ComparePropertyData d) => d.flatSizes.toString(),
      (ComparePropertyData d) =>
          d.unitPlanConfigs.map((e) => e.BHKType).join(', '),
      (ComparePropertyData d) => d.noOfFloors,
      (ComparePropertyData d) =>
          d.unitPlanConfigs.map((e) => e.BHKType).join(', '),
      (ComparePropertyData d) => d.projectPossession.isEmpty
          ? ''
          : d.projectPossession.substring(0, 10),
      (ComparePropertyData d) => d.pricePerSquareFeetRate,
      (ComparePropertyData d) => d.clubhousesize,
      (ComparePropertyData d) => d.totalOpenSpace,
      (ComparePropertyData d) => formatBudget(d.budget),
    ];

    return List.generate(propertyFields.length, (index) {
      return DataRow(
        color: WidgetStateProperty.all(
          index % 2 == 0 ? CustomColors.primary10 : CustomColors.white,
        ),
        cells: List.generate(widget.comparedPropertyData.length, (dataIndex) {
          return DataCell(
            Text(
              propertyFields[index](
                widget.comparedPropertyData[dataIndex],
              ),
            ),
          );
        }),
      );
    });
  }
}
