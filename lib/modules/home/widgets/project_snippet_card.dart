import 'package:flutter/material.dart';
import 'package:re_portal_frontend/modules/home/screens/property_details.dart';
import 'package:re_portal_frontend/modules/shared/models/appartment_model.dart';
import 'package:re_portal_frontend/modules/shared/widgets/colors.dart';

class ProjectSnippetCard extends StatefulWidget {
  final ApartmentModel apartment;
  final String videoLink;

  const ProjectSnippetCard({
    super.key,
    required this.apartment,
    required this.videoLink,
  });

  @override
  _ProjectSnippetCardState createState() => _ProjectSnippetCardState();
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
              heroTag: "hero-${widget.apartment.projectId}",
              nextApartment: widget.apartment,
            ),
          ),
        );
      },
      child: Container(
        height: double.infinity,
        width: 180,
        margin: const EdgeInsets.only(right: 8),
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: Hero(
                tag: "hero-${widget.apartment.projectId}",
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
                  const SizedBox(height: 4),
                  Text(
                    widget.apartment.projectLocation,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
