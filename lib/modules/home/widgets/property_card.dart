import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:re_portal_frontend/modules/home/screens/property_details.dart';
import 'package:re_portal_frontend/modules/shared/models/appartment_model.dart';
import 'package:re_portal_frontend/modules/shared/widgets/colors.dart';
import 'package:re_portal_frontend/riverpod/compare_appartments.dart';
import 'package:re_portal_frontend/riverpod/saved_properties.dart';
import 'package:shimmer/shimmer.dart';

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
  formatBudget(int budget) {
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
              apartment: widget.apartment,
              nextApartment: widget.nextApartment,
              heroTag: "property-${widget.apartment.projectId}",
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
                    tag: "property-${widget.apartment.projectId}",
                    child: Container(
                      height: 180,
                      clipBehavior: Clip.hardEdge,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                        ),
                      ),
                      child: widget.apartment.coverImage.isNotEmpty
                          ? Image.network(
                              widget.apartment.coverImage,
                              fit: BoxFit.cover,
                              loadingBuilder: (context, child,
                                      loadingProgress) =>
                                  loadingProgress == null
                                      ? child
                                      : Shimmer.fromColors(
                                          baseColor: CustomColors.black75,
                                          highlightColor: CustomColors.black25,
                                          child: Container(
                                            height: 200,
                                            width: 400,
                                            decoration: BoxDecoration(
                                              color: Colors.black,
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                            ),
                                          ),
                                        ),
                            )
                          : null,
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
                        widget.apartment.name,
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
                    widget.apartment.description,
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
                              text: "${widget.apartment.flatSize} sq.ft",
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
                                        "Compare button pressed for ${widget.apartment.name}",
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
                                          "assets/icons/compare_active.svg",
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
