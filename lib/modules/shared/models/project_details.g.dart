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
          json['projectHighlightsDescription'] as List<dynamic>? ?? const [],
      educationalInstitutions:
          json['educationalInstitutions'] as List<dynamic>? ?? const [],
      hospitals: json['hospitals'] as List<dynamic>? ?? const [],
      offices: json['offices'] as List<dynamic>? ?? const [],
      connectivity: json['connectivity'] as List<dynamic>? ?? const [],
      configImages: json['configImages'] as String? ?? "",
      gallery: json['gallery'] as String? ?? "",
      flatSizes: json['flatSizes'] as String? ?? "",
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
      'flatSizes': instance.flatSizes,
    };
