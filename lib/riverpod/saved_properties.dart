import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:re_portal_frontend/modules/shared/models/appartment_model.dart';

class SavedPropertiesNotifier extends StateNotifier<List<ApartmentModel>> {
  SavedPropertiesNotifier() : super([]);

  void addApartment(ApartmentModel apartment) {
    state = [...state, apartment];
  }

  void removeApartment(ApartmentModel apartment) {
    state = state
        .where((item) => item.apartmentID != apartment.apartmentID)
        .toList();
  }

  void clearApartments() {
    state = [];
  }
}

final savedPropertiesProvider =
    StateNotifierProvider<SavedPropertiesNotifier, List<ApartmentModel>>((ref) {
  return SavedPropertiesNotifier();
});