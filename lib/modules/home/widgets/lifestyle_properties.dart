import 'package:flutter/material.dart';
import 'package:re_portal_frontend/modules/home/screens/property_details.dart';
import 'package:re_portal_frontend/modules/shared/models/appartment_model.dart';
import 'package:re_portal_frontend/modules/shared/widgets/colors.dart';

class LifestyleProperties extends StatelessWidget {
  final List<ApartmentModel> lifestyleProperties;
  const LifestyleProperties({super.key, required this.lifestyleProperties});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Text(
            "Lifestyle Properties",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(
          height: 250,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: lifestyleProperties.length,
            itemBuilder: (context, index) {
              return _lifestylePropertyCard(
                  context, lifestyleProperties[index]);
            },
          ),
        ),
      ],
    );
  }
}

_lifestylePropertyCard(context, ApartmentModel lifestyleProperty) {
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
      width: MediaQuery.of(context).size.width * 0.8,
      height: MediaQuery.of(context).size.width * 0.8,
      margin: const EdgeInsets.symmetric(horizontal: 10),
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
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                child: Image.network(
                  lifestyleProperty.coverImage,
                  fit: BoxFit.cover,
                ),
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
                Column(
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
                    // Text(
                    //   "By ${lifestyleProperty.companyName}",
                    //   maxLines: 1,
                    //   overflow: TextOverflow.ellipsis,
                    //   style: const TextStyle(
                    //     fontSize: 14,
                    //     color: CustomColors.black50,
                    //   ),
                    // ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    ),
  );
}
