import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:re_portal_frontend/modules/maps/maps_property_card.dart';
import 'package:re_portal_frontend/modules/shared/models/appartment_model.dart';
import 'package:re_portal_frontend/modules/shared/widgets/colors.dart';

class GoogleMapsScreen extends StatefulWidget {
  final List<ApartmentModel> apartments;
  const GoogleMapsScreen({super.key, required this.apartments});

  @override
  State<GoogleMapsScreen> createState() => _GoogleMapsScreenState();
}

class _GoogleMapsScreenState extends State<GoogleMapsScreen> {
  LatLng? currentLocation;
  List<LatLng> locations = [];
  StreamSubscription<LocationData>? _locationSubscription;
  final Completer<GoogleMapController> _googleMapsController =
      Completer<GoogleMapController>();

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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchLocationUpdate();
      locations = widget.apartments.map((e) => LatLng(e.lat, e.long)).toList();
    });
    super.initState();
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
                    onMapCreated: (controller) =>
                        _googleMapsController.complete(controller),
                    initialCameraPosition: CameraPosition(
                      target: locations.last,
                      zoom: 14,
                    ),
                    markers: {
                      Marker(
                        markerId: const MarkerId('currentLocation'),
                        icon: BitmapDescriptor.defaultMarkerWithHue(2),
                        position: currentLocation!,
                        infoWindow: const InfoWindow(title: 'Current Location'),
                      ),
                      ...locations.map(
                        (e) => Marker(
                          markerId: MarkerId(e.toString()),
                          position: e,
                          infoWindow: const InfoWindow(title: 'Location'),
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
                        ...widget.apartments.map(
                          (e) => MapsPropertyCard(
                            apartment: e,
                            onTap: () {
                              //camera should pan to this location
                              _googleMapsController.future.then((controller) {
                                controller.animateCamera(
                                  CameraUpdate.newCameraPosition(
                                    CameraPosition(
                                      target: LatLng(e.lat, e.long),
                                      zoom: 14,
                                    ),
                                  ),
                                );
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
