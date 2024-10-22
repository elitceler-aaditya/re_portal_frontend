import 'package:flutter/material.dart';

import './colors.dart';

class CustomPrimaryButton extends StatelessWidget {
  final String title;
  final Widget? btnIcon;
  final Color? btnColor;
  final Color? btnTextColor;

  final void Function()? onTap;
  const CustomPrimaryButton({
    super.key,
    required this.title,
    this.btnIcon,
    this.onTap,
    this.btnColor = CustomColors.primary10,
    this.btnTextColor = CustomColors.primary,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: btnColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
          ),
          elevation: 4,
        ),
        onPressed: onTap,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (btnIcon != null) btnIcon!,
            if (btnIcon != null) const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.normal,
                color: btnTextColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
