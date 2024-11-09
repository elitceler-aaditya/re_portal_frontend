import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jwt_io/jwt_io.dart';
import 'package:re_portal_frontend/modules/home/screens/compare/compare_properties.dart';
import 'package:re_portal_frontend/modules/home/screens/home_Maps_screen.dart';
import 'package:re_portal_frontend/modules/home/screens/home_screen.dart';
import 'package:re_portal_frontend/modules/home/screens/saved_properties/saved_properties.dart';
import 'package:re_portal_frontend/modules/search/screens/search_apartments_results.dart';
import 'package:re_portal_frontend/modules/shared/models/user.dart';
import 'package:re_portal_frontend/modules/shared/widgets/bot_nav_bar.dart';
import 'package:re_portal_frontend/riverpod/bot_nav_bar.dart';
import 'package:re_portal_frontend/riverpod/user_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  final List<Widget> _screens = const [
    HomeScreen(),
    SearchApartmentResults(),
    HomeMapsScreen(),
    CompareProperties(),
    SavedProperties(),
  ];

  void setUserData() async {
    final sharedPref = await SharedPreferences.getInstance();
    final token = sharedPref.getString('token');
    if (token != null && token.isNotEmpty) {
      final userData = JwtToken.payload(token);
      ref
          .read(userProvider.notifier)
          .setUser(User.fromJson({...userData, 'token': token}));
    }
  }

  @override
  void initState() {
    super.initState();
    setUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[ref.watch(navBarIndexProvider)],
      bottomNavigationBar: const CustomBottomNavBar(),
    );
  }
}
