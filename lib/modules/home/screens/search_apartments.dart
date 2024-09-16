import 'package:flutter/material.dart';
import 'package:re_portal_frontend/modules/home/widgets/property_card.dart';
import 'package:re_portal_frontend/modules/shared/models/appartment_model.dart';
import 'package:re_portal_frontend/modules/shared/widgets/colors.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';

class SearchApartment extends StatefulWidget {
  final List<ApartmentModel> apartments;

  const SearchApartment({super.key, required this.apartments});

  @override
  State<SearchApartment> createState() => _SearchApartmentState();
}

class _SearchApartmentState extends State<SearchApartment> {
  final TextEditingController _searchController = TextEditingController();
  List<ApartmentModel> filteredApartments = [];

  OverlayEntry? _overlayEntry;
  bool _isOverlayVisible = false;
  List<GlobalKey> _globalKeys = [];

  void _toggleOverlay(
      BuildContext context, ApartmentModel apartment, GlobalKey globalKey) {
    if (_isOverlayVisible) {
      _removeOverlay();
    } else {
      _showOverlay(context, apartment, globalKey);
    }
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

  void _showOverlay(
      BuildContext context, ApartmentModel apartment, GlobalKey globalKey) {
    GlobalKey contactButtonKey = globalKey;
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
                        launchUrl(Uri.parse("tel:${apartment.companyPhone}"))
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
                              'https://wa.me/+91${apartment.companyPhone}?text=${Uri.encodeComponent("Hello, I'm interested in your property")}'))
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
    setState(() {
      _isOverlayVisible = false;
    });
  }

  setGlobalKeys() {
    _globalKeys = List.generate(
      widget.apartments.length,
      (index) => GlobalKey(debugLabel: widget.apartments[index].apartmentID),
    );
  }

  @override
  void initState() {
    super.initState();
    filteredApartments = widget.apartments;
    setGlobalKeys();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _removeOverlay();
    super.dispose();
  }

  void _filterApartments(String searchTerm) {
    setState(() {
      filteredApartments = widget.apartments
          .where((apartment) => apartment.apartmentName
              .toLowerCase()
              .contains(searchTerm.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 40, bottom: 4),
            decoration: const BoxDecoration(
              color: CustomColors.primary,
            ),
            child: Row(
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(
                    Icons.arrow_back,
                    color: CustomColors.white,
                  ),
                ),
                const Text(
                  "Search",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: CustomColors.white,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  CustomColors.primary,
                  Color(0xFFCE4F32),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(20),
              ),
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                color: CustomColors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  const Icon(Icons.search),
                  const SizedBox(width: 4),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      onChanged: _filterApartments,
                      style: const TextStyle(
                        fontSize: 14,
                      ),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.zero,
                        hintText: 'Search properties...',
                        hintStyle: const TextStyle(
                          color: CustomColors.black50,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ListView.builder(
                itemCount: filteredApartments.length,
                itemBuilder: (context, index) {
                  final apartment = filteredApartments[index];
                  return PropertyCard(
                    apartment: apartment,
                    isCompare: true,
                    onCallPress: (context) {
                      _toggleOverlay(
                        context,
                        filteredApartments[index],
                        _globalKeys[index],
                      );
                    },
                    globalKey: _globalKeys[index],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
