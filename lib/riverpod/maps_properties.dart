import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:re_portal_frontend/modules/shared/models/appartment_model.dart';

final mapsApartmentProvider =
    StateNotifierProvider<ApartmentListNotifier, List<ApartmentModel>>((ref) {
  return ApartmentListNotifier();
});

class ApartmentListNotifier extends StateNotifier<List<ApartmentModel>> {
  ApartmentListNotifier() : super([]);

  void setApartments(List<ApartmentModel> apartments) {
    state = apartments;
  }

  void addApartments(List<ApartmentModel> apartments) {
    state = [...state, ...apartments];
  }
  
  ApartmentModel getApartmentById(String id) {
    return state.firstWhere((element) => element.projectId == id);
  }

  void clearApartments() {
    state = [];
  }

}
