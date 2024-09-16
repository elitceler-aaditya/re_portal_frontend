import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:re_portal_frontend/modules/shared/widgets/colors.dart';

class GoogleMapsScreen extends StatefulWidget {
  const GoogleMapsScreen({super.key});

  @override
  State<GoogleMapsScreen> createState() => _GoogleMapsScreenState();
}

class _GoogleMapsScreenState extends State<GoogleMapsScreen> {
  LatLng? currentLocation;
  static const googlePlex = LatLng(18.516958014646075, 73.86555773056193);

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

    Location.instance.onLocationChanged.listen((LocationData currentLocation) {
      if (currentLocation.latitude != null &&
          currentLocation.longitude != null) {
        setState(() {
          this.currentLocation =
              LatLng(currentLocation.latitude!, currentLocation.longitude!);
        });
      }

      setState(() {
        this.currentLocation =
            LatLng(currentLocation.latitude!, currentLocation.longitude!);
      });
    });
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchLocationUpdate();
    });
    super.initState();
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
          : GoogleMap(
              initialCameraPosition: CameraPosition(
                target: currentLocation!,
                zoom: 14,
              ),
              markers: {
                Marker(
                  markerId: const MarkerId('currentLocation'),
                  icon: BitmapDescriptor.defaultMarkerWithHue(2),
                  position: currentLocation!,
                  infoWindow: const InfoWindow(title: 'Current Location'),
                ),
              },
            ),
    );
  }
}
