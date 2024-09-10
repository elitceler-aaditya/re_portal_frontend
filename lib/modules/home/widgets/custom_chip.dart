import 'package:flutter/material.dart';
import 'package:re_portal_frontend/modules/shared/widgets/colors.dart';

class CustomChip extends StatelessWidget {
  final String text;
  final bool isSelected;
  final Function()? onTap;

  const CustomChip({
    super.key,
    required this.text,
    this.isSelected = true,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(4),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? CustomColors.primary20 : CustomColors.white,
          borderRadius: BorderRadius.circular(100),
          border: Border.all(
              color: isSelected ? CustomColors.primary : CustomColors.black),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isSelected ? CustomColors.primary : CustomColors.black,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class CustomListChip extends StatelessWidget {
  final String text;
  final bool isSelected;
  final Function()? onTap;

  const CustomListChip({
    super.key,
    required this.text,
    this.isSelected = true,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(4),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? CustomColors.primary20 : CustomColors.white,
          borderRadius: BorderRadius.circular(100),
          border: Border.all(
              color: isSelected ? CustomColors.primary : CustomColors.black25),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isSelected ? CustomColors.primary : CustomColors.black25,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
