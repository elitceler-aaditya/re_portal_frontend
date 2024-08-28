import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:re_portal_frontend/modules/onboarding/screens/login_screen.dart';
import 'package:re_portal_frontend/modules/shared/widgets/colors.dart';
import 'package:re_portal_frontend/modules/shared/widgets/custom_buttons.dart';
import 'package:re_portal_frontend/modules/shared/widgets/transitions.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  bool _showPassword = false;

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
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: CustomColors.secondary,
      appBar: AppBar(
        backgroundColor: CustomColors.secondary,
        titleSpacing: 16,
        centerTitle: false,
        automaticallyImplyLeading: false,
        actions: [
          TextButton(
            onPressed: () {
              upSlideTransition(context, const LoginScreen());
            },
            child: const Text(
              "Skip",
              style: TextStyle(
                fontFamily: 'Poppins',
                color: CustomColors.white,
              ),
            ),
          ),
        ],
        title: RichText(
          textAlign: TextAlign.start,
          text: const TextSpan(
            children: [
              TextSpan(
                text: 'Re',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  color: CustomColors.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              TextSpan(
                text: 'Portal',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  color: CustomColors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: h,
              width: w,
              color: CustomColors.secondary,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Image.asset("assets/images/bg1.png"),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            top: 0,
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
                color: Colors.transparent,
                child: Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                      child: Container(
                        width: w * 0.9,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: CustomColors.secondary.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: CustomColors.white.withOpacity(0.2),
                            width: 1,
                          ),
                        ),
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Register',
                                style: TextStyle(
                                  color: CustomColors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 10),
                              const Text(
                                'Agree and click on lets start to create your account to explore various options',
                                style: TextStyle(
                                  color: CustomColors.white,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 20),
                              TextFormField(
                                decoration: InputDecoration(
                                  hintText: 'Username',
                                  hintStyle: TextStyle(
                                      color:
                                          CustomColors.white.withOpacity(0.5)),
                                  filled: true,
                                  fillColor:
                                      CustomColors.white.withOpacity(0.1),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide.none,
                                  ),
                                  prefixIcon: const Icon(Icons.person,
                                      color: CustomColors.white),
                                ),
                                style:
                                    const TextStyle(color: CustomColors.white),
                              ),
                              const SizedBox(height: 10),
                              TextFormField(
                                keyboardType: TextInputType.phone,
                                decoration: InputDecoration(
                                  hintText: 'Phone',
                                  hintStyle: TextStyle(
                                      color:
                                          CustomColors.white.withOpacity(0.5)),
                                  filled: true,
                                  fillColor:
                                      CustomColors.white.withOpacity(0.1),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide.none,
                                  ),
                                  prefixIcon: const Icon(Icons.phone,
                                      color: CustomColors.white),
                                ),
                                style:
                                    const TextStyle(color: CustomColors.white),
                              ),
                              const SizedBox(height: 10),
                              TextFormField(
                                decoration: InputDecoration(
                                  hintText: 'Email',
                                  hintStyle: TextStyle(
                                      color:
                                          CustomColors.white.withOpacity(0.5)),
                                  filled: true,
                                  fillColor:
                                      CustomColors.white.withOpacity(0.1),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide.none,
                                  ),
                                  prefixIcon: const Icon(Icons.email,
                                      color: CustomColors.white),
                                ),
                                style:
                                    const TextStyle(color: CustomColors.white),
                              ),
                              const SizedBox(height: 10),
                              TextFormField(
                                obscureText: !_showPassword,
                                decoration: InputDecoration(
                                  hintText: 'Password',
                                  hintStyle: TextStyle(
                                      color:
                                          CustomColors.white.withOpacity(0.5)),
                                  filled: true,
                                  fillColor:
                                      CustomColors.white.withOpacity(0.1),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide.none,
                                  ),
                                  prefixIcon: const Icon(Icons.lock,
                                      color: CustomColors.white),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _showPassword
                                          ? Icons.visibility_off_outlined
                                          : Icons.visibility_outlined,
                                      color: CustomColors.white,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _showPassword = !_showPassword;
                                      });
                                    },
                                  ),
                                ),
                                style:
                                    const TextStyle(color: CustomColors.white),
                              ),
                              const SizedBox(height: 20),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 28),
                                child: CustomPrimaryButton(
                                  title: 'Signup',
                                  onTap: () {},
                                ),
                              ),
                              const SizedBox(height: 20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 80,
                                    height: 1,
                                    color: CustomColors.white.withOpacity(0.5),
                                  ),
                                  const Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 10),
                                    child: Text(
                                      'Or',
                                      style: TextStyle(
                                        color: CustomColors.white,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: 80,
                                    height: 1,
                                    color: CustomColors.white.withOpacity(0.5),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  _buildSocialButton(Icon(Icons.email), () {
                                    // Handle email signup
                                  }),
                                  const SizedBox(width: 20),
                                  _buildSocialButton(
                                      SizedBox(
                                        width: 25,
                                        height: 25,
                                        child: SvgPicture.asset(
                                          "assets/icons/google.svg",
                                          height: 25,
                                          width: 25,
                                          fit: BoxFit.scaleDown,
                                        ),
                                      ), () {
                                    // Handle Google signup
                                  }),
                                  const SizedBox(width: 20),
                                  _buildSocialButton(
                                      SizedBox(
                                        width: 25,
                                        height: 25,
                                        child: SvgPicture.asset(
                                          "assets/icons/x.svg",
                                          fit: BoxFit.scaleDown,
                                        ),
                                      ), () {
                                    // Handle X (Twitter) signup
                                  }),
                                ],
                              ),
                              const SizedBox(height: 20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    'Already have an account? ',
                                    style: TextStyle(
                                      color: CustomColors.white,
                                      fontSize: 14,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      rightSlideTransition(
                                          context, const LoginScreen());
                                    },
                                    child: const Text(
                                      'Login',
                                      style: TextStyle(
                                        color: CustomColors.white,
                                        fontSize: 14,
                                        decoration: TextDecoration.underline,
                                        decorationColor: CustomColors.white,
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
            ),
          ),
        ],
      ),
    );
  }
}
