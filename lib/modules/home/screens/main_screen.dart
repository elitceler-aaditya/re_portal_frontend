import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jwt_io/jwt_io.dart';
import 'package:re_portal_frontend/modules/home/screens/compare/compare_properties.dart';
import 'package:re_portal_frontend/modules/home/screens/home_Maps_screen.dart';
import 'package:re_portal_frontend/modules/home/screens/home_screen.dart';
import 'package:re_portal_frontend/modules/home/screens/saved_properties/saved_properties.dart';
import 'package:re_portal_frontend/modules/search/screens/search_apartments_results.dart';
import 'package:re_portal_frontend/modules/shared/models/user.dart';
import 'package:re_portal_frontend/modules/shared/widgets/bot_nav_bar.dart';
import 'package:re_portal_frontend/riverpod/bot_nav_bar.dart';
import 'package:re_portal_frontend/riverpod/user_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  bool permissionDenied = false;

  final List<Widget> _screens = const [
    HomeScreen(),
    SearchApartmentResults(),
    HomeMapsScreen(),
    CompareProperties(),
    SavedProperties(),
  ];

  Future<LatLng> _getCurrentLocation() async {
    final location = Location();
    bool serviceEnabled;
    late LatLng currentLocation;
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
      permissionDenied = permissionGranted != PermissionStatus.granted;
    });
    return currentLocation;
  }

  void setUserData() async {
    final sharedPref = await SharedPreferences.getInstance();
    final token = sharedPref.getString('token');
    if (token != null && token.isNotEmpty) {
      final userData = JwtToken.payload(token);
      ref
          .read(userProvider.notifier)
          .setUser(User.fromJson({...userData, 'token': token}));
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _getCurrentLocation().then((LatLng currentLocation) {
        ref.read(userProvider.notifier).setUserLocation(currentLocation);
      });
    });
    setUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[ref.watch(navBarIndexProvider)],
      bottomNavigationBar: const CustomBottomNavBar(),
    );
  }
}
