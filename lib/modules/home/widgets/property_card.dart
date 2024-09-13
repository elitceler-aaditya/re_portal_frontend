import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:re_portal_frontend/modules/home/screens/property_details.dart';
import 'package:re_portal_frontend/modules/home/widgets/ribbon.dart';
import 'package:re_portal_frontend/modules/shared/models/appartment_model.dart';
import 'package:re_portal_frontend/modules/shared/widgets/colors.dart';
import 'package:re_portal_frontend/riverpod/compare_appartments.dart';
import 'package:re_portal_frontend/riverpod/saved_properties.dart';

class PropertyCard extends ConsumerStatefulWidget {
  final ApartmentModel apartment;
  final ApartmentModel? nextApartment;
  final bool isCompare;
  final Function(BuildContext) onCallPress;
  final GlobalKey globalKey;

  const PropertyCard({
    super.key,
    required this.apartment,
    this.nextApartment,
    required this.isCompare,
    required this.onCallPress,
    required this.globalKey,
  });

  @override
  ConsumerState<PropertyCard> createState() => _PropertyCardState();
}

class _PropertyCardState extends ConsumerState<PropertyCard> {
  formatBudget(double budget) {
    if (budget < 10000000) {
      return "${(budget / 100000).toStringAsFixed(2)} L";
    } else {
      return "${(budget / 10000000).toStringAsFixed(2)} Cr";
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => PropertyDetails(
              appartment: widget.apartment,
              nextApartment: widget.nextApartment,
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
                    tag: widget.apartment.apartmentID,
                    child: Container(
                      height: 180,
                      decoration: BoxDecoration(
                        color: CustomColors.black25,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                        ),
                        image: widget.apartment.image.isNotEmpty
                            ? DecorationImage(
                                image: NetworkImage(widget.apartment.image),
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
                        ref
                                .read(savedPropertiesProvider)
                                .contains(widget.apartment)
                            ? ref
                                .read(savedPropertiesProvider.notifier)
                                .removeApartment(widget.apartment)
                            : ref
                                .read(savedPropertiesProvider.notifier)
                                .addApartment(widget.apartment);
                      },
                      icon: Icon(
                        ref
                                .watch(savedPropertiesProvider)
                                .contains(widget.apartment)
                            ? Icons.bookmark
                            : Icons.bookmark_outline,
                        color: CustomColors.white,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        widget.apartment.apartmentName,
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
                  Text(
                    "This beautiful property lies in ${widget.apartment.locality} with ${widget.apartment.openSpace} acres of free space. It is a perfect place for a peaceful life.",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
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
                                  "${widget.apartment.flatSize.toStringAsFixed(0)} sq.ft",
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
                            color: Colors.black,
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
                              text: formatBudget(widget.apartment.budget),
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
                            if (widget.isCompare)
                              SizedBox(
                                height: 40,
                                width: 40,
                                child: IconButton.filled(
                                  style: IconButton.styleFrom(
                                    backgroundColor: ref
                                            .watch(comparePropertyProvider)
                                            .contains(widget.apartment)
                                        ? CustomColors.green10
                                        : CustomColors.primary20,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  onPressed: () {
                                    if (ref
                                        .watch(comparePropertyProvider)
                                        .contains(widget.apartment)) {
                                      debugPrint(
                                        "Compare button pressed for ${widget.apartment.apartmentName}",
                                      );
                                      ref
                                          .read(
                                              comparePropertyProvider.notifier)
                                          .removeApartment(widget.apartment);
                                    } else {
                                      ref
                                          .read(
                                              comparePropertyProvider.notifier)
                                          .addApartment(widget.apartment);
                                    }
                                  },
                                  icon: ref
                                          .watch(comparePropertyProvider)
                                          .contains(widget.apartment)
                                      ? const Icon(
                                          Icons.check,
                                          color: CustomColors.green,
                                        )
                                      : SvgPicture.asset(
                                          "assets/icons/compare.svg",
                                          color: CustomColors.primary,
                                          height: 20,
                                          width: 20,
                                        ),
                                ),
                              ),
                            const SizedBox(width: 8),
                            SizedBox(
                              key: widget.globalKey,
                              height: 40,
                              width: 40,
                              child: IconButton.filled(
                                style: IconButton.styleFrom(
                                  backgroundColor: CustomColors.secondary,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                onPressed: () => widget.onCallPress(context),
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
}
