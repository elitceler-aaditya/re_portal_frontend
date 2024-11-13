import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:re_portal_frontend/modules/home/screens/property_details.dart';
import 'package:re_portal_frontend/modules/shared/widgets/colors.dart';
import 'package:re_portal_frontend/riverpod/home_data.dart';

class ReadyToMovein extends ConsumerWidget {
  const ReadyToMovein({
    super.key,
  });

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

    final apartments = ref.watch(homePropertiesProvider).readyToMoveIn;
    if (apartments.isEmpty) {
      return const SizedBox.shrink();
    } else {
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
            const Padding(
              padding: EdgeInsets.fromLTRB(8, 0, 8, 8),
              child: Text(
                "Ready to move in projects",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(
              height: 200,
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
                            heroTag: "ready-${apartments[index].projectId}",
                          ),
                        ),
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.only(left: 10),
                      height: double.infinity,
                      width: MediaQuery.of(context).size.width * 0.8,
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                        color: CustomColors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: CustomColors.black.withOpacity(0.1),
                            blurRadius: 5,
                            spreadRadius: 4,
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Expanded(
                            child: Stack(
                              children: [
                                Hero(
                                  tag: "ready-${apartments[index].projectId}",
                                  child: SizedBox(
                                    height: double.infinity,
                                    width: double.infinity,
                                    child: Image.network(
                                      apartments[index].coverImage,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Positioned(
                                    child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 6,
                                    horizontal: 12,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0XFF6525FF)
                                        .withOpacity(0.6),
                                    borderRadius: const BorderRadius.only(
                                      bottomRight: Radius.circular(16),
                                      topLeft: Radius.circular(16),
                                    ),
                                  ),
                                  child: const Text(
                                    "Ready to move in",
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: CustomColors.white,
                                    ),
                                  ),
                                )),
                              ],
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            color: CustomColors.primary,
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 16),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        apartments[index].name,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: CustomColors.white,
                                        ),
                                      ),
                                      if (apartments[index]
                                          .builderName
                                          .isNotEmpty)
                                        Text(
                                          "By ${apartments[index].builderName}",
                                          style: const TextStyle(
                                            color: CustomColors.white,
                                            fontSize: 10,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.location_on,
                                            size: 14,
                                            color: CustomColors.white,
                                          ),
                                          const SizedBox(width: 2),
                                          Text(
                                            "${apartments[index].projectLocation} • ${formatBudget(apartments[index].minBudget)}",
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              fontSize: 12,
                                              color: CustomColors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: SizedBox(
                                    height: 30,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                PropertyDetails(
                                              apartment: apartments[index],
                                              heroTag:
                                                  "ready-${apartments[index].projectId}",
                                            ),
                                          ),
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: CustomColors.primary,
                                        side: const BorderSide(
                                          color: CustomColors.white,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                        ),
                                      ),
                                      child: const Text(
                                        'View more',
                                        style: TextStyle(
                                          color: CustomColors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                        ),
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
                  );
                },
              ),
            ),
          ],
        ),
      );
    }
  }
}
