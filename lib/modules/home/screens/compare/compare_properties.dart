import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:re_portal_frontend/modules/home/screens/compare/table.dart';
import 'package:re_portal_frontend/modules/shared/models/appartment_model.dart';
import 'package:re_portal_frontend/modules/shared/widgets/colors.dart';
import 'package:re_portal_frontend/riverpod/bot_nav_bar.dart';
import 'package:re_portal_frontend/riverpod/compare_appartments.dart';

class CompareProperties extends ConsumerStatefulWidget {
  const CompareProperties({super.key});

  @override
  ConsumerState<CompareProperties> createState() => _ComparePropertiesState();
}

class _ComparePropertiesState extends ConsumerState<CompareProperties> {
  bool _isFixedColumnVisible = true;
  final ScrollController _scrollController = ScrollController();
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
  Widget build(BuildContext context) {
    List<ApartmentModel> comparedProperties =
        ref.watch(comparePropertyProvider);
    return PopScope(
      canPop: true,
      onPopInvoked: (didPop) {
        ref.read(navBarIndexProvider.notifier).setNavBarIndex(0);
      },
      child: Scaffold(
        backgroundColor: CustomColors.primary10,
        appBar: AppBar(
          automaticallyImplyLeading: true,
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
            : SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 16),
                    Expanded(
                      child: SingleChildScrollView(
                        child: FixedColumnDataTable(
                          comparedProperties: comparedProperties,
                          isFixedColumnVisible: _isFixedColumnVisible,
                        ),
                      ),
                    )
                  ],
                ),
              ),
      ),
    );
  }
}
