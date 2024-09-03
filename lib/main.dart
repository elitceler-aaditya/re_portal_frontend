import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jwt_io/jwt_io.dart';
import 'package:path_provider/path_provider.dart';
import 'package:re_portal_frontend/modules/home/screens/property_types.dart';
import 'package:re_portal_frontend/modules/onboarding/screens/get_started.dart';
import 'package:re_portal_frontend/modules/shared/widgets/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await SharedPreferences.getInstance();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isLoggedIn = false;

  checkIfLoggedIn() async {
    final tempDir = await getTemporaryDirectory();
    final file = File('${tempDir.path}/token.json');
    final token = await file.readAsString();
    setState(() {
      isLoggedIn = !JwtToken.isExpired(token);
    });
  }

  @override
  void initState() {
    super.initState();
    checkIfLoggedIn();
  }

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Reportal Tech',
        theme: ThemeData(
          fontFamily: "eudoxus",
          colorScheme: ColorScheme.fromSeed(
            seedColor: CustomColors.primary,
            background: CustomColors.white,
          ),
          useMaterial3: true,
        ),
        home: isLoggedIn ? const PropertyTypesScreen() : const GetStarted(),
      ),
    );
  }
}
