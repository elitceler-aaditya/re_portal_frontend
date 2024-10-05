import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:re_portal_frontend/modules/shared/models/appartment_model.dart';

class HomeDataNotifier extends StateNotifier<HomeData> {
  HomeDataNotifier() : super(HomeData());

  void setAllApartments(List<ApartmentModel> allApartments) {
    state = state.copyWith(allApartments: allApartments);
  }

  void setfilteredApartments(List<ApartmentModel> filteredApartments) {
    state = state.copyWith(filteredApartments: filteredApartments);
  }

  void addFilteredApartments(List<ApartmentModel> filteredApartments) {
    state = state.copyWith(filteredApartments: [
      ...state.filteredApartments,
      ...filteredApartments
    ]);
  }

  void sortFilteredApartments(int sortBy) {
    if (sortBy == 0) {
      state = state.copyWith(
          filteredApartments: state.filteredApartments
            ..sort((a, b) => a.budget.compareTo(b.budget)));
    } else if (sortBy == 1) {
      state = state.copyWith(
          filteredApartments: state.filteredApartments
            ..sort((a, b) => b.budget.compareTo(a.budget)));
    } else {
      state = state.copyWith(filteredApartments: state.allApartments);
    }
  }

  void setBestDeals(List<ApartmentModel> bestDeals) {
    state = state.copyWith(bestDeals: bestDeals);
  }

  void setSelectedProperties(List<ApartmentModel> selectedProperties) {
    state = state.copyWith(selectedProperties: selectedProperties);
  }

  void setEditorsChoice(List<ApartmentModel> editorsChoice) {
    state = state.copyWith(editorsChoice: editorsChoice);
  }

  void setBuilderInFocus(List<ApartmentModel> builderInFocus) {
    state = state.copyWith(builderInFocus: builderInFocus);
  }

  void setNewProjects(List<ApartmentModel> newProjects) {
    state = state.copyWith(newProjects: newProjects);
  }

  void setReadyToMoveIn(List<ApartmentModel> readyToMoveIn) {
    state = state.copyWith(readyToMoveIn: readyToMoveIn);
  }

  void setLifestyleProjects(List<ApartmentModel> lifestyleProjects) {
    state = state.copyWith(lifestyleProjects: lifestyleProjects);
  }

  void setPropertyType(String propertyType) {
    state = state.copyWith(propertyType: propertyType);
  }

  List<ApartmentModel> getBudgetHomes(int maxBudget, int minBudget) {
    if (minBudget == 0 && maxBudget == 0) {
      return state.allApartments;
    } else {
      return state.allApartments
          .where((apartment) =>
              apartment.budget >= minBudget && apartment.budget <= maxBudget)
          .toList();
    }
  }
}

class HomeData {
  final List<ApartmentModel> allApartments;
  final List<ApartmentModel> filteredApartments;
  final List<ApartmentModel> bestDeals;
  final List<ApartmentModel> selectedProperties;
  final List<ApartmentModel> editorsChoice;
  final List<ApartmentModel> builderInFocus;
  final List<ApartmentModel> newProjects;
  final List<ApartmentModel> readyToMoveIn;
  final List<ApartmentModel> lifestyleProjects;
  final String propertyType;

  HomeData({
    this.allApartments = const [],
    this.filteredApartments = const [],
    this.bestDeals = const [],
    this.selectedProperties = const [],
    this.editorsChoice = const [],
    this.builderInFocus = const [],
    this.newProjects = const [],
    this.readyToMoveIn = const [],
    this.lifestyleProjects = const [],
    this.propertyType = '',
  });

  HomeData copyWith({
    List<ApartmentModel>? allApartments,
    List<ApartmentModel>? filteredApartments,
    List<ApartmentModel>? bestDeals,
    List<ApartmentModel>? selectedProperties,
    List<ApartmentModel>? editorsChoice,
    List<ApartmentModel>? builderInFocus,
    List<ApartmentModel>? newProjects,
    List<ApartmentModel>? readyToMoveIn,
    List<ApartmentModel>? lifestyleProjects,
    String? propertyType,
  }) {
    return HomeData(
      allApartments: allApartments ?? this.allApartments,
      filteredApartments: filteredApartments ?? this.filteredApartments,
      bestDeals: bestDeals ?? this.bestDeals,
      selectedProperties: selectedProperties ?? this.selectedProperties,
      editorsChoice: editorsChoice ?? this.editorsChoice,
      builderInFocus: builderInFocus ?? this.builderInFocus,
      newProjects: newProjects ?? this.newProjects,
      readyToMoveIn: readyToMoveIn ?? this.readyToMoveIn,
      lifestyleProjects: lifestyleProjects ?? this.lifestyleProjects,
      propertyType: propertyType ?? this.propertyType,
    );
  }
}

final homePropertiesProvider =
    StateNotifierProvider<HomeDataNotifier, HomeData>((ref) {
  return HomeDataNotifier();
});
