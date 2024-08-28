import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:re_portal_frontend/modules/onboarding/screens/get_started.dart';
import 'package:re_portal_frontend/modules/shared/widgets/colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Reportal Tech',
        theme: ThemeData(
          fontFamily: 'Poppins',
          colorScheme: ColorScheme.fromSeed(seedColor: CustomColors.primary),
          useMaterial3: true,
        ),
        home: const GetStarted(),
      ),
    );
  }
}
