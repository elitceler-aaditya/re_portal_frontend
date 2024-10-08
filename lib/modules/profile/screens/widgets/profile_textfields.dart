import 'package:flutter/material.dart';
import 'package:re_portal_frontend/modules/shared/widgets/colors.dart';

class ProfileTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? hint;
  final TextInputType? keyboardType;
  final int? maxLength;
  final String? errorText;
  final Icon? icon;
  final int? maxLines;

  const ProfileTextField({
    super.key,
    this.controller,
    this.hint,
    this.keyboardType,
    this.maxLength,
    this.errorText,
    this.icon,
    this.maxLines,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      maxLength: maxLength,
      minLines: 1,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hint,
        errorText: errorText,
        prefixIcon: icon,
        filled: true,
        fillColor: CustomColors.primary10,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: CustomColors.black, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: CustomColors.black, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: CustomColors.black, width: 2),
        ),
      ),
    );
  }
}
