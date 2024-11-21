import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:re_portal_frontend/modules/home/screens/property_details.dart';
import 'package:re_portal_frontend/modules/shared/models/appartment_model.dart';
import 'package:re_portal_frontend/modules/shared/widgets/colors.dart';
import 'package:shimmer/shimmer.dart';

class LifestyleProjectCard extends StatelessWidget {
  final ApartmentModel lifestyleProperty;
  final bool showPrice;

  const LifestyleProjectCard({
    super.key,
    required this.lifestyleProperty,
    this.showPrice = false,
  });

  @override
  Widget build(BuildContext context) {
    formatBudget(int budget) {
      if (budget < 10000000) {
        return "₹${(budget / 100000).toStringAsFixed(1)} L";
      } else {
        return "₹${(budget / 10000000).toStringAsFixed(2)} Cr";
      }
    }

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PropertyDetails(
              apartment: lifestyleProperty,
              heroTag: "lifestyle-${lifestyleProperty.projectId}",
            ),
          ),
        );
      },
      child: Container(
        width: MediaQuery.of(context).size.width * 0.95,
        height: MediaQuery.of(context).size.width * 0.8,
        clipBehavior: Clip.hardEdge,
        margin: const EdgeInsets.only(left: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: CustomColors.black25),
        ),
        child: Column(
          children: [
            Expanded(
              child: Hero(
                tag: "lifestyle-${lifestyleProperty.projectId}",
                child: Stack(
                  children: [
                    Container(
                      color: CustomColors.black10,
                      width: double.infinity,
                      height: MediaQuery.of(context).size.width * 0.8,
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: Image.network(
                              lifestyleProperty.coverImage,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Center(
                                child: Icon(Icons.info),
                              ),
                            ),
                          ),
                          Positioned.fill(
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    CustomColors.black.withOpacity(0),
                                    CustomColors.black.withOpacity(0.8),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 8,
                            left: 8,
                            right: 4,
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 4),
                                  child: CircleAvatar(
                                    radius: 14,
                                    backgroundColor: CustomColors.white,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(100),
                                      child: Image.network(
                                        lifestyleProperty.companyLogo,
                                        fit: BoxFit.cover,
                                        loadingBuilder: (context, child,
                                                loadingProgress) =>
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
                                            lifestyleProperty.builderName[0],
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
                                      lifestyleProperty.name,
                                      style: const TextStyle(
                                        color: CustomColors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      "By ${lifestyleProperty.builderName}",
                                      style: const TextStyle(
                                        color: CustomColors.white,
                                        fontSize: 10,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Text(
                                      "Ready by ${DateFormat('MMM yyyy').format(DateTime.parse(lifestyleProperty.projectPossession))}",
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
                          ),
                        ],
                      ),
                    ),
                    //price
                    if (showPrice)
                      Positioned(
                        bottom: 4,
                        right: 4,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 6, horizontal: 10),
                          decoration: BoxDecoration(
                            color: CustomColors.primary,
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: Text(
                            formatBudget(lifestyleProperty.budget),
                            style: const TextStyle(
                              color: CustomColors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                color: CustomColors.white,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.location_on,
                              size: 14,
                              color: CustomColors.primary,
                            ),
                            const SizedBox(width: 2),
                            Text(
                              lifestyleProperty.projectLocation,
                              style: const TextStyle(
                                color: CustomColors.black,
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const Icon(
                              Icons.bed,
                              size: 14,
                              color: CustomColors.primary,
                            ),
                            const SizedBox(width: 2),
                            Text(
                              "${lifestyleProperty.configTitle} ",
                              style: const TextStyle(
                                color: CustomColors.black,
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: CustomColors.primary,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Text(
                      "${formatBudget(lifestyleProperty.minBudget)} - ${formatBudget(lifestyleProperty.maxBudget)}",
                      style: const TextStyle(
                        color: CustomColors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
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
