import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:re_portal_frontend/modules/home/screens/property_details.dart';
import 'package:re_portal_frontend/modules/maps/maps_property_card.dart';
import 'package:re_portal_frontend/modules/shared/models/apartment_details_model.dart';
import 'package:re_portal_frontend/modules/shared/models/appartment_model.dart';
import 'package:re_portal_frontend/modules/shared/widgets/colors.dart';
import 'package:re_portal_frontend/modules/shared/widgets/snackbars.dart';
import 'package:re_portal_frontend/riverpod/bot_nav_bar.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart'
    as carousel;
import 'package:re_portal_frontend/riverpod/locality_list.dart';
import 'package:re_portal_frontend/riverpod/maps_properties.dart';
//http
import 'package:http/http.dart' as http;
import 'package:re_portal_frontend/riverpod/user_riverpod.dart';
import 'package:visibility_detector/visibility_detector.dart';

class GoogleMapsScreen extends ConsumerStatefulWidget {
  final ApartmentModel apartment;
  final ApartmentDetailsResponse? apartmentDetails;
  final bool isPop;
  const GoogleMapsScreen({
    super.key,
    required this.apartment,
    this.apartmentDetails,
    this.isPop = false,
  });

  @override
  ConsumerState<GoogleMapsScreen> createState() => _GoogleMapsScreenState();
}

class _GoogleMapsScreenState extends ConsumerState<GoogleMapsScreen> {
  LatLng? currentLocation;
  bool showSearch = false;
  bool isEndReached = false;
  int currentPage = 1;
  int apartmentListTotalCount = 10;
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

  Future<void> getApartmentByLocation(String location,
      {int page = 1, bool pan = true}) async {
    Map<String, dynamic> params = {
      'page': page.toString(),
      'projectLocation': location,
    };
    debugPrint("-----------------params: $params");

    try {
      String baseUrl = dotenv.get('BASE_URL');
      String url = "$baseUrl/project/filterApartmentsNew";
      Uri uri = Uri.parse(url).replace(queryParameters: params);

      final response = await http.get(
        uri,
        headers: {
          "Authorization": "Bearer ${ref.watch(userProvider).token}",
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        Map<String, dynamic> responseData = jsonDecode(response.body);
        List responseBody = responseData['projects'] ?? [];
        if (responseBody.isNotEmpty) {
          apartmentListTotalCount = responseData['totalCount'];
          debugPrint("-----------------responseData: $responseData");
          ref.read(mapsApartmentProvider.notifier).addApartments(
                responseBody.map((e) => ApartmentModel.fromJson(e)).toList(),
              );
          if (pan) panToLocation(ref.watch(mapsApartmentProvider).first);
        } else {
          setState(() {
            isEndReached = true;
          });
          if (currentPage == 1) {
            errorSnackBar(
                context, 'No apartments in ${_searchController.text.trim()}');
          }
        }
      } else {
        throw Exception("${response.statusCode}: ${response.body}");
      }
    } catch (e) {
      errorSnackBar(context, 'Failed to fetch apartments');
      debugPrint("Error in getFilteredApartments: $e");
      // Handle error (e.g., show error message to user)
    } finally {}
  }

  void getLocalitiesList() async {
    String baseUrl = dotenv.get('BASE_URL');
    String url = "$baseUrl/user/getLocations";
    Uri uri = Uri.parse(url);

    try {
      final response = await http.get(uri);

      if (response.statusCode == 200 || response.statusCode == 201) {
        Map<String, dynamic> responseData = jsonDecode(response.body);
        List<dynamic> responseBody = responseData['data'];
        List<String> localities =
            responseBody.map((item) => item.toString()).toList();
        ref.read(localityListProvider.notifier).setLocalities(localities);
        getApartmentByLocation('');
      } else {
        throw Exception('Failed to load localities');
      }
    } catch (error, stackTrace) {
      debugPrint("error: $error");
      debugPrint("stackTrace: $stackTrace");
    }
  }

  panToLocation(ApartmentModel selectedAppt) async {
    final GoogleMapController controller = await _googleMapsController.future;
    final int index = ref.watch(mapsApartmentProvider).indexOf(selectedAppt);

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
      ref.read(mapsApartmentProvider.notifier).clearApartments();
      getLocalitiesList();
      fetchLocationUpdate();
      apartments = ref.read(mapsApartmentProvider);
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
    return PopScope(
      canPop: !widget.isPop,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          ref.read(navBarIndexProvider.notifier).setNavBarIndex(0);
        }
      },
      child: Scaffold(
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
                      controller.showMarkerInfoWindow(
                          MarkerId(_selectedApartmentId!));
                    });
                  }
                },
                initialCameraPosition: CameraPosition(
                  target: LatLng(
                      widget.apartment.latitude, widget.apartment.longitude),
                  zoom: 14,
                ),
                markers: {
                  ...ref.watch(mapsApartmentProvider).map(
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
                            // _selectedApartmentId = e.projectId;
                            panToLocation(ref
                                .watch(mapsApartmentProvider.notifier)
                                .getApartmentById(e.projectId));

                            int index =
                                ref.watch(mapsApartmentProvider).indexOf(e);
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
              bottom: 0,
              right: 0,
              left: 0,
              child: Container(
                height: 180,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      CustomColors.white.withOpacity(0.6),
                      CustomColors.white.withOpacity(0.01),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 10,
              right: 0,
              left: 0,
              child: FlutterCarousel.builder(
                itemCount: ref.watch(mapsApartmentProvider).length,
                itemBuilder: (context, index, realIndex) {
                  final apartment = ref.watch(mapsApartmentProvider)[index];
                  return VisibilityDetector(
                    key: Key(apartment.projectId),
                    onVisibilityChanged: (info) {
                      if (index + 1 ==
                              ref.watch(mapsApartmentProvider).length &&
                          info.visibleFraction >= 0) {
                        if (!isEndReached) {
                          getApartmentByLocation(
                            _searchController.text.trim(),
                            page: currentPage++,
                            pan: false,
                          );
                        }
                      }
                    },
                    child: MapsPropertyCard(
                      apartment: apartment,
                      index: index,
                      length: apartmentListTotalCount,
                    ),
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
                    if (reason == CarouselPageChangedReason.manual) {
                      final apartment = ref.watch(mapsApartmentProvider)[index];
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
                          setState(
                              () => _selectedApartmentId = apartment.projectId);
                          controller.showMarkerInfoWindow(
                              MarkerId(apartment.projectId));
                        });
                      });
                    }
                  },
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
                  // border: Border.all(color: CustomColors.black50),
                  boxShadow: const [
                    BoxShadow(
                      color: CustomColors.black50,
                      blurRadius: 16,
                    ),
                  ],
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
                            onSubmitted: (value) {
                              if (value.trim().isEmpty) {
                                setState(() {
                                  showSearch = false;
                                });
                              }
                            },
                            style: const TextStyle(fontSize: 14),
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.zero,
                              hintText: 'Search for locations...',
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
                        if (_searchController.text.trim().isNotEmpty)
                          IconButton(
                            onPressed: () {
                              setState(() {
                                isEndReached = false;
                                _searchController.clear();
                                showSearch = false;
                                ref
                                    .read(mapsApartmentProvider.notifier)
                                    .clearApartments();
                                getApartmentByLocation('');
                              });
                            },
                            icon: const Icon(
                              Icons.clear,
                              size: 20,
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
                            itemCount: ref
                                .watch(localityListProvider.notifier)
                                .searchLocality(
                                    _searchController.text.trim(), []).length,
                            itemBuilder: (context, index) {
                              // String value = apartments
                              //     .map((e) => e.projectLocation)
                              //     .where((element) => element
                              //         .toLowerCase()
                              //         .contains(_searchController.text
                              //             .trim()
                              //             .toLowerCase()))
                              //     .toSet()
                              //     .toList()[index];
                              return ListTile(
                                title: Text(ref
                                    .watch(localityListProvider.notifier)
                                    .searchLocality(
                                        _searchController.text.trim(),
                                        [])[index]),
                                onTap: () {
                                  setState(() {
                                    ref
                                        .read(mapsApartmentProvider.notifier)
                                        .clearApartments();

                                    showSearch = false;
                                    _searchController.text = ref
                                        .watch(localityListProvider.notifier)
                                        .searchLocality(
                                            _searchController.text.trim(),
                                            [])[index];
                                    FocusManager.instance.primaryFocus
                                        ?.unfocus();
                                    getApartmentByLocation(
                                        _searchController.text.trim());
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
      ),
    );
  }
}
