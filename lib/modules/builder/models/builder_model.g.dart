// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'builder_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BuilderModelImpl _$$BuilderModelImplFromJson(Map<String, dynamic> json) =>
    _$BuilderModelImpl(
      projectId: json['projectId'] as String? ?? "",
      builderID: json['builderID'] as String? ?? "",
      name: json['name'] as String? ?? "",
      description: json['description'] as String? ?? "",
      reraID: json['reraID'] as String? ?? "",
      projectType: json['projectType'] as String? ?? "",
      projectLaunchedDate: json['projectLaunchedDate'] as String? ?? "",
      projectPossession: json['projectPossession'] as String? ?? "",
      pricePerSquareFeetRate:
          (json['pricePerSquareFeetRate'] as num?)?.toInt() ?? 0,
      amenities: json['amenities'] as String? ?? "",
      projectHighlights: json['projectHighlights'] as String? ?? "",
      elevationImages: (json['elevationImages'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      unitSizes: (json['unitSizes'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      unitPlanFiles: (json['unitPlanFiles'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      specifications: (json['specifications'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$BuilderModelImplToJson(_$BuilderModelImpl instance) =>
    <String, dynamic>{
      'projectId': instance.projectId,
      'builderID': instance.builderID,
      'name': instance.name,
      'description': instance.description,
      'reraID': instance.reraID,
      'projectType': instance.projectType,
      'projectLaunchedDate': instance.projectLaunchedDate,
      'projectPossession': instance.projectPossession,
      'pricePerSquareFeetRate': instance.pricePerSquareFeetRate,
      'amenities': instance.amenities,
      'projectHighlights': instance.projectHighlights,
      'elevationImages': instance.elevationImages,
      'unitSizes': instance.unitSizes,
      'unitPlanFiles': instance.unitPlanFiles,
      'specifications': instance.specifications,
    };
