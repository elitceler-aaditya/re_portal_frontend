import 'package:flutter/material.dart';
import 'package:re_portal_frontend/modules/shared/widgets/colors.dart';

class CustomChip extends StatelessWidget {
  final String text;
  final Function()? onTap;

  const CustomChip({
    super.key,
    required this.text,
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
          // color: isSelected ? CustomColors.primary20 : CustomColors.primary10,
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(100),
          border: Border.all(
            color: Colors.grey,
            width: 1,
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(
            color: CustomColors.primary,
            fontSize: 12,
            fontWeight: FontWeight.w500,
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
      child: Opacity(
        opacity: isSelected ? 1 : 0.5,
        child: Container(
          margin: const EdgeInsets.all(4),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: isSelected ? CustomColors.primary20 : CustomColors.black10,
            borderRadius: BorderRadius.circular(100),
            border: Border.all(
              color: isSelected ? CustomColors.primary : CustomColors.black25,
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: CustomColors.white.withOpacity(0.2),
                blurRadius: 10,
                offset: const Offset(0, 0),
              ),
            ],
          ),
          child: Row(
            children: [
              Text(
                text,
                style: TextStyle(
                  color: isSelected ? CustomColors.primary : CustomColors.black,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 4),
                child: isSelected
                    ? const Icon(
                        Icons.close,
                        size: 12,
                        color: CustomColors.primary,
                      )
                    : const Icon(
                        Icons.add,
                        size: 12,
                        color: CustomColors.black,
                      ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
