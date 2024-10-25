import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:re_portal_frontend/modules/home/widgets/property_stack_card.dart';
import 'package:re_portal_frontend/modules/shared/widgets/colors.dart';
import 'package:re_portal_frontend/riverpod/home_data.dart';

class UltraLuxuryHomes extends ConsumerWidget {
  final bool leftPadding;
  const UltraLuxuryHomes({super.key, this.leftPadding = true});

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
      margin: const EdgeInsets.only(top: 4),
      padding: leftPadding
          ? const EdgeInsets.symmetric(horizontal: 6, vertical: 10)
          : null,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: leftPadding ? 10 : 0, bottom: 8),
            child: const Text(
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
            leftPadding: leftPadding,
          ),
        ],
      ),
    );
  }
}
