import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:re_portal_frontend/modules/home/models/builder_data_model.dart';
import 'package:re_portal_frontend/modules/shared/models/appartment_model.dart';

class HomeDataNotifier extends StateNotifier<HomeData> {
  HomeDataNotifier() : super(HomeData());

  void setAllApartments(List<ApartmentModel> allApartments) {
    final uniqueApartments = allApartments.toSet().toList();
    state = state.copyWith(allApartments: uniqueApartments);
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
      state = state.copyWith(filteredApartments: state.allApartments);
    } else if (sortBy == 1) {
      state = state.copyWith(
          filteredApartments: state.filteredApartments
            ..sort((a, b) => b.budget.compareTo(a.budget)));
    } else if (sortBy == 2) {
      state = state.copyWith(
          filteredApartments: state.filteredApartments
            ..sort((a, b) => a.budget.compareTo(b.budget)));
    } else if (sortBy == 3) {
      state = state.copyWith(
          filteredApartments: state.filteredApartments
            ..sort((a, b) =>
                b.pricePerSquareFeetRate.compareTo(a.pricePerSquareFeetRate)));
    } else if (sortBy == 4) {
      state = state.copyWith(
          filteredApartments: state.filteredApartments
            ..sort((a, b) =>
                a.pricePerSquareFeetRate.compareTo(b.pricePerSquareFeetRate)));
    }
  }

  void resetFilteredApartments() {
    state = state.copyWith(filteredApartments: state.allApartments);
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

  void setBuilderData(List<BuilderDataModel> builderData) {
    //remove element which dont have any projects
    builderData =
        builderData.where((element) => element.projects.isNotEmpty).toList();
    state = state.copyWith(builderData: builderData);
  }

  List<ApartmentModel> getUltraLuxuryHomes() {
    return state.allApartments
        .where((apartment) => apartment.budget >= 20000000)
        .toList();
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

  List<ApartmentModel> getApartmentsByName(String searchTerm) {
    if (searchTerm.isEmpty) {
      return state.allApartments;
    }
    return state.allApartments
        .where((apartment) => apartment.name.toLowerCase().contains(searchTerm))
        .toList();
  }

  List<ApartmentModel> getApartmentsByBuilderName(String builderName) {
    if (builderName.isEmpty) {
      return state.allApartments;
    }
    return state.allApartments
        .where((apartment) =>
            apartment.companyName.toLowerCase().contains(builderName))
        .toList();
  }

  List<BuilderDataModel> getBuilderNames(String searchTerm) {
    if (searchTerm.isEmpty) {
      return state.builderData.map((builder) => builder).toList();
    }
    return state.builderData
        .where(
            (builder) => builder.CompanyName.toLowerCase().contains(searchTerm))
        .map((builder) => builder)
        .toList();
  }
}

class HomeData {
  final List<ApartmentModel> allApartments;
  final List<BuilderDataModel> builderData;
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
    this.builderData = const [],
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
    List<BuilderDataModel>? builderData,
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
      builderData: builderData ?? this.builderData,
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
