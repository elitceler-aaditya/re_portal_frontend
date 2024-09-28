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
      apartmentName: json['apartmentName'] as String? ?? "",
      locality: json['locality'] as String? ?? "",
      apartmentType: json['apartmentType'] as String? ?? "",
      amenities: json['amenities'] as String? ?? "",
      configuration: json['configuration'] as String? ?? "",
      budget: (json['budget'] as num?)?.toInt() ?? 0,
      flatSize: (json['flatSize'] as num?)?.toInt() ?? 0,
      companyName: json['companyName'] as String? ?? "",
      companyPhone: json['companyPhone'] as String? ?? "",
      noOfFloor: json['noOfFloor'] as String? ?? "",
      noOfFlats: json['noOfFlats'] as String? ?? "",
      noOfBlocks: json['noOfBlocks'] as String? ?? "",
      noOfTower: json['noOfTower'] as String? ?? "",
      noOfUnits: json['noOfUnits'] as String? ?? "",
      possessionDate: json['possessionDate'] as String? ?? "",
      clubhouseSize: json['clubhouseSize'] as String? ?? "",
      openSpace: (json['openSpace'] as num?)?.toInt() ?? null,
      image: json['image'] as String? ?? "",
      lat: (json['lat'] as num?)?.toDouble() ?? 0.0,
      long: (json['long'] as num?)?.toDouble() ?? 0.0,
      description: json['description'] as String? ?? "",
      images: (json['images'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      aWSKEYs: (json['aWSKEYs'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      reraApproval: json['reraApproval'] as bool? ?? false,
      createdAt: json['createdAt'] as String? ?? "",
      updatedAt: json['updatedAt'] as String? ?? "",
    );

Map<String, dynamic> _$$AppartmentModelImplToJson(
        _$AppartmentModelImpl instance) =>
    <String, dynamic>{
      'apartmentID': instance.apartmentID,
      'projectId': instance.projectId,
      'apartmentName': instance.apartmentName,
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
      'noOfTower': instance.noOfTower,
      'noOfUnits': instance.noOfUnits,
      'possessionDate': instance.possessionDate,
      'clubhouseSize': instance.clubhouseSize,
      'openSpace': instance.openSpace,
      'image': instance.image,
      'lat': instance.lat,
      'long': instance.long,
      'description': instance.description,
      'images': instance.images,
      'aWSKEYs': instance.aWSKEYs,
      'reraApproval': instance.reraApproval,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
    };
