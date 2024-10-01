import 'package:freezed_annotation/freezed_annotation.dart';

part 'apartment_details_model.freezed.dart';
part 'apartment_details_model.g.dart';

@freezed
class ApartmentDetailsResponse with _$ApartmentDetailsResponse {
  const factory ApartmentDetailsResponse({
    @Default('') String message,
    @Default(ProjectImages()) ProjectImages projectImages,
    @Default(ProjectDetails()) ProjectDetails projectDetails,
    @Default([]) List<UnitPlanConfig> unitPlanConfigFilesFormatted,
  }) = _ApartmentDetailsResponse;

  factory ApartmentDetailsResponse.fromJson(Map<String, dynamic> json) =>
      _$ApartmentDetailsResponseFromJson(json);
}

@freezed
class ProjectImages with _$ProjectImages {
  const factory ProjectImages({
    @Default([]) List<String> projectHighlights,
    @Default([]) List<String> elevationImages,
  }) = _ProjectImages;

  factory ProjectImages.fromJson(Map<String, dynamic> json) =>
      _$ProjectImagesFromJson(json);
}

@freezed
class ProjectDetails with _$ProjectDetails {
  const factory ProjectDetails({
    @Default('') String projectId,
    @Default('') String builderID,
    @Default('') String name,
    @Default('') String description,
    @Default('') String projectLocation,
    @Default('') String projectSize,
    @Default('') String noOfFloors,
    @Default('') String noOfFlats,
    @Default('') String noOfTowers,
    @Default('') String noOfFlatsPerFloor,
    @Default('') String clubhousesize,
    @Default('') String totalOpenSpace,
    @Default('') String constructionType,
    @Default(0.0) double latitude,
    @Default(0.0) double longitude,
    @Default('') String reraID,
    @Default('') String projectType,
    @Default('') String projectLaunchedDate,
    @Default('') String projectPossession,
    @Default('') String pricePerSquareFeetRate,
    @Default('') String totalArea,
    @Default('') String landMark,
    @Default('') String nearByHighlights,
    @Default('') String amenities,
    @Default('') String clubHouseAmenities,
    @Default('') String outdoorAmenities,
    @Default(Builder()) Builder builder,
    @Default([]) List<Institution> educationalInstitutions,
    @Default([]) List<Institution> hospitals,
    @Default([]) List<Institution> offices,
    @Default([]) List<Institution> connectivity,
  }) = _ProjectDetails;

  factory ProjectDetails.fromJson(Map<String, dynamic> json) =>
      _$ProjectDetailsFromJson(json);
}

@freezed
class Builder with _$Builder {
  const factory Builder({
    @Default('') String CompanyPhone,
    @Default('') String CompanyName,
  }) = _Builder;

  factory Builder.fromJson(Map<String, dynamic> json) =>
      _$BuilderFromJson(json);
}

@freezed
class Institution with _$Institution {
  const factory Institution({
    @Default('') String name,
    @Default('') String dist,
    @Default('') String time,
  }) = _Institution;

  factory Institution.fromJson(Map<String, dynamic> json) =>
      _$InstitutionFromJson(json);
}

@freezed
class UnitPlanConfig with _$UnitPlanConfig {
  const factory UnitPlanConfig({
    @Default('') String bHKType,
    @Default('') String sizeInSqft,
    @Default('') String facing,
    @Default([]) List<String> unitPlanConfigFiles,
  }) = _UnitPlanConfig;

  factory UnitPlanConfig.fromJson(Map<String, dynamic> json) =>
      _$UnitPlanConfigFromJson(json);
}
