// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'appartment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AppartmentModelImpl _$$AppartmentModelImplFromJson(
        Map<String, dynamic> json) =>
    _$AppartmentModelImpl(
      apartmentID: json['apartmentID'] as String? ?? "",
      projectId: json['projectId'] as String? ?? "",
      locality: json['locality'] as String? ?? "",
      apartmentType: json['apartmentType'] as String? ?? "",
      amenities: json['amenities'] as String? ?? "",
      configuration: json['configuration'] as String? ?? "",
      budget: (json['budget'] as num?)?.toDouble() ?? 0.0,
      flatSize: (json['flatSize'] as num?)?.toDouble() ?? 0.0,
      companyName: json['companyName'] as String? ?? "",
      companyPhone: json['companyPhone'] as String? ?? "",
      noOfFloor: json['noOfFloor'] as String? ?? "",
      noOfFlats: json['noOfFlats'] as String? ?? "",
      noOfBlocks: json['noOfBlocks'] as String? ?? "",
      possessionDate: json['possessionDate'] as String? ?? "",
      clubhouseSize: json['clubhouseSize'] as String? ?? "",
      openSpace: (json['openSpace'] as num?)?.toInt() ?? 0,
      createdAt: json['createdAt'] as String? ?? "",
      updatedAt: json['updatedAt'] as String? ?? "",
      appartmentName: json['appartmentName'] as String? ?? "",
    );

Map<String, dynamic> _$$AppartmentModelImplToJson(
        _$AppartmentModelImpl instance) =>
    <String, dynamic>{
      'apartmentID': instance.apartmentID,
      'projectId': instance.projectId,
      'locality': instance.locality,
      'apartmentType': instance.apartmentType,
      'amenities': instance.amenities,
      'configuration': instance.configuration,
      'budget': instance.budget,
      'flatSize': instance.flatSize,
      'companyName': instance.companyName,
      'companyPhone': instance.companyPhone,
      'noOfFloor': instance.noOfFloor,
      'noOfFlats': instance.noOfFlats,
      'noOfBlocks': instance.noOfBlocks,
      'possessionDate': instance.possessionDate,
      'clubhouseSize': instance.clubhouseSize,
      'openSpace': instance.openSpace,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'appartmentName': instance.appartmentName,
    };
