import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:re_portal_frontend/modules/home/screens/property_list.dart';
import 'package:re_portal_frontend/modules/shared/models/appartment_model.dart';
import 'package:re_portal_frontend/modules/shared/widgets/colors.dart';
import 'package:re_portal_frontend/riverpod/bot_nav_bar.dart';
import 'package:re_portal_frontend/riverpod/compare_appartments.dart';
import 'package:re_portal_frontend/riverpod/saved_properties.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

class SavedProperties extends ConsumerStatefulWidget {
  const SavedProperties({super.key});

  @override
  ConsumerState<SavedProperties> createState() => _ComparePropertiesState();
}

class _ComparePropertiesState extends ConsumerState<SavedProperties> {
  bool isCompare = false;

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
    return PopScope(
      canPop: true,
      onPopInvoked: (didPop) {
        ref.read(navBarIndexProvider.notifier).setNavBarIndex(0);
      },
      child: Scaffold(
          body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 10),
                if (ref.watch(savedPropertiesProvider).isEmpty)
                  const Center(
                    child: Column(
                      children: [
                        Text(
                          "No saved properties",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          "Save your favourite properties to view them here",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: CustomColors.black50,
                          ),
                        ),
                      ],
                    ),
                  ),
                if (ref.watch(savedPropertiesProvider).isNotEmpty)
                  PropertyList(
                    apartments: ref.watch(savedPropertiesProvider),
                    compare: true,
                  ),
                const SizedBox(height: 60),
              ],
            ),
          ),
        ),
      )),
    );
  }
}
