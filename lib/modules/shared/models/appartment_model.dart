import 'package:freezed_annotation/freezed_annotation.dart';

part 'appartment_model.freezed.dart';
part 'appartment_model.g.dart';

@freezed
class AppartmentModel with _$AppartmentModel {
  const factory AppartmentModel({

    @Default("") String apartmentID,
    @Default("") String projectId,
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
    @Default("") String apartmentName,
    @Default("") String image,
  }) = _AppartmentModel;

  factory AppartmentModel.fromJson(Map<String, dynamic> json) =>
      _$AppartmentModelFromJson(json);
}