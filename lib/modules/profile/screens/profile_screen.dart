import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:re_portal_frontend/modules/onboarding/screens/get_started.dart';
import 'package:re_portal_frontend/modules/profile/screens/my_account.dart';
import 'package:re_portal_frontend/modules/shared/widgets/colors.dart';
import 'package:re_portal_frontend/modules/shared/widgets/transitions.dart';
import 'package:re_portal_frontend/riverpod/bot_nav_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  String name = "";
  String email = "";
  String phoneNumber = "";

  _listTile({
    String title = "",
    String subtitle = "",
    IconData icon = Icons.bookmark_outline,
    Function()? onTap,
  }) {
    return ListTile(
      onTap: onTap,
      leading: CircleAvatar(
        backgroundColor: CustomColors.black.withOpacity(0.1),
        child: Icon(icon, color: Colors.black),
      ),
      title: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(color: CustomColors.black50, fontSize: 12),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
    );
  }

  getPref() async {
    final sharedPref = await SharedPreferences.getInstance();
    setState(() {
      name = sharedPref.getString("name") ?? "";
      email = sharedPref.getString("email") ?? "";
      phoneNumber = sharedPref.getString("phoneNumber") ?? "";
    });
  }

  Future<void> clearPref() async {
    final sharedPref = await SharedPreferences.getInstance();
    sharedPref.clear();
  }

  @override
  void initState() {
    getPref();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
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
                  ),
                ),
                Positioned(
                  left: 120,
                  top: 70,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: CustomColors.white,
                        ),
                      ),
                      Text(
                        phoneNumber,
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
          ),
          _listTile(
            title: 'Contact us',
            subtitle: 'Get in touch with our company',
            icon: Icons.phone_outlined,
          ),
          _listTile(
            title: 'FAQ’s',
            subtitle: 'Ask any queries related to our company',
            icon: Icons.question_answer_outlined,
          ),
          _listTile(
            title: 'About Company',
            subtitle: 'Get to know about our company',
            icon: Icons.info_outline,
          ),
          _listTile(
            title: 'Report an issue',
            subtitle: 'Raise an issue encountered by you and get solution',
            icon: Icons.report_problem_outlined,
          ),
          const Divider(
            height: 20,
            thickness: 1,
            color: CustomColors.black25,
          ),
          _listTile(
            title: 'My Account',
            subtitle: 'Logout from the app',
            icon: Icons.person_outline,
            onTap: () {
              rightSlideTransition(
                context,
                MyAccount(
                  name: name,
                  phone: phoneNumber,
                  email: email,
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
              await clearPref().then(
                (value) => Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const GetStarted()),
                  (route) => false,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}