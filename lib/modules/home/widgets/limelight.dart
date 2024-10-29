import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:re_portal_frontend/modules/search/widgets/editors_choice_card.dart';
import 'package:re_portal_frontend/riverpod/home_data.dart';

class Limelight extends ConsumerStatefulWidget {
  const Limelight({super.key});

  @override
  ConsumerState<Limelight> createState() => _LimelightState();
}

class _LimelightState extends ConsumerState<Limelight> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(8, 0, 0, 8),
          child: Text(
            "Properties in Limelight",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        EditorsChoiceCard(
          apartments: ref.watch(homePropertiesProvider).limelight,
        ),
      ],
    );
  }
}
