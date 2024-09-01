import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:re_portal_frontend/modules/onboarding/screens/signup_screen.dart';
import 'package:re_portal_frontend/modules/shared/widgets/colors.dart';
import 'package:re_portal_frontend/modules/shared/widgets/custom_buttons.dart';
import 'package:re_portal_frontend/modules/shared/widgets/transitions.dart';

class GetStarted extends StatefulWidget {
  const GetStarted({super.key});

  @override
  State<GetStarted> createState() => _GetStartedState();
}

class _GetStartedState extends State<GetStarted> {
  imageTile(String image) {
    return Padding(
      padding: const EdgeInsets.all(2),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.asset(
          image,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 0,
            // left: 0,
            // right: 0,
            child: Container(
              height: h * 0.65,
              color: CustomColors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        imageTile('assets/images/1.png'),
                        imageTile('assets/images/4.png'),
                        imageTile('assets/images/5.png'),
                        imageTile('assets/images/1.png'),
                        imageTile('assets/images/4.png'),
                        imageTile('assets/images/5.png'),
                      ],
                    )
                        .animate(
                          onComplete: (controller) => controller.repeat(),
                        )
                        .slide(duration: const Duration(milliseconds: 12000)),
                  ),
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        imageTile('assets/images/3.png'),
                        imageTile('assets/images/6.png'),
                        imageTile('assets/images/7.png'),
                        imageTile('assets/images/3.png'),
                        imageTile('assets/images/6.png'),
                        imageTile('assets/images/7.png'),
                      ],
                    )
                        .animate(
                          onComplete: (controller) => controller.repeat(),
                        )
                        .slide(duration: const Duration(milliseconds: 8000)),
                  ),
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        imageTile('assets/images/2.png'),
                        imageTile('assets/images/8.png'),
                        imageTile('assets/images/9.png'),
                        imageTile('assets/images/2.png'),
                        imageTile('assets/images/8.png'),
                        imageTile('assets/images/9.png'),
                      ],
                    )
                        .animate(
                          onComplete: (controller) => controller.repeat(),
                        )
                        .slide(duration: const Duration(milliseconds: 11000)),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: h * 0.35,
            left: 0,
            right: 0,
            child: Container(
              width: double.infinity,
              height: h * 0.3,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    CustomColors.white.withOpacity(0),
                    CustomColors.white,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),
          Animate(
            effects: const [
              SlideEffect(
                begin: Offset(0, 1),
                end: Offset.zero,
                duration: Duration(milliseconds: 800),
                curve: Curves.easeOut,
              ),
            ],
            child: Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: h * 0.35,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: const BoxDecoration(
                  color: CustomColors.white,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Column(
                      children: [
                        Text(
                          'Discover your Dream property',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            color: CustomColors.primary,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Agree and click on Let’s start to create your account to explore various options',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                            color: CustomColors.black75,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 250,
                      child: CustomPrimaryButton(
                        title: 'Get Started',
                        onTap: () {
                          upSlideTransition(context, const SignupScreen());
                        },
                      ),
                    ),
                    RichText(
                      textAlign: TextAlign.center,
                      text: const TextSpan(
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w300,
                          color: CustomColors.black50,
                        ),
                        children: [
                          TextSpan(
                            text: 'Your safety matters to us. ',
                          ),
                          TextSpan(
                            text: 'Terms and conditions applied',
                            style: TextStyle(
                              decoration: TextDecoration.underline,
                              color: CustomColors.black75,
                            ),
                          ),
                          TextSpan(
                            text:
                                '\nThat\'s why we require you to add authentic details.',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
