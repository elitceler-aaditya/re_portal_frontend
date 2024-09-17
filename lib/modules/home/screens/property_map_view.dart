import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:re_portal_frontend/modules/shared/models/appartment_model.dart';
import 'package:re_portal_frontend/modules/shared/widgets/colors.dart';

class PropertyMapView extends StatefulWidget {
  final ApartmentModel apartment;
  const PropertyMapView({super.key, required this.apartment});

  @override
  State<PropertyMapView> createState() => _PropertyMapViewState();
}

class _PropertyMapViewState extends State<PropertyMapView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomColors.white,
        elevation: 0,
        titleSpacing: 0,
        title: Text(
          widget.apartment.apartmentName,
          style: const TextStyle(
            color: CustomColors.black,
            fontSize: 24,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: Hero(
        tag: widget.apartment.apartmentID,
        child: GoogleMap(
          initialCameraPosition: CameraPosition(
            target: LatLng(widget.apartment.lat, widget.apartment.long),
            zoom: 15,
          ),
          markers: {
            Marker(
              markerId: MarkerId(widget.apartment.apartmentID),
              position: LatLng(widget.apartment.lat, widget.apartment.long),
              icon: BitmapDescriptor.defaultMarkerWithHue(2),
              infoWindow: InfoWindow(
                title: widget.apartment.apartmentName,
              ),
            ),
          },
        ),
      ),
    );
  }
}
