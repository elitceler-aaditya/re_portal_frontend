import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:re_portal_frontend/modules/home/screens/property_details.dart';
import 'package:re_portal_frontend/modules/maps/maps_property_card.dart';
import 'package:re_portal_frontend/modules/shared/models/apartment_details_model.dart';
import 'package:re_portal_frontend/modules/shared/models/appartment_model.dart';
import 'package:re_portal_frontend/modules/shared/widgets/colors.dart';
import 'package:re_portal_frontend/riverpod/home_data.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart'
    as carousel;

class GoogleMapsScreen extends ConsumerStatefulWidget {
  final ApartmentModel apartment;
  final ApartmentDetailsResponse apartmentDetails;
  const GoogleMapsScreen({
    super.key,
    required this.apartment,
    required this.apartmentDetails,
  });

  @override
  ConsumerState<GoogleMapsScreen> createState() => _GoogleMapsScreenState();
}

class _GoogleMapsScreenState extends ConsumerState<GoogleMapsScreen> {
  LatLng? currentLocation;
  bool showSearch = false;
  List<ApartmentModel> apartments = [];
  List<LatLng> locations = [];
  StreamSubscription<LocationData>? _locationSubscription;
  final Completer<GoogleMapController> _googleMapsController =
      Completer<GoogleMapController>();
  String? _selectedApartmentId;
  final carousel.CarouselController carouselController =
      carousel.CarouselController();
  final TextEditingController _searchController = TextEditingController();
  List<String> propertyLocations = [];

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

  ApartmentModel getApartmentByLocation(String location) {
    return ref
        .watch(homePropertiesProvider)
        .allApartments
        .where((element) => element.projectLocation == location)
        .first;
  }

  panToLocation(ApartmentModel selectedAppt) async {
    final GoogleMapController controller = await _googleMapsController.future;
    final int index =
        ref.watch(homePropertiesProvider).allApartments.indexOf(selectedAppt);

    // Animate map
    await controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(selectedAppt.latitude, selectedAppt.longitude),
          zoom: 15,
        ),
      ),
    );

    setState(() {
      _selectedApartmentId = selectedAppt.projectId;
      controller.showMarkerInfoWindow(MarkerId(selectedAppt.projectId));
    });
    Future.delayed(const Duration(milliseconds: 800), () {
      carouselController.animateToPage(index,
          duration: const Duration(milliseconds: 800), curve: Curves.easeInOut);
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchLocationUpdate();
      apartments = ref.read(homePropertiesProvider).allApartments;
      propertyLocations =
          apartments.map((e) => e.projectLocation).toSet().toList();
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
                        icon: BitmapDescriptor.defaultMarker,
                        infoWindow: InfoWindow(
                          title: e.name,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PropertyDetails(
                                  apartment: e,
                                  heroTag: "map-prop-${e.projectId}",
                                ),
                              ),
                            );
                          },
                        ),
                        onTap: () {
                          setState(() {
                            _selectedApartmentId = e.projectId;
                          });

                          int index = ref
                              .watch(homePropertiesProvider)
                              .allApartments
                              .indexOf(e);
                          carouselController.animateToPage(index,
                              duration: const Duration(milliseconds: 800),
                              curve: Curves.easeInOut);
                        },
                      ),
                    )
              },
            ),
          ),
          Positioned(
            bottom: 20,
            right: 0,
            left: 0,
            child: SizedBox(
              height: 180,
              child: FlutterCarousel.builder(
                itemCount:
                    ref.watch(homePropertiesProvider).allApartments.length,
                itemBuilder: (context, index, realIndex) {
                  final apartment =
                      ref.watch(homePropertiesProvider).allApartments[index];
                  return MapsPropertyCard(
                    apartment: apartment,
                    apartmentDetails: widget.apartmentDetails,
                  );
                },
                options: CarouselOptions(
                  controller: carouselController,
                  height: 180,
                  viewportFraction: 0.85,
                  enableInfiniteScroll: false,
                  enlargeCenterPage: true,
                  enlargeStrategy: CenterPageEnlargeStrategy.height,
                  padEnds: false,
                  showIndicator: false,
                  onPageChanged: (index, reason) {
                    final apartment =
                        ref.watch(homePropertiesProvider).allApartments[index];
                    _googleMapsController.future.then((controller) {
                      controller
                          .animateCamera(
                        CameraUpdate.newCameraPosition(
                          CameraPosition(
                            target:
                                LatLng(apartment.latitude, apartment.longitude),
                            zoom: 14,
                          ),
                        ),
                      )
                          .then((_) {
                        setState(
                            () => _selectedApartmentId = apartment.projectId);
                        controller.showMarkerInfoWindow(
                            MarkerId(apartment.projectId));
                      });
                    });
                  },
                ),
              ),
            ),
          ),
          Positioned(
            top: 50,
            left: 10,
            child: Container(
              width: MediaQuery.of(context).size.width - 20,
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: CustomColors.white,
                borderRadius: BorderRadius.circular(25),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.arrow_back),
                      ),
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          onTap: () {
                            setState(() {
                              showSearch = true;
                            });
                          },
                          onChanged: (value) {
                            setState(() {});
                          },
                          style: const TextStyle(fontSize: 14),
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.zero,
                            hintText: 'Search locations...',
                            hintStyle: const TextStyle(
                              color: CustomColors.black50,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (_searchController.text.trim().isNotEmpty && showSearch)
                    ConstrainedBox(
                      constraints: const BoxConstraints(
                        maxHeight: 300,
                        minHeight: 0,
                      ),
                      child: RawScrollbar(
                        thumbColor: CustomColors.black50,
                        thumbVisibility: true,
                        child: ListView.builder(
                          shrinkWrap: true,
                          padding: const EdgeInsets.only(top: 2),
                          itemCount: apartments
                              .map((e) => e.projectLocation)
                              .where((element) => element
                                  .toLowerCase()
                                  .contains(_searchController.text
                                      .trim()
                                      .toLowerCase()))
                              .toSet()
                              .toList()
                              .length,
                          itemBuilder: (context, index) {
                            String value = apartments
                                .map((e) => e.projectLocation)
                                .where((element) => element
                                    .toLowerCase()
                                    .contains(_searchController.text
                                        .trim()
                                        .toLowerCase()))
                                .toSet()
                                .toList()[index];
                            return ListTile(
                              title: Text(value),
                              onTap: () {
                                setState(() {
                                  showSearch = false;
                                  _searchController.text = value;
                                  FocusManager.instance.primaryFocus?.unfocus();
                                  ApartmentModel selectedApartment =
                                      getApartmentByLocation(value);
                                  panToLocation(selectedApartment);
                                });
                              },
                            );
                          },
                        ),
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
