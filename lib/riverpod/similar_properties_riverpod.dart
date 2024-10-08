import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:re_portal_frontend/modules/shared/models/appartment_model.dart';

class SimilarPropertiesNotifier extends StateNotifier<List<ApartmentModel>> {
  SimilarPropertiesNotifier() : super([]);

  void setSimilarProperties(List<ApartmentModel> properties) {
    state = properties;
  }

  void addSimilarProperty(ApartmentModel property) {
    state = [...state, property];
  }

  void removeSimilarProperty(String projectId) {
    state = state.where((property) => property.projectId != projectId).toList();
  }

  void clearSimilarProperties() {
    state = [];
  }
}

final similarPropertiesProvider =
    StateNotifierProvider<SimilarPropertiesNotifier, List<ApartmentModel>>(
  (ref) => SimilarPropertiesNotifier(),
);
