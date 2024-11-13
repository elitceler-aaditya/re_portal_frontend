import 'package:flutter/material.dart';
import 'package:re_portal_frontend/modules/home/screens/property_details.dart';
import 'package:re_portal_frontend/modules/shared/models/appartment_model.dart';
import 'package:re_portal_frontend/modules/shared/widgets/colors.dart';
import 'package:shimmer/shimmer.dart';

class ProjectSnippetCard extends StatefulWidget {
  final ApartmentModel apartment;
  final String? videoLink;
  final double cardWidth;
  final bool leftPadding;

  const ProjectSnippetCard({
    super.key,
    required this.apartment,
    this.videoLink,
    this.leftPadding = true,
    this.cardWidth = 180,
  });

  @override
  State<ProjectSnippetCard> createState() => _ProjectSnippetCardState();
}

class _ProjectSnippetCardState extends State<ProjectSnippetCard> {
  String formatBudget(int budget) {
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
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => PropertyDetails(
              apartment: widget.apartment,
              heroTag: "ProjectSnippet-${widget.apartment.projectId}",
            ),
          ),
        );
      },
      child: Container(
        height: double.infinity,
        width: widget.cardWidth,
        margin: EdgeInsets.only(
            left: widget.leftPadding ? 10 : 0,
            right: widget.leftPadding ? 0 : 10),
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: Hero(
                tag: "ProjectSnippet-${widget.apartment.projectId}",
                child: Image.network(
                  widget.apartment.coverImage,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: Colors.grey,
                    child: const Center(
                      child: Icon(
                        Icons.error,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  loadingBuilder: (context, child, loadingProgress) =>
                      loadingProgress == null
                          ? child
                          : Shimmer.fromColors(
                              baseColor: CustomColors.black25,
                              highlightColor: CustomColors.black10,
                              child: const SizedBox(
                                width: double.infinity,
                                height: double.infinity,
                              ),
                            ),
                ),
              ),
            ),
            //gradietn
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.transparent,
                      CustomColors.black.withOpacity(0.7)
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 8,
              left: 8,
              right: 3,
              child: SizedBox(
                width: 180,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.apartment.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (widget.apartment.builderName.isNotEmpty)
                      Text(
                        "By ${widget.apartment.builderName}",
                        style: const TextStyle(
                          color: CustomColors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.location_on,
                          size: 16,
                          color: CustomColors.primary,
                        ),
                        const SizedBox(width: 2),
                        Expanded(
                          child: Text(
                            "${widget.apartment.projectLocation} • ${formatBudget(widget.apartment.minBudget)}",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.king_bed_outlined,
                          size: 14,
                          color: CustomColors.primary,
                        ),
                        const SizedBox(width: 2),
                        Expanded(
                          child: Text(
                            "${widget.apartment.configTitle} ",
                            style: const TextStyle(
                              fontWeight: FontWeight.normal,
                              color: Colors.white,
                              fontSize: 12,
                            ),
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
  }
}
