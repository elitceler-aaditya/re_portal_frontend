import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:re_portal_frontend/modules/builder/screens/builder_portfolio.dart';
import 'package:re_portal_frontend/modules/home/screens/ads_section.dart';
import 'package:re_portal_frontend/modules/home/widgets/custom_chip.dart';
import 'package:re_portal_frontend/modules/home/widgets/property_card.dart';
import 'package:re_portal_frontend/modules/maps/google_maps_screen.dart';
import 'package:re_portal_frontend/modules/shared/models/apartment_details_model.dart';
import 'package:re_portal_frontend/modules/shared/models/appartment_model.dart';
import 'package:re_portal_frontend/modules/shared/widgets/colors.dart';
import 'package:re_portal_frontend/modules/shared/widgets/transitions.dart';
import 'package:re_portal_frontend/riverpod/compare_appartments.dart';
import 'package:re_portal_frontend/riverpod/saved_properties.dart';
import 'package:re_portal_frontend/riverpod/user_riverpod.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

class PropertyDetails extends ConsumerStatefulWidget {
  final ApartmentModel apartment;
  final ApartmentModel? nextApartment;
  final String heroTag;
  const PropertyDetails({
    super.key,
    required this.apartment,
    required this.heroTag,
    this.nextApartment,
  });

  @override
  ConsumerState<PropertyDetails> createState() => _PropertyDetailsState();
}

class _PropertyDetailsState extends ConsumerState<PropertyDetails> {
  bool _showFullDescription = false;
  bool _showKeyHighlights = true;
  final _nameController = TextEditingController();
  final _mobileController = TextEditingController();
  final _emailController = TextEditingController();
  final _enquiryDetails = TextEditingController();
  ApartmentDetailsResponse _projectDetails = const ApartmentDetailsResponse();
  OverlayEntry? _overlayEntry;
  bool _isOverlayVisible = false;
  final GlobalKey contactButtonKey = GlobalKey(debugLabel: 'contact-button');
  final GlobalKey nextPropertyButtonKey =
      GlobalKey(debugLabel: 'next-property-button');
  List<Map<String, dynamic>> _highlights = [];
  int timerIndex = 0;
  int galleryIndex = 0;
  int configIndex = 0;
  String displayImage = "";
  Timer? _timer;
  ScrollController galleryController = ScrollController();
  ScrollController configController = ScrollController();

  Future<void> sendEnquiry(BuildContext context) async {
    final url = Uri.parse("${dotenv.env['BASE_URL']}/user/lead-generation");
    final body = {
      "name": _nameController.text.trim(),
      "number": _mobileController.text.trim(),
      "email": _emailController.text.trim(),
      "enquiryDetails": _enquiryDetails.text.trim().isEmpty
          ? "No details"
          : _enquiryDetails.text.trim(),
    };

    final token = ref.read(userProvider).token;
    if (token.isEmpty) {
      errorSnackBar(context, 'User not authenticated');
      return;
    }

    try {
      final response = await http
          .post(
            url,
            headers: {
              "Authorization": "Bearer $token",
              "Content-Type": "application/json",
            },
            body: jsonEncode(body),
          )
          .timeout(const Duration(seconds: 10));

      if (!context.mounted) return;

      if (response.statusCode == 200 || response.statusCode == 201) {
        Navigator.pop(context);
        await enquirySuccessBottomSheet();
      } else {
        throw HttpException('Failed to send enquiry: ${response.statusCode}');
      }
    } on TimeoutException {
      errorSnackBar(context, 'Request timed out. Please try again.');
    } on SocketException {
      errorSnackBar(context, 'No internet connection');
    } on HttpException catch (e) {
      errorSnackBar(context, e.message);
      debugPrint("HTTP Exception: ${e.message}");
    } catch (e) {
      errorSnackBar(context, 'An unexpected error occurred');
      debugPrint("Unexpected error: $e");
    }
  }

  void errorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  enquirySuccessBottomSheet() {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 150,
              width: double.infinity,
              child: Stack(
                children: [
                  SizedBox(
                    height: 150,
                    width: double.infinity,
                    child: ClipRRect(
                      borderRadius:
                          const BorderRadius.vertical(top: Radius.circular(20)),
                      child: Image.network(
                        widget.apartment.coverImage,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: const Icon(
                          Icons.close,
                          color: CustomColors.white,
                        )),
                  )
                ],
              ),
            ),
            Container(
              color: CustomColors.green,
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.check_circle,
                    color: CustomColors.white,
                  ),
                  SizedBox(width: 10),
                  Text(
                    "Your details have been shared",
                    style: TextStyle(
                      color: CustomColors.white,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.phone,
                    color: CustomColors.black,
                    size: 16,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    "For more details ${widget.apartment.companyPhone}",
                    style: const TextStyle(
                      color: CustomColors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            if (widget.nextApartment != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: PropertyCard(
                  apartment: widget.nextApartment!,
                  isCompare: false,
                  onCallPress: (context) {
                    _showOverlay(
                      context,
                      nextPropertyButtonKey.currentContext!.findRenderObject()
                          as RenderBox,
                    );
                  },
                  globalKey: nextPropertyButtonKey,
                ),
              ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: AdsSection(),
            ),
          ],
        );
      },
    );
  }

  _keyHighlights(String title, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
      ),
      child: Row(
        children: [
          SvgPicture.asset(
            "assets/icons/home_location_pin.svg",
            color: CustomColors.primary,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 12,
                color: CustomColors.white,
              ),
            ),
          ),
          const SizedBox(
            width: 24,
            child: DottedLine(
              lineLength: double.infinity,
              lineThickness: 1.5,
              dashLength: 8,
              dashGapLength: 8,
              dashColor: CustomColors.white,
            ),
          ),
          const Icon(Icons.arrow_forward_ios,
              size: 10, color: CustomColors.white),
          const SizedBox(width: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 12,
              color: CustomColors.white,
            ),
          ),
        ],
      ),
    );
  }

  highlightsOption(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 10,
              color: CustomColors.white,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: CustomColors.white,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  sqftArea({double area = 1, double budget = 1}) {
    //rate per sqft
    int rate = budget ~/ area;
    // appropriate commas
    String rateWithCommas = rate.toString().replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},');
    return "$rateWithCommas/sq.ft";
  }

  formatBudget(double budget) {
    if (budget < 10000000) {
      return "₹${(budget / 100000).toStringAsFixed(1)} Lac";
    } else {
      return "₹${(budget / 10000000).toStringAsFixed(2)} Cr";
    }
  }

  enquiryFormPopup() {
    return showDialog(
      context: context,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.fromLTRB(
              16, 16, 16, MediaQuery.of(context).viewInsets.bottom),
          child: Center(
            child: Wrap(
              children: [
                Material(
                  borderRadius: BorderRadius.circular(20),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(width: 30),
                            const Text(
                              'Enquiry Form',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: const Icon(Icons.close),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              TextField(
                                controller: _nameController,
                                decoration: const InputDecoration(
                                  label: Text("Name"),
                                  border: OutlineInputBorder(),
                                  focusedBorder: OutlineInputBorder(),
                                  focusColor: CustomColors.black,
                                  labelStyle: TextStyle(
                                    color: CustomColors.black,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              TextField(
                                controller: _mobileController,
                                decoration: const InputDecoration(
                                  label: Text('Mobile'),
                                  border: OutlineInputBorder(),
                                  focusedBorder: OutlineInputBorder(),
                                  focusColor: CustomColors.black,
                                  labelStyle: TextStyle(
                                    color: CustomColors.black,
                                  ),
                                ),
                                keyboardType: TextInputType.phone,
                              ),
                              const SizedBox(height: 16),
                              TextField(
                                controller: _emailController,
                                decoration: const InputDecoration(
                                  label: Text('Email'),
                                  border: OutlineInputBorder(),
                                  focusedBorder: OutlineInputBorder(),
                                  focusColor: CustomColors.black,
                                  labelStyle: TextStyle(
                                    color: CustomColors.black,
                                  ),
                                ),
                                keyboardType: TextInputType.emailAddress,
                              ),
                              const SizedBox(height: 16),
                              TextField(
                                controller: _enquiryDetails,
                                textAlign: TextAlign.start,
                                decoration: const InputDecoration(
                                  label: Text('Enquire about your doubts'),
                                  border: OutlineInputBorder(),
                                  focusedBorder: OutlineInputBorder(),
                                  focusColor: CustomColors.black,
                                  labelStyle: TextStyle(
                                    color: CustomColors.black,
                                  ),
                                ),
                                minLines: 1,
                                maxLines: 3,
                              ),
                              const SizedBox(height: 24),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () {
                                    sendEnquiry(context);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: CustomColors.primary,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 16,
                                    ),
                                  ),
                                  child: const Text(
                                    'Submit',
                                    style: TextStyle(
                                      color: CustomColors.white,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // dataSheet() {
  //   return Container();
  // }

  dataSheet() {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: CustomColors.black,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Column(
                children: [
                  if (widget.apartment.projectLocation.isNotEmpty)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 24,
                          // width: 32,
                          child: SvgPicture.asset(
                              "assets/icons/home_location_pin.svg"),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          "${widget.apartment.projectLocation}, Hyderabad",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: CustomColors.white,
                          ),
                        ),
                      ],
                    ),
                  const SizedBox(height: 10),
                  Container(
                    height: 100,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: CustomColors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: GoogleMap(
                            zoomControlsEnabled: false,
                            mapToolbarEnabled: false,
                            initialCameraPosition: CameraPosition(
                              target: LatLng(widget.apartment.latitude,
                                  widget.apartment.longitude),
                              zoom: 10,
                            ),
                            markers: {
                              Marker(
                                markerId: MarkerId(widget.apartment.projectId),
                                position: LatLng(widget.apartment.latitude,
                                    widget.apartment.longitude),
                                icon: BitmapDescriptor.defaultMarkerWithHue(2),
                                infoWindow: InfoWindow(
                                  title: widget.apartment.name,
                                ),
                              ),
                            },
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => GoogleMapsScreen(
                                  apartment: widget.apartment,
                                ),
                              ),
                            );
                          },
                          child: Container(
                            height: 150,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: CustomColors.black.withOpacity(0.001),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            if (widget.apartment.description.isNotEmpty)
              Container(
                width: double.infinity,
                margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: CustomColors.black75,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Project Description",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: CustomColors.white,
                      ),
                    ),
                    const SizedBox(height: 10),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _showFullDescription = !_showFullDescription;
                        });
                      },
                      child: Text(
                        widget.apartment.description,
                        maxLines: _showFullDescription ? 100 : 3,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.normal,
                          color: CustomColors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            if (_projectDetails.projectImages.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        "Project Gallery",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: CustomColors.white,
                        ),
                      ),
                    ),
                    const Divider(
                      height: 10,
                      color: CustomColors.black50,
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          const SizedBox(width: 10),
                          ...List.generate(
                            _projectDetails.projectImages.length,
                            (index) => _projectDetails
                                    .projectImages[index].images.isEmpty
                                ? const SizedBox()
                                : Padding(
                                    padding: const EdgeInsets.only(right: 8),
                                    child: TextButton(
                                      style: TextButton.styleFrom(
                                        backgroundColor: galleryIndex == index
                                            ? CustomColors.white
                                            : Colors.transparent,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          galleryIndex = index;
                                        });
                                        galleryController.animateTo(
                                          0,
                                          duration:
                                              const Duration(milliseconds: 300),
                                          curve: Curves.easeInOut,
                                        );
                                      },
                                      child: Text(
                                        _projectDetails
                                            .projectImages[index].title,
                                        style: TextStyle(
                                          color: galleryIndex == index
                                              ? CustomColors.primary
                                              : CustomColors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                          ),
                          const SizedBox(width: 10),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 200,
                      child: ListView.builder(
                        controller: galleryController,
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: _projectDetails
                            .projectImages[galleryIndex].images.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => PhotoView(
                                    imageProvider: NetworkImage(
                                      _projectDetails
                                          .projectImages[galleryIndex]
                                          .images[index],
                                    ),
                                    minScale:
                                        PhotoViewComputedScale.contained * 0.70,
                                    maxScale:
                                        PhotoViewComputedScale.contained * 2,
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              width: 320,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: Image.network(
                                  _projectDetails.projectImages[galleryIndex]
                                      .images[index],
                                  key: GlobalKey(
                                    debugLabel:
                                        "${_projectDetails.projectImages[galleryIndex].title}-$index",
                                  ),
                                  fit: BoxFit.cover,
                                  loadingBuilder: (context, child,
                                          loadingProgress) =>
                                      loadingProgress == null
                                          ? child
                                          : Shimmer.fromColors(
                                              baseColor: CustomColors.black75,
                                              highlightColor:
                                                  CustomColors.black25,
                                              child: Container(
                                                height: 200,
                                                width: 320,
                                                decoration: BoxDecoration(
                                                  color: Colors.black,
                                                  borderRadius:
                                                      BorderRadius.circular(16),
                                                ),
                                              ),
                                            ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            if (_projectDetails.unitPlanConfigFilesFormatted.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    const Text(
                      "Configurations",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: CustomColors.white,
                      ),
                    ),
                    const Divider(
                      height: 12,
                      color: CustomColors.black50,
                    ),
                    if (_projectDetails.unitPlanConfigFilesFormatted
                        .map((e) => e.bHKType)
                        .isNotEmpty)
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            ...List.generate(
                              _projectDetails.unitPlanConfigFilesFormatted
                                  .map((e) => e.bHKType)
                                  .length,
                              (index) => _projectDetails
                                      .unitPlanConfigFilesFormatted
                                      .map((e) => e.bHKType)
                                      .isEmpty
                                  ? const SizedBox()
                                  : Padding(
                                      padding: const EdgeInsets.only(right: 8),
                                      child: TextButton(
                                        style: TextButton.styleFrom(
                                          backgroundColor: configIndex == index
                                              ? CustomColors.white
                                              : Colors.transparent,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            configIndex = index;
                                          });
                                          configController.animateTo(
                                            0,
                                            duration: const Duration(
                                                milliseconds: 300),
                                            curve: Curves.easeInOut,
                                          );
                                        },
                                        child: Text(
                                          _projectDetails
                                              .unitPlanConfigFilesFormatted
                                              .map((e) => e.bHKType)
                                              .toList()[index],
                                          style: TextStyle(
                                            color: configIndex == index
                                                ? CustomColors.primary
                                                : CustomColors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                            ),
                          ],
                        ),
                      ),
                    const SizedBox(height: 8),
                    if (_projectDetails.projectImages.isNotEmpty)
                      const SizedBox(height: 10),
                    SizedBox(
                      height: 200,
                      child: ListView.builder(
                        controller: configController,
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: _projectDetails
                            .unitPlanConfigFilesFormatted[configIndex]
                            .unitPlanConfigFiles
                            .length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => PhotoView(
                                    imageProvider: NetworkImage(
                                      _projectDetails
                                          .unitPlanConfigFilesFormatted[
                                              configIndex]
                                          .unitPlanConfigFiles[index],
                                    ),
                                    minScale:
                                        PhotoViewComputedScale.contained * 0.70,
                                    maxScale:
                                        PhotoViewComputedScale.contained * 2,
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              width: 320,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: Image.network(
                                  _projectDetails
                                      .unitPlanConfigFilesFormatted[configIndex]
                                      .unitPlanConfigFiles[index],
                                  fit: BoxFit.cover,
                                  loadingBuilder: (context, child,
                                          loadingProgress) =>
                                      loadingProgress == null
                                          ? child
                                          : Shimmer.fromColors(
                                              baseColor: CustomColors.black75,
                                              highlightColor:
                                                  CustomColors.black25,
                                              child: Container(
                                                height: 200,
                                                width: 320,
                                                decoration: BoxDecoration(
                                                  color: Colors.black,
                                                  borderRadius:
                                                      BorderRadius.circular(16),
                                                ),
                                              ),
                                            ),
                                  errorBuilder: (context, error, stackTrace) =>
                                      const Center(
                                    child: Text(
                                      "Error loading image",
                                      style: TextStyle(
                                        color: CustomColors.red,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            if (_projectDetails.projectDetails.amenities.isNotEmpty)
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      "Amenities",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: CustomColors.white,
                      ),
                    ),
                  ),
                  const Divider(
                    height: 20,
                    color: CustomColors.black50,
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(width: 10),
                        Column(
                          children: [
                            const Text(
                              "General Amenities",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.normal,
                                color: CustomColors.white,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              height: 150,
                              margin: const EdgeInsets.only(right: 10),
                              constraints: BoxConstraints(
                                maxWidth:
                                    MediaQuery.of(context).size.width - 50,
                              ),
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: CustomColors.black75,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Wrap(
                                children: List.generate(
                                  _projectDetails.projectDetails.amenities
                                      .split(",")
                                      .length,
                                  (index) => CustomChip(
                                    text: _projectDetails
                                        .projectDetails.amenities
                                        .split(",")[index],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            const Text(
                              "Clubhouse Amenities",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.normal,
                                color: CustomColors.white,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              height: 150,
                              margin: const EdgeInsets.only(right: 10),
                              constraints: BoxConstraints(
                                maxWidth:
                                    MediaQuery.of(context).size.width - 50,
                              ),
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: CustomColors.black75,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Wrap(
                                children: List.generate(
                                  _projectDetails
                                      .projectDetails.clubHouseAmenities
                                      .split(",")
                                      .length,
                                  (index) => CustomChip(
                                    text: _projectDetails
                                        .projectDetails.clubHouseAmenities
                                        .split(",")[index],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            const Text(
                              "Outdoor Amenities",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.normal,
                                color: CustomColors.white,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              height: 150,
                              margin: const EdgeInsets.only(right: 10),
                              constraints: BoxConstraints(
                                maxWidth:
                                    MediaQuery.of(context).size.width - 50,
                              ),
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: CustomColors.black75,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Wrap(
                                children: List.generate(
                                  _projectDetails
                                      .projectDetails.outdoorAmenities
                                      .split(",")
                                      .length,
                                  (index) => CustomChip(
                                    text: _projectDetails
                                        .projectDetails.outdoorAmenities
                                        .split(",")[index],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 10),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            if (_projectDetails.projectDetails.hospitals.isNotEmpty &&
                _projectDetails.projectDetails.offices.isNotEmpty &&
                _projectDetails.projectDetails.connectivity.isNotEmpty)
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      "Key Highlights ",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: CustomColors.white,
                      ),
                    ),
                  ),
                  const Divider(
                    height: 20,
                    color: CustomColors.black50,
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(width: 10),
                        if (_projectDetails.projectDetails.hospitals.isNotEmpty)
                          Column(
                            children: [
                              const Text(
                                "Hospitals",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal,
                                  color: CustomColors.white,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                height: 150,
                                margin: const EdgeInsets.only(right: 10),
                                constraints: BoxConstraints(
                                  maxWidth:
                                      MediaQuery.of(context).size.width - 50,
                                ),
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: CustomColors.black75,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Wrap(
                                  children: List.generate(
                                    _projectDetails
                                        .projectDetails.hospitals.length,
                                    (index) => _keyHighlights(
                                      _projectDetails
                                          .projectDetails.hospitals[index].name,
                                      _projectDetails
                                          .projectDetails.hospitals[index].dist,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        if (_projectDetails.projectDetails.offices.isNotEmpty)
                          Column(
                            children: [
                              const Text(
                                "Offices",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal,
                                  color: CustomColors.white,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                height: 150,
                                margin: const EdgeInsets.only(right: 10),
                                constraints: BoxConstraints(
                                  maxWidth:
                                      MediaQuery.of(context).size.width - 50,
                                ),
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: CustomColors.black75,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Wrap(
                                  children: List.generate(
                                    _projectDetails
                                        .projectDetails.offices.length,
                                    (index) => _keyHighlights(
                                      _projectDetails
                                          .projectDetails.offices[index].name,
                                      _projectDetails
                                          .projectDetails.offices[index].dist,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        if (_projectDetails
                            .projectDetails.connectivity.isNotEmpty)
                          Column(
                            children: [
                              const Text(
                                "Connectivity",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal,
                                  color: CustomColors.white,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                height: 150,
                                margin: const EdgeInsets.only(right: 10),
                                constraints: BoxConstraints(
                                  maxWidth:
                                      MediaQuery.of(context).size.width - 50,
                                ),
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: CustomColors.black75,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Wrap(
                                  children: List.generate(
                                    _projectDetails
                                        .projectDetails.connectivity.length,
                                    (index) => _keyHighlights(
                                      _projectDetails.projectDetails
                                          .connectivity[index].name,
                                      _projectDetails.projectDetails
                                          .connectivity[index].dist,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        // const SizedBox(width: 10),
                      ],
                    ),
                  ),
                ],
              ),
            const Divider(
              height: 20,
              color: CustomColors.black50,
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: () {
                      enquiryFormPopup();
                    },
                    child: Container(
                      height: 120,
                      width: 200,
                      decoration: BoxDecoration(
                        color: CustomColors.white.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Stack(
                        children: [
                          const Positioned(
                            top: 10,
                            left: 10,
                            child: Text(
                              "Brochure",
                              style: TextStyle(
                                fontSize: 16,
                                color: CustomColors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 10,
                            right: 10,
                            child: Container(
                              decoration: BoxDecoration(
                                color: CustomColors.black.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              child: const Text(
                                "Download",
                                style: TextStyle(
                                  fontSize: 10,
                                  color: CustomColors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  GestureDetector(
                    onTap: () {
                      enquiryFormPopup();
                    },
                    child: Container(
                      height: 120,
                      width: 200,
                      decoration: BoxDecoration(
                        color: CustomColors.white.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            top: 0,
                            left: 0,
                            bottom: 0,
                            right: 0,
                            child: Center(
                              child: IconButton.filled(
                                style: IconButton.styleFrom(
                                  backgroundColor:
                                      CustomColors.black.withOpacity(0.5),
                                ),
                                onPressed: () {
                                  enquiryFormPopup();
                                },
                                icon: const Icon(Icons.play_arrow),
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
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: AdsSection(darkMode: true),
            ),
            const SizedBox(height: 70),
          ],
        ),
      ),
    );
  }

  heroAppbar(double h) {
    return GestureDetector(
      onTap: () {
        //photoview gallery
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => PhotoViewGallery.builder(
              itemCount:
                  _projectDetails.projectImages.map((e) => e.images).length,
              builder: (context, index) {
                return PhotoViewGalleryPageOptions(
                  imageProvider: NetworkImage(
                    _projectDetails.projectImages[index].images[index],
                  ),
                );
              },
            ),
          ),
        );
      },
      child: Stack(
        children: [
          Hero(
            tag: widget.heroTag,
            child: Stack(
              children: [
                Container(
                  height: h + 32,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: CustomColors.black25,
                  ),
                  child: widget.apartment.coverImage.isNotEmpty
                      ? Image.network(
                          widget.apartment.coverImage,
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
              ],
            ),
          ),

          Animate(
            target: _showKeyHighlights ? 1 : 0,
            effects: const [
              FadeEffect(
                duration: Duration(milliseconds: 500),
                curve: Curves.easeInOut,
              ),
            ],
            child: Container(
              height: h + 32,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    CustomColors.black.withOpacity(0.8),
                    CustomColors.black.withOpacity(0),
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
            ),
          ),
          Container(
            height: h * 0.35,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  CustomColors.black.withOpacity(0.8),
                  CustomColors.black.withOpacity(0),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),

          //apartment name
          Positioned(
            top: 36,
            left: 0,
            right: 0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Icon(
                            Icons.arrow_back,
                            color: CustomColors.white.withOpacity(0.8),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width - 30,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Animate(
                                target: _showKeyHighlights ? 1 : 0,
                                effects: const [
                                  SlideEffect(
                                    duration: Duration(milliseconds: 500),
                                    curve: Curves.easeInOut,
                                    begin: Offset(-1, 0),
                                  ),
                                  FadeEffect(
                                    duration: Duration(milliseconds: 500),
                                    curve: Curves.easeInOut,
                                  ),
                                ],
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.apartment.name,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        color: CustomColors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 24,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        rightSlideTransition(
                                          context,
                                          BuilderPortfolio(
                                            projectId:
                                                widget.apartment.projectId,
                                          ),
                                        );
                                      },
                                      child: RichText(
                                        text: TextSpan(
                                          style: const TextStyle(
                                            color: CustomColors.white,
                                            fontWeight: FontWeight.normal,
                                            fontSize: 16,
                                          ),
                                          children: [
                                            const TextSpan(
                                              text: "By ",
                                            ),
                                            TextSpan(
                                              text:
                                                  widget.apartment.companyName,
                                              style: const TextStyle(
                                                decoration:
                                                    TextDecoration.underline,
                                                decorationColor:
                                                    CustomColors.white,
                                                decorationThickness: 2,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  _showKeyHighlights = !_showKeyHighlights;
                                });
                              },
                              icon: Icon(
                                _showKeyHighlights
                                    ? Icons.menu_open
                                    : Icons.menu,
                                color: CustomColors.white,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                //open menu with 3 options

                                showMenu(
                                  context: context,
                                  color: CustomColors.black,
                                  position: RelativeRect.fromLTRB(
                                    MediaQuery.of(context).size.width - 40,
                                    kToolbarHeight + 70,
                                    MediaQuery.of(context).size.width,
                                    kToolbarHeight + 40,
                                  ),
                                  items: [
                                    PopupMenuItem(
                                      onTap: () {
                                        ref
                                                .read(savedPropertiesProvider)
                                                .contains(widget.apartment)
                                            ? ref
                                                .read(savedPropertiesProvider
                                                    .notifier)
                                                .removeApartment(
                                                    widget.apartment)
                                            : ref
                                                .read(savedPropertiesProvider
                                                    .notifier)
                                                .addApartment(widget.apartment);
                                      },
                                      value: 1,
                                      child: Row(
                                        children: [
                                          Icon(
                                            ref
                                                    .watch(
                                                        savedPropertiesProvider)
                                                    .contains(widget.apartment)
                                                ? Icons.bookmark
                                                : Icons.bookmark_outline,
                                            color: ref
                                                    .watch(
                                                        savedPropertiesProvider)
                                                    .contains(widget.apartment)
                                                ? CustomColors.primary
                                                : CustomColors.white,
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            ref
                                                    .watch(
                                                        savedPropertiesProvider)
                                                    .contains(widget.apartment)
                                                ? "Remove bookmark"
                                                : "Bookmark",
                                            style: TextStyle(
                                              color: ref
                                                      .watch(
                                                          savedPropertiesProvider)
                                                      .contains(
                                                          widget.apartment)
                                                  ? CustomColors.primary
                                                  : CustomColors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    PopupMenuItem(
                                      onTap: () {},
                                      value: 2,
                                      child: const Row(
                                        children: [
                                          Icon(
                                            Icons.share,
                                            color: CustomColors.white,
                                          ),
                                          SizedBox(width: 8),
                                          Text(
                                            "Share",
                                            style: TextStyle(
                                              color: CustomColors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    PopupMenuItem(
                                      onTap: () {
                                        if (!ref
                                            .watch(comparePropertyProvider)
                                            .contains(widget.apartment)) {
                                          if (ref
                                                  .read(comparePropertyProvider)
                                                  .length >=
                                              4) {
                                            errorSnackBar(context,
                                                "You can compare up to 4 properties");
                                          } else {
                                            ref
                                                .read(comparePropertyProvider
                                                    .notifier)
                                                .addApartment(widget.apartment);
                                          }
                                        } else {
                                          ref
                                              .read(comparePropertyProvider
                                                  .notifier)
                                              .removeApartment(
                                                  widget.apartment);
                                        }
                                      },
                                      value: 3,
                                      child: Row(
                                        children: [
                                          !ref
                                                  .watch(
                                                      comparePropertyProvider)
                                                  .contains(widget.apartment)
                                              ? SvgPicture.asset(
                                                  "assets/icons/compare.svg",
                                                  color: Colors.white,
                                                  height: 20,
                                                  width: 20)
                                              : const Icon(
                                                  Icons.close,
                                                  color: CustomColors.primary,
                                                ),
                                          const SizedBox(width: 8),
                                          Text(
                                            !ref
                                                    .watch(
                                                        comparePropertyProvider)
                                                    .contains(widget.apartment)
                                                ? "Compare"
                                                : "Remove from compare",
                                            style: TextStyle(
                                              color: ref
                                                      .watch(
                                                          comparePropertyProvider)
                                                      .contains(
                                                          widget.apartment)
                                                  ? CustomColors.primary
                                                  : CustomColors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                );
                              },
                              icon: const Icon(
                                Icons.more_vert,
                                color: CustomColors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                if (_highlights.isNotEmpty)
                  GestureDetector(
                    onTap: () {
                      //photoview gallery
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => PhotoViewGallery.builder(
                            itemCount: _projectDetails.projectImages
                                .map((e) => e.images)
                                .length,
                            builder: (context, index) {
                              return PhotoViewGalleryPageOptions(
                                imageProvider: NetworkImage(_projectDetails
                                    .projectImages[index].images[index]),
                              );
                            },
                          ),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                      width: MediaQuery.of(context).size.width * 0.66,
                      decoration: BoxDecoration(
                        // color: CustomColors.black.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ...List.generate(
                            _highlights.length,
                            (index) => Animate(
                              target: _showKeyHighlights ? 1 : 0,
                              effects: const [
                                SlideEffect(
                                  duration: Duration(milliseconds: 500),
                                  curve: Curves.easeInOut,
                                  begin: Offset(-1, 0),
                                ),
                                FadeEffect(
                                  duration: Duration(milliseconds: 500),
                                  curve: Curves.easeInOut,
                                ),
                              ],
                              delay: Duration(milliseconds: index * 100),
                              child: highlightsOption(
                                _highlights[index]["title"],
                                _highlights[index]["value"],
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
        ],
      ),
    );
  }

  void _toggleOverlay(BuildContext context) {
    if (_isOverlayVisible) {
      _removeOverlay();
    } else {
      _showOverlay(context,
          contactButtonKey.currentContext!.findRenderObject() as RenderBox);
    }
  }

  void _showOverlay(BuildContext context, RenderBox renderBox) {
    final Size size = renderBox.size;
    final Offset position = renderBox.localToGlobal(Offset.zero);

    _overlayEntry = OverlayEntry(
      builder: (context) => Stack(
        children: [
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.5),
            ),
          ),
          Positioned.fill(
            child: GestureDetector(
              onTap: _removeOverlay,
              child: Container(
                color: Colors.transparent,
              ),
            ),
          ),
          Positioned(
            left: position.dx - (4 * size.width),
            bottom: 16,
            child: Material(
              color: Colors.transparent,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildOption(
                      SvgPicture.asset("assets/icons/phone.svg"),
                      'Call now',
                      () {
                        launchUrl(Uri.parse(
                                "tel:${widget.apartment.companyPhone}"))
                            .then(
                          (value) => _removeOverlay(),
                        );
                      },
                    ),
                    _buildOption(
                        SizedBox(
                            height: 20,
                            width: 20,
                            child: SvgPicture.asset(
                              "assets/icons/whatsapp.svg",
                            )),
                        'Chat on Whatsapp', () {
                      launchUrl(Uri.parse(
                              'https://wa.me/+91${widget.apartment.companyPhone}?text=${Uri.encodeComponent("Hello, I'm interested in your property")}'))
                          .then(
                        (value) => _removeOverlay(),
                      );
                    }),
                    _buildOption(
                        SizedBox(
                            height: 20,
                            width: 20,
                            child: SvgPicture.asset(
                              "assets/icons/phone_incoming.svg",
                            )),
                        'Request call back', () {
                      enquiryFormPopup();
                      _removeOverlay();
                    }),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
    setState(() {
      _isOverlayVisible = true;
    });
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    _isOverlayVisible = false;
  }

  Widget _buildOption(Widget icon, String text, VoidCallback onTap) {
    return InkWell(
      onTap: () {
        _removeOverlay();
        onTap();
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: Row(
          children: [
            icon,
            const SizedBox(width: 12),
            Text(text),
          ],
        ),
      ),
    );
  }

  getPropertyDetails() {
    Uri url = Uri.parse(
        "${dotenv.env['BASE_URL']}/user/getProjectHighlightsNew/${widget.apartment.projectId}");
    debugPrint("---------------------$url");
    http.get(url, headers: {
      "Authorization": "Bearer ${ref.read(userProvider).token}",
    }).then((response) {
      if (response.statusCode == 200 || response.statusCode == 201) {
        setState(() {
          _projectDetails =
              ApartmentDetailsResponse.fromJson(jsonDecode(response.body));

          _highlights = [
            {
              "title": "Configurations",
              "value": _projectDetails.unitPlanConfigFilesFormatted.isEmpty
                  ? "Not specified"
                  : "${_projectDetails.unitPlanConfigFilesFormatted.length} BHK"
            },
            {
              "title": "No. of Floors",
              "value": _projectDetails.projectDetails.noOfFloors
            },
            {
              "title": "No. of Flats",
              "value": _projectDetails.projectDetails.noOfFlats
            },
            {
              "title": "Launch Date",
              "value": DateFormat("MMM yyyy").format(DateTime.parse(
                  _projectDetails.projectDetails.projectLaunchedDate
                      .substring(0, 10)))
            },
            // {
            //   "title": "Possession Date",
            //   "value": DateFormat("MMM yyyy").format(DateTime.parse(
            //       _projectDetails.projectDetails.projectPossession
            //           .substring(0, 10)))
            // },
            {
              "title": "Club House Size",
              "value":
                  int.tryParse(_projectDetails.projectDetails.clubhousesize) !=
                          null
                      ? '${_projectDetails.projectDetails.clubhousesize} Sq.ft'
                      : _projectDetails.projectDetails.clubhousesize
            },
            {
              "title": "Open Space",
              "value": "${_projectDetails.projectDetails.totalOpenSpace} Sq.ft"
            },
          ];
        });
      }
    });
  }

  @override
  void initState() {
    getPropertyDetails();
    _nameController.text = ref.read(userProvider).name;
    _mobileController.text = ref.read(userProvider).phoneNumber;
    _emailController.text = ref.read(userProvider).email;

    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (timerIndex == 1) {
        _showKeyHighlights = false;
      }
      setState(() {
        timerIndex++;
      });
    });

    super.initState();
  }

  @override
  void dispose() {
    _removeOverlay();
    _timer!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: CustomColors.black,
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          FloatingActionButton(
            key: contactButtonKey,
            backgroundColor: CustomColors.primary,
            shape: const CircleBorder(),
            onPressed: () {
              _toggleOverlay(context);
            },
            child: SvgPicture.asset(
              "assets/icons/phone.svg",
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              backgroundColor: CustomColors.black,
              expandedHeight: h * 0.6,
              floating: false,
              automaticallyImplyLeading: false,
              pinned: false,
              flexibleSpace: FlexibleSpaceBar(background: heroAppbar(h * 0.6)),
            ),
          ];
        },
        body: dataSheet(),
      ),
    );
  }
}
