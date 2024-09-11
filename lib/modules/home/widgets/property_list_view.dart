import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:re_portal_frontend/modules/home/screens/ads_section.dart';
import 'package:re_portal_frontend/modules/home/screens/property_details.dart';
import 'package:re_portal_frontend/modules/home/widgets/ribbon.dart';
import 'package:re_portal_frontend/modules/shared/models/appartment_model.dart';
import 'package:re_portal_frontend/modules/shared/widgets/colors.dart';
import 'package:re_portal_frontend/modules/shared/widgets/snackbars.dart';
import 'package:re_portal_frontend/riverpod/compare_appartments.dart';
import 'package:re_portal_frontend/riverpod/saved_properties.dart';
import 'package:url_launcher/url_launcher.dart';

class PropertyListView extends ConsumerStatefulWidget {
  final List<ApartmentModel> sortedApartments;
  final bool compare;
  final bool displayAds;

  const PropertyListView({
    super.key,
    required this.sortedApartments,
    required this.compare,
    this.displayAds = false,
  });

  @override
  ConsumerState<PropertyListView> createState() => _PropertyListViewState();
}

class _PropertyListViewState extends ConsumerState<PropertyListView> {
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

  formatBudget(double budget) {
    if (budget < 10000000) {
      return "${(budget / 100000).toStringAsFixed(2)} L";
    } else {
      return "${(budget / 10000000).toStringAsFixed(2)} Cr";
    }
  }

  setGlobalKeys() {
    _globalKeys = List.generate(
      widget.sortedApartments.length,
      (index) =>
          GlobalKey(debugLabel: widget.sortedApartments[index].apartmentID),
    );
  }

  @override
  void initState() {
    super.initState();
    setGlobalKeys();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: widget.displayAds
          ? widget.sortedApartments.length +
              (widget.sortedApartments.length ~/ 4)
          : widget.sortedApartments.length,
      itemBuilder: (context, index) {
        if (widget.displayAds && index % 4 == 0 && index != 0) {
          return const AdsSection();
        } else {
          int listIndex = index - (index ~/ 4);
          return GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => PropertyDetails(
                    appartment: widget.sortedApartments[listIndex],
                  ),
                ),
              );
            },
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: CustomColors.white,
                boxShadow: [
                  BoxShadow(
                    color: CustomColors.black.withOpacity(0.3),
                    offset: const Offset(0, 3),
                    blurRadius: 5,
                  ),
                ],
              ),
              child: Column(
                children: [
                  SizedBox(
                    height: 180,
                    child: Stack(
                      children: [
                        Hero(
                          tag: widget.sortedApartments[listIndex].apartmentID,
                          child: Container(
                            height: 180,
                            decoration: BoxDecoration(
                              color: CustomColors.black25,
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10),
                              ),
                              image: widget.sortedApartments[listIndex].image
                                      .isNotEmpty
                                  ? DecorationImage(
                                      image: NetworkImage(widget
                                          .sortedApartments[listIndex].image),
                                      fit: BoxFit.cover,
                                    )
                                  : null,
                            ),
                          ),
                        ),
                        Container(
                          height: 180,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                CustomColors.secondary.withOpacity(0),
                                CustomColors.secondary.withOpacity(0.8),
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 10,
                          left: 0,
                          child: CustomPaint(
                            painter: RibbonPainter(CustomColors.primary),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              margin: const EdgeInsets.symmetric(vertical: 4),
                              child: const Text(
                                'RERA Approved',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                            top: 0,
                            right: 0,
                            child: IconButton(
                              onPressed: () {
                                if (!ref
                                    .watch(savedPropertiesProvider)
                                    .contains(
                                        widget.sortedApartments[listIndex])) {
                                  ref
                                      .read(savedPropertiesProvider.notifier)
                                      .addApartment(
                                          widget.sortedApartments[listIndex]);
                                } else {
                                  ref
                                      .read(savedPropertiesProvider.notifier)
                                      .removeApartment(
                                          widget.sortedApartments[listIndex]);
                                }
                              },
                              icon: ref.watch(savedPropertiesProvider).contains(
                                      widget.sortedApartments[listIndex])
                                  ? const Icon(
                                      Icons.bookmark,
                                      color: CustomColors.white,
                                    )
                                  : const Icon(
                                      Icons.bookmark_outline,
                                      color: CustomColors.white,
                                    ),
                            )),
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Align(
                            alignment: Alignment.bottomLeft,
                            child: Text(
                              widget.sortedApartments[listIndex].apartmentName,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: CustomColors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "This beautiful property lies in the heart of Hyderabad with xx acres of free space. It is a perfect place for a peaceful life.",
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: CustomColors.black50,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            RichText(
                              text: TextSpan(
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                ),
                                children: [
                                  const TextSpan(
                                    text: "Area: ",
                                    style: TextStyle(
                                      color: CustomColors.black75,
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                  TextSpan(
                                    text:
                                        "${widget.sortedApartments[listIndex].flatSize.toStringAsFixed(0)} sq.ft",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 16),
                            RichText(
                              text: TextSpan(
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.black, // Default text color
                                ),
                                children: [
                                  const TextSpan(
                                    text: "Cost: ",
                                    style: TextStyle(
                                      color: CustomColors.black75,
                                      fontWeight: FontWeight.normal,
                                      fontSize: 14,
                                    ),
                                  ),
                                  TextSpan(
                                    text: formatBudget(widget
                                        .sortedApartments[listIndex].budget),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Spacer(),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (widget.compare)
                                    SizedBox(
                                      height: 40,
                                      width: 40,
                                      child: IconButton.filled(
                                        style: IconButton.styleFrom(
                                          backgroundColor: ref
                                                  .watch(
                                                      comparePropertyProvider)
                                                  .contains(
                                                      widget.sortedApartments[
                                                          listIndex])
                                              ? CustomColors.green10
                                              : CustomColors.primary20,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                        ),
                                        onPressed: () {
                                          if (!ref
                                              .watch(comparePropertyProvider)
                                              .contains(widget.sortedApartments[
                                                  listIndex])) {
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
                                                      widget.sortedApartments[
                                                          listIndex]);
                                            }
                                          } else {
                                            ref
                                                .read(comparePropertyProvider
                                                    .notifier)
                                                .removeApartment(
                                                    widget.sortedApartments[
                                                        listIndex]);
                                          }
                                        },
                                        icon: !ref
                                                .watch(comparePropertyProvider)
                                                .contains(
                                                    widget.sortedApartments[
                                                        listIndex])
                                            ? SvgPicture.asset(
                                                "assets/icons/compare.svg",
                                                color: CustomColors.primary,
                                                height: 20,
                                                width: 20)
                                            : const Icon(
                                                Icons.check,
                                                color: CustomColors.green,
                                              ),
                                      ),
                                    ),
                                  const SizedBox(width: 8),
                                  SizedBox(
                                    key: _globalKeys[listIndex],
                                    height: 40,
                                    width: 40,
                                    child: IconButton.filled(
                                      style: IconButton.styleFrom(
                                        backgroundColor: CustomColors.secondary,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                      ),
                                      onPressed: () {
                                        _toggleOverlay(
                                          context,
                                          widget.sortedApartments[listIndex],
                                          _globalKeys[listIndex],
                                        );
                                      },
                                      icon: SvgPicture.asset(
                                        "assets/icons/phone.svg",
                                        color: CustomColors.white,
                                        height: 20,
                                        width: 20,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
