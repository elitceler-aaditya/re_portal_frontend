// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project_details.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ProjectHighlightsImpl _$$ProjectHighlightsImplFromJson(
        Map<String, dynamic> json) =>
    _$ProjectHighlightsImpl(
      projectHighlightsID: json['projectHighlightsID'] as String? ?? "",
      apartmentID: json['apartmentID'] as String? ?? "",
      projectHighlightsDescription:
          json['projectHighlightsDescription'] as String? ?? "",
      educationalInstitutions: json['educationalInstitutions'] as String? ?? "",
      hospitals: json['hospitals'] as String? ?? "",
      offices: json['offices'] as String? ?? "",
      connectivity: json['connectivity'] as String? ?? "",
      configImages: json['configImages'] as String? ?? "",
      gallery: json['gallery'] as String? ?? "",
    );

Map<String, dynamic> _$$ProjectHighlightsImplToJson(
        _$ProjectHighlightsImpl instance) =>
    <String, dynamic>{
      'projectHighlightsID': instance.projectHighlightsID,
      'apartmentID': instance.apartmentID,
      'projectHighlightsDescription': instance.projectHighlightsDescription,
      'educationalInstitutions': instance.educationalInstitutions,
      'hospitals': instance.hospitals,
      'offices': instance.offices,
      'connectivity': instance.connectivity,
      'configImages': instance.configImages,
      'gallery': instance.gallery,
    };
