// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'compare_property_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ComparePropertyDataImpl _$$ComparePropertyDataImplFromJson(
        Map<String, dynamic> json) =>
    _$ComparePropertyDataImpl(
      name: json['name'] as String? ?? "",
      projectType: json['projectType'] as String? ?? "",
      flatSizes: (json['flatSizes'] as num?)?.toInt() ?? 0,
      projectLocation: json['projectLocation'] as String? ?? "",
      projectStatus: json['projectStatus'] as String? ?? "",
      rERAApproval: json['rERAApproval'] as bool? ?? false,
      projectSize: json['projectSize'] as String? ?? "",
      noOfTowers: json['noOfTowers'] as String? ?? "",
      noOfFloors: json['noOfFloors'] as String? ?? "",
      unitPlanConfigs: (json['unitPlanConfigs'] as List<dynamic>?)
              ?.map((e) => UnitPlanConfig.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      projectPossession: json['projectPossession'] as String? ?? "",
      pricePerSquareFeetRate: json['pricePerSquareFeetRate'] as String? ?? "",
      clubhousesize: json['clubhousesize'] as String? ?? "",
      totalOpenSpace: json['totalOpenSpace'] as String? ?? "",
      constructionType: json['constructionType'] as String? ?? "",
      budget: (json['budget'] as num?)?.toInt() ?? 0,
      builder: json['builder'] == null
          ? const BuilderContact()
          : BuilderContact.fromJson(json['builder'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$ComparePropertyDataImplToJson(
        _$ComparePropertyDataImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'projectType': instance.projectType,
      'flatSizes': instance.flatSizes,
      'projectLocation': instance.projectLocation,
      'projectStatus': instance.projectStatus,
      'rERAApproval': instance.rERAApproval,
      'projectSize': instance.projectSize,
      'noOfTowers': instance.noOfTowers,
      'noOfFloors': instance.noOfFloors,
      'unitPlanConfigs': instance.unitPlanConfigs,
      'projectPossession': instance.projectPossession,
      'pricePerSquareFeetRate': instance.pricePerSquareFeetRate,
      'clubhousesize': instance.clubhousesize,
      'totalOpenSpace': instance.totalOpenSpace,
      'constructionType': instance.constructionType,
      'budget': instance.budget,
      'builder': instance.builder,
    };

_$UnitPlanConfigImpl _$$UnitPlanConfigImplFromJson(Map<String, dynamic> json) =>
    _$UnitPlanConfigImpl(
      BHKType: json['BHKType'] as String? ?? "",
    );

Map<String, dynamic> _$$UnitPlanConfigImplToJson(
        _$UnitPlanConfigImpl instance) =>
    <String, dynamic>{
      'BHKType': instance.BHKType,
    };

_$BuilderContactImpl _$$BuilderContactImplFromJson(Map<String, dynamic> json) =>
    _$BuilderContactImpl(
      CompanyPhone: json['CompanyPhone'] as String? ?? "",
      CompanyName: json['CompanyName'] as String? ?? "",
    );

Map<String, dynamic> _$$BuilderContactImplToJson(
        _$BuilderContactImpl instance) =>
    <String, dynamic>{
      'CompanyPhone': instance.CompanyPhone,
      'CompanyName': instance.CompanyName,
    };
