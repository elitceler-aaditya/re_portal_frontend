import 'package:flutter/material.dart';
import 'package:re_portal_frontend/modules/shared/widgets/colors.dart';

class AdsSection extends StatefulWidget {
  const AdsSection({super.key});

  @override
  State<AdsSection> createState() => _AdsSectionState();
}

class _AdsSectionState extends State<AdsSection> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: 250,
      color: CustomColors.red,
    );
  }
}
