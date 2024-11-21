import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:re_portal_frontend/modules/home/screens/property_details.dart';
import 'package:re_portal_frontend/modules/shared/models/appartment_model.dart';
import 'package:re_portal_frontend/modules/shared/widgets/colors.dart';
import 'package:shimmer/shimmer.dart';

class NewLaunchSection extends ConsumerWidget {
  final String title;
  final List<ApartmentModel> apartments;
  const NewLaunchSection(
      {super.key, required this.title, required this.apartments});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String formatBudget(int budget) {
      if (budget < 100000) {
        return "₹${(budget / 1000).toStringAsFixed(00)}K";
      } else if (budget < 10000000) {
        return "₹${(budget / 100000).toStringAsFixed(1)}L";
      } else {
        return "₹${(budget / 10000000).toStringAsFixed(2)}Cr";
      }
    }

    return Container(
      decoration: BoxDecoration(
        color: CustomColors.white,
        borderRadius: BorderRadius.circular(6),
      ),
      margin: const EdgeInsets.only(top: 4),
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 0, 8),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(
            height: 250,
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
                    width: 200,
                    clipBehavior: Clip.hardEdge,
                    margin: const EdgeInsets.fromLTRB(10, 0, 0, 8),
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
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Hero(
                          tag: "$title-${apartments[index].projectId}",
                          child: SizedBox(
                            height: 120,
                            width: double.infinity,
                            child: Stack(
                              children: [
                                Positioned.fill(
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
                                                        BorderRadius.circular(
                                                            16),
                                                  ),
                                                ),
                                              ),
                                  ),
                                ),
                                Positioned.fill(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          Colors.transparent,
                                          Colors.black.withOpacity(0.7),
                                        ],
                                      ),
                                    ),
                                  ),
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
                                Positioned(
                                  left: 6,
                                  bottom: 6,
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 4),
                                        child: CircleAvatar(
                                          radius: 14,
                                          backgroundColor: CustomColors.white,
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(100),
                                            child: Image.network(
                                              apartments[index].companyLogo,
                                              fit: BoxFit.cover,
                                              loadingBuilder: (context, child,
                                                      loadingProgress) =>
                                                  loadingProgress == null
                                                      ? child
                                                      : Shimmer.fromColors(
                                                          baseColor:
                                                              CustomColors
                                                                  .black25,
                                                          highlightColor:
                                                              CustomColors
                                                                  .black10,
                                                          child: const SizedBox(
                                                            width: 28,
                                                            height: 28,
                                                          ),
                                                        ),
                                              errorBuilder: (context, error,
                                                      stackTrace) =>
                                                  Center(
                                                child: Text(
                                                  apartments[index]
                                                      .builderName[0],
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            apartments[index].name,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              color: CustomColors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          ),
                                          Text(
                                            "by ${apartments[index].builderName}",
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              color: CustomColors.white,
                                              fontWeight: FontWeight.normal,
                                              fontSize: 10,
                                            ),
                                          ),
                                          Text(
                                            "Ready by ${DateFormat('MMM yyyy').format(DateTime.parse(apartments[index].projectPossession))}",
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              color: CustomColors.white,
                                              fontWeight: FontWeight.normal,
                                              fontSize: 10,
                                            ),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 8,
                            horizontal: 4,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(
                                    Icons.location_on,
                                    size: 14,
                                    color: CustomColors.primary,
                                  ),
                                  Text(
                                    "${apartments[index].projectLocation} • ${formatBudget(apartments[index].minBudget)} - ${formatBudget(apartments[index].maxBudget)}",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      color: CustomColors.black,
                                      fontWeight: FontWeight.normal,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
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
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.only(left: 4, top: 4),
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
                                                  .where(
                                                      (item) => item.isNotEmpty)
                                                  .toList()
                                                  .length,
                                              (configIndex) => Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 6),
                                                decoration: BoxDecoration(
                                                  border: configIndex !=
                                                          apartments[index]
                                                                  .configuration
                                                                  .where((item) =>
                                                                      item.isNotEmpty)
                                                                  .toList()
                                                                  .length -
                                                              1
                                                      ? const Border(
                                                          right: BorderSide(
                                                            color: CustomColors
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
                                                      .toList()[configIndex],
                                                  style: const TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
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
                            Container(
                              height: 37,
                              width: double.infinity,
                              decoration: const BoxDecoration(
                                color: CustomColors.primary,
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(12),
                                  bottomRight: Radius.circular(12),
                                ),
                              ),
                              child: const Center(
                                child: Text(
                                  "View more",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
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
