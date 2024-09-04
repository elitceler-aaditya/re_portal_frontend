import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:re_portal_frontend/modules/shared/models/appartment_model.dart';

class SavedPropertiesNotifier extends StateNotifier<List<AppartmentModel>> {
  SavedPropertiesNotifier() : super([]);

  void addApartment(AppartmentModel apartment) {
    state = [...state, apartment];
  }

  void removeApartment(AppartmentModel apartment) {
    state = state
        .where((item) => item.apartmentID != apartment.apartmentID)
        .toList();
  }

  void clearApartments() {
    state = [];
  }
}

final savedPropertiesProvider =
    StateNotifierProvider<SavedPropertiesNotifier, List<AppartmentModel>>(
        (ref) {
  return SavedPropertiesNotifier();
});
