import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:re_portal_frontend/modules/maps/maps_property_card.dart';
import 'package:re_portal_frontend/modules/shared/models/appartment_model.dart';
import 'package:re_portal_frontend/modules/shared/widgets/colors.dart';
import 'package:re_portal_frontend/riverpod/home_data.dart';

class GoogleMapsScreen extends ConsumerStatefulWidget {
  final ApartmentModel apartment;
  const GoogleMapsScreen({super.key, required this.apartment});

  @override
  ConsumerState<GoogleMapsScreen> createState() => _GoogleMapsScreenState();
}

class _GoogleMapsScreenState extends ConsumerState<GoogleMapsScreen> {
  LatLng? currentLocation;
  List<LatLng> locations = [];
  StreamSubscription<LocationData>? _locationSubscription;
  final Completer<GoogleMapController> _googleMapsController =
      Completer<GoogleMapController>();
  String? _selectedApartmentId;
  final PageController _scrollController = PageController();

  fetchLocationUpdate() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;
    serviceEnabled = await Location.instance.serviceEnabled();

    if (!serviceEnabled) {
      serviceEnabled = await Location.instance.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await Location.instance.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await Location.instance.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationSubscription = Location.instance.onLocationChanged
        .listen((LocationData currentLocation) {
      if (currentLocation.latitude != null &&
          currentLocation.longitude != null) {
        setState(() {
          this.currentLocation =
              LatLng(currentLocation.latitude!, currentLocation.longitude!);
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchLocationUpdate();
      final apartments = ref.read(homePropertiesProvider).allApartments;

      apartments.removeWhere(
          (element) => element.latitude == 0 && element.longitude == 0);
      apartments.removeWhere(
          (element) => element.projectId == widget.apartment.projectId);

      //inseart widget.apartment at the first position
      apartments.insert(0, widget.apartment);
      setState(() {
        locations =
            apartments.map((e) => LatLng(e.latitude, e.longitude)).toList();
      });

      if (apartments.isNotEmpty) {
        _selectedApartmentId = widget.apartment.projectId;
      }
    });
  }

  @override
  void dispose() {
    _locationSubscription?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: GoogleMap(
              onMapCreated: (GoogleMapController controller) {
                _googleMapsController.complete(controller);
                // Show info window for the initial selected apartment
                if (_selectedApartmentId != null) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    controller
                        .showMarkerInfoWindow(MarkerId(_selectedApartmentId!));
                  });
                }
              },
              initialCameraPosition: CameraPosition(
                target: LatLng(
                    widget.apartment.latitude, widget.apartment.longitude),
                zoom: 14,
              ),
              markers: {
                ...ref.watch(homePropertiesProvider).allApartments.map(
                      (e) => Marker(
                        markerId: MarkerId(e.projectId),
                        position: LatLng(e.latitude, e.longitude),
                        infoWindow: InfoWindow(title: e.name),
                        onTap: () {
                          setState(() {
                            _selectedApartmentId = e.projectId;
                          });

                          int index = ref
                              .watch(homePropertiesProvider)
                              .allApartments
                              .indexOf(e);
                          _scrollController.animateToPage(index,
                              duration: const Duration(milliseconds: 800),
                              curve: Curves.easeInOut);
                        },
                      ),
                    )
              },
            ),
          ),
          Positioned(
            top: 50,
            left: 10,
            child: IconButton.filled(
              style:
                  IconButton.styleFrom(backgroundColor: CustomColors.primary),
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.close),
            ),
          ),
          Positioned(
            bottom: 20,
            right: 0,
            left: 0,
            child: SizedBox(
              height: 180, // Adjust this height as needed
              child: PageView.builder(
                controller: _scrollController,
                itemCount:
                    ref.watch(homePropertiesProvider).allApartments.length,
                itemBuilder: (context, index) {
                  final apartment =
                      ref.watch(homePropertiesProvider).allApartments[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: MapsPropertyCard(
                      apartment: apartment,
                      onTap: () {
                        _googleMapsController.future.then((controller) {
                          controller
                              .animateCamera(
                            CameraUpdate.newCameraPosition(
                              CameraPosition(
                                target: LatLng(
                                    apartment.latitude, apartment.longitude),
                                zoom: 14,
                              ),
                            ),
                          )
                              .then((_) {
                            setState(() =>
                                _selectedApartmentId = apartment.projectId);
                            controller.showMarkerInfoWindow(
                                MarkerId(apartment.projectId));
                          });
                        });
                      },
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
