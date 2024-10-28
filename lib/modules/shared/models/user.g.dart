// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserImpl _$$UserImplFromJson(Map<String, dynamic> json) => _$UserImpl(
      token: json['token'] as String? ?? "",
      userId: json['userId'] as String? ?? "",
      name: json['name'] as String? ?? "",
      email: json['email'] as String? ?? "",
      phoneNumber: json['phoneNumber'] as String? ?? "",
      iat: (json['iat'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$UserImplToJson(_$UserImpl instance) =>
    <String, dynamic>{
      'token': instance.token,
      'userId': instance.userId,
      'name': instance.name,
      'email': instance.email,
      'phoneNumber': instance.phoneNumber,
      'iat': instance.iat,
    };
