import 'package:flutter_riverpod/flutter_riverpod.dart';

// Define the data model
class FiltersModel {
  final List<String> selectedLocalities;
  final String apartmentType;
  final List<String> amenities;
  final List<String> selectedConfigurations;
  final double minBudget;
  final double maxBudget;
  final double minFlatSize;
  final double maxFlatSize;

  FiltersModel({
     this.selectedLocalities = const [],
     this.apartmentType = '',
     this.amenities = const [],
     this.selectedConfigurations = const [],
     this.minBudget = 0.0,
     this.maxBudget = 0.0,
     this.minFlatSize = 0.0,
     this.maxFlatSize = 0.0,
  });

  FiltersModel copyWith({
    List<String>? selectedLocalities,
    String? apartmentType,
    List<String>? amenities,
    List<String>? selectedConfigurations,
    double? minBudget,
    double? maxBudget,
    double? minFlatSize,
    double? maxFlatSize,
  }) {
    return FiltersModel(
      selectedLocalities: selectedLocalities ?? this.selectedLocalities,
      apartmentType: apartmentType ?? this.apartmentType,
      amenities: amenities ?? this.amenities,
      selectedConfigurations:
          selectedConfigurations ?? this.selectedConfigurations,
      minBudget: minBudget ?? this.minBudget,
      maxBudget: maxBudget ?? this.maxBudget,
      minFlatSize: minFlatSize ?? this.minFlatSize,
      maxFlatSize: maxFlatSize ?? this.maxFlatSize,
    );
  }
}

// Define the state notifier
class FiltersNotifier extends StateNotifier<FiltersModel> {
  FiltersNotifier()
      : super(FiltersModel(
          selectedLocalities: [],
          apartmentType: '',
          amenities: [],
          selectedConfigurations: [],
          minBudget: 0,
          maxBudget: 0,
          minFlatSize: 0,
          maxFlatSize: 0,
        ));

  void setAllFilters(FiltersModel filters) {
    state = filters;
  }

  void updateSelectedLocalities(List<String> localities) {
    state = state.copyWith(selectedLocalities: localities);
  }

  void updateApartmentType(String type) {
    state = state.copyWith(apartmentType: type);
  }

  void updateAmenities(List<String> amenities) {
    state = state.copyWith(amenities: amenities);
  }

  void updateSelectedConfigurations(List<String> configurations) {
    state = state.copyWith(selectedConfigurations: configurations);
  }

  void updateMinBudget(double budget) {
    state = state.copyWith(minBudget: budget);
  }

  void updateMaxBudget(double budget) {
    state = state.copyWith(maxBudget: budget);
  }

  void updateMinFlatSize(double size) {
    state = state.copyWith(minFlatSize: size);
  }

  void updateMaxFlatSize(double size) {
    state = state.copyWith(maxFlatSize: size);
  }
}

// Define the provider
final filtersProvider =
    StateNotifierProvider<FiltersNotifier, FiltersModel>((ref) {
  return FiltersNotifier();
});
