import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jwt_io/jwt_io.dart';
import 'package:pinput/pinput.dart';
import 'package:re_portal_frontend/modules/home/screens/property_types.dart';
import 'package:re_portal_frontend/modules/shared/models/user.dart';
import 'package:re_portal_frontend/modules/shared/widgets/colors.dart';
import 'package:http/http.dart' as http;
import 'package:re_portal_frontend/modules/shared/widgets/snackbars.dart';
import 'package:re_portal_frontend/riverpod/user_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OTPScreen extends ConsumerStatefulWidget {
  final String otpSentTo;
  final String orderId;
  final Function()? resend;
  final bool goBack;
  const OTPScreen({
    super.key,
    required this.otpSentTo,
    required this.orderId,
    this.resend,
    this.goBack = false,
  });

  @override
  ConsumerState<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends ConsumerState<OTPScreen> {
  bool _isLoading = false;
  final TextEditingController _otpController = TextEditingController();

  _verifyOTP() async {
    setState(() {
      _isLoading = true;
    });

    String url = "${dotenv.env['BASE_URL']}/user/verify-otp";
    Map<String, String> body = {
      "phoneNumber": "+91${widget.otpSentTo}",
      "otp": _otpController.text,
      "orderId": widget.orderId,
    };
    try {
      await http
          .post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      )
          .then((response) async {
        setState(() {
          _isLoading = false;
        });
        if (response.statusCode == 200 || response.statusCode == 201) {
          Map responseData = jsonDecode(response.body);

          await SharedPreferences.getInstance().then((sharedPref) {
            sharedPref.setString('token', responseData['token']);
            sharedPref.setString('refreshToken', responseData['refreshToken']);
            if (responseData['token'].isNotEmpty) {
              final userData = JwtToken.payload(responseData['token']);
              ref.read(userProvider.notifier).setUser(
                  User.fromJson({...userData, 'token': responseData['token']}));
            }

            if (!widget.goBack) {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (context) => const PropertyTypesScreen()),
                (route) => false,
              );
            } else {
              Navigator.pop(context);
              Navigator.pop(context);
            }
          });
        } else {
          throw Exception('Failed to verify OTP');
        }
      });
    } catch (e) {
      debugPrint(e.toString());
      errorSnackBar(context, e.toString());
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
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
                                        controller: _otpController,
                                        length: 6,
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
                                      if (_isLoading)
                                        const Center(
                                            child: CircularProgressIndicator()),
                                      if (!_isLoading)
                                        ElevatedButton(
                                          onPressed: () {
                                            _verifyOTP();
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                CustomColors.primary,
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
                                            onTap: widget.resend,
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
