import 'package:flutter/material.dart';
import 'package:re_portal_frontend/modules/home/screens/property_details.dart';
import 'package:re_portal_frontend/modules/shared/models/appartment_model.dart';
import 'package:re_portal_frontend/modules/shared/widgets/colors.dart';

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
        return "₹${(budget / 100000).toStringAsFixed(1)} Lac";
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
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.width * 0.8,
        clipBehavior: Clip.hardEdge,
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
                    SizedBox(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.width * 0.8,
                      child: Image.network(
                        lifestyleProperty.coverImage,
                        fit: BoxFit.cover,
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
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const CircleAvatar(
                    radius: 28,
                    backgroundColor: CustomColors.primary50,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          lifestyleProperty.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        Text(
                          "By ${lifestyleProperty.companyName}",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 14,
                            color: CustomColors.black50,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
