import 'package:flutter/material.dart';
import 'package:re_portal_frontend/modules/home/screens/property_details.dart';
import 'package:re_portal_frontend/modules/shared/models/appartment_model.dart';
import 'package:re_portal_frontend/modules/shared/widgets/colors.dart';

class ProjectSnippetCard extends StatefulWidget {
  final ApartmentModel apartment;
  final String videoLink;
  final bool leftPadding;

  const ProjectSnippetCard({
    super.key,
    required this.apartment,
    required this.videoLink,
    this.leftPadding = true,
  });

  @override
  State<ProjectSnippetCard> createState() => _ProjectSnippetCardState();
}

class _ProjectSnippetCardState extends State<ProjectSnippetCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => PropertyDetails(
              apartment: widget.apartment,
              heroTag: "ProjectSnippet-${widget.apartment.projectId}",
              nextApartment: widget.apartment,
            ),
          ),
        );
      },
      child: Container(
        height: double.infinity,
        width: 180,
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
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                          size: 16,
                          color: CustomColors.primary,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          widget.apartment.projectLocation,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    )
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
