import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:re_portal_frontend/modules/home/screens/property_details.dart';
import 'package:re_portal_frontend/modules/maps/google_maps_screen.dart';
import 'package:re_portal_frontend/modules/shared/widgets/colors.dart';
import 'package:re_portal_frontend/riverpod/home_data.dart';
import 'package:shimmer/shimmer.dart';

class NewPropertiesSection extends ConsumerWidget {
  const NewPropertiesSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final apartments = ref.watch(homePropertiesProvider).newProjects;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Text(
            "New Projects",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(
          height: 290,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: apartments.length,
            itemBuilder: (context, index) {
              return Container(
                height: 290,
                width: 300,
                clipBehavior: Clip.hardEdge,
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0XFFFAF5E6),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Hero(
                          tag: "new-${apartments[index].projectId}",
                          child: SizedBox(
                            height: 120,
                            width: double.infinity,
                            child: Image.network(
                              apartments[index].coverImage,
                              fit: BoxFit.cover,
                              loadingBuilder: (context, child,
                                      loadingProgress) =>
                                  loadingProgress == null
                                      ? child
                                      : Shimmer.fromColors(
                                          baseColor: CustomColors.black75,
                                          highlightColor: CustomColors.black25,
                                          child: Container(
                                            height: 120,
                                            width: 300,
                                            decoration: BoxDecoration(
                                              color: Colors.black,
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                            ),
                                          ),
                                        ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 8),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        apartments[index].name,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          color: CustomColors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      Text(
                                        "@ ${apartments[index].projectLocation}",
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          color: CustomColors.black,
                                          fontWeight: FontWeight.normal,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              SizedBox(
                                height: 64,
                                width: 100,
                                child: Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: GoogleMap(
                                        zoomControlsEnabled: false,
                                        initialCameraPosition: CameraPosition(
                                          target: LatLng(
                                              apartments[index].latitude,
                                              apartments[index].longitude),
                                          zoom: 5,
                                        ),
                                        markers: {
                                          Marker(
                                            markerId: const MarkerId(
                                                'currentLocation'),
                                            icon: BitmapDescriptor
                                                .defaultMarkerWithHue(2),
                                            position: LatLng(
                                                apartments[index].latitude,
                                                apartments[index].longitude),
                                            infoWindow: const InfoWindow(
                                              title: 'Current Location',
                                            ),
                                          ),
                                        },
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                GoogleMapsScreen(
                                              apartment: apartments[index],
                                            ),
                                          ),
                                        );
                                      },
                                      child: Container(
                                        height: 86,
                                        width: 86,
                                        color: CustomColors.black10
                                            .withOpacity(0.1),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Divider(
                          height: 1,
                          color: CustomColors.yellow,
                          indent: 24,
                          endIndent: 24,
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(10, 0, 8, 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                if (apartments[index]
                                    .configuration
                                    .where((item) => item.isNotEmpty)
                                    .isNotEmpty)
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.only(left: 4),
                                        child: Text(
                                          'Available',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 4),
                                        child: Row(
                                          children: [
                                            ...List.generate(
                                              apartments[index]
                                                  .configuration
                                                  .where(
                                                      (item) => item.isNotEmpty)
                                                  .length,
                                              (index) => Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 6),
                                                decoration: BoxDecoration(
                                                  border: index !=
                                                          apartments[index]
                                                              .configuration
                                                              .where((item) =>
                                                                  item.isNotEmpty)
                                                              .length
                                                      ? const Border(
                                                          right: BorderSide(
                                                            color: CustomColors
                                                                .black,
                                                            width: 1,
                                                          ),
                                                        )
                                                      : null,
                                                ),
                                                child: Text(
                                                  apartments[index]
                                                      .configuration
                                                      .where((item) =>
                                                          item.isNotEmpty)
                                                      .first,
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                const SizedBox(width: 16),
                                SizedBox(
                                  height: 36,
                                  // width: 64,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => PropertyDetails(
                                            apartment: apartments[index],
                                            heroTag:
                                                "new-${apartments[index].projectId}",
                                          ),
                                        ),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: CustomColors.primary,
                                      shape: const StadiumBorder(),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 0,
                                      ),
                                    ),
                                    child: const Text(
                                      'View more',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 12),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 4),
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(12),
                          bottomRight: Radius.circular(12),
                        ),
                        color: Colors.redAccent,
                      ),
                      child: const Text(
                        "New",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
