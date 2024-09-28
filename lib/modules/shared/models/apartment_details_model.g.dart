// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'apartment_details_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ApartmentDetailsModelImpl _$$ApartmentDetailsModelImplFromJson(
        Map<String, dynamic> json) =>
    _$ApartmentDetailsModelImpl(
      projectHighlightsID: json['projectHighlightsID'] as String? ?? '',
      apartmentID: json['apartmentID'] as String? ?? '',
      configImages: (json['configImages'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      gallery: (json['gallery'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      highlightsImage11: (json['highlightsImage11'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      projectHighlightsDescription:
          (json['projectHighlightsDescription'] as List<dynamic>?)
                  ?.map((e) => e as String)
                  .toList() ??
              const [],
      educationalInstitutions:
          (json['educationalInstitutions'] as List<dynamic>?)
                  ?.map((e) => Institution.fromJson(e as Map<String, dynamic>))
                  .toList() ??
              const [],
      hospitals: (json['hospitals'] as List<dynamic>?)
              ?.map((e) => Institution.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      offices: (json['offices'] as List<dynamic>?)
              ?.map((e) => Institution.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      connectivity: (json['connectivity'] as List<dynamic>?)
              ?.map((e) => Institution.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      flatSizes: json['flatSizes'] as String? ?? '',
    );

Map<String, dynamic> _$$ApartmentDetailsModelImplToJson(
        _$ApartmentDetailsModelImpl instance) =>
    <String, dynamic>{
      'projectHighlightsID': instance.projectHighlightsID,
      'apartmentID': instance.apartmentID,
      'configImages': instance.configImages,
      'gallery': instance.gallery,
      'highlightsImage11': instance.highlightsImage11,
      'projectHighlightsDescription': instance.projectHighlightsDescription,
      'educationalInstitutions': instance.educationalInstitutions,
      'hospitals': instance.hospitals,
      'offices': instance.offices,
      'connectivity': instance.connectivity,
      'flatSizes': instance.flatSizes,
    };

_$InstitutionImpl _$$InstitutionImplFromJson(Map<String, dynamic> json) =>
    _$InstitutionImpl(
      name: json['name'] as String? ?? '',
      dist: json['dist'] as String? ?? '',
      time: json['time'] as String? ?? '',
    );

Map<String, dynamic> _$$InstitutionImplToJson(_$InstitutionImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'dist': instance.dist,
      'time': instance.time,
    };
