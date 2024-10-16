import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:re_portal_frontend/modules/onboarding/screens/otp_screen.dart';
import 'package:re_portal_frontend/modules/onboarding/screens/signup_screen.dart';
import 'package:re_portal_frontend/modules/shared/widgets/colors.dart';
import 'package:re_portal_frontend/modules/shared/widgets/custom_buttons.dart';
import 'package:re_portal_frontend/modules/shared/widgets/snackbars.dart';
import 'package:re_portal_frontend/modules/shared/widgets/textfields.dart';
import 'package:re_portal_frontend/modules/shared/widgets/transitions.dart';
import 'package:http/http.dart' as http;

class LoginScreen extends StatefulWidget {
  final Widget? redirectTo;
  const LoginScreen({super.key, this.redirectTo});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _phoneController = TextEditingController();

  bool _isLoading = false;
  String? phoneError;
  String? passwordError;

  bool _validateFields() {
    if (_phoneController.text.trim().isEmpty) {
      setState(() {
        phoneError = 'Phone number is required';
      });
    }

    return phoneError == null && passwordError == null;
  }

  _sendOTP(bool isResend) async {
    setState(() {
      _isLoading = true;
    });
    String url = "${dotenv.env['BASE_URL']}/user/otpless-signin";
    Map<String, String> body = {
      "phoneNumber": "+91${_phoneController.text.trim()}",
    };

    try {
      await http
          .post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(body),
      )
          .then((response) {
        if (response.statusCode == 200) {
          final responseData = jsonDecode(response.body);

          if (!isResend) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => OTPScreen(
                  redirectTo: widget.redirectTo,
                  otpSentTo: _phoneController.text.trim(),
                  orderId: responseData['data']['orderId'],
                  resend: () => _sendOTP(true),
                ),
              ),
            );
          } else {
            successSnackBar(context, "OTP resent");
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => OTPScreen(
                  redirectTo: widget.redirectTo,
                  otpSentTo: _phoneController.text.trim(),
                  orderId: responseData['data']['orderId'],
                  resend: () => _sendOTP(true),
                ),
              ),
            );
          }
          setState(() {
            _isLoading = false;
          });
        } else {
          setState(() {
            _isLoading = false;
          });
          errorSnackBar(context, jsonDecode(response.body)['message']);
        }
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      debugPrint(e.toString());
    }
  }

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
                        color: CustomColors.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                    ),
                    TextSpan(
                      text: 'Portal',
                      style: TextStyle(
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
                                      CustomTextField(
                                        controller: _phoneController,
                                        hint: 'Phone Number',
                                        keyboardType: TextInputType.phone,
                                        maxLength: 10,
                                        errorText: phoneError,
                                        icon: const Icon(
                                          Icons.phone,
                                          color: CustomColors.white,
                                        ),
                                      ),
                                      const SizedBox(height: 24),
                                      if (_isLoading)
                                        const Center(
                                            child: CircularProgressIndicator()),
                                      if (!_isLoading)
                                        CustomPrimaryButton(
                                          title: 'Send OTP',
                                          onTap: () {
                                            _sendOTP(false);
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
