import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:re_portal_frontend/modules/home/widgets/property_stack_card.dart';
import 'package:re_portal_frontend/modules/shared/widgets/colors.dart';
import 'package:re_portal_frontend/riverpod/location_homes.dart';
import 'package:http/http.dart' as http;

class LocationHomes extends ConsumerStatefulWidget {
  final bool useActualLocation;
  const LocationHomes({super.key, this.useActualLocation = false});

  @override
  ConsumerState<LocationHomes> createState() => _LocationHomesState();
}

class _LocationHomesState extends ConsumerState<LocationHomes> {
  int selectedlocation = 0;
  PageController pageController = PageController();

  void getLocationHomes(double lat, double long) async {
    debugPrint("-----------------getting location homes");
    String baseUrl = dotenv.get('BASE_URL');
    String url = "$baseUrl/user/getPopularLocalities";
    Uri uri = Uri.parse(url).replace(queryParameters: {
      "latitude": lat.toString(),
      "longitude": long.toString(),
    });

    try {
      final response = await http.get(uri);
      if (response.statusCode == 200 || response.statusCode == 201) {
        Map<String, dynamic> responseData = jsonDecode(response.body);
        debugPrint("-----------------responseData: $responseData");
        ref
            .read(locationHomesProvider.notifier)
            .setLocationHomesData(responseData);
      } else {
        getLocationHomes(17.4699, 78.2236);
        throw Exception('Error ${response.statusCode}: ${response.body}');
      }
    } catch (error, stackTrace) {
      getLocationHomes(17.4699, 78.2236);

      debugPrint("error: $error");
      debugPrint("stackTrace: $stackTrace");
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (ref.watch(locationHomesProvider) == null &&
          widget.useActualLocation) {
        getLocationHomes(17.463, 78.286);
      }
    });
  }

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
                      const EdgeInsets.symmetric(horizontal: 4, vertical: 10),
                  child: RichText(
                    text: TextSpan(
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.normal,
                        color: Colors.black,
                      ),
                      children: [
                        const TextSpan(
                            text: "Popular locations near  ",
                            style: TextStyle(
                              fontFamily: 'eudoxus',
                            )),
                        TextSpan(
                          text: ref
                              .watch(locationHomesProvider)!
                              .searchedLocation,
                          style: const TextStyle(
                            fontFamily: 'eudoxus',
                            fontWeight: FontWeight.bold,
                            color: CustomColors.primary,
                          ),
                        ),
                      ],
                    ),
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
                                side: const BorderSide(
                                  color: CustomColors.primary50,
                                ),
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
                          cardWidth: MediaQuery.of(context).size.width * 0.9,
                          apartments: ref
                              .watch(locationHomesProvider.notifier)
                              .getProjectByLocation(ref
                                  .watch(locationHomesProvider.notifier)
                                  .getLocations()[selectedlocation])!
                              .projects,
                        ),
                ),
              ],
            ),
          );
  }
}
