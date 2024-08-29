import './colors.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? hint;
  final Widget? icon;
  final int? maxLines;
  final String? errorText;
  final bool isEnabled;
  final TextInputType keyboardType;
  final bool? obscureText;
  final Widget? suffixIcon;
  final int? maxLength;
  const CustomTextField({
    super.key,
    this.controller,
    this.hint,
    this.icon,
    this.maxLines,
    this.errorText,
    this.keyboardType = TextInputType.text,
    this.isEnabled = true,
    this.maxLength,
    this.obscureText,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      maxLength: maxLength,
      // obscureText: obscureText ?? false,
      decoration: InputDecoration(
        counterText: '',
        errorText: errorText,
        hintText: hint,
        hintStyle: TextStyle(color: CustomColors.white.withOpacity(0.5)),
        filled: true,
        fillColor: CustomColors.white.withOpacity(0.1),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: CustomColors.red),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        prefixIcon: icon,
        suffixIcon: suffixIcon,
      ),
      style: const TextStyle(color: CustomColors.white),
      enabled: isEnabled,
      keyboardType: keyboardType,
      maxLines: maxLines,
    );
  }
}
