import 'package:flutter_riverpod/flutter_riverpod.dart';

class FilterState {
  final bool isFilterApplied;
  final int appartmentType;
  final int configurationType;
  final double minBudget;
  final double maxBudget;
  final double budgetSliderMin;
  final double budgetSliderMax;
  final double minFlatSize;
  final double maxFlatSize;
  final double flatSizeSliderMin;
  final double flatSizeSliderMax;
  final List<String> localities;
  final List<String> amenities;

  FilterState({
    this.isFilterApplied = false,
    this.appartmentType = 0,
    this.configurationType = 0,
    this.minBudget = 0.0,
    this.maxBudget = 0.0,
    this.budgetSliderMin = 0.0,
    this.budgetSliderMax = 0.0,
    this.minFlatSize = 0.0,
    this.maxFlatSize = 0.0,
    this.flatSizeSliderMin = 0.0,
    this.flatSizeSliderMax = 0.0,
    this.localities = const [],
    this.amenities = const [],
  });

  FilterState copyWith({
    bool? isFilterApplied,
    int? appartmentType,
    int? configurationType,
    double? minBudget,
    double? maxBudget,
    double? budgetSliderMin,
    double? budgetSliderMax,
    double? minFlatSize,
    double? maxFlatSize,
    double? flatSizeSliderMin,
    double? flatSizeSliderMax,
    List<String>? localities,
    List<String>? amenities,
  }) {
    return FilterState(
      isFilterApplied: isFilterApplied ?? this.isFilterApplied,
      appartmentType: appartmentType ?? this.appartmentType,
      configurationType: configurationType ?? this.configurationType,
      minBudget: minBudget ?? this.minBudget,
      maxBudget: maxBudget ?? this.maxBudget,
      budgetSliderMin: budgetSliderMin ?? this.budgetSliderMin,
      budgetSliderMax: budgetSliderMax ?? this.budgetSliderMax,
      minFlatSize: minFlatSize ?? this.minFlatSize,
      maxFlatSize: maxFlatSize ?? this.maxFlatSize,
      flatSizeSliderMin: flatSizeSliderMin ?? this.flatSizeSliderMin,
      flatSizeSliderMax: flatSizeSliderMax ?? this.flatSizeSliderMax,
      localities: localities ?? this.localities,
      amenities: amenities ?? this.amenities,
    );
  }
}

class FilterStateNotifier extends StateNotifier<FilterState> {
  FilterStateNotifier() : super(FilterState());

  void setIsFilterApplied(bool value) {
    state = state.copyWith(isFilterApplied: value);
  }

  void setAppartmentType(int value) {
    state = state.copyWith(appartmentType: value);
  }

  void setConfigurationType(int value) {
    state = state.copyWith(configurationType: value);
  }

  void setBudgetRange(double min, double max) {
    state = state.copyWith(minBudget: min, maxBudget: max);
  }

  void setBudgetSliderRange(double min, double max) {
    state = state.copyWith(budgetSliderMin: min, budgetSliderMax: max);
  }

  void setFlatSizeRange(double min, double max) {
    state = state.copyWith(minFlatSize: min, maxFlatSize: max);
  }

  void setFlatSizeSliderRange(double min, double max) {
    state = state.copyWith(flatSizeSliderMin: min, flatSizeSliderMax: max);
  }

  void setLocalities(List<String> value) {
    state = state.copyWith(localities: value);
  }

  void setAmenities(List<String> value) {
    state = state.copyWith(amenities: value);
  }

  void clearFilters() {
    state = FilterState();
  }
}

final filterStateProvider = StateNotifierProvider<FilterStateNotifier, FilterState>((ref) {
  return FilterStateNotifier();
});