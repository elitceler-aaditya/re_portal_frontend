import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:re_portal_frontend/modules/shared/models/appartment_model.dart';
import 'package:re_portal_frontend/modules/shared/widgets/colors.dart';
import 'package:url_launcher/url_launcher.dart';

class FixedColumnDataTable extends ConsumerStatefulWidget {
  final List<ApartmentModel> comparedProperties;

  const FixedColumnDataTable({super.key, required this.comparedProperties});

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

  formatBudget(double budget) {
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
    return Row(
      children: [
        // Fixed Column
        SingleChildScrollView(
          controller: _verticalController,
          child: DataTable(
            headingRowHeight: 115,
            columnSpacing: 2,
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
                columns: _buildScrollableColumns(),
                rows: _buildScrollableRows(),
              ),
            ),
          ),
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
                        prop.image,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      prop.apartmentName,
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
    return [
      const DataRow(
          cells: [DataCell(Text('Type', style: TextStyle(fontSize: 12)))],
          color: WidgetStatePropertyAll(CustomColors.primary10)),
      const DataRow(
          cells: [DataCell(Text('Flat size', style: TextStyle(fontSize: 12)))],
          color: WidgetStatePropertyAll(CustomColors.primary20)),
      const DataRow(
          cells: [DataCell(Text('Approval', style: TextStyle(fontSize: 12)))],
          color: WidgetStatePropertyAll(CustomColors.primary10)),
      const DataRow(cells: [
        DataCell(Text('Project size', style: TextStyle(fontSize: 12)))
      ], color: WidgetStatePropertyAll(CustomColors.primary20)),
      const DataRow(
          cells: [DataCell(Text('Units', style: TextStyle(fontSize: 12)))],
          color: WidgetStatePropertyAll(CustomColors.primary10)),
      const DataRow(
          cells: [DataCell(Text('Floors', style: TextStyle(fontSize: 12)))],
          color: WidgetStatePropertyAll(CustomColors.primary20)),
      const DataRow(cells: [
        DataCell(Text('Configuration', style: TextStyle(fontSize: 12)))
      ], color: WidgetStatePropertyAll(CustomColors.primary10)),
      const DataRow(
          cells: [DataCell(Text('Possession', style: TextStyle(fontSize: 12)))],
          color: WidgetStatePropertyAll(CustomColors.primary20)),
      const DataRow(
          cells: [DataCell(Text('Base price', style: TextStyle(fontSize: 12)))],
          color: WidgetStatePropertyAll(CustomColors.primary10)),
      const DataRow(
          cells: [DataCell(Text('Club size', style: TextStyle(fontSize: 12)))],
          color: WidgetStatePropertyAll(CustomColors.primary20)),
      const DataRow(
          cells: [DataCell(Text('Open area', style: TextStyle(fontSize: 12)))],
          color: WidgetStatePropertyAll(CustomColors.primary10)),
      const DataRow(cells: [
        DataCell(Text('Cost',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)))
      ], color: WidgetStatePropertyAll(CustomColors.primary20)),
      const DataRow(
          cells: [DataCell(Text('Contact'))],
          color: WidgetStatePropertyAll(CustomColors.primary10)),
      const DataRow(
          cells: [DataCell(Text(''))],
          color: WidgetStatePropertyAll(CustomColors.primary20)),
      const DataRow(cells: [DataCell(Text(''))]),
    ];
  }

  List<DataRow> _buildScrollableRows() {
    return [
      _buildDataRow((prop) => prop.apartmentType, const TextStyle(fontSize: 12),
          CustomColors.primary20),
      _buildDataRow((prop) => "${prop.flatSize.toStringAsFixed(0)} sq.ft."),
      _buildDataRow((_) => 'RERA Approved', null, CustomColors.primary20),
      _buildDataRow((prop) => prop.flatSize.toString()),
      _buildDataRow(
          (prop) => prop.noOfFlats.toString(), null, CustomColors.primary20),
      _buildDataRow((prop) => prop.noOfFloor.toString()),
      _buildDataRow((prop) => prop.configuration.toString(), null,
          CustomColors.primary20),
      _buildDataRow((prop) =>
          DateFormat("MMM yyyy").format(DateTime.parse(prop.possessionDate))),
      _buildDataRow(
          (prop) => '₹${formatPrice(prop.budget / prop.flatSize)} per sq.ft.',
          null,
          CustomColors.primary20),
      _buildDataRow((prop) => prop.clubhouseSize.toString()),
      _buildDataRow(
          (prop) => prop.openSpace.toString(), null, CustomColors.primary20),
      _buildDataRow((prop) => formatBudget(prop.budget),
          const TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
      DataRow(
          cells: _buildContactButtons(),
          color: const WidgetStatePropertyAll(CustomColors.primary20)),
    ];
  }

  DataRow _buildDataRow(String Function(ApartmentModel) getValue,
      [TextStyle? style, Color? color]) {
    return DataRow(
        cells: widget.comparedProperties
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
              final Uri phoneUri = Uri(scheme: 'tel', path: prop.companyPhone);
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
