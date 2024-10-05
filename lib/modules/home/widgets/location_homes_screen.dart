import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:re_portal_frontend/modules/home/models/location_homes_data.dart';
import 'package:re_portal_frontend/modules/home/widgets/property_stack_card.dart';
import 'package:re_portal_frontend/modules/shared/models/appartment_model.dart';
import 'package:re_portal_frontend/modules/shared/widgets/colors.dart';
import 'package:re_portal_frontend/riverpod/location_homes.dart';

class LocationHomes extends ConsumerStatefulWidget {
  const LocationHomes({super.key});

  @override
  ConsumerState<LocationHomes> createState() => _LocationHomesState();
}

class _LocationHomesState extends ConsumerState<LocationHomes> {
  int selectedlocation = 0;
  PageController pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return ref.watch(locationHomesProvider.notifier).getLocations().isEmpty
        ? const SizedBox.shrink()
        : Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Popular locations in",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        ref.watch(locationHomesProvider)!.area,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: CustomColors.primary,
                          decoration: TextDecoration.underline,
                          decorationColor: CustomColors.primary,
                          decorationThickness: 2,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 40,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        const SizedBox(width: 10),
                        ...List.generate(
                          ref
                              .watch(locationHomesProvider.notifier)
                              .getLocations()
                              .length,
                          (index) => Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: TextButton(
                              style: TextButton.styleFrom(
                                backgroundColor: selectedlocation == index
                                    ? CustomColors.primary
                                    : Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              onPressed: () {
                                setState(() {
                                  selectedlocation = index;
                                  pageController.animateTo(
                                    0,
                                    duration: const Duration(milliseconds: 500),
                                    curve: Curves.easeInOut,
                                  );
                                });
                              },
                              child: Text(
                                ref
                                    .watch(locationHomesProvider.notifier)
                                    .getLocations()[index],
                                style: TextStyle(
                                  color: selectedlocation == index
                                      ? CustomColors.white
                                      : CustomColors.primary,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  child: ref
                          .watch(locationHomesProvider.notifier)
                          .getProjectByLocation(ref
                              .watch(locationHomesProvider.notifier)
                              .getLocations()[selectedlocation])!
                          .projects
                          .isEmpty
                      ? Center(
                          child: Text(
                              "No apartments found in ${ref.watch(locationHomesProvider.notifier).getLocations()[selectedlocation]}"),
                        )
                      : PropertyStackCard(
                          apartments: ref
                              .watch(locationHomesProvider.notifier)
                              .getProjectByLocation(ref
                                  .watch(locationHomesProvider.notifier)
                                  .getLocations()[selectedlocation])!
                              .projects,
                        ),
                )
              ],
            ),
          );
  }
}
