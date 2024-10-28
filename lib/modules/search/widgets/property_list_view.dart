import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:re_portal_frontend/modules/home/screens/ads_section.dart';
import 'package:re_portal_frontend/modules/home/widgets/property_card.dart';
import 'package:re_portal_frontend/modules/shared/models/appartment_model.dart';
import 'package:re_portal_frontend/modules/shared/widgets/colors.dart';
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
          mainAxisAlignment: MainAxisAlignment.end,
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
              color: Colors.black.withOpacity(0.7),
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
            left: position.dx - 150,
            top: position.dy - 180,
            child: Material(
              color: Colors.transparent,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.transparent,
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
                  mainAxisAlignment: MainAxisAlignment.end,
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
                            color: CustomColors.primary,
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
    setState(() {
      _isOverlayVisible = false;
    });
  }

  setGlobalKeys() {
    _globalKeys = List.generate(
      widget.sortedApartments.length,
      (index) =>
          GlobalKey(debugLabel: widget.sortedApartments[index].projectId),
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
      padding: EdgeInsets.zero,
      itemCount: widget.displayAds
          ? widget.sortedApartments.length +
              (widget.sortedApartments.length ~/ 4)
          : widget.sortedApartments.length,
      itemBuilder: (context, index) {
        if (!widget.displayAds) {
          return PropertyCard(
            apartment: widget.sortedApartments[index],
            nextApartment: index + 1 < widget.sortedApartments.length
                ? widget.sortedApartments[index + 1]
                : widget.sortedApartments.first,
            isCompare: widget.compare,
            onCallPress: (context) {
              _toggleOverlay(
                context,
                widget.sortedApartments[index],
                _globalKeys[index],
              );
            },
            globalKey: _globalKeys[index],
          );
        } else {
          if (widget.displayAds && index % 4 == 0 && index != 0) {
            return const AdsSection();
          } else {
            int listIndex = index - (index ~/ 4);
            return PropertyCard(
              apartment: widget.sortedApartments[listIndex],
              nextApartment: listIndex + 1 < widget.sortedApartments.length
                  ? widget.sortedApartments[listIndex + 1]
                  : widget.sortedApartments.first,
              isCompare: widget.compare,
              onCallPress: (context) {
                _toggleOverlay(
                  context,
                  widget.sortedApartments[listIndex],
                  _globalKeys[listIndex],
                );
              },
              globalKey: _globalKeys[listIndex],
            );
          }
        }
      },
    );
  }
}
