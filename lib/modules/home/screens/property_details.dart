import 'package:flutter/material.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:re_portal_frontend/modules/home/widgets/custom_chip.dart';
import 'package:re_portal_frontend/modules/shared/models/appartment_model.dart';
import 'package:re_portal_frontend/modules/shared/widgets/colors.dart';

class PropertyDetails extends StatefulWidget {
  final AppartmentModel appartment;
  final bool bestDeals;
  const PropertyDetails({super.key, required this.appartment, this.bestDeals = false});

  @override
  State<PropertyDetails> createState() => _PropertyDetailsState();
}

class _PropertyDetailsState extends State<PropertyDetails> {
  int _selectedConfig = 0;

  _keyHighlights(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          SvgPicture.asset("assets/icons/home_location_pin.svg"),
          const SizedBox(width: 8),
          Text(title, style: const TextStyle(fontSize: 12)),
          const Spacer(),
          Text(value, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  highlightsOption(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(title, style: const TextStyle(fontSize: 10)),
        Text(value,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12)),
      ],
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
      return "₹${(budget / 100000).toStringAsFixed(2)} L";
    } else {
      return "₹${(budget / 10000000).toStringAsFixed(2)} Cr";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomColors.primary,
        iconTheme: const IconThemeData(color: CustomColors.white),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Hero(
              tag: widget.bestDeals ? "best-${widget.appartment.apartmentID}" : widget.appartment.apartmentID,
              child: Stack(
                children: [
                  Container(
                    height: 320,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: CustomColors.black25,
                      image: DecorationImage(
                        image: NetworkImage(widget.appartment.image),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Container(
                    height: 320,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          CustomColors.black,
                          CustomColors.black.withOpacity(0),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 16,
                    left: 16,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          widget.appartment.apartmentName,
                          style: const TextStyle(
                            color: CustomColors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                          ),
                        ),
                        RichText(
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
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 26,
                    left: 10,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomChip(
                          text: formatBudget(widget.appartment.budget),
                        ),
                        const SizedBox(width: 8),
                        CustomChip(
                          text: widget.appartment.configuration,
                        ),
                        const SizedBox(width: 8),
                        CustomChip(
                            text: sqftArea(
                                area: widget.appartment.flatSize,
                                budget: widget.appartment.budget)),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 20,
                      decoration: const BoxDecoration(
                        color: CustomColors.white,
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(20)),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: CustomColors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Padding(
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
                    const Text(
                      "The regent by Balaji constructors is the ultimate realm where the lush green , blue skies and shades of luxury exist together The regent by Balaji constructors is the ultimate realm where the lush green , blue skies and shades of luxury exist ",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.normal,
                        color: CustomColors.black50,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 16),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: CustomColors.black.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Project Highlights",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Divider(
                            height: 20,
                            color: CustomColors.black50,
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              highlightsOption("Project Size",
                                  widget.appartment.configuration),
                              highlightsOption(
                                  "No. of Floors", widget.appartment.noOfFloor),
                              highlightsOption(
                                  "No. of Flats", widget.appartment.noOfFlats),
                              highlightsOption("No. of Blocks",
                                  widget.appartment.noOfBlocks),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                highlightsOption(
                                    "Possession Date",
                                    DateFormat("MMM yyyy").format(
                                        DateTime.parse(
                                            widget.appartment.possessionDate))),
                                highlightsOption("Club House Size",
                                    "${widget.appartment.clubhouseSize} Sq.ft"),
                                highlightsOption("Open Space",
                                    "${widget.appartment.openSpace} Sq.ft"),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
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
                        color: CustomColors.black10,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "Configurations",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Divider(
                      height: 20,
                      color: CustomColors.black50,
                    ),
                    Row(
                      children: [
                        CustomChip(
                            text: "1BHK",
                            isSelected: _selectedConfig == 0,
                            onTap: () {
                              setState(() {
                                _selectedConfig = 0;
                              });
                            }),
                        CustomChip(
                            text: "2BHK",
                            isSelected: _selectedConfig == 1,
                            onTap: () {
                              setState(() {
                                _selectedConfig = 1;
                              });
                            }),
                        CustomChip(
                            text: "3BHK",
                            isSelected: _selectedConfig == 2,
                            onTap: () {
                              setState(() {});
                            }),
                      ],
                    ),
                    const SizedBox(height: 10),
                    FlutterCarousel(
                      items: [
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 8),
                          height: 200,
                          decoration: BoxDecoration(
                            color: CustomColors.black10,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ],
                      options: CarouselOptions(
                        height: 200,
                        aspectRatio: 16 / 9,
                        viewportFraction: 0.8,
                        initialPage: 0,
                        enableInfiniteScroll: true,
                        reverse: false,
                        autoPlay: true,
                        showIndicator: true,
                      ),
                    ),
                    const SizedBox(height: 16),
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
                    _keyHighlights("Main railway station", "1.5 km"),
                    _keyHighlights("Airport", "3 km"),
                    _keyHighlights("Oakridge Raiwalay Station", "1.5 km"),
                    const SizedBox(height: 16),
                    const Text(
                      "Amenities",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Divider(
                      height: 20,
                      color: CustomColors.black50,
                    ),
                    const Wrap(
                      children: [
                        CustomChip(text: "Swimming Pool"),
                        CustomChip(text: "Gym"),
                        CustomChip(text: "Club House"),
                        CustomChip(text: "Children's Play Area"),
                        CustomChip(text: "Jogging Track"),
                        CustomChip(text: "24/7 Security"),
                      ],
                    )
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
