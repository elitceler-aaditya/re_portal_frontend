// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserImpl _$$UserImplFromJson(Map<String, dynamic> json) => _$UserImpl(
      uid: json['uid'] as String? ?? "",
      name: json['name'] as String? ?? "",
      email: json['email'] as String? ?? "",
      phoneNumber: json['phoneNumber'] as String? ?? "",
      token: json['token'] as String? ?? "",
    );

Map<String, dynamic> _$$UserImplToJson(_$UserImpl instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'name': instance.name,
      'email': instance.email,
      'phoneNumber': instance.phoneNumber,
      'token': instance.token,
    };
