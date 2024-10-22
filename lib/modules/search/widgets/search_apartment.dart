import 'package:flutter/material.dart';
import 'package:re_portal_frontend/modules/home/screens/property_details.dart';
import 'package:re_portal_frontend/modules/shared/models/appartment_model.dart';
import 'package:re_portal_frontend/modules/shared/widgets/colors.dart';

class SearchApartmentCard extends StatefulWidget {
  final ApartmentModel apartment;
  const SearchApartmentCard({
    super.key,
    required this.apartment,
  });

  @override
  State<SearchApartmentCard> createState() => _SearchApartmentCardState();
}

class _SearchApartmentCardState extends State<SearchApartmentCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PropertyDetails(
              apartment: widget.apartment,
              heroTag: "search-${widget.apartment.projectId}",
            ),
          ),
        );
      },
      child: Container(
        width: 120,
        height: 100,
        margin: const EdgeInsets.only(right: 10),
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          color: CustomColors.secondary,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Stack(
          children: [
            Hero(
              tag: "search-${widget.apartment.projectId}",
              child: SizedBox(
                height: 100,
                width: 120,
                child: Image.network(
                  widget.apartment.coverImage,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              height: 100,
              width: 120,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    CustomColors.secondary.withOpacity(0.0),
                    CustomColors.secondary.withOpacity(0.9),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            Positioned(
              bottom: 10,
              left: 4,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 110,
                    child: Text(
                      widget.apartment.name,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        height: 1,
                        color: CustomColors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        size: 12,
                        color: CustomColors.primary,
                      ),
                      const SizedBox(width: 2),
                      Text(
                        widget.apartment.projectLocation,
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
            )
          ],
        ),
      ),
    );
  }
}