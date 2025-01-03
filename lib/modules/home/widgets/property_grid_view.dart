import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:re_portal_frontend/modules/home/screens/property_details.dart';
import 'package:re_portal_frontend/modules/shared/models/appartment_model.dart';
import 'package:re_portal_frontend/modules/shared/widgets/colors.dart';
import 'package:re_portal_frontend/modules/shared/widgets/snackbars.dart';
import 'package:re_portal_frontend/riverpod/compare_appartments.dart';
import 'package:re_portal_frontend/riverpod/saved_properties.dart';
import 'package:url_launcher/url_launcher.dart';

class PropertyGridView extends ConsumerStatefulWidget {
  final List<ApartmentModel> sortedApartments;
  final bool compare;
  final List<GlobalKey> globalKeys;
  const PropertyGridView({
    super.key,
    required this.sortedApartments,
    this.compare = false,
    required this.globalKeys,
  });

  @override
  ConsumerState<PropertyGridView> createState() => _PropertyGridViewState();
}

class _PropertyGridViewState extends ConsumerState<PropertyGridView> {
  OverlayEntry? _overlayEntry;
  bool _isOverlayVisible = false;
  List<GlobalKey> _globalKeys = [];

  void _toggleOverlay(
      BuildContext context, ApartmentModel apartment, int index) {
    if (_isOverlayVisible) {
      _removeOverlay();
    } else {
      _showOverlay(context, apartment, index);
    }
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

  void _showOverlay(BuildContext context, ApartmentModel apartment, int index) {
    GlobalKey contactButtonKey = _globalKeys[index];
    final RenderBox renderBox =
        contactButtonKey.currentContext!.findRenderObject() as RenderBox;
    final Size size = renderBox.size;
    final Offset position = renderBox.localToGlobal(Offset.zero);

    _overlayEntry = OverlayEntry(
      builder: (context) => Stack(
        children: [
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.8),
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
            left: index % 2 == 0 ? 0 : position.dx - 150,
            top: position.dy - size.height * 5.5,
            child: Material(
              color: Colors.transparent,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(index % 2 == 0 ? 0 : 10),
                    bottomLeft: const Radius.circular(10),
                    bottomRight: const Radius.circular(10),
                    topRight: Radius.circular(index % 2 == 0 ? 10 : 0),
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
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    _buildOption(
                      SvgPicture.asset(
                        "assets/icons/phone.svg",
                        color: CustomColors.blue,
                      ),
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
                            color: CustomColors.green,
                          )),
                      'Chat on Whatsapp',
                      () {
                        launchUrl(Uri.parse(
                                'https://wa.me/+91${apartment.companyPhone}?text=${Uri.encodeComponent("Hello, I'm interested in your property")}'))
                            .then(
                          (value) => _removeOverlay(),
                        );
                      },
                      delay: 100,
                    ),
                    _buildOption(
                      SizedBox(
                          height: 20,
                          width: 20,
                          child: SvgPicture.asset(
                            "assets/icons/phone_incoming.svg",
                          )),
                      'Request call back',
                      () => _removeOverlay(),
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
    setState(() {
      _isOverlayVisible = true;
    });
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    _isOverlayVisible = false;
  }

  formatBudget(int budget) {
    if (budget < 10000000) {
      return "₹${(budget / 100000).toStringAsFixed(2)} Lac";
    } else {
      return "₹${(budget / 10000000).toStringAsFixed(2)} Cr";
    }
  }

  @override
  void initState() {
    super.initState();
    _globalKeys = widget.globalKeys;
  }

  @override
  void dispose() {
    _removeOverlay();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.6,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: widget.sortedApartments.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => PropertyDetails(
                  apartment: widget.sortedApartments[index],
                  heroTag:
                      "property-grid-card-${widget.sortedApartments[index].projectId}",
                ),
              ),
            );
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              boxShadow: const [
                BoxShadow(
                  color: CustomColors.black10,
                  offset: Offset(0, 0),
                  blurRadius: 4,
                ),
              ],
              color: CustomColors.white,
              border: Border.all(
                color: CustomColors.black25,
              ),
            ),
            child: Column(
              children: [
                SizedBox(
                  height: 160,
                  child: Stack(
                    children: [
                      Hero(
                        tag:
                            "grid-card-${widget.sortedApartments[index].projectId}",
                        child: Container(
                          height: 180,
                          decoration: BoxDecoration(
                            color: CustomColors.black25,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                            ),
                            image: DecorationImage(
                              image: NetworkImage(
                                  widget.sortedApartments[index].coverImage),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        height: 180,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              CustomColors.secondary.withOpacity(0),
                              CustomColors.secondary,
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
                          top: 0,
                          right: 0,
                          child: IconButton(
                            onPressed: () {
                              if (!ref
                                  .watch(savedPropertiesProvider)
                                  .contains(widget.sortedApartments[index])) {
                                ref
                                    .read(savedPropertiesProvider.notifier)
                                    .addApartment(
                                        widget.sortedApartments[index]);
                              } else {
                                ref
                                    .read(savedPropertiesProvider.notifier)
                                    .removeApartment(
                                        widget.sortedApartments[index]);
                              }
                            },
                            icon: ref
                                    .watch(savedPropertiesProvider)
                                    .contains(widget.sortedApartments[index])
                                ? const Icon(
                                    Icons.favorite,
                                    color: CustomColors.white,
                                  )
                                : const Icon(
                                    Icons.favorite_outline,
                                    color: CustomColors.white,
                                  ),
                          )),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Align(
                          alignment: Alignment.bottomLeft,
                          child: Text(
                            widget.sortedApartments[index].name,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: CustomColors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                                text: widget.sortedApartments[index].flatSize
                                    .toString(),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              const TextSpan(
                                text: " sq.ft",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),
                        RichText(
                          text: TextSpan(
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black, // Default text color
                            ),
                            children: [
                              const TextSpan(
                                text: "Price: ",
                                style: TextStyle(
                                  color: CustomColors.black75,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 14,
                                ),
                              ),
                              TextSpan(
                                text: formatBudget(
                                    widget.sortedApartments[index].budget),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                        RichText(
                          text: TextSpan(
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black, // Default text color
                            ),
                            children: [
                              const TextSpan(
                                text: "Cost/sq.ft: ",
                                style: TextStyle(
                                  color: CustomColors.black75,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 14,
                                ),
                              ),
                              TextSpan(
                                text:
                                    "₹${widget.sortedApartments[index].pricePerSquareFeetRate}",
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
                                  height: 32,
                                  width: 32,
                                  child: IconButton.filled(
                                    style: IconButton.styleFrom(
                                      padding: const EdgeInsets.all(2),
                                      backgroundColor: ref
                                              .watch(comparePropertyProvider)
                                              .contains(widget
                                                  .sortedApartments[index])
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
                                          .contains(
                                              widget.sortedApartments[index])) {
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
                                              .addApartment(widget
                                                  .sortedApartments[index]);
                                        }
                                      } else {
                                        ref
                                            .read(comparePropertyProvider
                                                .notifier)
                                            .removeApartment(
                                                widget.sortedApartments[index]);
                                      }
                                    },
                                    icon: !ref
                                            .watch(comparePropertyProvider)
                                            .contains(
                                                widget.sortedApartments[index])
                                        ? SizedBox(
                                            height: 22,
                                            width: 22,
                                            child: SvgPicture.asset(
                                              "assets/icons/compare.svg",
                                              color: CustomColors.primary,
                                            ),
                                          )
                                        : const Icon(
                                            Icons.check,
                                            color: CustomColors.green,
                                          ),
                                  ),
                                ),
                              const SizedBox(width: 4),
                              SizedBox(
                                key: _globalKeys[index],
                                height: 32,
                                width: 32,
                                child: IconButton.filled(
                                  style: IconButton.styleFrom(
                                    backgroundColor: CustomColors.blue,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  onPressed: () {
                                    _toggleOverlay(
                                      context,
                                      widget.sortedApartments[index],
                                      index,
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
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
