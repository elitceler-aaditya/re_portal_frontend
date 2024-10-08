// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'location_homes_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LocationHomesDataImpl _$$LocationHomesDataImplFromJson(
        Map<String, dynamic> json) =>
    _$LocationHomesDataImpl(
      area: json['area'] as String,
      searchedLocation: json['searchedLocation'] as String,
      projects: (json['projects'] as List<dynamic>)
          .map((e) => LocationProject.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$LocationHomesDataImplToJson(
        _$LocationHomesDataImpl instance) =>
    <String, dynamic>{
      'area': instance.area,
      'searchedLocation': instance.searchedLocation,
      'projects': instance.projects,
    };

_$LocationProjectImpl _$$LocationProjectImplFromJson(
        Map<String, dynamic> json) =>
    _$LocationProjectImpl(
      location: json['location'] as String,
      noOfProjects: (json['noOfProjects'] as num).toInt(),
      projects: (json['projects'] as List<dynamic>)
          .map((e) => ApartmentModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$LocationProjectImplToJson(
        _$LocationProjectImpl instance) =>
    <String, dynamic>{
      'location': instance.location,
      'noOfProjects': instance.noOfProjects,
      'projects': instance.projects,
    };
