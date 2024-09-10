import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:re_portal_frontend/modules/builder/screens/builder_portfolio.dart';
import 'package:re_portal_frontend/modules/home/screens/ads_section.dart';
import 'package:re_portal_frontend/modules/home/widgets/custom_chip.dart';
import 'package:re_portal_frontend/modules/shared/models/appartment_model.dart';
import 'package:re_portal_frontend/modules/shared/widgets/colors.dart';
import 'package:re_portal_frontend/modules/shared/widgets/transitions.dart';
import 'package:re_portal_frontend/riverpod/user_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

class PropertyDetails extends ConsumerStatefulWidget {
  final ApartmentModel appartment;
  final bool bestDeals;
  const PropertyDetails(
      {super.key, required this.appartment, this.bestDeals = false});

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
  final _doubtController = TextEditingController();
  OverlayEntry? _overlayEntry;
  bool _isOverlayVisible = false;
  final GlobalKey contactButtonKey = GlobalKey(debugLabel: 'contact-button');

  _keyHighlights(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          SvgPicture.asset("assets/icons/home_location_pin.svg"),
          const SizedBox(width: 8),
          Text(title, style: const TextStyle(fontSize: 12)),
          const SizedBox(width: 20),
          const Expanded(
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
                    size: 16, color: CustomColors.black75),
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
                                ),
                              ),
                              const SizedBox(height: 16),
                              TextField(
                                controller: _mobileController,
                                decoration: const InputDecoration(
                                  label: Text('Mobile'),
                                  border: OutlineInputBorder(),
                                ),
                                keyboardType: TextInputType.phone,
                              ),
                              const SizedBox(height: 16),
                              TextField(
                                controller: _emailController,
                                decoration: const InputDecoration(
                                  label: Text('Email'),
                                  border: OutlineInputBorder(),
                                ),
                                keyboardType: TextInputType.emailAddress,
                              ),
                              const SizedBox(height: 16),
                              TextField(
                                controller: _doubtController,
                                textAlign: TextAlign.start,
                                decoration: const InputDecoration(
                                  label: Text('Enquire about your doubts'),
                                  border: OutlineInputBorder(),
                                ),
                                minLines: 1,
                                maxLines: 3,
                              ),
                              const SizedBox(height: 24),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(context);
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
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
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
                      height: 28,
                      width: 28,
                      child: SvgPicture.asset(
                          "assets/icons/home_location_pin.svg"),
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
                    IconButton.filled(
                      key: contactButtonKey,
                      style: IconButton.styleFrom(
                        backgroundColor: CustomColors.primary,
                      ),
                      onPressed: () => _toggleOverlay(context),
                      icon: SvgPicture.asset(
                        "assets/icons/phone.svg",
                        color: CustomColors.white,
                      ),
                    ),
                  ],
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
                            "${widget.appartment.configuration.split(',').map((config) => config.replaceAll('BHK', '')).join(',')} BHK"),
                        highlightsOption(
                            "No. of Floors", widget.appartment.noOfFloor),
                        highlightsOption(
                            "No. of Flats", widget.appartment.noOfFlats),
                        highlightsOption(
                            "No. of Blocks", widget.appartment.noOfBlocks),
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
                                widget.appartment.possessionDate,
                              ),
                            ),
                          ),
                          highlightsOption(
                              "Club House Size",
                              int.tryParse(widget.appartment.clubhouseSize) !=
                                      null
                                  ? '${widget.appartment.clubhouseSize} Sq.ft'
                                  : widget.appartment.clubhouseSize),
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
              Wrap(
                children: List.generate(
                  _amenities.length,
                  (index) => CustomChip(
                    text: _amenities[index],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Types of project plans",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
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
                  height: 150,
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
              SingleChildScrollView(
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
              const SizedBox(height: 20),
              const AdsSection(),
              const SizedBox(height: 20),
            ],
          ),
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
          height: 300,
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
                  rightSlideTransition(context, const BuilderPortfolio());
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
              CustomChip(
                text:
                    "${widget.appartment.configuration.split(",").first}${widget.appartment.configuration.split(",").length > 1 ? ' + ${widget.appartment.configuration.split(",").length - 1} others' : ''}",
              ),
              CustomChip(
                text: sqftArea(
                  area: widget.appartment.flatSize == 0
                      ? 1
                      : widget.appartment.flatSize,
                  budget: widget.appartment.budget,
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
            left: position.dx - 200,
            top: position.dy + size.height,
            child: Material(
              color: Colors.transparent,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),
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

    Overlay.of(context)!.insert(_overlayEntry!);
    setState(() {
      _isOverlayVisible = true;
    });
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    setState(() {
      _isOverlayVisible = false;
    });
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

  @override
  void initState() {
    _configurations = widget.appartment.configuration.split(',');
    _amenities = widget.appartment.amenities.split(',');
    _nameController.text = ref.read(userProvider).name;
    _mobileController.text = ref.read(userProvider).phoneNumber;
    _emailController.text = ref.read(userProvider).email;
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
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              expandedHeight: h - 120,
              floating: false,
              automaticallyImplyLeading: false,
              pinned: false, // Set to false to hide after collapse
              flexibleSpace: FlexibleSpaceBar(background: heroAppbar(h - 120)),
            ),
          ];
        },
        body: dataSheet(),
      ),
    );
  }
}
