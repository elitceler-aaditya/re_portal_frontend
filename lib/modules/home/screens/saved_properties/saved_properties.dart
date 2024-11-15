import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:re_portal_frontend/modules/home/screens/property_list.dart';
import 'package:re_portal_frontend/modules/profile/screens/profile_screen.dart';
import 'package:re_portal_frontend/modules/shared/widgets/colors.dart';
import 'package:re_portal_frontend/modules/shared/widgets/transitions.dart';
import 'package:re_portal_frontend/riverpod/bot_nav_bar.dart';
import 'package:re_portal_frontend/riverpod/saved_properties.dart';

class SavedProperties extends ConsumerStatefulWidget {
  final bool isPop;
  const SavedProperties({super.key, this.isPop = false});

  @override
  ConsumerState<SavedProperties> createState() => _ComparePropertiesState();
}

class _ComparePropertiesState extends ConsumerState<SavedProperties> {
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
      canPop: widget.isPop,
      onPopInvokedWithResult: (didPop, results) {
        if (!didPop) ref.watch(navBarIndexProvider.notifier).setNavBarIndex(0);
      },
      child: PopScope(
        canPop: widget.isPop,
        onPopInvokedWithResult: (didPop, results) {
          if (!didPop) ref.read(navBarIndexProvider.notifier).setNavBarIndex(0);
        },
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: () {
                if (widget.isPop) {
                  Navigator.of(context).pop();
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
            actions: [
              GestureDetector(
                onTap: () {
                  rightSlideTransition(context, const ProfileScreen());
                },
                child: CircleAvatar(
                  radius: 20,
                  child: Center(
                    child: SvgPicture.asset(
                      "assets/icons/person.svg",
                      height: 20,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
            ],
          ),
          body: ref.watch(savedPropertiesProvider).isEmpty
              ? const Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
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
                )
              : SafeArea(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 10),
                        PropertyList(
                          apartments: ref.watch(savedPropertiesProvider),
                          compare: true,
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
