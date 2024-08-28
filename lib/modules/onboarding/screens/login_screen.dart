import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:re_portal_frontend/modules/onboarding/screens/otp_screen.dart';
import 'package:re_portal_frontend/modules/onboarding/screens/signup_screen.dart';
import 'package:re_portal_frontend/modules/shared/widgets/colors.dart';
import 'package:re_portal_frontend/modules/shared/widgets/custom_buttons.dart';
import 'package:re_portal_frontend/modules/shared/widgets/transitions.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  Widget _buildSocialButton(Widget icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: CustomColors.white,
          borderRadius: BorderRadius.circular(100),
        ),
        child: icon,
      ),
    );
  }

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
                'Welcome',
                style: TextStyle(
                  color: CustomColors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Enter your registered mobile number to explore',
                style: TextStyle(
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
                          'assets/images/bg2.png',
                          fit: BoxFit.fitHeight,
                        ),
                      ),
                      Positioned(
                        top: MediaQuery.of(context).viewInsets.bottom > 0
                            ? 50
                            : 150,
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
                                      Container(
                                        decoration: BoxDecoration(
                                          color: CustomColors.white
                                              .withOpacity(0.1),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: TextField(
                                          keyboardType: TextInputType.phone,
                                          style: const TextStyle(
                                              color: CustomColors.white),
                                          decoration: InputDecoration(
                                            hintText: 'Phone Number',
                                            hintStyle: TextStyle(
                                              color: CustomColors.white
                                                  .withOpacity(0.5),
                                            ),
                                            prefixIcon: const Icon(Icons.phone,
                                                color: CustomColors.white),
                                            border: InputBorder.none,
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                              horizontal: 16,
                                              vertical: 12,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 24),
                                      CustomPrimaryButton(
                                        title: 'Send OTP',
                                        onTap: () {
                                          upSlideTransition(
                                              context,
                                              const OTPScreen(
                                                  otpSentTo: '1234567890'));
                                        },
                                      ),
                                      const SizedBox(height: 24),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Divider(
                                              color: CustomColors.white
                                                  .withOpacity(0.5),
                                            ),
                                          ),
                                          const Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 16),
                                            child: Text(
                                              'or',
                                              style: TextStyle(
                                                color: CustomColors.white,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Divider(
                                              color: CustomColors.white
                                                  .withOpacity(0.5),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 24),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          _buildSocialButton(
                                              const Icon(Icons.email), () {}),
                                          _buildSocialButton(
                                            SizedBox(
                                              width: 25,
                                              height: 25,
                                              child: SvgPicture.asset(
                                                "assets/icons/google.svg",
                                                fit: BoxFit.scaleDown,
                                              ),
                                            ),
                                            () {},
                                          ),
                                          _buildSocialButton(
                                            SvgPicture.asset(
                                              "assets/icons/x.svg",
                                              fit: BoxFit.scaleDown,
                                            ),
                                            () {},
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 24),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Text(
                                            'Don\'t have an account? ',
                                            style: TextStyle(
                                              color: CustomColors.white,
                                              fontSize: 14,
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              rightSlideTransition(context,
                                                  const SignupScreen());
                                            },
                                            child: const Text(
                                              'Signup',
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
