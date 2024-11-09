import 'package:freezed_annotation/freezed_annotation.dart';

part 'apartment_details_model.freezed.dart';
part 'apartment_details_model.g.dart';

@freezed
class ApartmentDetailsResponse with _$ApartmentDetailsResponse {
  const factory ApartmentDetailsResponse({
    @Default('') String message,
    @Default([]) List<ProjectImageModel> projectImages,
    @Default(ProjectDetails()) ProjectDetails projectDetails,
    @Default([]) List<UnitPlanConfig> unitPlanConfigFilesFormatted,
  }) = _ApartmentDetailsResponse;

  factory ApartmentDetailsResponse.fromJson(Map<String, dynamic> json) =>
      _$ApartmentDetailsResponseFromJson(json);
}

@freezed
class ProjectImageModel with _$ProjectImageModel {
  const factory ProjectImageModel({
    @Default('') String title,
    @Default([]) List<String> images,
  }) = _ProjectImageModel;

  factory ProjectImageModel.fromJson(Map<String, dynamic> json) =>
      _$ProjectImageModelFromJson(json);
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
    @Default('0') String pricePerSquareFeetRate,
    @Default('') String totalArea,
    @Default('') String landMark,
    @Default('') String nearByHighlights,
    @Default('') String amenities,
    @Default('') String clubHouseAmenities,
    @Default('') String outdoorAmenities,
    @Default([]) List<String> specifications,
    @Default([]) List<String> projectHighlightsPoints,
    @Default(Builder()) Builder builder,
    @Default([]) List<Institution> educationalInstitutions,
    @Default([]) List<Institution> hospitals,
    @Default([]) List<Institution> offices,
    @Default([]) List<Institution> connectivity,
    @Default('') String bankName,
    @Default(0) int loanPercentage,
    @Default([]) List<Bank> banks,
    @Default([]) List<Institution> restaurants,
    @Default([]) List<Institution> colleges,
    @Default([]) List<Institution> pharmacies,
    @Default([]) List<Institution> hotspots,
    @Default([]) List<Institution> shopping,
    @Default([]) List<Institution> entertainment,
  }) = _ProjectDetails;

  factory ProjectDetails.fromJson(Map<String, dynamic> json) =>
      _$ProjectDetailsFromJson(json);
}

@freezed
class Bank with _$Bank {
  const factory Bank({
    @Default('') String bankName,
    @Default('') String bankLogo,
    @Default(0) int loanPercentage,
  }) = _Bank;

  factory Bank.fromJson(Map<String, dynamic> json) => _$BankFromJson(json);
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
