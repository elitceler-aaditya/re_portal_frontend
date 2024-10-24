import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:re_portal_frontend/modules/shared/screens/splash_screen.dart';
import 'package:re_portal_frontend/modules/shared/widgets/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await SharedPreferences.getInstance();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Reportal Tech',
        theme: ThemeData(
          fontFamily: "PlusJakartaSans",
          colorScheme: ColorScheme.fromSeed(
            seedColor: CustomColors.primary,
          ),
          scaffoldBackgroundColor: CustomColors.white,
          useMaterial3: true,
        ),
        home: const SplashScreen(),
      ),
    );
  }
}
