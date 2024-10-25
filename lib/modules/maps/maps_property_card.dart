import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:re_portal_frontend/modules/home/screens/property_details.dart';
import 'package:re_portal_frontend/modules/shared/models/appartment_model.dart';
import 'package:re_portal_frontend/modules/shared/widgets/colors.dart';

class MapsPropertyCard extends StatelessWidget {
  final ApartmentModel apartment;
  const MapsPropertyCard({
    super.key,
    required this.apartment,
  });

  String formatBudget(int budget) {
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
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PropertyDetails(
              apartment: apartment,
              heroTag: "map-prop-${apartment.projectId}",
            ),
          ),
        );
      },
      child: Container(
        height: 100,
        width: 290,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: CustomColors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: CustomColors.black.withOpacity(0.1),
              blurRadius: 10,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Column(
          children: [
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Hero(
                    tag: "map-prop-${apartment.projectId}",
                    child: SizedBox(
                      height: double.infinity,
                      width: 110,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          apartment.coverImage,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Center(
                              child: Icon(Icons.error),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            apartment.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              height: 1.1,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: CustomColors.primary20,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: CustomColors.primary,
                              width: 1,
                            ),
                          ),
                          child: Text(
                            formatBudget(apartment.budget),
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: CustomColors.primary,
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(
                              Icons.location_on_rounded,
                              color: CustomColors.primary,
                              size: 14,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              apartment.projectLocation,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            const Icon(
                              Icons.bed,
                              color: CustomColors.primary,
                              size: 14,
                            ),
                            const SizedBox(width: 4),
                            RichText(
                              text: TextSpan(
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.black,
                                ),
                                children: [
                                  ...apartment.configuration
                                      .take(2)
                                      .map((config) => TextSpan(
                                            text: config +
                                                (apartment.configuration
                                                            .indexOf(config) <
                                                        apartment.configuration
                                                                .take(2)
                                                                .length -
                                                            1
                                                    ? ', '
                                                    : ''),
                                            style: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.normal,
                                            ),
                                          )),
                                  if (apartment.configuration.length - 2 != 0)
                                    TextSpan(
                                      text:
                                          ' +${apartment.configuration.length - 2} more',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            const Icon(
                              Icons.fullscreen,
                              color: CustomColors.primary,
                              size: 14,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              "${apartment.flatSize} sq.ft",
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        SizedBox(
                          width: 90,
                          height: 32,
                          child: TextButton(
                            style: TextButton.styleFrom(
                              backgroundColor: CustomColors.primary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PropertyDetails(
                                    apartment: apartment,
                                    heroTag: "map-prop-${apartment.projectId}",
                                  ),
                                ),
                              );
                            },
                            child: const Text(
                              'View more',
                              style: TextStyle(
                                color: CustomColors.white,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
