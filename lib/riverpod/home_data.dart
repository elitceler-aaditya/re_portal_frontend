import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:re_portal_frontend/modules/home/models/builder_data_model.dart';
import 'package:re_portal_frontend/modules/shared/models/appartment_model.dart';

class HomeDataNotifier extends StateNotifier<HomeData> {
  HomeDataNotifier() : super(HomeData());

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
          ..sort(
            (a, b) =>
                b.pricePerSquareFeetRate.compareTo(a.pricePerSquareFeetRate),
          ),
      );
    } else if (sortBy == 4) {
      state = state.copyWith(
        filteredApartments: state.filteredApartments
          ..sort(
            (a, b) =>
                a.pricePerSquareFeetRate.compareTo(b.pricePerSquareFeetRate),
          ),
      );
    } else if (sortBy == 5) {
      state = state.copyWith(
        filteredApartments: state.filteredApartments
          ..sort(
            (a, b) => DateTime.parse(a.projectPossession)
                .compareTo(DateTime.parse(b.projectPossession)),
          ),
      );
    } else if (sortBy == 6) {
      state = state.copyWith(
        filteredApartments: state.filteredApartments
          ..sort(
            (b, a) => DateTime.parse(a.projectPossession)
                .compareTo(DateTime.parse(b.projectPossession)),
          ),
      );
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

  void setSponsoredAd(List<ApartmentModel> sponsoredAd) {
    state = state.copyWith(sponsoredAd: sponsoredAd);
  }

  void setLimelight(List<ApartmentModel> limelight) {
    state = state.copyWith(limelight: limelight);
  }

  List<ApartmentModel> getUltraLuxuryHomes() {
    return state.filteredApartments
        .where((apartment) => apartment.budget >= 10000000)
        .toList();
  }

  List<ApartmentModel> getBudgetHomes(int maxBudget, int minBudget) {
    if (minBudget == 0 && maxBudget == 0) {
      return state.filteredApartments;
    } else {
      return state.filteredApartments
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
        .where((apartment) =>
            apartment.name.toLowerCase().contains(searchTerm.toLowerCase()))
        .toList();
  }

  List<ApartmentModel> getApartmentsByBuilderName(String builderName) {
    if (builderName.isEmpty) {
      return state.allApartments;
    }
    return state.allApartments
        .where((apartment) => apartment.companyName
            .toLowerCase()
            .contains(builderName.toLowerCase()))
        .toList();
  }

  List<BuilderDataModel> getBuilderNames(String searchTerm) {
    if (searchTerm.isEmpty) {
      return state.builderData.map((builder) => builder).toList();
    }
    return state.builderData
        .where((builder) => builder.CompanyName.toLowerCase()
            .contains(searchTerm.toLowerCase()))
        .map((builder) => builder)
        .toList();
  }

  void setProjectSnippets(List<ApartmentModel> projectSnippets) {
    state = state.copyWith(projectSnippets: projectSnippets);
  }
}

class HomeData {
  final List<BuilderDataModel> builderData;
  final List<ApartmentModel> filteredApartments;
  final List<ApartmentModel> bestDeals;
  final List<ApartmentModel> selectedProperties;
  final List<ApartmentModel> editorsChoice;
  final List<ApartmentModel> builderInFocus;
  final List<ApartmentModel> newProjects;
  final List<ApartmentModel> readyToMoveIn;
  final List<ApartmentModel> lifestyleProjects;
  final List<ApartmentModel> sponsoredAd;
  final List<ApartmentModel> limelight;
  final String propertyType;
  final List<ApartmentModel> projectSnippets;

  HomeData({
    this.builderData = const [],
    this.filteredApartments = const [],
    this.bestDeals = const [],
    this.selectedProperties = const [],
    this.editorsChoice = const [],
    this.builderInFocus = const [],
    this.newProjects = const [],
    this.readyToMoveIn = const [],
    this.lifestyleProjects = const [],
    this.sponsoredAd = const [],
    this.limelight = const [],
    this.propertyType = '',
    this.projectSnippets = const [],
  });

  List<ApartmentModel> get allApartments {
    // Combine all apartment lists into a single set to remove duplicates
    return {
      ...filteredApartments,
      ...bestDeals,
      ...selectedProperties,
      ...editorsChoice,
      ...builderInFocus,
      ...newProjects,
      ...readyToMoveIn,
      ...lifestyleProjects,
      ...sponsoredAd,
      ...limelight,
      ...projectSnippets,
    }.toList();
  }

  HomeData copyWith({
    List<BuilderDataModel>? builderData,
    List<ApartmentModel>? filteredApartments,
    List<ApartmentModel>? bestDeals,
    List<ApartmentModel>? selectedProperties,
    List<ApartmentModel>? editorsChoice,
    List<ApartmentModel>? builderInFocus,
    List<ApartmentModel>? newProjects,
    List<ApartmentModel>? readyToMoveIn,
    List<ApartmentModel>? lifestyleProjects,
    List<ApartmentModel>? sponsoredAd,
    List<ApartmentModel>? limelight,
    String? propertyType,
    List<ApartmentModel>? projectSnippets,
  }) {
    return HomeData(
      builderData: builderData ?? this.builderData,
      filteredApartments: filteredApartments ?? this.filteredApartments,
      bestDeals: bestDeals ?? this.bestDeals,
      selectedProperties: selectedProperties ?? this.selectedProperties,
      editorsChoice: editorsChoice ?? this.editorsChoice,
      builderInFocus: builderInFocus ?? this.builderInFocus,
      newProjects: newProjects ?? this.newProjects,
      readyToMoveIn: readyToMoveIn ?? this.readyToMoveIn,
      lifestyleProjects: lifestyleProjects ?? this.lifestyleProjects,
      sponsoredAd: sponsoredAd ?? this.sponsoredAd,
      limelight: limelight ?? this.limelight,
      propertyType: propertyType ?? this.propertyType,
      projectSnippets: projectSnippets ?? this.projectSnippets,
    );
  }
}

final homePropertiesProvider =
    StateNotifierProvider<HomeDataNotifier, HomeData>((ref) {
  return HomeDataNotifier();
});
