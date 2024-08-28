import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:pinput/pinput.dart';
import 'package:re_portal_frontend/modules/home/screens/home_screen.dart';
import 'package:re_portal_frontend/modules/onboarding/screens/signup_screen.dart';
import 'package:re_portal_frontend/modules/shared/widgets/colors.dart';
import 'package:re_portal_frontend/modules/shared/widgets/transitions.dart';

class OTPScreen extends StatefulWidget {
  final String otpSentTo;

  const OTPScreen({super.key, required this.otpSentTo});

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: CustomColors.secondary,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              RichText(
                text: const TextSpan(
                  children: [
                    TextSpan(
                      text: 'Re',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        color: CustomColors.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                    ),
                    TextSpan(
                      text: 'Portal',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        color: CustomColors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              const Text(
                'Enter OTP',
                style: TextStyle(
                  color: CustomColors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Please enter the OTP sent to ${widget.otpSentTo}',
                style: const TextStyle(
                  color: CustomColors.white,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 32),
              Expanded(
                child: SizedBox(
                  width: w,
                  child: Stack(
                    children: [
                      Positioned(
                        left: 0,
                        right: 0,
                        child: Image.asset(
                          'assets/images/bg3.png',
                          fit: BoxFit.fitHeight,
                        ),
                      ),
                      Positioned(
                        top: MediaQuery.of(context).viewInsets.bottom > 0
                            ? 50
                            : 200,
                        left: 0,
                        right: 0,
                        child: Animate(
                          effects: const [
                            SlideEffect(
                              duration: Duration(milliseconds: 1000),
                              curve: Curves.easeInOut,
                              begin: Offset(0, 1),
                            ),
                          ],
                          child: Container(
                            width: w,
                            decoration: BoxDecoration(
                              color: CustomColors.black25.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: BackdropFilter(
                                filter:
                                    ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 20,
                                    horizontal: 16,
                                  ),
                                  child: Column(
                                    children: [
                                      Pinput(
                                        length: 4,
                                        keyboardType: TextInputType.number,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        defaultPinTheme: PinTheme(
                                          width: 50,
                                          height: 50,
                                          textStyle: const TextStyle(
                                            fontSize: 24,
                                            color: CustomColors.white,
                                          ),
                                          decoration: BoxDecoration(
                                            color: CustomColors.white
                                                .withOpacity(0.1),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                        ),
                                        focusedPinTheme: PinTheme(
                                          width: 50,
                                          height: 50,
                                          textStyle: const TextStyle(
                                            fontSize: 24,
                                            color: CustomColors.white,
                                          ),
                                          decoration: BoxDecoration(
                                            color: CustomColors.white
                                                .withOpacity(0.2),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                        ),
                                        submittedPinTheme: PinTheme(
                                          width: 50,
                                          height: 50,
                                          textStyle: const TextStyle(
                                            fontSize: 24,
                                            color: CustomColors.white,
                                          ),
                                          decoration: BoxDecoration(
                                            color: CustomColors.white
                                                .withOpacity(0.3),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 24),
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const HomeScreen()));
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: CustomColors.primary,
                                          minimumSize:
                                              const Size(double.infinity, 50),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(108),
                                          ),
                                        ),
                                        child: const Text(
                                          'Verify',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500,
                                            color: CustomColors.white,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 24),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Text(
                                            'Did not recieve OTP? ',
                                            style: TextStyle(
                                              color: CustomColors.white,
                                              fontSize: 14,
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {},
                                            child: const Text(
                                              'Resend',
                                              style: TextStyle(
                                                color: CustomColors.white,
                                                fontSize: 14,
                                                decoration:
                                                    TextDecoration.underline,
                                                decorationColor:
                                                    CustomColors.white,
                                                decorationThickness: 2,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
