import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:re_portal_frontend/modules/shared/models/appartment_model.dart';

final apartmentListProvider =
    StateNotifierProvider<ApartmentListNotifier, List<ApartmentModel>>((ref) {
  return ApartmentListNotifier();
});

class ApartmentListNotifier extends StateNotifier<List<ApartmentModel>> {
  ApartmentListNotifier() : super([]);

  //set apartment list
  void setApartmentList(List<ApartmentModel> apartmentList) {
    state = apartmentList;
  }

  //add apartment
  void addApartment(ApartmentModel apartment) {
    state = [...state, apartment];
  }

  //remove apartment
  void removeApartment(ApartmentModel apartment) {
    state = state
        .where((element) => element.projectId != apartment.projectId)
        .toList();
  }

  //update apartment
  void updateApartment(ApartmentModel apartment) {
    state = state
        .map((e) => e.projectId == apartment.projectId ? apartment : e)
        .toList();
  }

  //clear apartment list
  void clearApartmentList() {
    state = [];
  }
}
