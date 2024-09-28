import 'package:freezed_annotation/freezed_annotation.dart';

part 'apartment_details_model.freezed.dart';
part 'apartment_details_model.g.dart';

@freezed
class ApartmentDetailsModel with _$ApartmentDetailsModel {
  const factory ApartmentDetailsModel({
    @Default('') String projectHighlightsID,
    @Default('') String apartmentID,
    @Default([]) List<String> configImages,
    @Default([]) List<String> gallery,
    @Default([]) List<String> highlightsImage11,
    @Default([]) List<String> projectHighlightsDescription,
    @Default([]) List<Institution> educationalInstitutions,
    @Default([]) List<Institution> hospitals,
    @Default([]) List<Institution> offices,
    @Default([]) List<Institution> connectivity,
    @Default('') String flatSizes,
    
  }) = _ApartmentDetailsModel;

  factory ApartmentDetailsModel.fromJson(Map<String, dynamic> json) =>
      _$ApartmentDetailsModelFromJson(json);
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
