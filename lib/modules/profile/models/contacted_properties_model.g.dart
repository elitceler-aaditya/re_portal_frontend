// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contacted_properties_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ContactedPropertyModelImpl _$$ContactedPropertyModelImplFromJson(
        Map<String, dynamic> json) =>
    _$ContactedPropertyModelImpl(
      leadId: json['leadId'] as String? ?? '',
      userId: json['userId'] as String? ?? '',
      name: json['name'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      email: json['email'] as String? ?? '',
      enquiryDetails: json['enquiryDetails'] as String? ?? '',
      apartmentId: json['apartmentId'] as String? ?? '',
      projectId: json['projectId'] as String? ?? '',
      builderId: json['builderId'] as String? ?? '',
      emailSent: json['emailSent'] as bool? ?? false,
      createdAt: json['createdAt'] as String? ?? '',
      updatedAt: json['updatedAt'] as String? ?? '',
      project: json['project'] == null
          ? const ProjectDetails(name: '', projectLocation: '')
          : ProjectDetails.fromJson(json['project'] as Map<String, dynamic>),
      builder: json['builder'] == null
          ? const BuilderDetails(name: '', CompanyName: '')
          : BuilderDetails.fromJson(json['builder'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$ContactedPropertyModelImplToJson(
        _$ContactedPropertyModelImpl instance) =>
    <String, dynamic>{
      'leadId': instance.leadId,
      'userId': instance.userId,
      'name': instance.name,
      'phone': instance.phone,
      'email': instance.email,
      'enquiryDetails': instance.enquiryDetails,
      'apartmentId': instance.apartmentId,
      'projectId': instance.projectId,
      'builderId': instance.builderId,
      'emailSent': instance.emailSent,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'project': instance.project,
      'builder': instance.builder,
    };

_$ProjectDetailsImpl _$$ProjectDetailsImplFromJson(Map<String, dynamic> json) =>
    _$ProjectDetailsImpl(
      name: json['name'] as String,
      projectLocation: json['projectLocation'] as String,
    );

Map<String, dynamic> _$$ProjectDetailsImplToJson(
        _$ProjectDetailsImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'projectLocation': instance.projectLocation,
    };

_$BuilderDetailsImpl _$$BuilderDetailsImplFromJson(Map<String, dynamic> json) =>
    _$BuilderDetailsImpl(
      name: json['name'] as String? ?? '',
      CompanyName: json['CompanyName'] as String? ?? '',
      phoneNumber: json['phoneNumber'] as String? ?? '',
    );

Map<String, dynamic> _$$BuilderDetailsImplToJson(
        _$BuilderDetailsImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'CompanyName': instance.CompanyName,
      'phoneNumber': instance.phoneNumber,
    };
