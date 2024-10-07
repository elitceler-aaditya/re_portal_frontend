// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'appartment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ApartmentModelImpl _$$ApartmentModelImplFromJson(Map<String, dynamic> json) =>
    _$ApartmentModelImpl(
      projectId: json['projectId'] as String? ?? "",
      builderID: json['builderID'] as String? ?? "",
      apartmentID: json['apartmentID'] as String? ?? "",
      companyPhone: json['companyPhone'] as String? ?? "",
      companyName: json['companyName'] as String? ?? "",
      name: json['name'] as String? ?? "",
      description: json['description'] as String? ?? "",
      projectLocation: json['projectLocation'] as String? ?? "",
      pricePerSquareFeetRate:
          (json['pricePerSquareFeetRate'] as num?)?.toInt() ?? 0,
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
      coverImage: json['coverImage'] as String? ?? "",
      projectGallery: (json['projectGallery'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      configuration: (json['configuration'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      videoLink: json['videoLink'] as String? ?? null,
      flatSize: (json['flatSize'] as num?)?.toInt() ?? 0,
      budget: (json['budget'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$ApartmentModelImplToJson(
        _$ApartmentModelImpl instance) =>
    <String, dynamic>{
      'projectId': instance.projectId,
      'builderID': instance.builderID,
      'apartmentID': instance.apartmentID,
      'companyPhone': instance.companyPhone,
      'companyName': instance.companyName,
      'name': instance.name,
      'description': instance.description,
      'projectLocation': instance.projectLocation,
      'pricePerSquareFeetRate': instance.pricePerSquareFeetRate,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'coverImage': instance.coverImage,
      'projectGallery': instance.projectGallery,
      'configuration': instance.configuration,
      'videoLink': instance.videoLink,
      'flatSize': instance.flatSize,
      'budget': instance.budget,
    };
