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
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:re_portal_frontend/modules/search/screens/search_apartments_results.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

import 'package:re_portal_frontend/modules/builder/screens/builder_portfolio.dart';
import 'package:re_portal_frontend/modules/home/screens/ads_section.dart';
import 'package:re_portal_frontend/modules/home/screens/brochure_video_section.dart';
import 'package:re_portal_frontend/modules/home/screens/compare/compare_properties.dart';
import 'package:re_portal_frontend/modules/home/screens/project_config_gallery.dart';
import 'package:re_portal_frontend/modules/home/screens/project_details_gallery.dart';
import 'package:re_portal_frontend/modules/home/screens/saved_properties/saved_properties.dart';
import 'package:re_portal_frontend/modules/home/widgets/category_row.dart';
import 'package:re_portal_frontend/modules/home/widgets/custom_chip.dart';
import 'package:re_portal_frontend/modules/home/widgets/property_card.dart';
import 'package:re_portal_frontend/modules/maps/google_maps_screen.dart';
import 'package:re_portal_frontend/modules/onboarding/screens/login_screen.dart';
import 'package:re_portal_frontend/modules/search/screens/recently_viewed_section.dart';
import 'package:re_portal_frontend/modules/search/widgets/location_homes_screen.dart';
import 'package:re_portal_frontend/modules/search/widgets/photo_scrolling_gallery.dart';
import 'package:re_portal_frontend/modules/shared/models/apartment_details_model.dart';
import 'package:re_portal_frontend/modules/shared/models/appartment_model.dart';
import 'package:re_portal_frontend/modules/shared/widgets/colors.dart';
import 'package:re_portal_frontend/modules/shared/widgets/snackbars.dart';
import 'package:re_portal_frontend/modules/shared/widgets/transitions.dart';
import 'package:re_portal_frontend/riverpod/compare_appartments.dart';
import 'package:re_portal_frontend/riverpod/recently_viewed.dart';
import 'package:re_portal_frontend/riverpod/saved_properties.dart';
import 'package:re_portal_frontend/riverpod/user_riverpod.dart';

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
  final GlobalKey contactButtonKey = GlobalKey(debugLabel: 'contact-button');
  final GlobalKey nextPropertyButtonKey =
      GlobalKey(debugLabel: 'next-property-button');
  List<Map<String, dynamic>> _highlights = [];
  int timerIndex = 0;
  int configIndex = 0;
  String displayImage = "";
  Timer? _timer;
  bool openOptions = true;
  List<Map<String, dynamic>> projectDetailsList = [];

  Future<void> sendEnquiry(BuildContext context) async {
    final url = Uri.parse("${dotenv.env['BASE_URL']}/user/newLeadGeneration");
    final body = {
      "name": _nameController.text.trim(),
      "number": _mobileController.text.trim(),
      "email": _emailController.text.trim(),
      "enquiryDetails": _enquiryDetails.text.trim().isEmpty
          ? "${_nameController.text.trim()} is interested in this project: ${widget.apartment.name}"
          : _enquiryDetails.text.trim(),
      "projectID": widget.apartment.projectId,
    };

    final token = ref.read(userProvider).token;
    if (token.isEmpty) {
      errorSnackBar(context, 'Please login first');
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const LoginScreen()));
      errorSnackBar(context, 'User not logged in');
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
        debugPrint("Error ${response.statusCode}: ${response.body}");
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

  enquirySuccessBottomSheet() {
    return showModalBottomSheet(
      backgroundColor: CustomColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      barrierColor: CustomColors.black.withOpacity(0.9),
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.7,
          minChildSize: 0.6,
          maxChildSize: 1,
          expand: false,
          builder: (context, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              child: Column(
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
                            borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(20)),
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
                  GestureDetector(
                    onTap: () =>
                        launchUrlString('tel:${widget.apartment.companyPhone}'),
                    child: Padding(
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
                  ),
                  Column(
                    children: [
                      if (widget.nextApartment != null)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 2),
                          child: PropertyCard(
                            apartment: widget.nextApartment!,
                            isCompare: false,
                            onCallPress: (context) {
                              _showOverlay(
                                context,
                                nextPropertyButtonKey.currentContext!
                                    .findRenderObject() as RenderBox,
                              );
                            },
                            globalKey: nextPropertyButtonKey,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            );
          },
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
          Expanded(
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 12,
                color: CustomColors.black,
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
              dashColor: CustomColors.black,
            ),
          ),
          const Icon(Icons.arrow_forward_ios,
              size: 10, color: CustomColors.black),
          const SizedBox(width: 8),
          SizedBox(
            width: 52,
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 12,
                color: CustomColors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  highlightsOption(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 12,
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
    );
  }

  _formatArea(int area) {
    if (area < 1000) {
      return "${area.toString()} sq.ft";
    } else {
      return "${(area / 1000).toStringAsFixed(1)}k sq.ft";
    }
  }

  Future<void> enquiryFormPopup() async {
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

  dataSheet() {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: CustomColors.white,
                borderRadius: BorderRadius.circular(6),
              ),
              margin: const EdgeInsets.only(top: 4),
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 90,
                          width: double.infinity,
                          clipBehavior: Clip.hardEdge,
                          decoration: BoxDecoration(
                            color: CustomColors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: CustomColors.white,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: CustomColors.black.withOpacity(0.2),
                                offset: const Offset(1, 1),
                                blurRadius: 10,
                              ),
                            ],
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
                                      markerId:
                                          MarkerId(widget.apartment.projectId),
                                      position: LatLng(
                                          widget.apartment.latitude,
                                          widget.apartment.longitude),
                                      icon:
                                          BitmapDescriptor.defaultMarkerWithHue(
                                              2),
                                      infoWindow: InfoWindow(
                                        title: widget.apartment.name,
                                      ),
                                    ),
                                  },
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  _timer!.cancel();
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => GoogleMapsScreen(
                                        apartment: widget.apartment,
                                        apartmentDetails: _projectDetails,
                                      ),
                                    ),
                                  ).then((value) {
                                    _timer = Timer.periodic(
                                        const Duration(seconds: 3), (timer) {
                                      if (timerIndex == 1) {
                                        _showKeyHighlights = false;
                                      }
                                      setState(() {
                                        timerIndex++;
                                      });
                                    });
                                  });
                                },
                                child: Container(
                                  height: 160,
                                  clipBehavior: Clip.hardEdge,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color:
                                        CustomColors.black.withOpacity(0.001),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (widget.apartment.projectLocation.isNotEmpty)
                                Text(
                                  "${widget.apartment.projectLocation}, Hyderabad",
                                  textAlign: TextAlign.start,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: CustomColors.black,
                                  ),
                                ),
                              const SizedBox(height: 4),
                              TextButton.icon(
                                key: contactButtonKey,
                                style: IconButton.styleFrom(
                                  backgroundColor: _overlayEntry != null
                                      ? CustomColors.white
                                      : CustomColors.primary,
                                ),
                                onPressed: () {
                                  if (ref.read(userProvider).token.isEmpty) {
                                    errorSnackBar(
                                        context, 'Please login first');
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const LoginScreen(
                                          goBack: true,
                                        ),
                                      ),
                                    );
                                  } else {
                                    _showOverlay(
                                        context,
                                        contactButtonKey.currentContext!
                                            .findRenderObject() as RenderBox);
                                    setState(() {});
                                  }
                                },
                                icon: SvgPicture.asset(
                                  "assets/icons/phone.svg",
                                  color: _overlayEntry != null
                                      ? CustomColors.primary
                                      : CustomColors.white,
                                ),
                                label: Text(
                                  "Contact Builder",
                                  style: TextStyle(
                                    color: _overlayEntry != null
                                        ? CustomColors.primary
                                        : CustomColors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (widget.apartment.description.isNotEmpty)
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(top: 4),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: CustomColors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: CustomColors.black.withOpacity(0.2),
                      blurRadius: 10,
                      spreadRadius: 0,
                      offset: const Offset(0, 0),
                    ),
                  ],
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
                        color: CustomColors.black,
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
                          color: CustomColors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            if (_projectDetails
                .projectDetails.projectHighlightsPoints.isNotEmpty)
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(top: 4),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: CustomColors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: CustomColors.black.withOpacity(0.2),
                      blurRadius: 10,
                      spreadRadius: 0,
                      offset: const Offset(0, 0),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        text: "Why ",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: CustomColors.black,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text: widget.apartment.name,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: CustomColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      children: _projectDetails
                          .projectDetails.projectHighlightsPoints
                          .map((point) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.check,
                                size: 20,
                                color: CustomColors.green,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  point,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: CustomColors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    )
                  ],
                ),
              ),
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(top: 4),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: CustomColors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: CustomColors.black.withOpacity(0.2),
                    blurRadius: 10,
                    spreadRadius: 0,
                    offset: const Offset(0, 0),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 4, bottom: 6),
                    child: Text(
                      "Project Details",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: CustomColors.black,
                      ),
                    ),
                  ),
                  GridView.builder(
                    padding: EdgeInsets.zero,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 1.8,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                    ),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: projectDetailsList.length,
                    itemBuilder: (context, index) {
                      final detail = projectDetailsList[index];
                      return Container(
                        decoration: BoxDecoration(
                          color: CustomColors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            const BoxShadow(
                              color: CustomColors.white,
                              blurRadius: 5,
                              offset: Offset(0, 0),
                            ),
                            BoxShadow(
                              color: CustomColors.black.withOpacity(0.1),
                              blurRadius: 5,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              detail["title"],
                              style: const TextStyle(fontSize: 12),
                            ),
                            Text(
                              detail["value"].toString(),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            if (_projectDetails.projectImages.isNotEmpty)
              ProjectDetailsGallery(
                  projectImages: _projectDetails.projectImages),
            if (_projectDetails.unitPlanConfigFilesFormatted.isNotEmpty)
              ProjectConfigGallery(
                  unitPlanConfigFilesFormatted:
                      _projectDetails.unitPlanConfigFilesFormatted),
            if (_projectDetails.projectDetails.amenities.isNotEmpty)
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(top: 4),
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: CustomColors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: CustomColors.black.withOpacity(0.2),
                      blurRadius: 10,
                      spreadRadius: 0,
                      offset: const Offset(0, 0),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 6),
                      child: Text(
                        "Amenities",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: CustomColors.black,
                        ),
                      ),
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(width: 4),
                          Column(
                            children: [
                              const Text(
                                "General Amenities",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: CustomColors.black,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                height: 150,
                                margin:
                                    const EdgeInsets.only(right: 10, left: 2),
                                constraints: BoxConstraints(
                                  maxWidth:
                                      MediaQuery.of(context).size.width - 50,
                                ),
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: CustomColors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color:
                                          CustomColors.black.withOpacity(0.2),
                                      blurRadius: 10,
                                      offset: const Offset(0, 0),
                                    ),
                                  ],
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: SingleChildScrollView(
                                  child: Wrap(
                                    direction: Axis.horizontal,
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
                              ),
                              const SizedBox(height: 10),
                            ],
                          ),
                          Column(
                            children: [
                              const Text(
                                "Clubhouse Amenities",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: CustomColors.black,
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
                                  color: CustomColors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color:
                                          CustomColors.black.withOpacity(0.3),
                                      blurRadius: 10,
                                      offset: const Offset(0, 0),
                                    ),
                                  ],
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: SingleChildScrollView(
                                  child: Wrap(
                                    direction: Axis.horizontal,
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
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              const Text(
                                "Outdoor Amenities",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: CustomColors.black,
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
                                  color: CustomColors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color:
                                          CustomColors.black.withOpacity(0.3),
                                      blurRadius: 10,
                                      offset: const Offset(0, 0),
                                    ),
                                  ],
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: SingleChildScrollView(
                                  child: Wrap(
                                    direction: Axis.horizontal,
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
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            if (_projectDetails.projectDetails.hospitals.isNotEmpty &&
                _projectDetails.projectDetails.offices.isNotEmpty &&
                _projectDetails.projectDetails.connectivity.isNotEmpty)
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(top: 4),
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: CustomColors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: CustomColors.black.withOpacity(0.2),
                      blurRadius: 10,
                      spreadRadius: 0,
                      offset: const Offset(0, 0),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 6),
                      child: Text(
                        "Key Highlights",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: CustomColors.black,
                        ),
                      ),
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(width: 10),
                          if (_projectDetails
                              .projectDetails.hospitals.isNotEmpty)
                            Column(
                              children: [
                                const Text(
                                  "Hospitals",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: CustomColors.black,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Container(
                                  height: 150,
                                  margin: const EdgeInsets.only(right: 10),
                                  clipBehavior: Clip.hardEdge,
                                  constraints: BoxConstraints(
                                    maxWidth:
                                        MediaQuery.of(context).size.width - 50,
                                  ),
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: CustomColors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        color:
                                            CustomColors.black.withOpacity(0.3),
                                        blurRadius: 10,
                                        offset: const Offset(0, 0),
                                      ),
                                    ],
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Column(
                                    children: List.generate(
                                      _projectDetails
                                          .projectDetails.hospitals.length,
                                      (index) => _keyHighlights(
                                        _projectDetails.projectDetails
                                            .hospitals[index].name,
                                        _projectDetails.projectDetails
                                            .hospitals[index].dist,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                              ],
                            ),
                          if (_projectDetails.projectDetails.offices.isNotEmpty)
                            Column(
                              children: [
                                const Text(
                                  "Offices",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: CustomColors.black,
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
                                  padding:
                                      const EdgeInsets.fromLTRB(10, 6, 10, 0),
                                  decoration: BoxDecoration(
                                    color: CustomColors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        color:
                                            CustomColors.black.withOpacity(0.3),
                                        blurRadius: 10,
                                        offset: const Offset(0, 0),
                                      ),
                                    ],
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: SingleChildScrollView(
                                    child: Column(
                                      children: List.generate(
                                        _projectDetails
                                            .projectDetails.offices.length,
                                        (index) => _keyHighlights(
                                          _projectDetails.projectDetails
                                              .offices[index].name,
                                          _projectDetails.projectDetails
                                              .offices[index].dist,
                                        ),
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
                                    fontWeight: FontWeight.bold,
                                    color: CustomColors.black,
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
                                    color: CustomColors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        color:
                                            CustomColors.black.withOpacity(0.3),
                                        blurRadius: 10,
                                        offset: const Offset(0, 0),
                                      ),
                                    ],
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: SingleChildScrollView(
                                    child: Column(
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
                                ),
                              ],
                            ),
                          // const SizedBox(width: 10),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            BrochureVideoSection(sendEnquiry: () => sendEnquiry(context)),
            if (ref.watch(recentlyViewedProvider).length > 1)
              const RecentlyViewedSection(hideFirstProperty: true),
            if (mounted) const AdsSection(),
            //category options
            CategoryRow(
              onTap: () =>
                  rightSlideTransition(context, const SearchApartmentResults()),
            ),
            const LocationHomes(),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  heroAppbar(double h) {
    return GestureDetector(
      onTap: () {
        final List<String> allImgs = widget.apartment.projectGallery;
        List<double> breakpoints = [];

        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => PhotoScrollingGallery(
              allImages: allImgs,
              labels: const [],
              galleryIndex: 0,
              breakPoints: breakpoints,
              // image: _projectDetails.projectImages[0].images[0],
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
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.error),
                        )
                      : null,
                ),
              ],
            ),
          ),

          if (widget.apartment.projectGallery.isNotEmpty && _timer != null)
            ...List.generate(
              widget.apartment.projectGallery.length,
              (index) => Animate(
                target: _timer!.tick % widget.apartment.projectGallery.length ==
                        index
                    ? 1
                    : 0,
                effects: const [
                  FadeEffect(
                    duration: Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                  ),
                ],
                child: GestureDetector(
                  onTap: () {
                    final List<String> allImgs =
                        widget.apartment.projectGallery;
                    List<double> breakpoints = [];

                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => PhotoScrollingGallery(
                          allImages: allImgs,
                          labels: const [],
                          galleryIndex: index,
                          breakPoints: breakpoints,
                          image: widget.apartment.projectGallery[index],
                        ),
                      ),
                    );
                  },
                  child: Container(
                    height: h + 32,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: CustomColors.black25,
                    ),
                    child: Image.network(
                      widget.apartment.projectGallery[index],
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.error),
                      loadingBuilder: (context, child, loadingProgress) =>
                          loadingProgress == null
                              ? child
                              : Shimmer.fromColors(
                                  baseColor: CustomColors.black25,
                                  highlightColor: CustomColors.black50,
                                  child: Container(
                                    height: 200,
                                    width: 320,
                                    decoration: BoxDecoration(
                                      color: Colors.black,
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                  ),
                                ),
                    ),
                  ),
                ),
              ),
            ),

          Container(
            height: h * 0.5,
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
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
                      Container(
                        decoration: BoxDecoration(
                          color: openOptions
                              ? CustomColors.white.withOpacity(0.25)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Row(
                          children: [
                            if (openOptions)
                              Row(
                                children: [
                                  const SizedBox(width: 4),
                                  SizedBox(
                                    height: 36,
                                    width: 36,
                                    child: IconButton(
                                      style: ElevatedButton.styleFrom(
                                        padding: EdgeInsets.zero,
                                      ),
                                      icon: Icon(
                                        ref
                                                .watch(savedPropertiesProvider)
                                                .contains(widget.apartment)
                                            ? Icons.favorite
                                            : Icons.favorite_outline,
                                        size: 20,
                                        color: ref
                                                .watch(savedPropertiesProvider)
                                                .contains(widget.apartment)
                                            ? CustomColors.primary
                                            : CustomColors.white,
                                      ),
                                      onPressed: () {
                                        ref
                                                .read(savedPropertiesProvider)
                                                .contains(widget.apartment)
                                            ? {
                                                errorSnackBar(context,
                                                    'Property removed from favourites'),
                                                ref
                                                    .read(
                                                        savedPropertiesProvider
                                                            .notifier)
                                                    .removeApartment(
                                                        widget.apartment)
                                              }
                                            : {
                                                successSnackBar(
                                                  context,
                                                  'Property added to favourites',
                                                  action: SnackBarAction(
                                                    backgroundColor:
                                                        CustomColors.white
                                                            .withOpacity(0.25),
                                                    textColor:
                                                        CustomColors.white,
                                                    label: 'View',
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .push(
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              const SavedProperties(
                                                            isPop: true,
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                ),
                                                ref
                                                    .read(
                                                        savedPropertiesProvider
                                                            .notifier)
                                                    .addApartment(
                                                        widget.apartment)
                                              };
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    height: 36,
                                    width: 36,
                                    child: IconButton(
                                      icon: const Icon(
                                        Icons.share,
                                        color: CustomColors.white,
                                        size: 20,
                                      ),
                                      onPressed: () {
                                        // Implement share functionality
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    height: 36,
                                    width: 36,
                                    child: IconButton(
                                      style: ElevatedButton.styleFrom(
                                        padding: EdgeInsets.zero,
                                      ),
                                      icon: !ref
                                              .watch(comparePropertyProvider)
                                              .contains(widget.apartment)
                                          ? SvgPicture.asset(
                                              "assets/icons/compare_active.svg",
                                              color: Colors.white,
                                              height: 22,
                                              width: 22,
                                            )
                                          : const Icon(
                                              Icons.close,
                                              color: CustomColors.primary,
                                            ),
                                      onPressed: () {
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
                                            successSnackBar(
                                              context,
                                              'property added',
                                              action: SnackBarAction(
                                                backgroundColor: CustomColors
                                                    .white
                                                    .withOpacity(0.25),
                                                textColor: CustomColors.white,
                                                label: 'Compare',
                                                onPressed: () {
                                                  Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          const CompareProperties(
                                                        isPop: true,
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                            );
                                          }
                                        } else {
                                          ref
                                              .read(comparePropertyProvider
                                                  .notifier)
                                              .removeApartment(
                                                  widget.apartment);
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            IconButton(
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.zero,
                              ),
                              onPressed: () {
                                setState(() {
                                  openOptions = !openOptions;
                                });
                              },
                              icon: const Icon(
                                Icons.more_horiz,
                                color: CustomColors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                if (_highlights.isNotEmpty)
                  GestureDetector(
                    onTap: () {
                      final List<String> allImgs =
                          widget.apartment.projectGallery;
                      List<double> breakpoints = [];

                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => PhotoScrollingGallery(
                            allImages: allImgs,
                            labels: const [],
                            galleryIndex: 0,
                            breakPoints: breakpoints,
                            image: widget.apartment.projectGallery[0],
                          ),
                        ),
                      );
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 10, bottom: 24),
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
                                  fontSize: 22,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  _timer?.cancel();
                                  rightSlideTransition(
                                    context,
                                    BuilderPortfolio(
                                      projectId: widget.apartment.projectId,
                                    ),
                                    onComplete: () => _timer = Timer.periodic(
                                      const Duration(seconds: 3),
                                      (timer) {
                                        if (timerIndex == 1) {
                                          _showKeyHighlights = false;
                                        }
                                        setState(() {
                                          timerIndex++;
                                        });
                                      },
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
                                        style: TextStyle(fontSize: 14),
                                      ),
                                      TextSpan(
                                        text: widget.apartment.companyName,
                                        style: const TextStyle(
                                          decoration: TextDecoration.underline,
                                          decorationColor: CustomColors.white,
                                          decorationThickness: 2,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Animate(
                          target: _showKeyHighlights ? 1 : 0,
                          effects: const [
                            SlideEffect(
                              duration: Duration(milliseconds: 500),
                              curve: Curves.easeInOut,
                              begin: Offset(-0.4, 0),
                            ),
                          ],
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 20,
                                ),
                                width: MediaQuery.of(context).size.width * 0.4,
                                decoration: BoxDecoration(
                                  color: CustomColors.black.withOpacity(0.7),
                                  borderRadius: const BorderRadius.only(
                                    topRight: Radius.circular(10),
                                    bottomRight: Radius.circular(10),
                                  ),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ...List.generate(
                                      _highlights.length,
                                      (index) => _highlights[index]["value"] !=
                                              null
                                          ? Padding(
                                              padding: EdgeInsets.only(
                                                bottom: index !=
                                                        _highlights.length - 1
                                                    ? 16
                                                    : 0,
                                              ),
                                              child: highlightsOption(
                                                _highlights[index]["title"],
                                                _highlights[index]["value"]
                                                    .toString(),
                                              ),
                                            )
                                          : const SizedBox.shrink(),
                                    ),
                                  ],
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _showKeyHighlights = !_showKeyHighlights;
                                  });
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(top: 150),
                                  width: 30,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: CustomColors.black.withOpacity(0.7),
                                    borderRadius: const BorderRadius.only(
                                      topRight: Radius.circular(10),
                                      bottomRight: Radius.circular(10),
                                    ),
                                  ),
                                  child: Icon(
                                    _showKeyHighlights
                                        ? Icons.keyboard_arrow_left
                                        : Icons.keyboard_arrow_right,
                                    color: CustomColors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showOverlay(BuildContext context, RenderBox renderBox) {
    final Offset position = renderBox.localToGlobal(Offset.zero);
    _overlayEntry = OverlayEntry(
      builder: (context) => Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              onTap: _removeOverlay,
              child: Container(
                color: Colors.black.withOpacity(0.5),
              ),
            ),
          ),
          Positioned(
            right: 0,
            bottom: MediaQuery.of(context).size.height - position.dy - 10,
            child: Material(
              color: Colors.transparent,
              child: Container(
                width: 210,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.transparent,
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
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildOption(
                      SvgPicture.asset(
                        "assets/icons/phone.svg",
                        color: CustomColors.blue,
                      ),
                      'Call now',
                      () {
                        if (ref.read(userProvider).token.isNotEmpty) {
                          launchUrl(Uri.parse(
                                  "tel:${widget.apartment.companyPhone}"))
                              .then((value) => _removeOverlay());
                        } else {
                          errorSnackBar(context, 'Please login first');

                          if (ref.read(userProvider).token.isEmpty) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LoginScreen(
                                  goBack: true,
                                ),
                              ),
                            );
                          } else {
                            enquiryFormPopup().then((_) {
                              _removeOverlay();
                            });
                          }
                        }
                      },
                      CustomColors.blue,
                    ),
                    _buildOption(
                      SizedBox(
                        height: 20,
                        width: 20,
                        child: SvgPicture.asset(
                          "assets/icons/whatsapp.svg",
                          color: CustomColors.green,
                        ),
                      ),
                      'Chat on Whatsapp',
                      () {
                        if (ref.read(userProvider).token.isNotEmpty) {
                          launchUrl(Uri.parse(
                            'https://wa.me/+91${widget.apartment.companyPhone}?text=${Uri.encodeComponent("Hello, I'm interested in your property")}',
                          )).then((value) => _removeOverlay());
                        } else {
                          errorSnackBar(context, 'Please login first');
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginScreen(
                                goBack: true,
                              ),
                            ),
                          );
                        }
                      },
                      CustomColors.green,
                    ),
                    _buildOption(
                      SizedBox(
                        height: 20,
                        width: 20,
                        child:
                            SvgPicture.asset("assets/icons/phone_incoming.svg"),
                      ),
                      'Request call back',
                      () {
                        if (ref.read(userProvider).token.isEmpty) {
                          errorSnackBar(context, 'Please login first');
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginScreen(
                                goBack: true,
                              ),
                            ),
                          );
                        } else {
                          enquiryFormPopup();
                          _removeOverlay();
                        }
                      },
                      CustomColors.secondary,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    setState(() {});
  }

  Widget _buildOption(
      Widget icon, String text, VoidCallback onTap, Color color) {
    return InkWell(
      onTap: () {
        _removeOverlay();
        onTap();
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(100),
        ),
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: Row(
          children: [
            icon,
            const SizedBox(width: 12),
            Text(
              text,
              style: TextStyle(color: color),
            ),
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

          _highlights = [];

          if (_projectDetails.unitPlanConfigFilesFormatted.isNotEmpty) {
            _highlights.add({
              "title": "Configurations",
              "value": _projectDetails.unitPlanConfigFilesFormatted.length
            });
            projectDetailsList.add({
              "title": "Configurations",
              "value": _projectDetails.unitPlanConfigFilesFormatted.length
            });
          }
          if (_projectDetails
              .projectDetails.pricePerSquareFeetRate.isNotEmpty) {
            projectDetailsList.add({
              "title": "Price/sq.ft",
              "value": _formatArea(int.parse(
                  _projectDetails.projectDetails.pricePerSquareFeetRate))
            });
          }

          if (_projectDetails.projectDetails.noOfFloors.isNotEmpty) {
            _highlights.add({
              "title": "No. of Floors",
              "value": _projectDetails.projectDetails.noOfFloors
            });
            projectDetailsList.add({
              "title": "No. of Floors",
              "value": _projectDetails.projectDetails.noOfFloors
            });
          }

          if (_projectDetails.projectDetails.noOfFlats.isNotEmpty) {
            _highlights.add({
              "title": "No. of Flats",
              "value": _projectDetails.projectDetails.noOfFlats
            });
            projectDetailsList.add({
              "title": "No. of Flats",
              "value": _projectDetails.projectDetails.noOfFlats
            });
          }

          if (_projectDetails.projectDetails.projectLaunchedDate.isNotEmpty) {
            _highlights.add({
              "title": "Launch Date",
              "value": DateFormat("MMM yyyy").format(DateTime.parse(
                  _projectDetails.projectDetails.projectLaunchedDate
                      .substring(0, 10)))
            });
            projectDetailsList.add({
              "title": "Launch Date",
              "value": DateFormat("MMM yyyy").format(DateTime.parse(
                  _projectDetails.projectDetails.projectLaunchedDate
                      .substring(0, 10)))
            });
          }

          if (_projectDetails.projectDetails.clubhousesize.isNotEmpty) {
            _highlights.add({
              "title": "Club House Size",
              "value": int.tryParse(
                          _projectDetails.projectDetails.clubhousesize) !=
                      null
                  ? _formatArea(
                      (int.parse(_projectDetails.projectDetails.clubhousesize)))
                  : _projectDetails.projectDetails.clubhousesize
            });
            projectDetailsList.add({
              "title": "Club House Size",
              "value": int.tryParse(
                          _projectDetails.projectDetails.clubhousesize) !=
                      null
                  ? _formatArea(
                      (int.parse(_projectDetails.projectDetails.clubhousesize)))
                  : _projectDetails.projectDetails.clubhousesize
            });
          }

          if (_projectDetails.projectDetails.totalOpenSpace.isNotEmpty) {
            _highlights.add({
              "title": "Open Space",
              "value": _projectDetails.projectDetails.totalOpenSpace
            });
            projectDetailsList.add({
              "title": "Open Space",
              "value": _projectDetails.projectDetails.totalOpenSpace
            });
          }
          if (_projectDetails.projectDetails.reraID.isNotEmpty) {
            projectDetailsList.add({"title": "RERA Approved", "value": "Yes"});
          }

          if (_projectDetails.projectDetails.constructionType.isNotEmpty) {
            projectDetailsList.add({
              "title": "Construction",
              "value": _projectDetails.projectDetails.constructionType
            });
          }
          if (_projectDetails.projectDetails.noOfTowers.isNotEmpty) {
            projectDetailsList.add({
              "title": "No. of Towers",
              "value": _projectDetails.projectDetails.noOfTowers
            });
          }
          if (_projectDetails.projectDetails.projectPossession.isNotEmpty) {
            projectDetailsList.add({
              "title": "Possession",
              "value": DateFormat("MMM yyyy").format(DateTime.parse(
                  _projectDetails.projectDetails.projectPossession
                      .substring(0, 10))),
            });
          }
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
    _enquiryDetails.text =
        'Hi, I am interested in ${widget.apartment.name}. I want to know more about the project.';

    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (timerIndex == 1) {
        _showKeyHighlights = false;
        openOptions = false;
      }
      setState(() {
        timerIndex++;
      });
    });
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(recentlyViewedProvider.notifier).addApartment(widget.apartment);
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
      backgroundColor: CustomColors.black10,
      // floatingActionButton: Column(
      //   mainAxisAlignment: MainAxisAlignment.center,
      //   crossAxisAlignment: CrossAxisAlignment.center,
      //   children: [
      //     FloatingActionButton(
      //       key: contactButtonKey,
      //       backgroundColor: CustomColors.primary,
      //       shape: const CircleBorder(),
      //       onPressed: () {
      //         _toggleOverlay(context);
      //       },
      //       child: SvgPicture.asset(
      //         "assets/icons/phone.svg",
      //         color: Colors.white,
      //       ),
      //     ),
      //   ],
      // ),
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
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
