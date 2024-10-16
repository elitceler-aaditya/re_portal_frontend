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
  final int totalCount;
  final String builderName;
  final bool affordableHomes;
  final bool largeLivingSpaces;
  final bool sustainableLivingHomes;
  final bool twopointfiveBHKHomes;
  final bool largeBalconies;
  final bool skyVillaHabitat;
  final bool standAloneBuildings;
  final bool skyScrapers;

  FiltersModel({
    this.selectedLocalities = const [],
    this.apartmentType = '',
    this.amenities = const [],
    this.selectedConfigurations = const [],
    this.minBudget = 0.0,
    this.maxBudget = 0.0,
    this.minFlatSize = 0.0,
    this.maxFlatSize = 0.0,
    this.totalCount = 0,
    this.builderName = '',
    this.affordableHomes = false,
    this.largeLivingSpaces = false,
    this.sustainableLivingHomes = false,
    this.twopointfiveBHKHomes = false,
    this.largeBalconies = false,
    this.skyVillaHabitat = false,
    this.standAloneBuildings = false,
    this.skyScrapers = false,
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
    int? totalCount,
    String? builderName,
    bool? affordableHomes,
    bool? largeLivingSpaces,
    bool? sustainableLivingHomes,
    bool? twopointfiveBHKHomes,
    bool? largeBalconies,
    bool? skyVillaHabitat,
    bool? standAloneBuildings,
    bool? skyScrapers,
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
      totalCount: totalCount ?? this.totalCount,
      builderName: builderName ?? this.builderName,
      affordableHomes: affordableHomes ?? this.affordableHomes,
      largeLivingSpaces: largeLivingSpaces ?? this.largeLivingSpaces,
      sustainableLivingHomes:
          sustainableLivingHomes ?? this.sustainableLivingHomes,
      twopointfiveBHKHomes: twopointfiveBHKHomes ?? this.twopointfiveBHKHomes,
      largeBalconies: largeBalconies ?? this.largeBalconies,
      skyVillaHabitat: skyVillaHabitat ?? this.skyVillaHabitat,
      standAloneBuildings: standAloneBuildings ?? this.standAloneBuildings,
      skyScrapers: skyScrapers ?? this.skyScrapers,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {};

    if (selectedLocalities.isNotEmpty) {
      json['projectLocation'] = selectedLocalities.join(',');
    }
    if (apartmentType.isNotEmpty) {
      json['projectType'] = apartmentType;
    }
    if (selectedConfigurations.isNotEmpty) {
      json['selectedConfigurations'] = selectedConfigurations.join(',');
    }
    if (minBudget > 0) {
      json['minBudget'] = minBudget.toString();
    }
    if (maxBudget > 0) {
      json['maxBudget'] = maxBudget.toString();
    }
    if (builderName.isNotEmpty) {
      json['builderName'] = builderName;
    }
    if (affordableHomes) json['affordableHomes'] = 'true';
    if (largeLivingSpaces) json['largeLivingSpaces'] = 'true';
    if (sustainableLivingHomes) json['sustainableLivingHomes'] = 'true';
    if (twopointfiveBHKHomes) json['twopointfiveBHKHomes'] = 'true';
    if (largeBalconies) json['largeBalconies'] = 'true';
    if (skyVillaHabitat) json['skyVillaHabitat'] = 'true';
    if (standAloneBuildings) json['standAloneBuildings'] = 'true';
    if (skyScrapers) json['skyScrapers'] = 'true';

    return json;
  }

  FiltersModel fromJson(Map<String, dynamic> json) {
    return FiltersModel(
      selectedLocalities: json['projectLocation']?.split(',') ?? [],
      apartmentType: json['projectType'] ?? '',
      selectedConfigurations: json['BHKType']?.split(',') ?? [],
      minBudget: double.tryParse(json['minBudget'] ?? '') ?? 0,
      maxBudget: double.tryParse(json['maxBudget'] ?? '') ?? 0,
      minFlatSize: double.tryParse(json['minFlatSize'] ?? '') ?? 0,
      maxFlatSize: double.tryParse(json['maxFlatSize'] ?? '') ?? 0,
      builderName: json['builderName'] ?? '',
      affordableHomes: json['affordableHomes'] ?? 'false',
      largeLivingSpaces: json['largeLivingSpaces'] ?? 'false',
      sustainableLivingHomes: json['sustainableLivingHomes'] ?? 'false',
      twopointfiveBHKHomes: json['twopointfiveBHKHomes'] ?? 'false',
      largeBalconies: json['largeBalconies'] ?? 'false',
      skyVillaHabitat: json['skyVillaHabitat'] ?? 'false',
      standAloneBuildings: json['standAloneBuildings'] ?? 'false',
      skyScrapers: json['skyScrapers'] ?? 'false',
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
          totalCount: 0,
          builderName: '',
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

  void updateTotalCount(int count) {
    state = state.copyWith(totalCount: count);
  }

  void updateBuilderName(String name) {
    state = state.copyWith(builderName: name);
  }

  void clearBuilderName() {
    state = state.copyWith(builderName: '');
  }

  void updateAffordableHomes(bool value) {
    state = state.copyWith(affordableHomes: value);
  }

  void updateLargeLivingSpaces(bool value) {
    state = state.copyWith(largeLivingSpaces: value);
  }

  void updateSustainableLivingHomes(bool value) {
    state = state.copyWith(sustainableLivingHomes: value);
  }

  void updateTwopointfiveBHKHomes(bool value) {
    state = state.copyWith(twopointfiveBHKHomes: value);
  }

  void updateLargeBalconies(bool value) {
    state = state.copyWith(largeBalconies: value);
  }

  void updateSkyVillaHabitat(bool value) {
    state = state.copyWith(skyVillaHabitat: value);
  }

  void updateStandAloneBuildings(bool value) {
    state = state.copyWith(standAloneBuildings: value);
  }

  void updateSkyScrapers(bool value) {
    state = state.copyWith(skyScrapers: value);
  }
}

// Define the provider
final filtersProvider =
    StateNotifierProvider<FiltersNotifier, FiltersModel>((ref) {
  return FiltersNotifier();
});
