// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'compare_property_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ComparePropertyDataImpl _$$ComparePropertyDataImplFromJson(
        Map<String, dynamic> json) =>
    _$ComparePropertyDataImpl(
      name: json['name'] as String? ?? "",
      builderName: json['builderName'] as String? ?? "",
      projectType: json['projectType'] as String? ?? "",
      projectLocation: json['projectLocation'] as String? ?? "",
      RERAApproval: json['RERAApproval'] as String? ?? "",
      projectSize: json['projectSize'] as String? ?? "",
      noOfUnits: json['noOfUnits'] as String? ?? "",
      noOfFloors: json['noOfFloors'] as String? ?? "",
      noOfTowers: json['noOfTowers'] as String? ?? "",
      totalOpenSpace: json['totalOpenSpace'] as String? ?? "",
      unitPlanConfigs: (json['unitPlanConfigs'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      flatSizes: json['flatSizes'] as String? ?? "",
      configTitle: json['configTitle'] as String? ?? "",
      projectPossession: json['projectPossession'] as String? ?? "",
      Clubhousesize: json['Clubhousesize'] as String? ?? "",
      pricePerSquareFeetRate: json['pricePerSquareFeetRate'] as String? ?? "",
      constructionType: json['constructionType'] as String? ?? "",
      builder: json['builder'] == null
          ? const BuilderContact()
          : BuilderContact.fromJson(json['builder'] as Map<String, dynamic>),
      budgetText: json['budgetText'] as String? ?? "",
    );

Map<String, dynamic> _$$ComparePropertyDataImplToJson(
        _$ComparePropertyDataImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'builderName': instance.builderName,
      'projectType': instance.projectType,
      'projectLocation': instance.projectLocation,
      'RERAApproval': instance.RERAApproval,
      'projectSize': instance.projectSize,
      'noOfUnits': instance.noOfUnits,
      'noOfFloors': instance.noOfFloors,
      'noOfTowers': instance.noOfTowers,
      'totalOpenSpace': instance.totalOpenSpace,
      'unitPlanConfigs': instance.unitPlanConfigs,
      'flatSizes': instance.flatSizes,
      'configTitle': instance.configTitle,
      'projectPossession': instance.projectPossession,
      'Clubhousesize': instance.Clubhousesize,
      'pricePerSquareFeetRate': instance.pricePerSquareFeetRate,
      'constructionType': instance.constructionType,
      'builder': instance.builder,
      'budgetText': instance.budgetText,
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
