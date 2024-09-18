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
      final apartments = ref.read(homePropertiesProvider).apartments;
      locations = apartments.map((e) => LatLng(e.lat, e.long)).toList();

      // Set the initial selected apartment
      if (apartments.isNotEmpty) {
        _selectedApartmentId = widget.apartment.apartmentID;
      }
    });
  }

  @override
  void dispose() {
    _locationSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: currentLocation == null
          ? const Center(
              child: CircularProgressIndicator(
                color: CustomColors.primary,
                strokeCap: StrokeCap.round,
              ),
            )
          : Stack(
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
                          controller.showMarkerInfoWindow(
                              MarkerId(_selectedApartmentId!));
                        });
                      }
                    },
                    initialCameraPosition: CameraPosition(
                      target:
                          LatLng(widget.apartment.lat, widget.apartment.long),
                      zoom: 14,
                    ),
                    markers: {
                      Marker(
                        markerId: const MarkerId('currentLocation'),
                        icon: BitmapDescriptor.defaultMarkerWithHue(2),
                        position: currentLocation!,
                        infoWindow: const InfoWindow(title: 'Current Location'),
                      ),
                      ...ref.watch(homePropertiesProvider).apartments.map(
                            (e) => Marker(
                              markerId: MarkerId(e.apartmentID),
                              position: LatLng(e.lat, e.long),
                              infoWindow: InfoWindow(title: e.apartmentName),
                              onTap: () => setState(
                                  () => _selectedApartmentId = e.apartmentID),
                            ),
                          )
                    },
                  ),
                ),
                //top left close button
                Positioned(
                  top: 50,
                  left: 10,
                  child: IconButton.filled(
                    style: IconButton.styleFrom(
                        backgroundColor: CustomColors.primary),
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close),
                  ),
                ),
                Positioned(
                  bottom: 20,
                  right: 0,
                  left: 0,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        //Apaprtmet list
                        const SizedBox(width: 10),
                        ...ref.watch(homePropertiesProvider).apartments.map(
                              (e) => MapsPropertyCard(
                                apartment: e,
                                onTap: () {
                                  _googleMapsController.future
                                      .then((controller) {
                                    controller
                                        .animateCamera(
                                      CameraUpdate.newCameraPosition(
                                        CameraPosition(
                                          target: LatLng(e.lat, e.long),
                                          zoom: 14,
                                        ),
                                      ),
                                    )
                                        .then((_) {
                                      setState(() =>
                                          _selectedApartmentId = e.apartmentID);
                                      controller.showMarkerInfoWindow(
                                          MarkerId(e.apartmentID));
                                    });
                                  });
                                },
                              ),
                            ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
