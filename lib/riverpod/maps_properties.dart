import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:re_portal_frontend/modules/shared/models/appartment_model.dart';

final mapsApartmentProvider =
    StateNotifierProvider<ApartmentListNotifier, List<ApartmentModel>>((ref) {
  return ApartmentListNotifier();
});

class ApartmentListNotifier extends StateNotifier<List<ApartmentModel>> {
  ApartmentListNotifier() : super([]);

  void setApartments(List<ApartmentModel> apartments) {
    final uniqueApartments = <String, ApartmentModel>{};
    for (var apartment in apartments) {
      uniqueApartments[apartment.projectId] = apartment;
    }
    state = uniqueApartments.values.toList();
  }

  void addApartments(List<ApartmentModel> apartments) {
    state = <ApartmentModel>{...state, ...apartments}.toList();
  }

  ApartmentModel getApartmentById(String id) {
    return state.firstWhere((element) => element.projectId == id);
  }

  void clearApartments() {
    state = [];
  }
}
