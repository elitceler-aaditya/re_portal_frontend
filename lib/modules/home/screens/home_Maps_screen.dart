import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:re_portal_frontend/modules/maps/google_maps_screen.dart';

class HomeMapsScreen extends ConsumerStatefulWidget {
  const HomeMapsScreen({super.key});

  @override
  ConsumerState<HomeMapsScreen> createState() => _HomeMapsScreenState();
}

class _HomeMapsScreenState extends ConsumerState<HomeMapsScreen> {
  @override
  Widget build(BuildContext context) {
    return const GoogleMapsScreen(
      isPop: true,
    );
  }
}
