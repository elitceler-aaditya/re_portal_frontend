import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:re_portal_frontend/modules/home/screens/main_screen.dart';
import 'package:re_portal_frontend/modules/home/widgets/properties_tiles.dart';
import 'package:re_portal_frontend/modules/onboarding/screens/login_screen.dart';
import 'package:re_portal_frontend/modules/shared/models/property_type.dart';
import 'package:re_portal_frontend/modules/shared/models/user.dart';
import 'package:re_portal_frontend/modules/shared/widgets/colors.dart';
import 'package:re_portal_frontend/modules/shared/widgets/transitions.dart';
import 'package:re_portal_frontend/riverpod/home_data.dart';
import 'package:re_portal_frontend/riverpod/user_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_io/jwt_io.dart';

class PropertyTypesScreen extends ConsumerStatefulWidget {
  const PropertyTypesScreen({super.key});

  @override
  ConsumerState<PropertyTypesScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<PropertyTypesScreen> {
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
      name = sharedPref.getString("name") ?? "";
      email = sharedPref.getString("email") ?? "";
      phoneNumber = sharedPref.getString("phoneNumber") ?? "";
    });
  }

  getTempStorage() async {
    final tempDir = await getTemporaryDirectory();
    final file = File('${tempDir.path}/token.json');
    token = await file.readAsString();
    bool hasExpired = JwtToken.isExpired(token);

    if (hasExpired) {
      debugPrint("Token has expired");
      debugPrint("-------------data: ${JwtToken.payload(token)}");
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const LoginScreen()));
    } else {
      debugPrint("Token is valid");
      Map data = JwtToken.payload(token);
      debugPrint("-------------$data");
      uid = data['userId'];
      getPref();
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
  }

  setTempStorage() async {
    final tempDir = await getTemporaryDirectory();
    debugPrint("Temporary Directory: ${tempDir.path}");

    //save token in json
    final file = File('${tempDir.path}/token.json');
    file.writeAsString(token);
    debugPrint("Token saved to ${file.path}");
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // getPref();
      // setTempStorage();
      getTempStorage();
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
                  color: CustomColors.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              TextSpan(
                text: 'Portal',
                style: TextStyle(
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
              onTap: () {
                ref
                    .read(homeDataProvider.notifier)
                    .setPropertyType(PropertyTypes.commercial);
                rightSlideTransition(
                  context,
                  const MainScreen(),
                );
              },
            ),
            PropertiesTiles(
              title: 'Villas',
              description: 'Luxurious villas and upscale properties',
              image: 'assets/images/tile_bg2.png',
              onTap: () {
                ref
                    .read(homeDataProvider.notifier)
                    .setPropertyType(PropertyTypes.villas);
                rightSlideTransition(
                  context,
                  const MainScreen(),
                );
              },
            ),
            PropertiesTiles(
              title: 'Apartments',
              description: 'Luxury living in stunning apartments.',
              image: 'assets/images/tile_bg3.png',
              onTap: () {
                ref
                    .read(homeDataProvider.notifier)
                    .setPropertyType(PropertyTypes.appartments);
                rightSlideTransition(
                  context,
                  const MainScreen(),
                );
              },
            ),
            PropertiesTiles(
              title: 'Plots',
              description: 'Your dream sanctuary on prime plots.',
              image: 'assets/images/tile_bg4.png',
              onTap: () {
                ref
                    .read(homeDataProvider.notifier)
                    .setPropertyType(PropertyTypes.plots);
                rightSlideTransition(
                  context,
                  const MainScreen(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
