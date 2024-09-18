import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:re_portal_frontend/modules/maps/google_maps_screen.dart';
import 'package:re_portal_frontend/modules/shared/models/appartment_model.dart';
import 'package:re_portal_frontend/modules/shared/widgets/colors.dart';

class NewPropertiesSection extends StatefulWidget {
  final List<ApartmentModel> apartments;
  const NewPropertiesSection({super.key, required this.apartments});

  @override
  State<NewPropertiesSection> createState() => _NewPropertiesSectionState();
}

class _NewPropertiesSectionState extends State<NewPropertiesSection> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: widget.apartments.length,
        itemBuilder: (context, index) {
          if (!mounted) {
            return const SizedBox.shrink();
          } else {
            return Container(
              height: 300,
              width: 300,
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0XFFFAF5E6),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.apartments[index].apartmentName,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "@ ${widget.apartments[index].locality}",
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(height: 8),
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: SizedBox(
                            height: 80,
                            width: double.infinity,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.network(
                                widget.apartments[index].image,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.grey,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 86,
                          width: 86,
                          child: Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: GoogleMap(
                                  zoomControlsEnabled: false,
                                  initialCameraPosition: CameraPosition(
                                    target: LatLng(widget.apartments[index].lat,
                                        widget.apartments[index].long),
                                    zoom: 50,
                                  ),
                                  markers: {
                                    Marker(
                                      markerId:
                                          const MarkerId('currentLocation'),
                                      icon:
                                          BitmapDescriptor.defaultMarkerWithHue(
                                              2),
                                      position: LatLng(
                                          widget.apartments[index].lat,
                                          widget.apartments[index].long),
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
                                      builder: (context) => GoogleMapsScreen(
                                        apartment: widget.apartments[index],
                                      ),
                                    ),
                                  );
                                },
                                child: Container(
                                  height: 86,
                                  width: 86,
                                  color: CustomColors.black10.withOpacity(0.1),
                                ),
                              )
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            widget.apartments[index].description,
                            maxLines: 5,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: CustomColors.black,
                              fontWeight: FontWeight.normal,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 8, 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          if (widget.apartments[index].configuration
                              .split(",")
                              .where((item) => item.isNotEmpty)
                              .isNotEmpty)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(left: 10, top: 4),
                                  child: Text(
                                    'Available',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 8),
                                  child: Row(
                                    children: [
                                      ...List.generate(
                                        widget.apartments[index].configuration
                                            .split(",")
                                            .where((item) => item.isNotEmpty)
                                            .length,
                                        (index) => Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 10,
                                          ),
                                          decoration: BoxDecoration(
                                            border: index !=
                                                    widget.apartments[index]
                                                        .configuration
                                                        .split(",")
                                                        .where((item) =>
                                                            item.isNotEmpty)
                                                        .length
                                                ? const Border(
                                                    right: BorderSide(
                                                      color: CustomColors.black,
                                                      width: 1.5,
                                                    ),
                                                  )
                                                : null,
                                          ),
                                          child: Text(
                                            widget
                                                .apartments[index].configuration
                                                .split(",")
                                                .where(
                                                    (item) => item.isNotEmpty)
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
                                // Handle "View more" action
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
            );
          }
        },
      ),
    );
  }
}
