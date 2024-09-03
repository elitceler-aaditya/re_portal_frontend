import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:re_portal_frontend/modules/shared/models/appartment_model.dart';

class ApartmentListNotifier extends StateNotifier<List<AppartmentModel>> {
  ApartmentListNotifier() : super([]);

  void setApartments(List<AppartmentModel> apartments) {
    state = apartments;
  }

  void addApartment(AppartmentModel apartment) {
    if (state.length < 4) {
      state = [...state, apartment];
    }
  }

  void removeApartment(AppartmentModel apartment) {
    state = state.where((a) => a.apartmentID != apartment.apartmentID).toList();
  }

  void clearApartments() {
    state = [];
  }
}

final comparePropertyProvider =
    StateNotifierProvider<ApartmentListNotifier, List<AppartmentModel>>((ref) {
  return ApartmentListNotifier();
});
