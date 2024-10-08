import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:re_portal_frontend/modules/home/widgets/property_stack_card.dart';
import 'package:re_portal_frontend/riverpod/home_data.dart';

class UltraLuxuryHomes extends ConsumerWidget {
  const UltraLuxuryHomes({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ultraLuxuryHomes =
        ref.watch(homePropertiesProvider.notifier).getUltraLuxuryHomes();

    if (ultraLuxuryHomes.isEmpty) {
      return SizedBox(
        child: Text("No ultra luxury homes found: ${ultraLuxuryHomes.length}"),
      );
    }

    return SizedBox(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 10, 16, 0),
            child: Text(
              "Ultra Luxury Homes",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          PropertyStackCard(
            apartments: ultraLuxuryHomes,
          ),
        ],
      ),
    );
  }
}
