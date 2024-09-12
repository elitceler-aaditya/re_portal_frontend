import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:re_portal_frontend/modules/home/screens/property_types.dart';
import 'package:re_portal_frontend/modules/onboarding/screens/get_started.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool isExpired = true;

  Future<void> checkIfLoggedIn() async {
    String token = "";
    String refreshToken = "";

    try {
      SharedPreferences.getInstance().then((sharedPref) {
        token = sharedPref.getString('token') ?? "";
        refreshToken = sharedPref.getString('refreshToken') ?? "";

        if (token.isEmpty) {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const GetStarted()));
        } else {
          
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => const PropertyTypesScreen()));
        }
      });
    } catch (e) {
      // Handle any errors (e.g., file read errors)
      print('Error checking login status: $e');
      isExpired = true;
      if (mounted) {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const GetStarted()));
      }
    }
  }

  Future<void> refreshToken(
      String refreshToken, Map<String, dynamic> fileData) async {
    if (refreshToken.isEmpty) {
      debugPrint('-----------------Refresh token not found');
      return;
    }

    String url = "${dotenv.env['BASE_URL']}/user/refresh-token";
    Map<String, String> body = {"refreshToken": refreshToken};

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        debugPrint('----------------new refresh token: $responseData');

        final newToken = responseData['token'];
        fileData["token"] = newToken;
        // Update token file
        final tempDir = await getTemporaryDirectory();
        final file = File('${tempDir.path}/token.json');
        await file.writeAsString(jsonEncode(fileData));
      } else {
        debugPrint('----------------Failed to refresh token: ${response.body}');
      }
    } catch (e) {
      debugPrint('----------------Error refreshing token: $e');
    }
  }

  @override
  void initState() {
    checkIfLoggedIn();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: SizedBox(
          height: 100,
          width: 100,
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
