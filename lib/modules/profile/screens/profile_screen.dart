import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:re_portal_frontend/modules/home/screens/saved_properties/saved_properties.dart';
import 'package:re_portal_frontend/modules/onboarding/screens/get_started.dart';
import 'package:re_portal_frontend/modules/onboarding/screens/login_screen.dart';
import 'package:re_portal_frontend/modules/profile/screens/my_account.dart';
import 'package:re_portal_frontend/modules/shared/widgets/colors.dart';
import 'package:re_portal_frontend/modules/shared/widgets/transitions.dart';
import 'package:re_portal_frontend/riverpod/bot_nav_bar.dart';
import 'package:re_portal_frontend/riverpod/user_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher_string.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  _listTile({
    String title = "",
    String subtitle = "",
    IconData icon = Icons.bookmark_outline,
    Function()? onTap,
  }) {
    return ListTile(
      onTap: onTap,
      leading: CircleAvatar(
        backgroundColor: CustomColors.white.withOpacity(0.5),
        child: Icon(icon, color: Colors.black),
      ),
      title: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(color: CustomColors.black50, fontSize: 10),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          ref.read(navBarIndexProvider.notifier).setNavBarIndex(0);
        }
      },
      child: Scaffold(
        body: ref.watch(userProvider).name.isNotEmpty
            ? Column(
                children: [
                  SizedBox(
                    height: 160,
                    width: double.infinity,
                    child: Stack(
                      children: [
                        Container(
                          height: 100,
                          color: CustomColors.primary,
                        ),
                        const Positioned(
                          left: 16,
                          top: 50,
                          child: CircleAvatar(
                            radius: 50,
                            child: Center(
                              child: Icon(
                                Icons.person_outline,
                                size: 40,
                                color: CustomColors.black,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          left: 120,
                          top: 64,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                ref.watch(userProvider).name.isEmpty
                                    ? "User"
                                    : "${ref.watch(userProvider).name[0].toUpperCase()}${ref.watch(userProvider).name.substring(1).toLowerCase()}",
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: CustomColors.white,
                                ),
                              ),
                              Text(
                                ref.watch(userProvider).phoneNumber,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: CustomColors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  _listTile(
                    title: 'Saved properties',
                    subtitle: 'Review your previous properties',
                    icon: Icons.bookmark_outline,
                    onTap: () => rightSlideTransition(
                      context,
                      const SavedProperties(),
                    ),
                  ),
                  _listTile(
                      title: 'Contact us',
                      subtitle: 'Get in touch with our company',
                      icon: Icons.phone_outlined,
                      onTap: () {
                        launchUrlString("tel:+91 70752 02565");
                      }),
                  _listTile(
                    title: 'FAQ’s',
                    subtitle: 'Ask any queries related to our company',
                    icon: Icons.question_answer_outlined,
                  ),
                  _listTile(
                      title: 'About Company',
                      subtitle: 'Get to know about our company',
                      icon: Icons.info_outline,
                      onTap: () => launchUrlString("https://elitceler.com/")),
                  _listTile(
                    title: 'Report an issue',
                    subtitle:
                        'Raise an issue encountered by you and get solution',
                    icon: Icons.report_problem_outlined,
                  ),
                  const Divider(
                    height: 20,
                    thickness: 1,
                    color: CustomColors.black25,
                  ),
                  _listTile(
                    title: 'My Account',
                    subtitle: 'My account details',
                    icon: Icons.person_outline,
                    onTap: () async {
                      SharedPreferences.getInstance().then((sharedPref) {
                        sharedPref.clear();
                      });

                      rightSlideTransition(
                        context,
                        MyAccount(
                          name: ref.watch(userProvider).name,
                          phone: ref.watch(userProvider).phoneNumber,
                          email: ref.watch(userProvider).email,
                        ),
                      );
                    },
                  ),
                  _listTile(
                    title: 'Logout',
                    subtitle: 'Logout from the app',
                    icon: Icons.logout,
                    onTap: () async {
                      ref.read(navBarIndexProvider.notifier).setNavBarIndex(0);
                      SharedPreferences.getInstance().then((sharedPref) {
                        sharedPref.clear();
                        ref.read(userProvider.notifier).clearUser();
                        if (mounted) {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const GetStarted()),
                            (route) => false,
                          );
                        }
                      });
                    },
                  ),
                ],
              )
            : Center(
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: CustomColors.primary,
                  ),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => const LoginScreen()),
                    );
                  },
                  icon: const Icon(
                    Icons.login,
                    color: CustomColors.white,
                  ),
                  label: const Text(
                    'Login to continue',
                    style: TextStyle(
                      color: CustomColors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
