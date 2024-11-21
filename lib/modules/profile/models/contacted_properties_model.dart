import 'package:freezed_annotation/freezed_annotation.dart';

part 'contacted_properties_model.freezed.dart';
part 'contacted_properties_model.g.dart';

@freezed
class ContactedPropertyModel with _$ContactedPropertyModel {
  const factory ContactedPropertyModel({
    @Default('') String leadId,
    @Default('') String userId,
    @Default('') String name,
    @Default('') String phone,
    @Default('') String email,
    @Default('') String enquiryDetails,
    @Default('') String? apartmentId,
    @Default('') String projectId,
    @Default('') String builderId,
    @Default(false) bool emailSent,
    @Default('') String createdAt,
    @Default('') String updatedAt,
    @Default(ProjectDetails(name: '', projectLocation: ''))
    ProjectDetails project,
    @Default(BuilderDetails(name: '', CompanyName: '')) BuilderDetails builder,
  }) = _ContactedPropertyModel;

  factory ContactedPropertyModel.fromJson(Map<String, dynamic> json) =>
      _$ContactedPropertyModelFromJson(json);
}

@freezed
class ProjectDetails with _$ProjectDetails {
  const factory ProjectDetails({
    required String name,
    required String projectLocation,
  }) = _ProjectDetails;

  factory ProjectDetails.fromJson(Map<String, dynamic> json) =>
      _$ProjectDetailsFromJson(json);
}

@freezed
class BuilderDetails with _$BuilderDetails {
  const factory BuilderDetails({
    @Default('') String name,
    @Default('') String CompanyName,
    @Default('') String phoneNumber,
  }) = _BuilderDetails;

  factory BuilderDetails.fromJson(Map<String, dynamic> json) =>
      _$BuilderDetailsFromJson(json);
}
