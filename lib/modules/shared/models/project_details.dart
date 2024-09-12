import 'package:freezed_annotation/freezed_annotation.dart';

part 'project_details.freezed.dart';
part 'project_details.g.dart';

@freezed
class ProjectDetails with _$ProjectDetails {
  const factory ProjectDetails({
    @Default("") String projectHighlightsID,
    @Default("") String apartmentID,
    @Default([]) List projectHighlightsDescription,
    @Default([]) List educationalInstitutions,
    @Default([]) List hospitals,
    @Default([]) List offices,
    @Default([]) List connectivity,
    @Default("") String configImages,
    @Default("") String gallery,
    @Default("") String flatSizes,
  }) = _ProjectHighlights;

  factory ProjectDetails.fromJson(Map<String, dynamic> json) =>
      _$ProjectDetailsFromJson(json);
}
