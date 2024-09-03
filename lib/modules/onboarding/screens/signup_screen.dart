import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:re_portal_frontend/modules/home/screens/property_types.dart';
import 'package:re_portal_frontend/modules/onboarding/screens/login_screen.dart';
import 'package:re_portal_frontend/modules/onboarding/screens/otp_screen.dart';
import 'package:re_portal_frontend/modules/shared/widgets/colors.dart';
import 'package:re_portal_frontend/modules/shared/widgets/custom_buttons.dart';
import 'package:re_portal_frontend/modules/shared/widgets/snackbars.dart';
import 'package:re_portal_frontend/modules/shared/widgets/textfields.dart';
import 'package:re_portal_frontend/modules/shared/widgets/transitions.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  bool _showPassword = false;
  bool _isLoading = false;

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String? phoneError;
  String? emailError;
  String? passwordError;

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

  bool _validateFields() {
    if (_phoneController.text.trim().isEmpty ||
        _phoneController.text.trim().length != 10) {
      setState(() {
        phoneError = 'Enter a valid phone number';
      });
    }
    if (_emailController.text.trim().isEmpty ||
        !(_emailController.text.trim().contains("@") &&
            _emailController.text.trim().contains("."))) {
      setState(() {
        emailError = 'Enter a valid email address';
      });
    }
    if (_passwordController.text.trim().isEmpty) {
      setState(() {
        passwordError = 'Password is required';
      });
    }

    return phoneError == null && emailError == null && passwordError == null;
  }

  Future<void> setUser(Map<String, dynamic> responseData) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("isLoggedIn", true);
    prefs.setString("email", responseData['user']['email']);
    prefs.setString("uid", responseData['user']['id']);
    prefs.setString("username", responseData['user']['name']);
    prefs.setString("phoneNumber", responseData['user']['phoneNumber']);
  }

  Future<void> _sendOTP() async {
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

          rightSlideTransition(
              context,
              OTPScreen(
                otpSentTo: _phoneController.text.trim(),
                orderId: responseData['data']['orderId'],
              ));
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

  Future<void> _signupUser() async {
    //signup user
    String url = "${dotenv.get('BASE_URL')}/user/register-user";
    Map<String, String> body = {
      "email": _emailController.text.trim(),
      "password": _passwordController.text,
      "phoneNumber": "+91${_phoneController.text.trim()}",
      "username": _usernameController.text.trim(),
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
          .then((response) async {
        if (response.statusCode == 200 || response.statusCode == 201) {
          final responseData = jsonDecode(response.body);
          debugPrint("--------------$responseData");
          await setUser(responseData).then((value) async {
            await _sendOTP();
          });
        } else {
          debugPrint("--------------${response.body}");
          errorSnackBar(
              context, jsonDecode(response.body)['message'].toString());
        }
      });
    } catch (e) {
      debugPrint("--------------$e");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
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
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (context) => const PropertyTypesScreen()),
                (route) => false,
              );
            },
            child: const Text(
              "Skip",
              style: TextStyle(
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
                  color: CustomColors.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              TextSpan(
                text: 'Portal',
                style: TextStyle(
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
                            CustomTextField(
                              controller: _usernameController,
                              hint: "Username",
                              icon: const Icon(
                                Icons.person,
                                color: CustomColors.white,
                                size: 20,
                              ),
                            ),
                            const SizedBox(height: 10),
                            CustomTextField(
                              controller: _phoneController,
                              hint: "Phone",
                              maxLength: 10,
                              keyboardType: TextInputType.phone,
                              errorText: phoneError,
                              icon: const Icon(
                                Icons.phone,
                                color: CustomColors.white,
                                size: 20,
                              ),
                            ),
                            const SizedBox(height: 10),
                            CustomTextField(
                              controller: _emailController,
                              hint: 'Email',
                              errorText: emailError,
                              icon: const Icon(
                                Icons.email,
                                color: CustomColors.white,
                                size: 20,
                              ),
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                              controller: _passwordController,
                              obscureText: !_showPassword,
                              decoration: InputDecoration(
                                errorText: passwordError,
                                hintText: 'Password',
                                hintStyle: TextStyle(
                                    color: CustomColors.white.withOpacity(0.5)),
                                filled: true,
                                fillColor: CustomColors.white.withOpacity(0.1),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide.none,
                                ),
                                prefixIcon: const Icon(Icons.lock,
                                    color: CustomColors.white),
                                suffixIcon: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _showPassword = !_showPassword;
                                    });
                                  },
                                  child: Icon(
                                    _showPassword
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    color: CustomColors.white,
                                  ),
                                ),
                              ),
                              style: const TextStyle(color: CustomColors.white),
                            ),
                            const SizedBox(height: 20),
                            if (_isLoading)
                              const Center(child: CircularProgressIndicator()),
                            if (!_isLoading)
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 28),
                                child: CustomPrimaryButton(
                                  title: 'Signup',
                                  onTap: () {
                                    if (_validateFields()) {
                                      FocusManager.instance.primaryFocus
                                          ?.unfocus();
                                      setState(() {
                                        _isLoading = true;
                                      });
                                      _signupUser();
                                    }
                                  },
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
                                  padding: EdgeInsets.symmetric(horizontal: 10),
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
                                _buildSocialButton(const Icon(Icons.email), () {
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
        ],
      ),
    );
  }
}
