// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'appartment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ApartmentModelImpl _$$ApartmentModelImplFromJson(Map<String, dynamic> json) =>
    _$ApartmentModelImpl(
      projectId: json['projectId'] as String? ?? "",
      builderID: json['builderID'] as String? ?? "",
      builderName: json['builderName'] as String? ?? "",
      apartmentID: json['apartmentID'] as String? ?? "",
      companyPhone: json['companyPhone'] as String? ?? "",
      companyName: json['companyName'] as String? ?? "",
      companyLogo: json['companyLogo'] as String? ?? "",
      name: json['name'] as String? ?? "",
      description: json['description'] as String? ?? "",
      projectLocation: json['projectLocation'] as String? ?? "",
      pricePerSquareFeetRate:
          (json['pricePerSquareFeetRate'] as num?)?.toInt() ?? 0,
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
      projectPossession: json['projectPossession'] as String? ?? "",
      coverImage: json['coverImage'] as String? ?? "",
      projectGallery: (json['projectGallery'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      configuration: (json['configuration'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      configTitle: json['configTitle'] as String? ?? "",
      videoLink: json['videoLink'] as String? ?? null,
      flatSize: (json['flatSize'] as num?)?.toInt() ?? 0,
      budget: (json['budget'] as num?)?.toInt() ?? 0,
      minBudget: (json['minBudget'] as num?)?.toInt() ?? 0,
      maxBudget: (json['maxBudget'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$ApartmentModelImplToJson(
        _$ApartmentModelImpl instance) =>
    <String, dynamic>{
      'projectId': instance.projectId,
      'builderID': instance.builderID,
      'builderName': instance.builderName,
      'apartmentID': instance.apartmentID,
      'companyPhone': instance.companyPhone,
      'companyName': instance.companyName,
      'companyLogo': instance.companyLogo,
      'name': instance.name,
      'description': instance.description,
      'projectLocation': instance.projectLocation,
      'pricePerSquareFeetRate': instance.pricePerSquareFeetRate,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'projectPossession': instance.projectPossession,
      'coverImage': instance.coverImage,
      'projectGallery': instance.projectGallery,
      'configuration': instance.configuration,
      'configTitle': instance.configTitle,
      'videoLink': instance.videoLink,
      'flatSize': instance.flatSize,
      'budget': instance.budget,
      'minBudget': instance.minBudget,
      'maxBudget': instance.maxBudget,
    };
