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
  final String affordableHomes;
  final String largeLivingSpaces;
  final String sustainableLivingHomes;
  final String twopointfiveBHKHomes;
  final String largeBalconies;
  final String skyVillaHabitat;
  final String standAloneBuildings;
  final String skyScrapers;
  final String readyToMove;
  final String newProject;
  final String underConstruction;
  final String newSaleType;
  final String resaleType;
  final String postedByBuilder;
  final String postedByOwner;
  final String postedByAgent;
  final String igbcCertifiedHomes;
  final String semiGatedApartments;
  final String moreOffers;

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
    this.affordableHomes = 'false',
    this.largeLivingSpaces = 'false',
    this.sustainableLivingHomes = 'false',
    this.twopointfiveBHKHomes = 'false',
    this.largeBalconies = 'false',
    this.skyVillaHabitat = 'false',
    this.standAloneBuildings = 'false',
    this.skyScrapers = 'false',
    this.readyToMove = 'false',
    this.newProject = 'false',
    this.underConstruction = 'false',
    this.newSaleType = 'false',
    this.resaleType = 'false',
    this.postedByBuilder = 'false',
    this.postedByOwner = 'false',
    this.postedByAgent = 'false',
    this.igbcCertifiedHomes = 'false',
    this.semiGatedApartments = 'false',
    this.moreOffers = 'false',
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
    String? affordableHomes,
    String? largeLivingSpaces,
    String? sustainableLivingHomes,
    String? twopointfiveBHKHomes,
    String? largeBalconies,
    String? skyVillaHabitat,
    String? standAloneBuildings,
    String? skyScrapers,
    String? readyToMove,
    String? newProject,
    String? underConstruction,
    String? newSaleType,
    String? resaleType,
    String? postedByBuilder,
    String? postedByOwner,
    String? postedByAgent,
    String? igbcCertifiedHomes,
    String? semiGatedApartments,
    String? moreOffers,
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
      readyToMove: readyToMove ?? this.readyToMove,
      newProject: newProject ?? this.newProject,
      underConstruction: underConstruction ?? this.underConstruction,
      newSaleType: newSaleType ?? this.newSaleType,
      resaleType: resaleType ?? this.resaleType,
      postedByBuilder: postedByBuilder ?? this.postedByBuilder,
      postedByOwner: postedByOwner ?? this.postedByOwner,
      postedByAgent: postedByAgent ?? this.postedByAgent,
      igbcCertifiedHomes: igbcCertifiedHomes ?? this.igbcCertifiedHomes,
      semiGatedApartments: semiGatedApartments ?? this.semiGatedApartments,
      moreOffers: moreOffers ?? this.moreOffers,
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
    if (affordableHomes == 'true') json['affordableHomes'] = 'true';
    if (largeLivingSpaces == 'true') json['largeLivingSpaces'] = 'true';
    if (sustainableLivingHomes == 'true') {
      json['sustainableLivingHomes'] = 'true';
    }
    if (twopointfiveBHKHomes == 'true') json['twopointfiveBHKHomes'] = 'true';
    if (largeBalconies == 'true') json['largeBalconies'] = 'true';
    if (skyVillaHabitat == 'true') json['skyVillaHabitat'] = 'true';
    if (standAloneBuildings == 'true') json['standAloneBuildings'] = 'true';
    if (skyScrapers == 'true') json['skyScrapers'] = 'true';
    if (readyToMove == 'true') json['readyToMove'] = 'true';
    if (newProject == 'true') json['newProject'] = 'true';
    if (underConstruction == 'true') json['underConstruction'] = 'true';
    if (newSaleType == 'true') json['newSaleType'] = 'true';
    if (resaleType == 'true') json['resaleType'] = 'true';
    if (postedByBuilder == 'true') json['postedByBuilder'] = 'true';
    if (postedByOwner == 'true') json['postedByOwner'] = 'true';
    if (postedByAgent == 'true') json['postedByAgent'] = 'true';
    if (igbcCertifiedHomes == 'true') json['igbcCertifiedHomes'] = 'true';
    if (semiGatedApartments == 'true') json['semiGatedApartments'] = 'true';
    if (moreOffers == 'true') json['moreOffers'] = 'true';

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
      readyToMove: json['readyToMove'] ?? 'false',
      newProject: json['newProject'] ?? 'false',
      underConstruction: json['underConstruction'] ?? 'false',
      newSaleType: json['newSaleType'] ?? 'false',
      resaleType: json['resaleType'] ?? 'false',
      postedByBuilder: json['postedByBuilder'] ?? 'false',
      postedByOwner: json['postedByOwner'] ?? 'false',
      postedByAgent: json['postedByAgent'] ?? 'false',
      igbcCertifiedHomes: json['igbcCertifiedHomes'] ?? 'false',
      semiGatedApartments: json['semiGatedApartments'] ?? 'false',
      moreOffers: json['moreOffers'] ?? 'false',
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

  void updateOnlySelectedFilter(FiltersModel filters) {
    state = state.copyWith(
      selectedLocalities: filters.selectedLocalities.isNotEmpty ? filters.selectedLocalities : state.selectedLocalities,
      apartmentType: filters.apartmentType.isNotEmpty ? filters.apartmentType : state.apartmentType,
      amenities: filters.amenities.isNotEmpty ? filters.amenities : state.amenities,
      selectedConfigurations: filters.selectedConfigurations.isNotEmpty ? filters.selectedConfigurations : state.selectedConfigurations,
      minBudget: filters.minBudget != 0 ? filters.minBudget : state.minBudget,
      maxBudget: filters.maxBudget != 0 ? filters.maxBudget : state.maxBudget,
      minFlatSize: filters.minFlatSize != 0 ? filters.minFlatSize : state.minFlatSize,
      maxFlatSize: filters.maxFlatSize != 0 ? filters.maxFlatSize : state.maxFlatSize,
      builderName: filters.builderName.isNotEmpty ? filters.builderName : state.builderName,
      affordableHomes: filters.affordableHomes.isNotEmpty ? filters.affordableHomes : state.affordableHomes,
      largeLivingSpaces: filters.largeLivingSpaces.isNotEmpty ? filters.largeLivingSpaces : state.largeLivingSpaces,
      sustainableLivingHomes: filters.sustainableLivingHomes.isNotEmpty ? filters.sustainableLivingHomes : state.sustainableLivingHomes,
      twopointfiveBHKHomes: filters.twopointfiveBHKHomes.isNotEmpty ? filters.twopointfiveBHKHomes : state.twopointfiveBHKHomes,
      largeBalconies: filters.largeBalconies.isNotEmpty ? filters.largeBalconies : state.largeBalconies,
      skyVillaHabitat: filters.skyVillaHabitat.isNotEmpty ? filters.skyVillaHabitat : state.skyVillaHabitat,
      standAloneBuildings: filters.standAloneBuildings.isNotEmpty ? filters.standAloneBuildings : state.standAloneBuildings,
      skyScrapers: filters.skyScrapers.isNotEmpty ? filters.skyScrapers : state.skyScrapers,
      readyToMove: filters.readyToMove.isNotEmpty ? filters.readyToMove : state.readyToMove,
      newProject: filters.newProject.isNotEmpty ? filters.newProject : state.newProject,
      underConstruction: filters.underConstruction.isNotEmpty ? filters.underConstruction : state.underConstruction,
      newSaleType: filters.newSaleType.isNotEmpty ? filters.newSaleType : state.newSaleType,
      resaleType: filters.resaleType.isNotEmpty ? filters.resaleType : state.resaleType,
      postedByBuilder: filters.postedByBuilder.isNotEmpty ? filters.postedByBuilder : state.postedByBuilder,
      postedByOwner: filters.postedByOwner.isNotEmpty ? filters.postedByOwner : state.postedByOwner,
      postedByAgent: filters.postedByAgent.isNotEmpty ? filters.postedByAgent : state.postedByAgent,
      igbcCertifiedHomes: filters.igbcCertifiedHomes.isNotEmpty ? filters.igbcCertifiedHomes : state.igbcCertifiedHomes,
      semiGatedApartments: filters.semiGatedApartments.isNotEmpty ? filters.semiGatedApartments : state.semiGatedApartments,
      moreOffers: filters.moreOffers.isNotEmpty ? filters.moreOffers : state.moreOffers,
    );
  }

  void updateFilters(FiltersModel filters) {
    state = state.copyWith(
      selectedLocalities: filters.selectedLocalities,
      apartmentType: filters.apartmentType,
      amenities: filters.amenities,
      selectedConfigurations: filters.selectedConfigurations,
      minBudget: filters.minBudget,
      maxBudget: filters.maxBudget,
      minFlatSize: filters.minFlatSize,
      maxFlatSize: filters.maxFlatSize,
      totalCount: filters.totalCount,
      builderName: filters.builderName,
      affordableHomes: filters.affordableHomes,
      largeLivingSpaces: filters.largeLivingSpaces,
      sustainableLivingHomes: filters.sustainableLivingHomes,
      twopointfiveBHKHomes: filters.twopointfiveBHKHomes,
      largeBalconies: filters.largeBalconies,
      skyVillaHabitat: filters.skyVillaHabitat,
      standAloneBuildings: filters.standAloneBuildings,
      skyScrapers: filters.skyScrapers,
      readyToMove: filters.readyToMove,
      newProject: filters.newProject,
      underConstruction: filters.underConstruction,
      newSaleType: filters.newSaleType,
      resaleType: filters.resaleType,
      postedByBuilder: filters.postedByBuilder,
      postedByOwner: filters.postedByOwner,
      postedByAgent: filters.postedByAgent,
      igbcCertifiedHomes: filters.igbcCertifiedHomes,
      semiGatedApartments: filters.semiGatedApartments,
      moreOffers: filters.moreOffers,
    );
  }

  void updateSelectedLocalities(List<String> localities) {
    state = state.copyWith(selectedLocalities: localities);
  }

  // void updateApartmentType(String type) {
  //   state = state.copyWith(apartmentType: type);
  // }

  // void updateAmenities(List<String> amenities) {
  //   state = state.copyWith(amenities: amenities);
  // }

  // void updateSelectedConfigurations(List<String> configurations) {
  //   state = state.copyWith(selectedConfigurations: configurations);
  // }

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

  void updateAffordableHomes(String value) {
    state = state.copyWith(affordableHomes: value);
  }

  void updateLargeLivingSpaces(String value) {
    state = state.copyWith(largeLivingSpaces: value);
  }

  void updateSustainableLivingHomes(String value) {
    state = state.copyWith(sustainableLivingHomes: value);
  }

  void updateTwopointfiveBHKHomes(String value) {
    state = state.copyWith(twopointfiveBHKHomes: value);
  }

  void updateLargeBalconies(String value) {
    state = state.copyWith(largeBalconies: value);
  }

  void updateSkyVillaHabitat(String value) {
    state = state.copyWith(skyVillaHabitat: value);
  }

  void updateStandAloneBuildings(String value) {
    state = state.copyWith(standAloneBuildings: value);
  }

  void updateSkyScrapers(String value) {
    state = state.copyWith(skyScrapers: value);
  }

  void updateReadyToMove(String value) {
    state = state.copyWith(readyToMove: value);
  }

  void updateNewProject(String value) {
    state = state.copyWith(newProject: value);
  }

  void updateUnderConstruction(String value) {
    state = state.copyWith(underConstruction: value);
  }

  void updateNewSaleType(String value) {
    state = state.copyWith(newSaleType: value);
  }

  void updateResaleType(String value) {
    state = state.copyWith(resaleType: value);
  }

  void updatePostedByBuilder(String value) {
    state = state.copyWith(postedByBuilder: value);
  }

  void updatePostedByOwner(String value) {
    state = state.copyWith(postedByOwner: value);
  }

  void updatePostedByAgent(String value) {
    state = state.copyWith(postedByAgent: value);
  }

  void updateIgbcCertifiedHomes(String value) {
    state = state.copyWith(igbcCertifiedHomes: value);
  }

  void updateSemiGatedApartments(String value) {
    state = state.copyWith(semiGatedApartments: value);
  }

  void updateMoreOffers(String value) {
    state = state.copyWith(moreOffers: value);
  }

  void clearAllFilters() {
    state = FiltersModel();
  }
}

// Define the provider
final filtersProvider =
    StateNotifierProvider<FiltersNotifier, FiltersModel>((ref) {
  return FiltersNotifier();
});
