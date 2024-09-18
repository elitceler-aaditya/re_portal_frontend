import 'package:flutter/material.dart';
import 'package:re_portal_frontend/modules/home/screens/property_details.dart';
import 'package:re_portal_frontend/modules/shared/models/appartment_model.dart';
import 'package:re_portal_frontend/modules/shared/widgets/colors.dart';
import 'package:re_portal_frontend/riverpod/home_data.dart';

class BuilderInFocus extends StatefulWidget {
  final List<ApartmentModel> apartments;
  const BuilderInFocus({super.key, required this.apartments});

  @override
  State<BuilderInFocus> createState() => _BuilderInFocusState();
}

class _BuilderInFocusState extends State<BuilderInFocus> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: CustomColors.primary20,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Builder In Focus",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 10),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: CustomColors.primary,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: const Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Balaji Constructors",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: CustomColors.white,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "RERA ID: P0244000006675",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 10),
                CircleAvatar(
                  radius: 24,
                )
              ],
            ),
          ),
          SizedBox(
            height: 250,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: widget
                  .apartments.length, // Use the actual length of apartments
              itemBuilder: (context, index) {
                final apartments = widget.apartments;
                final nextIndex =
                    (index + 1) % apartments.length; // Ensure circular access
                return _builderInFocusCard(
                  context,
                  apartments[index],
                  apartments[nextIndex],
                );
              },
            ),
          )
        ],
      ),
    );
  }
}

_builderInFocusCard(BuildContext context, ApartmentModel apartment,
    ApartmentModel nextApartment) {
  return GestureDetector(
    onTap: () {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => PropertyDetails(
            apartment: apartment,
            bestDeals: false,
            nextApartment: nextApartment,
          ),
        ),
      );
    },
    child: Padding(
      padding: const EdgeInsets.only(right: 16, top: 12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Hero(
              tag: apartment.apartmentID,
              child: Container(
                width: 200,
                height: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  image: DecorationImage(
                    image: NetworkImage(apartment.image),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            apartment.apartmentName,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: CustomColors.primary,
            ),
          ),
          Text(
            "@${apartment.locality},Hyderabad",
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.normal,
              color: CustomColors.black,
            ),
          ),
        ],
      ),
    ),
  );
}
