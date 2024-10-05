import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:re_portal_frontend/modules/home/widgets/lifestyle_projects_card.dart';
import 'package:re_portal_frontend/riverpod/home_data.dart';

class LifestyleProperties extends ConsumerWidget {
  const LifestyleProperties({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lifestyleProperties =
        ref.watch(homePropertiesProvider).lifestyleProjects;
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
              return LifestyleProjectCard(
                  lifestyleProperty: lifestyleProperties[index]);
            },
          ),
        ),
      ],
    );
  }
}
