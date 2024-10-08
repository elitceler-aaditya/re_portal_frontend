// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'builder_data_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BuilderDataModelImpl _$$BuilderDataModelImplFromJson(
        Map<String, dynamic> json) =>
    _$BuilderDataModelImpl(
      builderId: json['builderId'] as String? ?? '',
      builderName: json['builderName'] as String? ?? '',
      CompanyName: json['CompanyName'] as String? ?? '',
      CompanyLogo: json['CompanyLogo'] as String? ?? '',
      builderTotalProjects:
          (json['builderTotalProjects'] as num?)?.toInt() ?? 0,
      projects: (json['projects'] as List<dynamic>?)
              ?.map((e) => ApartmentModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$BuilderDataModelImplToJson(
        _$BuilderDataModelImpl instance) =>
    <String, dynamic>{
      'builderId': instance.builderId,
      'builderName': instance.builderName,
      'CompanyName': instance.CompanyName,
      'CompanyLogo': instance.CompanyLogo,
      'builderTotalProjects': instance.builderTotalProjects,
      'projects': instance.projects,
    };
