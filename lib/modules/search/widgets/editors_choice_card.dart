import 'package:flutter/material.dart';
import 'package:re_portal_frontend/modules/home/screens/property_details.dart';
import 'package:re_portal_frontend/modules/shared/models/appartment_model.dart';
import 'package:re_portal_frontend/modules/shared/widgets/colors.dart';

class EditorsChoiceCard extends StatelessWidget {
  final List<ApartmentModel> apartments;

  const EditorsChoiceCard({
    super.key,
    required this.apartments,
  });
  String formatBudget(int budget) {
    //return budget in k format or lakh and cr format
    if (budget < 100000) {
      return "${(budget / 1000).toStringAsFixed(00)}K";
    } else if (budget < 10000000) {
      return "${(budget / 100000).toStringAsFixed(1)}L";
    } else {
      return "${(budget / 10000000).toStringAsFixed(2)}Cr";
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
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
                    heroTag: "editors-choice-${apartments[index].projectId}",
                    nextApartment: index + 1 < apartments.length
                        ? apartments[index + 1]
                        : apartments.first,
                  ),
                ),
              );
            },
            child: Container(
              width: MediaQuery.of(context).size.width * 0.85,
              margin: const EdgeInsets.only(right: 14, left: 2),
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                color: CustomColors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: Hero(
                      tag: "editors-choice-${apartments[index].projectId}",
                      child: Container(
                        height: 200,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          image: DecorationImage(
                            image: NetworkImage(apartments[index].coverImage),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: 200,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      gradient: LinearGradient(
                        colors: [
                          CustomColors.secondary.withOpacity(0.8),
                          CustomColors.secondary.withOpacity(0),
                        ],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                    ),
                  ),
                  ClipPath(
                    clipper: CustomShapeClipper(),
                    child: Container(
                      color: CustomColors.secondary,
                      height: 200,
                      width: MediaQuery.of(context).size.width * 0.9,
                    ),
                  ),
                  Positioned(
                    top: 0,
                    left: 0,
                    child: Container(
                      height: 200,
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            apartments[index].name,
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
                                size: 14,
                                color: CustomColors.primary,
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
                          const Spacer(),
                          Text(
                            "your dream flat @ ${formatBudget(apartments[index].budget)}",
                            style: const TextStyle(
                              color: CustomColors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: CustomColors.primary,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text(
                              "View more",
                              style: TextStyle(
                                color: CustomColors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
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

class CustomShapeClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height);
    path.lineTo(size.width * 0.5, size.height);
    path.lineTo(size.width * 0.25, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
