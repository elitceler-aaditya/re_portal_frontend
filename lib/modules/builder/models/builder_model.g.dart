// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'builder_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BuilderModelImpl _$$BuilderModelImplFromJson(Map<String, dynamic> json) =>
    _$BuilderModelImpl(
      companyName: json['companyName'] as String? ?? "",
      reraId: json['reraId'] as String? ?? "",
      logoLink: json['logoLink'] as String? ?? "",
      totalNoOfProjects: (json['totalNoOfProjects'] as num?)?.toInt() ?? 0,
      apartments: (json['apartments'] as List<dynamic>?)
              ?.map((e) => ApartmentModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$BuilderModelImplToJson(_$BuilderModelImpl instance) =>
    <String, dynamic>{
      'companyName': instance.companyName,
      'reraId': instance.reraId,
      'logoLink': instance.logoLink,
      'totalNoOfProjects': instance.totalNoOfProjects,
      'apartments': instance.apartments,
    };
