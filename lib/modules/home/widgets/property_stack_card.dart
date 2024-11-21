import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:re_portal_frontend/modules/home/screens/property_details.dart';
import 'package:re_portal_frontend/modules/shared/models/appartment_model.dart';
import 'package:re_portal_frontend/modules/shared/widgets/colors.dart';
import 'package:shimmer/shimmer.dart';

class PropertyStackCard extends StatelessWidget {
  final List<ApartmentModel> apartments;
  final double cardWidth;
  final double cardHeight;
  final bool showCompanyName;
  final bool leftPadding;
  final ScrollController? controller;

  const PropertyStackCard({
    super.key,
    required this.apartments,
    required this.cardWidth,
    this.showCompanyName = false,
    this.cardHeight = 200,
    this.leftPadding = true,
    this.controller,
  });

  String formatBudget(int budget) {
    //return budget in k format or lakh and cr format
    if (budget < 100000) {
      return "₹${(budget / 1000).toStringAsFixed(00)}K";
    } else if (budget < 10000000) {
      return "₹${(budget / 100000).toStringAsFixed(1)}L";
    } else {
      return "₹${(budget / 10000000).toStringAsFixed(2)}Cr";
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: cardHeight,
      child: ListView.builder(
        controller: controller,
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: apartments.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => PropertyDetails(
                    apartment: apartments[index],
                    heroTag: "property-stack-${apartments[index].projectId}",
                  ),
                ),
              );
            },
            child: Container(
              width: cardWidth,
              height: cardHeight,
              margin: EdgeInsets.only(
                  left: leftPadding ? 8 : 0, right: leftPadding ? 0 : 8),
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                color: CustomColors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Stack(
                children: [
                  Hero(
                    tag: "property-stack-${apartments[index].projectId}",
                    child: SizedBox(
                      height: cardHeight,
                      width: double.infinity,
                      child: Image.network(
                        apartments[index].coverImage,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) =>
                            loadingProgress == null
                                ? child
                                : Shimmer.fromColors(
                                    baseColor: CustomColors.black75,
                                    highlightColor: CustomColors.black25,
                                    child: Container(
                                      height: cardHeight,
                                      width: MediaQuery.of(context).size.width *
                                          0.8,
                                      decoration: BoxDecoration(
                                        color: Colors.black,
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                    ),
                                  ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: cardHeight / 2,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        gradient: LinearGradient(
                          colors: [
                            CustomColors.black.withOpacity(0),
                            CustomColors.black.withOpacity(0.8),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    child: Container(
                      width: cardWidth,
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 4),
                                child: CircleAvatar(
                                  radius: 14,
                                  backgroundColor: CustomColors.white,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(100),
                                    child: Image.network(
                                      apartments[index].companyLogo,
                                      fit: BoxFit.cover,
                                      loadingBuilder:
                                          (context, child, loadingProgress) =>
                                              loadingProgress == null
                                                  ? child
                                                  : Shimmer.fromColors(
                                                      baseColor:
                                                          CustomColors.black25,
                                                      highlightColor:
                                                          CustomColors.black10,
                                                      child: const SizedBox(
                                                        width: 28,
                                                        height: 28,
                                                      ),
                                                    ),
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              Center(
                                        child: Text(
                                          apartments[index].builderName[0],
                                          style: const TextStyle(
                                            color: CustomColors.black,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    apartments[index].name,
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      height: 1,
                                      color: CustomColors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  if (apartments[index].companyName.isNotEmpty)
                                    Text(
                                      "By ${apartments[index].builderName}",
                                      style: const TextStyle(
                                        color: CustomColors.white,
                                        fontSize: 10,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          if (showCompanyName)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 4),
                              child: Text(
                                "by ${apartments[index].companyName}",
                                style: const TextStyle(
                                  color: CustomColors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          Row(
                            children: [
                              const Icon(
                                Icons.location_on,
                                size: 12,
                                color: CustomColors.primary,
                              ),
                              const SizedBox(width: 2),
                              Text(
                                "${apartments[index].projectLocation} ${apartments[index].configuration.isNotEmpty ? '• ${apartments[index].configTitle}' : ''} • Ready by ${DateFormat('MMM yyyy').format(DateTime.parse(apartments[index].projectPossession))}",
                                style: const TextStyle(
                                  color: CustomColors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            "${formatBudget(apartments[index].minBudget)} - ${formatBudget(apartments[index].maxBudget)}",
                            style: const TextStyle(
                              color: CustomColors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
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
      ),
    );
  }
}
