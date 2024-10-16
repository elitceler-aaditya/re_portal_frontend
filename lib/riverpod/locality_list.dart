import 'package:flutter_riverpod/flutter_riverpod.dart';

final localityListProvider =
    StateNotifierProvider<LocalityListNotifier, List<dynamic>>((ref) {
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

  List<dynamic> searchLocality(
      String searchTerm, List<dynamic> selectedLocalities) {
    return state
        .where((locality) =>
            locality.toLowerCase().contains(searchTerm.toLowerCase()))
        .where((locality) => !selectedLocalities.contains(locality))
        .take(20)
        .toList();
  }
}
