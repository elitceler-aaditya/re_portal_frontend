import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:re_portal_frontend/modules/shared/models/appartment_model.dart';

class ApartmentListNotifier extends StateNotifier<List<ApartmentModel>> {
  ApartmentListNotifier() : super([]);

  void setApartments(List<ApartmentModel> apartments) {
    state = apartments;
  }

  void addApartment(ApartmentModel apartment) {
    if (state.length < 4) {
      state = [...state, apartment];
    }
  }

  void removeApartment(ApartmentModel apartment) {
    state = state.where((a) => a.apartmentID != apartment.apartmentID).toList();
  }

  void clearApartments() {
    state = [];
  }
}

final comparePropertyProvider =
    StateNotifierProvider<ApartmentListNotifier, List<ApartmentModel>>((ref) {
  return ApartmentListNotifier();
});
