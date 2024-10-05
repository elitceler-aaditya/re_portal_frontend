import 'package:flutter_riverpod/flutter_riverpod.dart';

final localityListProvider = StateNotifierProvider<LocalityListNotifier, List<dynamic>>((ref) {
  return LocalityListNotifier();
});

class LocalityListNotifier extends StateNotifier<List<dynamic>> {
  LocalityListNotifier() : super([]);

  void setLocalities(List<dynamic> localities) {
    state = localities;
  }

  void addLocality(dynamic locality) {
    state = [...state, locality];
  }

  void removeLocality(dynamic locality) {
    state = state.where((item) => item != locality).toList();
  }

  void clearLocalities() {
    state = [];
  }
}


