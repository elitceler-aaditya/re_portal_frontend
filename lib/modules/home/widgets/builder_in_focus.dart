import 'package:flutter/material.dart';
import 'package:re_portal_frontend/modules/home/models/builder_data_model.dart';
import 'package:re_portal_frontend/modules/home/screens/property_details.dart';
import 'package:re_portal_frontend/modules/shared/models/appartment_model.dart';
import 'package:re_portal_frontend/modules/shared/widgets/colors.dart';
import 'package:shimmer/shimmer.dart';

class BuilderInFocus extends StatefulWidget {
  final List<BuilderDataModel> builderData;
  const BuilderInFocus({super.key, required this.builderData});

  @override
  State<BuilderInFocus> createState() => _BuilderInFocusState();
}

class _BuilderInFocusState extends State<BuilderInFocus> {
  List<BuilderDataModel> builders = [];

  @override
  void initState() {
    super.initState();
    builders = widget.builderData;
  }

  @override
  Widget build(BuildContext context) {
    // return SizedBox(height: 300, child: Text(builders.length.toString()));
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width,
          child: const Padding(
            padding: EdgeInsets.fromLTRB(8, 4, 8, 10),
            child: Row(
              children: [
                Text(
                  "Builders in Focus",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Spacer(),
                Text(
                  "Scroll for more>",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              const SizedBox(width: 10),
              ...List.generate(
                builders.length,
                (index) => _builderCard(context, builders[index]),
              ),
              const SizedBox(width: 10),
            ],
          ),
        ),
      ],
    );
  }
}

Widget _builderCard(BuildContext context, BuilderDataModel builder) {
  return Container(
    width: 330,
    margin: const EdgeInsets.only(right: 10),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: CustomColors.primary),
      color: CustomColors.primary20,
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: CustomColors.primary.withOpacity(0.8),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(11),
              topRight: Radius.circular(11),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                backgroundColor: CustomColors.white.withOpacity(0.3),
                radius: 24,
                child: Image.network(
                  builder.CompanyLogo,
                  loadingBuilder: (context, child, loadingProgress) =>
                      loadingProgress == null
                          ? child
                          : Shimmer.fromColors(
                              baseColor: CustomColors.black25,
                              highlightColor: CustomColors.black10,
                              child: Container(),
                            ),
                  errorBuilder: (context, error, stackTrace) => Center(
                    child: Text(
                      builder.CompanyName[0],
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: CustomColors.white,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      builder.CompanyName,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: CustomColors.black10,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Row(
                          children: [
                            Icon(
                              Icons.verified_user_rounded,
                              color: Color(0xFFEBD300),
                              size: 14,
                            ),
                            SizedBox(width: 4),
                            Text(
                              "Verified",
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFFEBD300),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          "|",
                          style: TextStyle(
                            fontSize: 16,
                            color: CustomColors.black10,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Row(
                          children: [
                            const Icon(
                              Icons.apartment,
                              color: CustomColors.black10,
                              size: 14,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              "${builder.builderTotalProjects} projects",
                              style: const TextStyle(
                                fontSize: 12,
                                color: CustomColors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
            ],
          ),
        ),
        SizedBox(
          height: 250,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount:
                builder.projects.length, // Use the actual length of apartments
            itemBuilder: (context, index) {
              final apartments = builder.projects;
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

_builderInFocusCard(BuildContext context, ApartmentModel apartment,
    ApartmentModel nextApartment) {
  return GestureDetector(
    onTap: () {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => PropertyDetails(
            apartment: apartment,
            heroTag: "builder-${apartment.projectId}",
            nextApartment: nextApartment,
          ),
        ),
      );
    },
    child: Padding(
      padding: const EdgeInsets.fromLTRB(10, 2, 10, 14),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Hero(
              tag: "builder-${apartment.projectId}",
              child: Container(
                width: 200,
                clipBehavior: Clip.hardEdge,
                height: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Image.network(
                  apartment.coverImage,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) =>
                      loadingProgress == null
                          ? child
                          : Shimmer.fromColors(
                              baseColor: CustomColors.black25,
                              highlightColor: CustomColors.black10,
                              child: Container(
                                height: 200,
                                width: 320,
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                            ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            apartment.name,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: CustomColors.primary,
            ),
          ),
          Text(
            "@${apartment.projectLocation},Hyderabad",
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
