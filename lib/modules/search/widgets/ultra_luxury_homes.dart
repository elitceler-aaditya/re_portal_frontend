import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:re_portal_frontend/modules/home/widgets/property_stack_card.dart';
import 'package:re_portal_frontend/modules/shared/widgets/colors.dart';
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

    return Container(
      decoration: BoxDecoration(
        color: CustomColors.white,
        borderRadius: BorderRadius.circular(6),
      ),
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(2, 0, 0, 10),
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
            cardWidth: MediaQuery.of(context).size.width * 0.9,
          ),
        ],
      ),
    );
  }
}
