import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:re_portal_frontend/modules/home/screens/main_screen.dart';
import 'package:re_portal_frontend/modules/home/widgets/property_card.dart';
import 'package:re_portal_frontend/riverpod/bot_nav_bar.dart';
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
  final String heroTag;
  const PropertyDetails({
    super.key,
    required this.apartment,
    required this.heroTag,
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
  bool openProjectSpecifications = false;
  bool openWhyProject = false;
  List<Map<String, dynamic>> projectDetailsList = [];
  List<ApartmentModel> nextApartments = [];
  List<GlobalKey> nextApartmentsKeys = [];
  List<Map<String, dynamic>> highlights = [];

  Future<void> sendEnquiry(BuildContext context, String message) async {
    final url = Uri.parse("${dotenv.env['BASE_URL']}/user/newLeadGeneration");
    final body = {
      "name": _nameController.text.trim(),
      "number": _mobileController.text.trim(),
      "email": _emailController.text.trim(),
      "enquiryDetails": message,
      "projectID": widget.apartment.projectId,
    };

    final token = ref.read(userProvider).token;
    if (token.isEmpty) {
      errorSnackBar(context, 'Please login first');
      Navigator.push(context,
              MaterialPageRoute(builder: (context) => const LoginScreen()))
          .then((_) {
        _nameController.text = ref.read(userProvider).name;
        _mobileController.text = ref.read(userProvider).phoneNumber;
        _emailController.text = ref.read(userProvider).email;
      });
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

  Future<void> getFilteredApartments() async {
    Map<String, dynamic> defaultParams = {
      'projectLocation': widget.apartment.projectLocation
    };
    defaultParams['page'] = "1";

    try {
      String baseUrl = dotenv.get('BASE_URL');
      String url = "$baseUrl/project/filterApartmentsNew";
      Uri uri = Uri.parse(url).replace(queryParameters: defaultParams);

      final response = await http.get(
        uri,
        headers: {
          "Authorization": "Bearer ${ref.watch(userProvider).token}",
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        Map<String, dynamic> responseData = jsonDecode(response.body);
        List responseBody = responseData['projects'] ?? [];
        if (mounted) {
          setState(() {
            nextApartments =
                responseBody.map((e) => ApartmentModel.fromJson(e)).toList();
            nextApartmentsKeys =
                List.generate(nextApartments.length, (index) => GlobalKey());
          });
        }
      } else {
        throw Exception("${response.statusCode}: ${response.body}");
      }
    } catch (e) {
      debugPrint("Error in getting next appts: $e");
      // Handle error (e.g., show error message to user)
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
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
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
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(Icons.error),
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
                  if (_projectDetails.projectDetails.leadPOCNumber.isNotEmpty)
                    GestureDetector(
                      onTap: () => launchUrlString(
                          'tel:${_projectDetails.projectDetails.leadPOCNumber.isNotEmpty}'),
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
                              "For more details ${_projectDetails.projectDetails.leadPOCNumber}",
                              style: const TextStyle(
                                color: CustomColors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Column(
                      children: List.generate(
                        nextApartments.length,
                        (index) => PropertyCard(
                          apartment: nextApartments[index],
                          globalKey: nextApartmentsKeys[index],
                          isContact: true,
                          onCallPress: (context) {
                            _showOverlay(
                                context,
                                nextApartmentsKeys[index]
                                    .currentContext!
                                    .findRenderObject() as RenderBox);
                          },
                        ),
                      ),
                    ),
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
            width: 56,
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
            fontSize: 10,
            color: CustomColors.white,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            color: CustomColors.white,
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  String _formatArea(int area) {
    if (area < 1000) {
      return area.toString();
    } else {
      return "${(area / 1000).toStringAsFixed(1)}k";
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
                                    sendEnquiry(
                                      context,
                                      _enquiryDetails.text.trim().isEmpty
                                          ? "${_nameController.text.trim()} is interested in this project: ${widget.apartment.name}"
                                          : _enquiryDetails.text.trim(),
                                    );
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
                                  backgroundColor: CustomColors.primary,
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
                                    ).then((_) {
                                      _nameController.text =
                                          ref.read(userProvider).name;
                                      _mobileController.text =
                                          ref.read(userProvider).phoneNumber;
                                      _emailController.text =
                                          ref.read(userProvider).email;
                                    });
                                  } else {
                                    _showOverlay(
                                        context,
                                        contactButtonKey.currentContext!
                                            .findRenderObject() as RenderBox);
                                    setState(() {});
                                  }
                                },
                                icon: SvgPicture.asset("assets/icons/phone.svg",
                                    color: CustomColors.white),
                                label: const Text(
                                  "Contact Builder",
                                  style: TextStyle(color: CustomColors.white),
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
                      child: AnimatedSize(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeInOut,
                        child: Text(
                          widget.apartment.description,
                          maxLines: _showFullDescription ? null : 4,
                          overflow: TextOverflow.fade,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.normal,
                            color: CustomColors.black,
                          ),
                        ),
                      ),
                    ),
                    if (_projectDetails.projectDetails.description.length > 200)
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 500),
                        height: 44,
                        child: TextButton.icon(
                          onPressed: () {
                            setState(() {
                              _showFullDescription = !_showFullDescription;
                            });
                          },
                          icon: AnimatedRotation(
                            duration: const Duration(milliseconds: 500),
                            turns: _showFullDescription ? 0.5 : 0,
                            child: const Icon(
                              Icons.keyboard_arrow_down_rounded,
                              color: CustomColors.primary,
                            ),
                          ),
                          label: Text(
                            _showFullDescription ? "View Less" : "View More",
                            style: const TextStyle(
                              color: CustomColors.primary,
                              fontWeight: FontWeight.normal,
                            ),
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
                    AnimatedSize(
                      duration: const Duration(milliseconds: 700),
                      curve: Curves.easeInOut,
                      child: Column(
                        children: _projectDetails
                            .projectDetails.projectHighlightsPoints
                            .take(openWhyProject
                                ? _projectDetails.projectDetails
                                    .projectHighlightsPoints.length
                                : 3)
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
                      ),
                    ),
                    if (_projectDetails
                            .projectDetails.projectHighlightsPoints.length >
                        3)
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 700),
                        padding: const EdgeInsets.only(top: 10),
                        height: 44,
                        child: TextButton.icon(
                          onPressed: () {
                            setState(() {
                              openWhyProject = !openWhyProject;
                            });
                          },
                          icon: AnimatedRotation(
                            duration: const Duration(milliseconds: 700),
                            turns: openWhyProject ? 0.5 : 0,
                            child: const Icon(
                              Icons.keyboard_arrow_down_rounded,
                              color: CustomColors.primary,
                            ),
                          ),
                          label: Text(
                            openWhyProject ? "View Less" : "View More",
                            style: const TextStyle(
                              color: CustomColors.primary,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            if (projectDetailsList.isNotEmpty)
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(top: 4),
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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
                    AnimatedSize(
                      duration: const Duration(milliseconds: 700),
                      curve: Curves.easeInOut,
                      child: GridView.builder(
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
                          return AnimatedOpacity(
                            duration: const Duration(milliseconds: 700),
                            opacity: 1.0,
                            child: AnimatedScale(
                              duration: const Duration(milliseconds: 700),
                              scale: 1.0,
                              child: Container(
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
                                      color:
                                          CustomColors.black.withOpacity(0.1),
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
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
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
            if (_projectDetails.projectImages
                .map((e) => e.images)
                .toList()
                .isNotEmpty)
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
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 10),
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
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            if (_projectDetails
                                    .projectDetails.amenities.isNotEmpty &&
                                _projectDetails.projectDetails.amenities !=
                                    "null")
                              Container(
                                height: 170,
                                margin: const EdgeInsets.only(left: 10),
                                constraints: BoxConstraints(
                                  maxWidth:
                                      MediaQuery.of(context).size.width - 50,
                                ),
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color:
                                          CustomColors.black.withOpacity(0.2),
                                      blurRadius: 10,
                                      offset: const Offset(0, 0),
                                    ),
                                  ],
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Column(
                                  children: [
                                    const Text(
                                      "General Amenities",
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: CustomColors.black,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Expanded(
                                      child: SingleChildScrollView(
                                        child: Wrap(
                                          direction: Axis.horizontal,
                                          children: List.generate(
                                            _projectDetails
                                                .projectDetails.amenities
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
                                  ],
                                ),
                              ),
                            const SizedBox(height: 10),
                            if (_projectDetails.projectDetails
                                    .clubHouseAmenities.isNotEmpty &&
                                _projectDetails
                                        .projectDetails.clubHouseAmenities !=
                                    "null")
                              Container(
                                height: 170,
                                margin: const EdgeInsets.only(left: 10),
                                constraints: BoxConstraints(
                                  maxWidth:
                                      MediaQuery.of(context).size.width - 50,
                                ),
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color:
                                          CustomColors.black.withOpacity(0.3),
                                      blurRadius: 10,
                                      offset: const Offset(0, 0),
                                    ),
                                  ],
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Column(
                                  children: [
                                    const Text(
                                      "Clubhouse Amenities",
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: CustomColors.black,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Expanded(
                                      child: SingleChildScrollView(
                                        child: Wrap(
                                          direction: Axis.horizontal,
                                          children: List.generate(
                                            _projectDetails.projectDetails
                                                .clubHouseAmenities
                                                .split(",")
                                                .length,
                                            (index) => CustomChip(
                                              text: _projectDetails
                                                  .projectDetails
                                                  .clubHouseAmenities
                                                  .split(",")[index],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            if (_projectDetails.projectDetails.outdoorAmenities
                                    .isNotEmpty &&
                                _projectDetails
                                        .projectDetails.outdoorAmenities !=
                                    "null")
                              Container(
                                height: 170,
                                margin: const EdgeInsets.only(left: 10),
                                constraints: BoxConstraints(
                                  maxWidth:
                                      MediaQuery.of(context).size.width - 50,
                                ),
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color:
                                          CustomColors.black.withOpacity(0.3),
                                      blurRadius: 10,
                                      offset: const Offset(0, 0),
                                    ),
                                  ],
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Column(
                                  children: [
                                    const Text(
                                      "Outdoor Amenities",
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: CustomColors.black,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Expanded(
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
                                                  .projectDetails
                                                  .outdoorAmenities
                                                  .split(",")[index],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            if (_projectDetails.projectDetails.specifications.isNotEmpty)
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(top: 4),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: CustomColors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Project Specifications",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: CustomColors.black,
                      ),
                    ),
                    AnimatedSize(
                      duration: const Duration(milliseconds: 700),
                      curve: Curves.easeInOut,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            openProjectSpecifications =
                                !openProjectSpecifications;
                          });
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ...List.generate(
                              openProjectSpecifications
                                  ? _projectDetails
                                      .projectDetails.specifications.length
                                  : min(
                                      3,
                                      _projectDetails.projectDetails
                                          .specifications.length),
                              (index) => Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Text(
                                  _projectDetails
                                      .projectDetails.specifications[index],
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: CustomColors.black,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    //view more button
                    if (_projectDetails.projectDetails.specifications.length >
                        3)
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 700),
                        padding: const EdgeInsets.only(top: 10),
                        height: 44,
                        child: TextButton.icon(
                          onPressed: () {
                            setState(() {
                              openProjectSpecifications =
                                  !openProjectSpecifications;
                            });
                          },
                          icon: AnimatedRotation(
                            duration: const Duration(milliseconds: 700),
                            turns: openProjectSpecifications ? 0.5 : 0,
                            child: const Icon(
                              Icons.keyboard_arrow_down_rounded,
                              color: CustomColors.primary,
                            ),
                          ),
                          label: Text(
                            openProjectSpecifications
                                ? "View Less"
                                : "View More",
                            style: const TextStyle(
                              color: CustomColors.primary,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            if (_projectDetails
                    .projectDetails.educationalInstitutions.isNotEmpty ||
                _projectDetails.projectDetails.hospitals.isNotEmpty ||
                _projectDetails.projectDetails.offices.isNotEmpty ||
                _projectDetails.projectDetails.connectivity.isNotEmpty ||
                _projectDetails.projectDetails.restaurants.isNotEmpty ||
                _projectDetails.projectDetails.colleges.isNotEmpty ||
                _projectDetails.projectDetails.pharmacies.isNotEmpty ||
                _projectDetails.projectDetails.hotspots.isNotEmpty ||
                _projectDetails.projectDetails.shopping.isNotEmpty ||
                _projectDetails.projectDetails.entertainment.isNotEmpty)
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(top: 4),
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: CustomColors.white,
                  borderRadius: BorderRadius.circular(8),
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
                        children: List.generate(
                          highlights.length,
                          (index) => Visibility(
                            visible: highlights[index]['visible'],
                            child: Container(
                              height: 170,
                              width: 310,
                              margin: const EdgeInsets.all(10),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 10,
                              ),
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
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    highlights[index]['title'],
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: CustomColors.black,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Expanded(
                                    child: SingleChildScrollView(
                                      child: Column(
                                        children: List.generate(
                                          highlights[index]['data'].length,
                                          (i) => _keyHighlights(
                                            highlights[index]['data'][i]
                                                ['title'],
                                            highlights[index]['data'][i]
                                                ['value'],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            if (_projectDetails.projectDetails.banks.isNotEmpty)
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(top: 4),
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: CustomColors.white,
                  borderRadius: BorderRadius.circular(6),
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
                      padding: EdgeInsets.only(left: 10),
                      child: Text(
                        "Home Loan",
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
                        children: List.generate(
                          _projectDetails.projectDetails.banks.length,
                          (index) => Container(
                            margin: const EdgeInsets.all(10),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: CustomColors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: CustomColors.black.withOpacity(0.2),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: CustomColors.white,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color:
                                          CustomColors.black.withOpacity(0.1),
                                      width: 1,
                                    ),
                                  ),
                                  child: Image.network(
                                    _projectDetails
                                        .projectDetails.banks[index].bankLogo,
                                    width: 72,
                                    height: 42,
                                    fit: BoxFit.contain,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            const Icon(Icons.error),
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  "Starts from ${_projectDetails.projectDetails.banks[index].loanPercentage}%",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: CustomColors.black.withOpacity(0.6),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            if (_projectDetails.projectDetails.videoLink.isNotEmpty ||
                _projectDetails.projectDetails.brochurePdf.isNotEmpty)
              BrochureVideoSection(
                sendEnquiry: () => sendEnquiry(
                  context,
                  _enquiryDetails.text.trim().isEmpty
                      ? "${_nameController.text.trim()} is interested in this project: ${widget.apartment.name}"
                      : _enquiryDetails.text.trim(),
                ),
                projectName: widget.apartment.name,
                videoLink: _projectDetails.projectDetails.videoLink,
                brochureLink: _projectDetails.projectDetails.brochurePdf,
              ),
            if (ref.watch(recentlyViewedProvider).length > 1)
              const RecentlyViewedSection(hideFirstProperty: true),
            if (mounted) const AdsSection(),
            CategoryRow(
              onTap: () {
                ref.read(navBarIndexProvider.notifier).setNavBarIndex(1);
                Navigator.popUntil(context, (route) => route.isFirst);
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const MainScreen(),
                  ),
                );
              },
              cardHeight: 110,
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
        final List<String> allImgs = [];
        for (String image in widget.apartment.projectGallery) {
          precacheImage(NetworkImage(image), context).then((_) {
            if (mounted) {
              allImgs.add(image);
            }
          }).catchError((error) {
            debugPrint('Error loading image $image: $error');
          });
        }
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => PhotoViewGallery.builder(
              itemCount: allImgs.length,
              builder: (context, index) {
                return PhotoViewGalleryPageOptions(
                  imageProvider: NetworkImage(allImgs[index]),
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
                  child: GestureDetector(
                    onTap: () {
                      final List<String> allImgs =
                          widget.apartment.projectGallery;

                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => Scaffold(
                            appBar: AppBar(
                              backgroundColor: CustomColors.black,
                              title: const Text(
                                "Gallery",
                                style: TextStyle(color: Colors.white),
                              ),
                              leading: IconButton(
                                icon: const Icon(
                                  Icons.arrow_back,
                                  color: Colors.white,
                                ),
                                onPressed: () => Navigator.of(context).pop(),
                              ),
                            ),
                            body: PhotoViewGallery.builder(
                              itemCount: allImgs.length,
                              builder: (context, index) {
                                return PhotoViewGalleryPageOptions(
                                  imageProvider: NetworkImage(allImgs[index]),
                                  minScale: PhotoViewComputedScale.contained,
                                  maxScale:
                                      PhotoViewComputedScale.contained * 2,
                                );
                              },
                            ),
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
                        child: AnimatedSize(
                          duration: const Duration(milliseconds: 500),
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
                                                  .watch(
                                                      savedPropertiesProvider)
                                                  .contains(widget.apartment)
                                              ? Icons.favorite
                                              : Icons.favorite_outline,
                                          size: 20,
                                          color: ref
                                                  .watch(
                                                      savedPropertiesProvider)
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
                                                              .withOpacity(
                                                                  0.25),
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
                                                "assets/icons/compare.svg",
                                                color: Colors.white,
                                                height: 22,
                                                width: 22,
                                              )
                                            : SvgPicture.asset(
                                                "assets/icons/compare.svg",
                                                color: CustomColors.primary,
                                                height: 22,
                                                width: 22,
                                              ),
                                        onPressed: () {
                                          if (!ref
                                              .watch(comparePropertyProvider)
                                              .contains(widget.apartment)) {
                                            if (ref
                                                    .read(
                                                        comparePropertyProvider)
                                                    .length >=
                                                4) {
                                              errorSnackBar(context,
                                                  "You can compare up to 4 properties");
                                            } else {
                                              ref
                                                  .read(comparePropertyProvider
                                                      .notifier)
                                                  .addApartment(
                                                      widget.apartment);
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
                      ),
                    ],
                  ),
                ),
                if (_highlights.isNotEmpty)
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => UnitPlanGallery(
                              unitPlans:
                                  _projectDetails.unitPlanConfigFilesFormatted),
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
                                        text: widget.apartment.builderName,
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
                              begin: Offset(-0.42, 0),
                            ),
                          ],
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 20,
                                ),
                                width: MediaQuery.of(context).size.width * 0.42,
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
                                                    ? 14
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
                color: Colors.black.withOpacity(0.7),
              ),
            ),
          ),
          Positioned(
            right: 14,
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
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildOption(
                      SvgPicture.asset(
                        "assets/icons/phone.svg",
                        color: CustomColors.blue,
                      ),
                      'Call now',
                      () {
                        sendEnquiry(context,
                            "${_nameController.text.trim()} is interested in this project: ${widget.apartment.name} and contacted you via phone call");
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
                            ).then((_) {
                              _nameController.text =
                                  ref.read(userProvider).name;
                              _mobileController.text =
                                  ref.read(userProvider).phoneNumber;
                              _emailController.text =
                                  ref.read(userProvider).email;
                            });
                          } else {
                            enquiryFormPopup().then((_) {
                              _removeOverlay();
                            });
                          }
                        }
                      },
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
                        sendEnquiry(context,
                            "${_nameController.text.trim()} is interested in this project: ${widget.apartment.name} and contacted you via Whatsapp");
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
                          ).then((_) {
                            _nameController.text = ref.read(userProvider).name;
                            _mobileController.text =
                                ref.read(userProvider).phoneNumber;
                            _emailController.text =
                                ref.read(userProvider).email;
                          });
                        }
                      },
                      delay: 100,
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
                          ).then((_) {
                            _nameController.text = ref.read(userProvider).name;
                            _mobileController.text =
                                ref.read(userProvider).phoneNumber;
                            _emailController.text =
                                ref.read(userProvider).email;
                          });
                        } else {
                          enquiryFormPopup();
                          _removeOverlay();
                        }
                      },
                      delay: 200,
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
  }

  Widget _buildOption(Widget icon, String text, VoidCallback onTap,
      {int delay = 0}) {
    return Animate(
      effects: [
        FadeEffect(
          delay: Duration(milliseconds: delay),
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        ),
        SlideEffect(
          delay: Duration(milliseconds: delay),
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
          begin: const Offset(0, 1),
        ),
      ],
      child: InkWell(
        onTap: () {
          _removeOverlay();
          onTap();
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              text,
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(width: 12),
            Container(
                margin: const EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(100),
                ),
                padding: const EdgeInsets.all(14),
                child: icon),
          ],
        ),
      ),
    );
  }

  Future<void> getPropertyDetails() async {
    Uri url = Uri.parse(
        "${dotenv.env['BASE_URL']}/user/getProjectHighlightsNew/${widget.apartment.projectId}");
    debugPrint("---------------------$url");
    http.get(url, headers: {
      "Authorization": "Bearer ${ref.read(userProvider).token}",
    }).then((response) async {
      if (response.statusCode == 200 || response.statusCode == 201) {
        setState(() {
          _projectDetails =
              ApartmentDetailsResponse.fromJson(jsonDecode(response.body));
        });

        _highlights = [];
        //1 - project size
        if (_projectDetails.projectDetails.projectSize.isNotEmpty) {
          _highlights.add({
            "title": "Project Size",
            "value": _projectDetails.projectDetails.projectSize,
          });
        }

        //2 - no of flats
        if (_projectDetails.projectDetails.noOfFlats.isNotEmpty) {
          _highlights.add({
            "title": "No. of Units",
            "value": "${_projectDetails.projectDetails.noOfFlats} Units"
          });
          projectDetailsList.add({
            "title": "No. of Flats",
            "value": _projectDetails.projectDetails.noOfFlats
          });
        }

        //3 - Possession
        if (_projectDetails.projectDetails.projectPossession.isNotEmpty) {
          {
            _highlights.add({
              "title": "Possession by",
              "value": DateFormat("MMM yyyy").format(DateTime.parse(
                  _projectDetails.projectDetails.projectPossession
                      .substring(0, 10)))
            });
          }

          //4 - configurations
          if (widget.apartment.configTitle.isNotEmpty) {
            _highlights.add({
              "title": "Configurations",
              "value": widget.apartment.configTitle,
            });
          }

          //5 - available sizes
          if (_projectDetails.unitPlanConfigFilesFormatted.isNotEmpty) {
            final sizes = _projectDetails.unitPlanConfigFilesFormatted
                .expand((e) => e.unitPlanConfigFiles.map((f) => f.flatSize))
                .toList();
            sizes.sort();
            final minSize = sizes.first;
            final maxSize = sizes.last;
            final displaySize = minSize == maxSize
                ? "$minSize Sq.Ft"
                : "$minSize - $maxSize Sq.Ft";
            _highlights.add({
              "title": "Available Sizes",
              "value": displaySize,
            });
          }

          //6 - price per sqft
          if (_projectDetails
              .projectDetails.pricePerSquareFeetRate.isNotEmpty) {
            _highlights.add({
              "title": "Base price",
              "value": "${_formatArea(
                int.parse(
                    _projectDetails.projectDetails.pricePerSquareFeetRate),
              )}/Sq.Ft"
            });
          }

          if (_projectDetails.unitPlanConfigFilesFormatted.isNotEmpty) {
            projectDetailsList.add({
              "title": "Configurations",
              "value": _projectDetails.unitPlanConfigFilesFormatted.length
            });
          }
          if (_projectDetails
              .projectDetails.pricePerSquareFeetRate.isNotEmpty) {
            projectDetailsList.add({
              "title": "Price/Sq.Ft",
              "value":
                  "₹${_formatArea(int.parse(_projectDetails.projectDetails.pricePerSquareFeetRate))}"
            });
          }

          if (_projectDetails.projectDetails.noOfFloors.isNotEmpty) {
            projectDetailsList.add({
              "title": "No. of Floors",
              "value": _projectDetails.projectDetails.noOfFloors
            });
          }

          if (_projectDetails.projectDetails.projectLaunchedDate.isNotEmpty) {
            projectDetailsList.add({
              "title": "Launch Date",
              "value": DateFormat("MMM yyyy").format(DateTime.parse(
                  _projectDetails.projectDetails.projectLaunchedDate
                      .substring(0, 10)))
            });
          }

          if (_projectDetails.projectDetails.clubhousesize.isNotEmpty) {
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
            projectDetailsList.add({
              "title": "Open Space",
              "value": _projectDetails.projectDetails.totalOpenSpace
            });
          }
          if (_projectDetails.projectDetails.reraID.isNotEmpty) {
            projectDetailsList.add({
              "title": "RERA",
              "value": _projectDetails.projectDetails.reraID
            });
          }
          if (_projectDetails.projectDetails.projectType.isNotEmpty) {
            projectDetailsList.add({
              "title": "Project Type",
              "value": _projectDetails.projectDetails.projectType
            });
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
              "title": "Possession by",
              "value": DateFormat("MMM yyyy").format(DateTime.parse(
                  _projectDetails.projectDetails.projectPossession
                      .substring(0, 10))),
            });
          }
        }

        highlights = [
          //1: Hospitals
          {
            'visible': _projectDetails.projectDetails.hospitals.isNotEmpty,
            'title': 'Hospitals',
            'data': [
              for (var hospital in _projectDetails.projectDetails.hospitals)
                {
                  'title': hospital.name,
                  'value': hospital.dist,
                }
            ],
          },
          //2: Offices
          {
            'visible': _projectDetails.projectDetails.offices.isNotEmpty,
            'title': 'Offices',
            'data': [
              for (var office in _projectDetails.projectDetails.offices)
                {
                  'title': office.name,
                  'value': office.dist,
                }
            ],
          },
          //3: Connectivity
          {
            'visible': _projectDetails.projectDetails.connectivity.isNotEmpty,
            'title': 'Connectivity',
            'data': [
              for (var connectivity
                  in _projectDetails.projectDetails.connectivity)
                {
                  'title': connectivity.name,
                  'value': connectivity.dist,
                }
            ],
          },
          //4: Educational
          {
            'visible': _projectDetails
                .projectDetails.educationalInstitutions.isNotEmpty,
            'title': 'Educational Institutions',
            'data': [
              for (var institution
                  in _projectDetails.projectDetails.educationalInstitutions)
                {
                  'title': institution.name,
                  'value': institution.dist,
                }
            ],
          },
          //5: Colleges
          {
            'visible': _projectDetails.projectDetails.colleges.isNotEmpty,
            'title': 'Colleges',
            'data': [
              for (var college in _projectDetails.projectDetails.colleges)
                {
                  'title': college.name,
                  'value': college.dist,
                }
            ],
          },
          //6: Pharmacies
          {
            'visible': _projectDetails.projectDetails.pharmacies.isNotEmpty,
            'title': 'Pharmacies',
            'data': [
              for (var pharmacy in _projectDetails.projectDetails.pharmacies)
                {
                  'title': pharmacy.name,
                  'value': pharmacy.dist,
                }
            ],
          },
          //7: Hotspots
          {
            'visible': _projectDetails.projectDetails.hotspots.isNotEmpty,
            'title': 'Hotspots',
            'data': [
              for (var hotspot in _projectDetails.projectDetails.hotspots)
                {
                  'title': hotspot.name,
                  'value': hotspot.dist,
                }
            ],
          },
          //8: Shopping
          {
            'visible': _projectDetails.projectDetails.shopping.isNotEmpty,
            'title': 'Shopping',
            'data': [
              for (var shop in _projectDetails.projectDetails.shopping)
                {
                  'title': shop.name,
                  'value': shop.dist,
                }
            ],
          },
          //9: Entertainment
          {
            'visible': _projectDetails.projectDetails.entertainment.isNotEmpty,
            'title': 'Entertainment',
            'data': [
              for (var entertainment
                  in _projectDetails.projectDetails.entertainment)
                {
                  'title': entertainment.name,
                  'value': entertainment.dist,
                }
            ],
          },
          //10: Restaurants
          {
            'visible': _projectDetails.projectDetails.restaurants.isNotEmpty,
            'title': 'Restaurants',
            'data': [
              for (var restaurant in _projectDetails.projectDetails.restaurants)
                {
                  'title': restaurant.name,
                  'value': restaurant.dist,
                }
            ],
          },
        ];
        setState(() {});
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
      getFilteredApartments();
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
