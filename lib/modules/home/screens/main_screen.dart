import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:re_portal_frontend/modules/home/screens/home_screen.dart';
import 'package:re_portal_frontend/modules/profile/screens/profile_screen.dart';
import 'package:re_portal_frontend/modules/shared/widgets/bot_nav_bar.dart';
import 'package:re_portal_frontend/riverpod/bot_nav_bar.dart';

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  final List<Widget> _screens = const [
    HomeScreen(),
    SizedBox(),
    SizedBox(),
    ProfileScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[ref.watch(navBarIndexProvider)],
      bottomNavigationBar: const CustomBottomNavBar(),
    );
  }
}
