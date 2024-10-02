import 'package:flutter_riverpod/flutter_riverpod.dart';

class FetchHomeDataNotifier extends StateNotifier<bool> {
  FetchHomeDataNotifier() : super(false);

  void setStatus(bool status) {
    state = status;
  }
}

final fetchHomeDataProvider =
    StateNotifierProvider<FetchHomeDataNotifier, bool>((ref) {
  return FetchHomeDataNotifier();
});
