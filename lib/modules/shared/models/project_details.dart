import 'package:freezed_annotation/freezed_annotation.dart';

part 'project_details.freezed.dart';
part 'project_details.g.dart';

@freezed
class ProjectDetails with _$ProjectDetails {
  const factory ProjectDetails({
    @Default("") String projectHighlightsID,
    @Default("") String apartmentID,
    @Default("") String projectHighlightsDescription,
    @Default("") String educationalInstitutions,
    @Default("") String hospitals,
    @Default("") String offices,
    @Default("") String connectivity,
    @Default("") String configImages,
    @Default("") String gallery,
  }) = _ProjectHighlights;

  factory ProjectDetails.fromJson(Map<String, dynamic> json) =>
      _$ProjectDetailsFromJson(json);
}
