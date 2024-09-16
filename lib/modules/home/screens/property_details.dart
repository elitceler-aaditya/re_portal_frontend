import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:re_portal_frontend/modules/builder/screens/builder_portfolio.dart';
import 'package:re_portal_frontend/modules/home/screens/ads_section.dart';
import 'package:re_portal_frontend/modules/home/widgets/custom_chip.dart';
import 'package:re_portal_frontend/modules/home/widgets/property_card.dart';
import 'package:re_portal_frontend/modules/shared/models/appartment_model.dart';
import 'package:re_portal_frontend/modules/shared/models/project_details.dart';
import 'package:re_portal_frontend/modules/shared/widgets/colors.dart';
import 'package:re_portal_frontend/modules/shared/widgets/transitions.dart';
import 'package:re_portal_frontend/riverpod/user_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

class PropertyDetails extends ConsumerStatefulWidget {
  final ApartmentModel appartment;
  final bool bestDeals;
  final ApartmentModel? nextApartment;
  const PropertyDetails({
    super.key,
    required this.appartment,
    this.bestDeals = false,
    this.nextApartment,
  });

  @override
  ConsumerState<PropertyDetails> createState() => _PropertyDetailsState();
}

class _PropertyDetailsState extends ConsumerState<PropertyDetails> {
  int _selectedConfig = 0;
  int _selectedPlan = 0;
  List<String> _configurations = [];
  List<String> _amenities = [];
  final _nameController = TextEditingController();
  final _mobileController = TextEditingController();
  final _emailController = TextEditingController();
  final _enquiryDetails = TextEditingController();
  final _highlightsScrollController = ScrollController();
  ProjectDetails _projectDetails = const ProjectDetails();
  List _projectGallery = [];
  List configImages = [];
  OverlayEntry? _overlayEntry;
  bool _isOverlayVisible = false;
  final GlobalKey contactButtonKey = GlobalKey(debugLabel: 'contact-button');

  List<Map<String, dynamic>> _highlights = [];

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
                        widget.appartment.image,
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
                    "For more details ${widget.appartment.companyPhone}",
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
                  onCallPress: (context) {},
                  globalKey: GlobalKey(),
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
      margin: const EdgeInsets.only(right: 10),
      decoration: BoxDecoration(
        color: CustomColors.primary20,
        borderRadius: BorderRadius.circular(100),
      ),
      child: Row(
        children: [
          SvgPicture.asset("assets/icons/home_location_pin.svg"),
          const SizedBox(width: 8),
          Text(title, style: const TextStyle(fontSize: 12)),
          const SizedBox(width: 20),
          const SizedBox(
            width: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: DottedLine(
                    lineLength: double.infinity,
                    lineThickness: 1.5,
                    dashLength: 8,
                    dashGapLength: 8,
                    dashColor: CustomColors.black75,
                  ),
                ),
                Icon(Icons.arrow_forward_ios,
                    size: 10, color: CustomColors.black75),
              ],
            ),
          ),
          const SizedBox(width: 20),
          Text(value, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  highlightsOption(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              color: CustomColors.white,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: CustomColors.white,
              fontWeight: FontWeight.w600,
              fontSize: 16,
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

  dataSheet() {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Project Description",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    _projectDetails.projectHighlightsDescription.join(" "),
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.normal,
                      color: CustomColors.black50,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: CustomColors.primary20,
              ),
              padding: const EdgeInsets.fromLTRB(8, 4, 5, 4),
              child: Row(
                children: [
                  SizedBox(
                    height: 40,
                    width: 28,
                    child:
                        SvgPicture.asset("assets/icons/home_location_pin.svg"),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    "${widget.appartment.locality}, Hyderabad",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: CustomColors.primary,
                    ),
                  ),
                  const Spacer(),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Map",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Divider(
                    height: 20,
                    color: CustomColors.black50,
                  ),
                  Container(
                    height: 150,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: CustomColors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "Configurations",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Divider(
              height: 20,
              color: CustomColors.black50,
            ),
            SizedBox(
              height: 40,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _configurations.length,
                itemBuilder: (context, index) {
                  return CustomChip(
                      text: _configurations[index],
                      isSelected: _selectedConfig == 0,
                      onTap: () {
                        setState(() {
                          _selectedConfig = 0;
                        });
                      });
                },
              ),
            ),
            const SizedBox(height: 10),
            if (configImages.isNotEmpty)
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    const SizedBox(width: 10),
                    ...List.generate(
                      configImages.length,
                      (index) => Container(
                        height: 200,
                        width: 300,
                        margin: const EdgeInsets.only(right: 24),
                        decoration: BoxDecoration(
                          color: CustomColors.white,
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                            image: NetworkImage(
                              _projectDetails.configImages
                                  .split(",")[index]
                                  .trim(),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 16),
            if (_projectDetails.educationalInstitutions.isNotEmpty &&
                _projectDetails.hospitals.isNotEmpty &&
                _projectDetails.connectivity.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Key Highlights",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Divider(
                      height: 20,
                      color: CustomColors.black50,
                    ),
                    SizedBox(
                      height: 40,
                      child: ListView.builder(
                        controller: _highlightsScrollController,
                        scrollDirection: Axis.horizontal,
                        itemCount:
                            _projectDetails.educationalInstitutions.length,
                        itemBuilder: (context, index) {
                          return _keyHighlights(
                            _projectDetails.educationalInstitutions[index]
                                ['name'],
                            _projectDetails.educationalInstitutions[index]
                                    ['dist']
                                .toString(),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 40,
                      child: ListView.builder(
                        controller: _highlightsScrollController,
                        scrollDirection: Axis.horizontal,
                        itemCount: _projectDetails.hospitals.length,
                        itemBuilder: (context, index) {
                          return _keyHighlights(
                            _projectDetails.hospitals[index]['name'],
                            _projectDetails.hospitals[index]['dist'].toString(),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 40,
                      child: ListView.builder(
                        controller: _highlightsScrollController,
                        scrollDirection: Axis.horizontal,
                        itemCount: _projectDetails.connectivity.length,
                        itemBuilder: (context, index) {
                          return _keyHighlights(
                            _projectDetails.connectivity[index]['name'],
                            _projectDetails.connectivity[index]['dist']
                                .toString(),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "Amenities",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Divider(
              height: 20,
              color: CustomColors.black50,
            ),
            Wrap(
              children: List.generate(
                _amenities.length,
                (index) => CustomChip(
                  text: _amenities[index],
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "Project gallery",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
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
                children: [
                  CustomChip(
                    text: "Master Plan",
                    isSelected: _selectedPlan == 0,
                    onTap: () {
                      setState(() {
                        _selectedPlan = 0;
                      });
                    },
                  ),
                  CustomChip(
                    text: "Tower plan",
                    isSelected: _selectedPlan == 1,
                    onTap: () {
                      setState(() {
                        _selectedPlan = 1;
                      });
                    },
                  ),
                  CustomChip(
                    text: "Floor Plan",
                    isSelected: _selectedPlan == 2,
                    onTap: () {
                      setState(() {
                        _selectedPlan = 2;
                      });
                    },
                  ),
                  CustomChip(
                    text: "Unit Plan",
                    isSelected: _selectedPlan == 3,
                    onTap: () {
                      setState(() {
                        _selectedPlan = 3;
                      });
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            if (_projectGallery.isNotEmpty)
              FlutterCarousel.builder(
                itemBuilder: (context, index, realIndex) => Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  height: 250,
                  decoration: BoxDecoration(
                    color: CustomColors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Image.network(
                    _projectGallery[index].trim(),
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => const Center(
                      child: Text("Failed to load image"),
                    ),
                    // loadingBuilder: (context, child, loadingProgress) => Center(
                    //   child: CircularProgressIndicator(
                    //     color: CustomColors.black,
                    //     value: loadingProgress != null
                    //         ? loadingProgress.cumulativeBytesLoaded /
                    //             loadingProgress.expectedTotalBytes!
                    //         : null,
                    //   ),
                    // ),
                  ),
                ),
                itemCount: _projectGallery.length,
                options: CarouselOptions(
                  height: 250,
                  aspectRatio: 16 / 9,
                  viewportFraction: 1,
                  initialPage: 0,
                  enableInfiniteScroll: true,
                  reverse: false,
                  autoPlay: true,
                  showIndicator: true,
                ),
              ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        enquiryFormPopup();
                      },
                      child: Container(
                        height: 120,
                        width: 200,
                        decoration: BoxDecoration(
                          color: CustomColors.black.withOpacity(0.5),
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
                    Container(
                      height: 120,
                      width: 200,
                      decoration: BoxDecoration(
                        color: CustomColors.black.withOpacity(0.5),
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
                                onPressed: () {},
                                icon: const Icon(Icons.play_arrow),
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
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: AdsSection(),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  heroAppbar(double h) {
    return Stack(
      children: [
        Hero(
          tag: widget.bestDeals
              ? "best-${widget.appartment.apartmentID}"
              : widget.appartment.apartmentID,
          child: Container(
            height: h + 30,
            width: double.infinity,
            decoration: BoxDecoration(
              color: CustomColors.black25,
              image: widget.appartment.image.isNotEmpty
                  ? DecorationImage(
                      image: NetworkImage(widget.appartment.image),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
          ),
        ),
        Container(
          height: h + 30,
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
        //apartment name
        Positioned(
          top: 36,
          left: 16,
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
              Text(
                widget.appartment.apartmentName,
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
                      projectId: widget.appartment.projectId,
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
                        text: widget.appartment.companyName,
                        style: const TextStyle(
                          decoration: TextDecoration.underline,
                          decorationColor: CustomColors.white,
                          decorationThickness: 2,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),
              ...List.generate(
                _highlights.length,
                (index) => Animate(
                  effects: [
                    SlideEffect(
                      begin: const Offset(-3, 0),
                      end: const Offset(0, 0),
                      curve: Curves.easeIn,
                      duration: const Duration(milliseconds: 1000),
                      delay: Duration(milliseconds: 100 * index),
                    )
                  ],
                  child: highlightsOption(
                    _highlights[index]["title"],
                    _highlights[index]["value"],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _toggleOverlay(BuildContext context) {
    if (_isOverlayVisible) {
      _removeOverlay();
    } else {
      _showOverlay(context);
    }
  }

  void _showOverlay(BuildContext context) {
    final RenderBox renderBox =
        contactButtonKey.currentContext!.findRenderObject() as RenderBox;
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
                                "tel:${widget.appartment.companyPhone}"))
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
                              'https://wa.me/+91${widget.appartment.companyPhone}?text=${Uri.encodeComponent("Hello, I'm interested in your property")}'))
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
                        'Request call back',
                        () => _removeOverlay()),
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
        "${dotenv.env['BASE_URL']}/user/getProjectHighlights/${widget.appartment.apartmentID}");
    http.get(url, headers: {
      "Authorization": "Bearer ${ref.read(userProvider).token}",
    }).then((response) {
      if (response.statusCode == 200 || response.statusCode == 201) {
        setState(() {
          _projectDetails = ProjectDetails.fromJson(
              jsonDecode(response.body)['formattedHighlightsApartment'][0]);
          _projectGallery = _projectDetails.gallery
              .split(",")
              .where((image) => image.trim().isNotEmpty)
              .toList();
          configImages = _projectDetails.configImages
              .split(",")
              .where((image) => image.trim().isNotEmpty)
              .toList();
        });
      }
    });
  }

  @override
  void initState() {
    getPropertyDetails();
    _configurations = widget.appartment.configuration.split(',');
    _amenities = widget.appartment.amenities.split(',');
    _nameController.text = ref.read(userProvider).name;
    _mobileController.text = ref.read(userProvider).phoneNumber;
    _emailController.text = ref.read(userProvider).email;

    _highlights = [
      {
        "title": "Project Size",
        "value":
            "${widget.appartment.configuration.split(',').map((config) => config.replaceAll('BHK', '')).join(',')} BHK"
      },
      {"title": "No. of Floors", "value": widget.appartment.noOfFloor},
      {"title": "No. of Flats", "value": widget.appartment.noOfFlats},
      {"title": "No. of Blocks", "value": widget.appartment.noOfBlocks},
      {
        "title": "Possession Date",
        "value": DateFormat("MMM yyyy")
            .format(DateTime.parse(widget.appartment.possessionDate))
      },
      {
        "title": "Club House Size",
        "value": int.tryParse(widget.appartment.clubhouseSize) != null
            ? '${widget.appartment.clubhouseSize} Sq.ft'
            : widget.appartment.clubhouseSize
      },
      {"title": "Open Space", "value": "${widget.appartment.openSpace} Sq.ft"},
    ];
    super.initState();
  }

  @override
  void dispose() {
    _removeOverlay();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: CustomColors.primary10,
      floatingActionButton: FloatingActionButton(
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
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              expandedHeight: h - 120,
              floating: false,
              automaticallyImplyLeading: false,
              pinned: false,
              flexibleSpace: FlexibleSpaceBar(background: heroAppbar(h - 120)),
            ),
          ];
        },
        body: dataSheet(),
      ),
    );
  }
}
