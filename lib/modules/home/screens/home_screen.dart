import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:re_portal_frontend/modules/home/widgets/properties_tiles.dart';
import 'package:re_portal_frontend/modules/shared/models/user.dart';
import 'package:re_portal_frontend/modules/shared/widgets/colors.dart';
import 'package:re_portal_frontend/riverpod/user_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  late SharedPreferences sharedPref;
  String uid = "";
  String name = "";
  String email = "";
  String phoneNumber = "";
  String token = "";
  bool isLoggedIn = false;

  getPref() async {
    sharedPref = await SharedPreferences.getInstance();
    setState(() {
      isLoggedIn = sharedPref.getBool("isLoggedIn") ?? false;
      uid = sharedPref.getString("uid") ?? "";
      name = sharedPref.getString("name") ?? "";
      email = sharedPref.getString("email") ?? "";
      phoneNumber = sharedPref.getString("phoneNumber") ?? "";
      token = sharedPref.getString("token") ?? "";
    });
    ref.read(userProvider.notifier).setUser(
          User(
            uid: uid,
            name: name,
            email: email,
            phoneNumber: phoneNumber,
            token: token,
          ),
        );
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getPref();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
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
                  color: CustomColors.secondary,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            PropertiesTiles(
              title: 'Commercial',
              description: 'Discover top commercial properties nearby',
              image: 'assets/images/tile_bg1.png',
            ),
            PropertiesTiles(
              title: 'Villas',
              description: 'Luxurious villas and upscale properties',
              image: 'assets/images/tile_bg2.png',
            ),
            PropertiesTiles(
              title: 'Apartments',
              description: 'Luxury living in stunning apartments.',
              image: 'assets/images/tile_bg3.png',
            ),
            PropertiesTiles(
              title: 'Plots',
              description: 'Your dream sanctuary on prime plots.',
              image: 'assets/images/tile_bg4.png',
            ),
          ],
        ),
      ),
    );
  }
}
