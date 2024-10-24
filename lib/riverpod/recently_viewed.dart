import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:re_portal_frontend/modules/shared/models/appartment_model.dart';

class RecentlyViewedNotifier extends StateNotifier<List<ApartmentModel>> {
  RecentlyViewedNotifier() : super([]);

  void addApartment(ApartmentModel apartment) {
    // Remove the apartment if it already exists to avoid duplicates
    state =
        state.where((item) => item.projectId != apartment.projectId).toList();

    // Add the apartment to the beginning of the list
    state = [apartment, ...state];

    // Keep only the most recent 10 apartments
    if (state.length > 10) {
      state = state.sublist(0, 10);
    }
  }

  void clearRecentlyViewed() {
    state = [];
  }
}

final recentlyViewedProvider =
    StateNotifierProvider<RecentlyViewedNotifier, List<ApartmentModel>>((ref) {
  return RecentlyViewedNotifier();
});
