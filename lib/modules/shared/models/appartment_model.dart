import 'package:freezed_annotation/freezed_annotation.dart';

part 'appartment_model.freezed.dart';
part 'appartment_model.g.dart';

@freezed
class ApartmentModel with _$ApartmentModel {
  const factory ApartmentModel({
    @Default("") String apartmentID,
    @Default("") String projectId,
    @Default("") String apartmentName,
    @Default("") String locality,
    @Default("") String apartmentType,
    @Default("") String amenities,
    @Default("") String configuration,
    @Default(0.0) double budget,
    @Default(0.0) double flatSize,
    @Default("") String companyName,
    @Default("") String companyPhone,
    @Default("") String noOfFloor,
    @Default("") String noOfFlats,
    @Default("") String noOfBlocks,
    @Default("") String possessionDate,
    @Default("") String clubhouseSize,
    @Default(0) int openSpace,
    @Default("") String createdAt,
    @Default("") String updatedAt,
    @Default("") String image,
    @Default(0.0) double lat,
    @Default(0.0) double long,
    @Default("") String description,
  }) = _AppartmentModel;

  factory ApartmentModel.fromJson(Map<String, dynamic> json) =>
      _$ApartmentModelFromJson(json);
}
