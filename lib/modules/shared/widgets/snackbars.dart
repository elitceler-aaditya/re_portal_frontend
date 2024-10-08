import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import './colors.dart';

successSnackBar(BuildContext context, String? message,
    {SnackBarAction? action}) {
  ScaffoldMessenger.of(context).clearSnackBars();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message ?? ""),
      backgroundColor: Colors.green,
      duration: const Duration(seconds: 2),
      action: action,
    ),
  );
}

errorSnackBar(BuildContext context, String? message, {SnackBarAction? action}) {
  ScaffoldMessenger.of(context).clearSnackBars();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message ?? ''),
      backgroundColor: CustomColors.red,
      action: action,
    ),
  );
}

markAsCompleteSnackBar(BuildContext context, String? message,
    {SnackBarAction? action}) {
  ScaffoldMessenger.of(context).clearSnackBars();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      duration: const Duration(milliseconds: 2000),
      content: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(vertical: 14),
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color(0xff7FFF84),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.only(right: 10),
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: CustomColors.green,
                borderRadius: BorderRadius.circular(50),
              ),
              child: SvgPicture.asset(
                "assets/check_circle.svg",
                color: CustomColors.green,
              ),
            ),
            Text(
              message!,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20,
                color: Colors.black,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.transparent,
    ),
  );
}
