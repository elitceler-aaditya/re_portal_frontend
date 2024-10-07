import 'package:flutter/material.dart';
import 'package:re_portal_frontend/modules/home/screens/property_details.dart';
import 'package:re_portal_frontend/modules/shared/models/appartment_model.dart';
import 'package:re_portal_frontend/modules/shared/widgets/colors.dart';
import 'package:shimmer/shimmer.dart';

class PropertyStackCard extends StatelessWidget {
  final List<ApartmentModel> apartments;

  const PropertyStackCard({
    super.key,
    required this.apartments,
  });
  String formatBudget(double budget) {
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
      height: 180,
      child: ListView.builder(
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
                    heroTag: "property-${apartments[index].projectId}",
                    nextApartment: index + 1 < apartments.length
                        ? apartments[index + 1]
                        : apartments.first,
                  ),
                ),
              );
            },
            child: Container(
              width: MediaQuery.of(context).size.width * 0.8,
              margin: const EdgeInsets.symmetric(horizontal: 6),
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                color: CustomColors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Stack(
                children: [
                  Hero(
                    tag: "property-${apartments[index].projectId}",
                    child: SizedBox(
                      height: 180,
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
                                      height: 180,
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
                  Container(
                    height: 180,
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
                  Positioned(
                    bottom: 0,
                    left: 0,
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            apartments[index].name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: CustomColors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Row(
                            children: [
                              const Icon(
                                Icons.location_on,
                                size: 12,
                                color: CustomColors.white,
                              ),
                              const SizedBox(width: 2),
                              Text(
                                apartments[index].projectLocation,
                                style: const TextStyle(
                                  color: CustomColors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
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
