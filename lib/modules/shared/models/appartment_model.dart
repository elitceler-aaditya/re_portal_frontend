import 'package:freezed_annotation/freezed_annotation.dart';

part 'appartment_model.freezed.dart';
part 'appartment_model.g.dart';

@freezed
class ApartmentModel with _$ApartmentModel {
  const factory ApartmentModel({
    @Default("") String projectId,
    @Default("") String builderID,
    @Default("") String builderName,
    @Default("") String apartmentID,
    @Default("") String companyPhone,
    @Default("") String companyName,
    @Default("") String companyLogo,
    @Default("") String name,
    @Default("") String description,
    @Default("") String projectLocation,
    @Default(0) int pricePerSquareFeetRate,
    @Default(0.0) double latitude,
    @Default(0.0) double longitude,
    @Default("") String projectPossession,
    @Default("") String coverImage,
    @Default([]) List<String> projectGallery,
    @Default([]) List<String> configuration,
    @Default("") String configTitle,
    @Default(null) String? videoLink,
    @Default(0) int flatSize,
    @Default(0) int budget,
    @Default(0) int minBudget,
    @Default(0) int maxBudget,
  }) = _ApartmentModel;

  factory ApartmentModel.fromJson(Map<String, dynamic> json) =>
      _$ApartmentModelFromJson(json);
}
