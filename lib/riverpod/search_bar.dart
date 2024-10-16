import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchBarNotifier extends StateNotifier<String> {
  SearchBarNotifier() : super('');

  void setSearchTerm(String term) {
    state = term;
  }

  void clearSearchTerm() {
    state = '';
  }
}

final searchBarProvider =
    StateNotifierProvider<SearchBarNotifier, String>((ref) {
  return SearchBarNotifier();
});
