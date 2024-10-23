import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:re_portal_frontend/modules/home/screens/property_details.dart';
import 'package:re_portal_frontend/modules/shared/widgets/colors.dart';
import 'package:re_portal_frontend/riverpod/home_data.dart';
import 'package:shimmer/shimmer.dart';

class NewLaunchSection extends ConsumerWidget {
  final String title;
  const NewLaunchSection({super.key, required this.title});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final apartments = ref.watch(homePropertiesProvider).newProjects;
    return Container(
        decoration: BoxDecoration(
          color: CustomColors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        margin: const EdgeInsets.only(top: 16),
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(4, 0, 16, 8),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(
            height: 300,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: apartments.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PropertyDetails(
                          apartment: apartments[index],
                          heroTag: "$title-${apartments[index].projectId}",
                        ),
                      ),
                    );
                  },
                  child: Container(
                    height: 300,
                    width: 200,
                    clipBehavior: Clip.hardEdge,
                    margin: const EdgeInsets.fromLTRB(2, 0, 16, 8),
                    decoration: BoxDecoration(
                      color: const Color(0XFFFAF5E6),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 5,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Stack(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Hero(
                              tag: "$title-${apartments[index].projectId}",
                              child: SizedBox(
                                height: 120,
                                width: double.infinity,
                                child: Image.network(
                                  apartments[index].coverImage,
                                  fit: BoxFit.cover,
                                  loadingBuilder: (context, child,
                                          loadingProgress) =>
                                      loadingProgress == null
                                          ? child
                                          : Shimmer.fromColors(
                                              baseColor: CustomColors.black75,
                                              highlightColor:
                                                  CustomColors.black25,
                                              child: Container(
                                                height: 120,
                                                width: 300,
                                                decoration: BoxDecoration(
                                                  color: Colors.black,
                                                  borderRadius:
                                                      BorderRadius.circular(16),
                                                ),
                                              ),
                                            ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 4),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                apartments[index].name,
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                  color: CustomColors.black,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                ),
                                              ),
                                              Row(
                                                children: [
                                                  const Icon(
                                                    Icons.location_on,
                                                    size: 14,
                                                    color: CustomColors.primary,
                                                  ),
                                                  Text(
                                                    apartments[index]
                                                        .projectLocation,
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: const TextStyle(
                                                      color: CustomColors.black,
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      fontSize: 12,
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
                                  SizedBox(
                                    height: 64,
                                    width: 80,
                                    child: Stack(
                                      children: [
                                        Container(
                                          height: 80,
                                          width: 80,
                                          decoration: BoxDecoration(
                                            color: CustomColors.black10
                                                .withOpacity(0.1),
                                            border: Border.all(
                                              color: CustomColors.black10,
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: CustomColors.black10
                                                    .withOpacity(0.5),
                                                blurRadius: 5,
                                                offset: const Offset(0, 1),
                                              ),
                                            ],
                                          ),
                                          child: Image.asset(
                                            'assets/images/map.png',
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        const Center(
                                          child: Icon(
                                            Icons.location_on,
                                            color: CustomColors.primary,
                                            size: 30,
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    PropertyDetails(
                                                  apartment: apartments[index],
                                                  heroTag:
                                                      "$title-${apartments[index].projectId}",
                                                ),
                                              ),
                                            );
                                          },
                                          child: Container(
                                            height: 86,
                                            width: 86,
                                            color: CustomColors.black10
                                                .withOpacity(0.1),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Divider(
                              height: 1,
                              color: CustomColors.yellow,
                              indent: 24,
                              endIndent: 24,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                if (apartments[index]
                                    .configuration
                                    .where((item) => item.isNotEmpty)
                                    .isNotEmpty)
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Padding(
                                          padding:
                                              EdgeInsets.only(left: 4, top: 4),
                                          child: Text(
                                            'Available',
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 4),
                                          child: SingleChildScrollView(
                                            scrollDirection: Axis.horizontal,
                                            child: Row(
                                              children: [
                                                ...List.generate(
                                                  apartments[index]
                                                      .configuration
                                                      .where((item) =>
                                                          item.isNotEmpty)
                                                      .length,
                                                  (index) => Container(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 6),
                                                    decoration: BoxDecoration(
                                                      border: index !=
                                                              apartments[index]
                                                                      .configuration
                                                                      .where((item) =>
                                                                          item.isNotEmpty)
                                                                      .length -
                                                                  1
                                                          ? const Border(
                                                              right: BorderSide(
                                                                color:
                                                                    CustomColors
                                                                        .black,
                                                                width: 1,
                                                              ),
                                                            )
                                                          : null,
                                                    ),
                                                    child: Text(
                                                      apartments[index]
                                                          .configuration
                                                          .where((item) =>
                                                              item.isNotEmpty)
                                                          .first,
                                                      style: const TextStyle(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                SizedBox(
                                  height: 36,
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => PropertyDetails(
                                            apartment: apartments[index],
                                            heroTag:
                                                "$title-${apartments[index].projectId}",
                                          ),
                                        ),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: CustomColors.primary,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(0),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                    ),
                                    child: const Text(
                                      'View more',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 12),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 4),
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(12),
                              bottomRight: Radius.circular(12),
                            ),
                            color: CustomColors.primary,
                          ),
                          child: Text(
                            title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
