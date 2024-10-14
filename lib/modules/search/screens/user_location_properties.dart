import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:re_portal_frontend/modules/home/models/location_homes_data.dart';
import 'package:re_portal_frontend/modules/home/screens/property_list.dart';
import 'package:re_portal_frontend/modules/search/screens/global_search.dart';
import 'package:re_portal_frontend/modules/shared/widgets/colors.dart';
import 'package:http/http.dart' as http;
import 'package:shimmer/shimmer.dart';
import 'package:app_settings/app_settings.dart';

class UserLocationProperties extends ConsumerStatefulWidget {
  const UserLocationProperties({super.key});

  @override
  ConsumerState<UserLocationProperties> createState() =>
      _UserLocationPropertiesState();
}

class _UserLocationPropertiesState
    extends ConsumerState<UserLocationProperties> {
  StreamSubscription<LocationData>? _locationSubscription;
  LatLng? currentLocation;
  LocationHomesData? userLocationHomesData;
  bool permissionDenied = false;

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
      setState(() {
        permissionDenied = true;
      });
      permissionGranted = await Location.instance.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        setState(() {
          permissionDenied = false;
        });
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

        getLocationHomes(
          currentLocation.latitude!,
          currentLocation.longitude!,
        );
      }
    });
  }

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
        setState(() {
          userLocationHomesData = LocationHomesData.fromJson(responseData);
        });
      } else {
        throw Exception('Error ${response.statusCode}: ${response.body}');
      }
    } catch (error, stackTrace) {
      debugPrint("error: $error");
      debugPrint("stackTrace: $stackTrace");
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchLocationUpdate();
    });
  }

  @override
  void dispose() {
    _locationSubscription?.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomColors.primary,
        titleSpacing: 0,
        iconTheme: const IconThemeData(color: CustomColors.white),
        title: const Text(
          "Properties in your area",
          style: TextStyle(color: CustomColors.white),
        ),
      ),
      body: permissionDenied
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(width: double.infinity),
                const Icon(Icons.location_off,
                    size: 60, color: CustomColors.primary),
                const SizedBox(height: 16),
                const Text(
                  "Location Permission Denied",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: CustomColors.primary,
                  ),
                ),
                const SizedBox(height: 8),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 32),
                  child: Text(
                    "Please enable location permission in settings to view properties in your area",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: CustomColors.black75,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: CustomColors.primary20,
                    foregroundColor: CustomColors.primary,
                  ),
                  onPressed: () => AppSettings.openAppSettings(),
                  child: const Text("Open settings"),
                ),
              ],
            )
          : NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return [
                  SliverAppBar(
                    expandedHeight: h * 0.3,
                    floating: false,
                    automaticallyImplyLeading: false,
                    pinned: false,
                    flexibleSpace: FlexibleSpaceBar(
                      background: currentLocation == null
                          ? Shimmer.fromColors(
                              baseColor: CustomColors.black25,
                              highlightColor: CustomColors.black50,
                              child: Container(
                                height: 200,
                                width: double.infinity,
                                decoration: const BoxDecoration(
                                    color: CustomColors.white),
                              ),
                            )
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Stack(
                                  children: [
                                    SizedBox(
                                      height: h * 0.3,
                                      width: double.infinity,
                                      child: GoogleMap(
                                        zoomControlsEnabled: false,
                                        mapToolbarEnabled: false,
                                        initialCameraPosition: CameraPosition(
                                          target: currentLocation!,
                                          zoom: 12,
                                        ),
                                        markers: {
                                          Marker(
                                            markerId:
                                                const MarkerId("user_location"),
                                            position: currentLocation ??
                                                const LatLng(0, 0),
                                            icon: BitmapDescriptor
                                                .defaultMarkerWithHue(2),
                                            infoWindow: const InfoWindow(
                                              title: "Your Location",
                                            ),
                                          ),
                                        },
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 0,
                                      right: 0,
                                      left: 0,
                                      child: Container(
                                        width: double.infinity,
                                        height: 50,
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              CustomColors.white,
                                              CustomColors.white.withOpacity(0),
                                            ],
                                            begin: Alignment.bottomCenter,
                                            end: Alignment.topCenter,
                                          ),
                                        ),
                                      ),
                                    ),
                                    if (userLocationHomesData != null)
                                      Positioned(
                                        bottom: 10,
                                        right: 10,
                                        child: Text(
                                          "${userLocationHomesData!.projects.length} locations found",
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: CustomColors.secondary,
                                          ),
                                        ),
                                      ),
                                  ],
                                )
                              ],
                            ),
                    ),
                  ),
                ];
              },
              body: userLocationHomesData == null
                  ? SingleChildScrollView(
                      child: Column(
                        children: [
                          const SizedBox(height: 20),
                          ...List.generate(
                            10,
                            (index) => Shimmer.fromColors(
                              baseColor: CustomColors.black10,
                              highlightColor: CustomColors.black25,
                              child: Container(
                                height: 200,
                                width: double.infinity,
                                margin: const EdgeInsets.only(bottom: 10),
                                decoration: BoxDecoration(
                                  color: CustomColors.white,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  : userLocationHomesData!.projects.isEmpty
                      ? SizedBox(
                          height: h * 0.7,
                          width: double.infinity,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Text(
                                "No properties found in your area",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: CustomColors.secondary,
                                ),
                              ),
                              const SizedBox(height: 20),
                              ElevatedButton.icon(
                                onPressed: () {
                                  Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const GlobalSearch(),
                                    ),
                                  );
                                },
                                icon: const Icon(Icons.explore_outlined),
                                label: const Text(
                                  "Explore other locations",
                                  style: TextStyle(
                                    color: CustomColors.primary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      : SingleChildScrollView(
                          child: PropertyList(
                            apartments: userLocationHomesData!.projects
                                .map((e) => e.projects)
                                .toList()
                                .expand((x) => x)
                                .toList(),
                          ),
                        ),
            ),
    );
  }
}
