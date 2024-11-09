import 'package:flutter/material.dart';
import 'package:re_portal_frontend/modules/home/widgets/project_snippet_card.dart';
import 'package:re_portal_frontend/modules/shared/models/appartment_model.dart';

class SponsoredCards extends StatelessWidget {
  final List<ApartmentModel> apartments;
  const SponsoredCards({super.key, required this.apartments});
  String formatBudget(int budget) {
    //return budget in k format or lakh and cr format
    if (budget < 100000) {
      return "${(budget / 1000).toStringAsFixed(00)}K";
    } else if (budget < 10000000) {
      return "${(budget / 100000).toStringAsFixed(1)}L";
    } else {
      return "${(budget / 10000000).toStringAsFixed(2)}Cr";
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      scrollDirection: Axis.horizontal,
      itemCount: apartments.length,
      itemBuilder: (context, index) {
        return ProjectSnippetCard(
          apartment: apartments[index],
          videoLink: "",
          cardWidth: 145,
        );
      },
    );
  }
}
