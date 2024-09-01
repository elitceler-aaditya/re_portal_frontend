import 'package:flutter_riverpod/flutter_riverpod.dart';

class NavBarIndexNotifier extends StateNotifier<int> {
  NavBarIndexNotifier() : super(0);

  void setNavBarIndex(int index) {
    state = index;
  }
}

final navBarIndexProvider =
    StateNotifierProvider<NavBarIndexNotifier, int>((ref) {
  return NavBarIndexNotifier();
});
