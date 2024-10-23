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
import 'package:re_portal_frontend/riverpod/location_homes.dart';
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
  bool _loading = true;
  bool permissionDenied = false;
  bool defaultLocation = false;
  late LatLng currentLocation;
  LocationHomesData? userLocationHomesData;
  bool _noPropertiesFound = false;

  @override
  void initState() {
    super.initState();
    _initializeLocation();
  }

  Future<void> _initializeLocation() async {
    final location = await _getCurrentLocation();
    await _fetchLocationHomes(location.latitude, location.longitude);
  }

  Future<LatLng> _getCurrentLocation() async {
    final location = Location();
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    // Try to get service status and enable it
    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
    }

    // Try to get permission
    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
    }

    // If we have permission and service is enabled, try to get the location
    if (permissionGranted == PermissionStatus.granted && serviceEnabled) {
      try {
        final locationData = await location.getLocation();
        setState(() {
          currentLocation =
              LatLng(locationData.latitude!, locationData.longitude!);
          defaultLocation = false;
          permissionDenied = false;
        });
        return currentLocation;
      } catch (e) {
        debugPrint("Error getting location: $e");
      }
    }

    // If we couldn't get the location, use default
    setState(() {
      currentLocation = const LatLng(17.3850, 78.4867); // Default to Hyderabad
      defaultLocation = true;
      permissionDenied = permissionGranted != PermissionStatus.granted;
    });
    return currentLocation;
  }

  Future<void> _fetchLocationHomes(double lat, double long) async {
    setState(() {
      _loading = true;
      _noPropertiesFound = false;
    });

    final baseUrl = dotenv.get('BASE_URL');
    final uri = Uri.parse("$baseUrl/user/getPopularLocalities").replace(
      queryParameters: {
        "latitude": lat.toString(),
        "longitude": long.toString()
      },
    );

    try {
      final response = await http.get(uri);
      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        ref
            .read(locationHomesProvider.notifier)
            .setLocationHomesData(responseData);
        setState(() {
          userLocationHomesData = LocationHomesData.fromJson(responseData);
          _noPropertiesFound = userLocationHomesData!.projects.isEmpty;
        });
      } else {
        throw Exception('Error ${response.statusCode}: ${response.body}');
      }
    } catch (error) {
      debugPrint("Error fetching location homes: $error");
      setState(() {
        userLocationHomesData = null;
        _noPropertiesFound = true;
      });
      _showErrorDialog();
    } finally {
      setState(() => _loading = false);
    }
  }

  void _showErrorDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("No Properties Found"),
          content:
              const Text("We don't have any properties near your location"),
          actions: <Widget>[
            TextButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
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
          ? _buildPermissionDeniedWidget()
          : NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return [
                  SliverAppBar(
                    expandedHeight: h * 0.3,
                    floating: false,
                    automaticallyImplyLeading: false,
                    pinned: false,
                    flexibleSpace: FlexibleSpaceBar(
                      background: _loading
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
                                            position: currentLocation,
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
                                    if (userLocationHomesData != null &&
                                        !defaultLocation)
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
                                ),
                              ],
                            ),
                    ),
                  ),
                ];
              },
              body: _buildBody(),
            ),
    );
  }

  Widget _buildBody() {
    if (_loading) {
      return _buildShimmerEffect();
    } else if (_noPropertiesFound) {
      return _buildNoPropertiesWidget();
    } else if (userLocationHomesData == null) {
      return _buildErrorWidget();
    } else {
      return _buildPropertyList();
    }
  }

  Widget _buildShimmerEffect() {
    return SingleChildScrollView(
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
    );
  }

  Widget _buildNoPropertiesWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.home_work, size: 80, color: CustomColors.primary),
          const SizedBox(height: 20),
          const Text(
            "No Properties Found",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          const Text(
            "We couldn't find any properties in this area.",
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              gradient: LinearGradient(
                colors: [
                  CustomColors.primary,
                  CustomColors.primary.withOpacity(0.7)
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: CustomColors.primary.withOpacity(0.3),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const GlobalSearch(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.explore,
                    size: 20,
                    color: CustomColors.white,
                  ),
                  SizedBox(width: 10),
                  Text(
                    "Explore Other Locations",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: CustomColors.white,
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

  Widget _buildErrorWidget() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 80, color: CustomColors.primary),
          SizedBox(height: 20),
          Text(
            "Oops! Something went wrong",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Text(
            "We're having trouble loading the properties. Please try again later.",
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildPropertyList() {
    return SingleChildScrollView(
      child: Column(
        children: [
          if (defaultLocation)
            Container(
              margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: CustomColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border:
                    Border.all(color: CustomColors.primary.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline, color: CustomColors.primary),
                  const SizedBox(width: 12),
                  Expanded(
                    child: RichText(
                      text: const TextSpan(
                        style:
                            TextStyle(fontSize: 14, color: CustomColors.black),
                        children: [
                          TextSpan(
                            text: "Showing default properties. ",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                            text:
                                "No properties found in your area. You can still explore other great options!",
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          PropertyList(
            apartments: userLocationHomesData!.projects
                .map((e) => e.projects)
                .toList()
                .expand((x) => x)
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildPermissionDeniedWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(width: double.infinity),
        const Icon(Icons.location_off, size: 60, color: CustomColors.primary),
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
    );
  }
}
