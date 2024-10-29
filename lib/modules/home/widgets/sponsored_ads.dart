import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:re_portal_frontend/modules/search/widgets/editors_choice_card.dart';
import 'package:re_portal_frontend/modules/shared/widgets/colors.dart';
import 'package:re_portal_frontend/riverpod/home_data.dart';

class SponsoredAds extends ConsumerStatefulWidget {
  const SponsoredAds({super.key});

  @override
  ConsumerState<SponsoredAds> createState() => _SponsoredAdsState();
}

class _SponsoredAdsState extends ConsumerState<SponsoredAds> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: CustomColors.white,
        borderRadius: BorderRadius.circular(6),
      ),
      margin: const EdgeInsets.only(top: 4),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(8, 0, 0, 8),
            child: Text(
              "Sponsored Ads",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          EditorsChoiceCard(
            apartments: ref.watch(homePropertiesProvider).sponsoredAd,
          ),
        ],
      ),
    );
  }
}
