import 'package:flutter_riverpod/flutter_riverpod.dart';

class OpenFiltersNotifier extends StateNotifier<bool> {
  OpenFiltersNotifier() : super(false);

  void openFilterStatus(bool value) {
    state = value;
  }
}

final openFiltersProvider =
    StateNotifierProvider<OpenFiltersNotifier, bool>((ref) {
  return OpenFiltersNotifier();
});
