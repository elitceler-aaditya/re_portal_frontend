// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'apartment_details_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ApartmentDetailsResponseImpl _$$ApartmentDetailsResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$ApartmentDetailsResponseImpl(
      message: json['message'] as String? ?? '',
      projectImages: (json['projectImages'] as List<dynamic>?)
              ?.map(
                  (e) => ProjectImageModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      projectDetails: json['projectDetails'] == null
          ? const ProjectDetails()
          : ProjectDetails.fromJson(
              json['projectDetails'] as Map<String, dynamic>),
      unitPlanConfigFilesFormatted: (json['unitPlanConfigFilesFormatted']
                  as List<dynamic>?)
              ?.map((e) => UnitPlanConfig.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$ApartmentDetailsResponseImplToJson(
        _$ApartmentDetailsResponseImpl instance) =>
    <String, dynamic>{
      'message': instance.message,
      'projectImages': instance.projectImages,
      'projectDetails': instance.projectDetails,
      'unitPlanConfigFilesFormatted': instance.unitPlanConfigFilesFormatted,
    };

_$ProjectImageModelImpl _$$ProjectImageModelImplFromJson(
        Map<String, dynamic> json) =>
    _$ProjectImageModelImpl(
      title: json['title'] as String? ?? '',
      images: (json['images'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$ProjectImageModelImplToJson(
        _$ProjectImageModelImpl instance) =>
    <String, dynamic>{
      'title': instance.title,
      'images': instance.images,
    };

_$ProjectDetailsImpl _$$ProjectDetailsImplFromJson(Map<String, dynamic> json) =>
    _$ProjectDetailsImpl(
      projectId: json['projectId'] as String? ?? '',
      builderID: json['builderID'] as String? ?? '',
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      projectLocation: json['projectLocation'] as String? ?? '',
      projectSize: json['projectSize'] as String? ?? '',
      noOfFloors: json['noOfFloors'] as String? ?? '',
      noOfFlats: json['noOfFlats'] as String? ?? '',
      noOfTowers: json['noOfTowers'] as String? ?? '',
      noOfFlatsPerFloor: json['noOfFlatsPerFloor'] as String? ?? '',
      clubhousesize: json['clubhousesize'] as String? ?? '',
      totalOpenSpace: json['totalOpenSpace'] as String? ?? '',
      constructionType: json['constructionType'] as String? ?? '',
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
      reraID: json['reraID'] as String? ?? '',
      projectType: json['projectType'] as String? ?? '',
      projectLaunchedDate: json['projectLaunchedDate'] as String? ?? '',
      projectPossession: json['projectPossession'] as String? ?? '',
      pricePerSquareFeetRate: json['pricePerSquareFeetRate'] as String? ?? '0',
      totalArea: json['totalArea'] as String? ?? '',
      landMark: json['landMark'] as String? ?? '',
      nearByHighlights: json['nearByHighlights'] as String? ?? '',
      amenities: json['amenities'] as String? ?? '',
      clubHouseAmenities: json['clubHouseAmenities'] as String? ?? '',
      outdoorAmenities: json['outdoorAmenities'] as String? ?? '',
      specifications: (json['specifications'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      projectHighlightsPoints:
          (json['projectHighlightsPoints'] as List<dynamic>?)
                  ?.map((e) => e as String)
                  .toList() ??
              const [],
      builder: json['builder'] == null
          ? const Builder()
          : Builder.fromJson(json['builder'] as Map<String, dynamic>),
      educationalInstitutions:
          (json['educationalInstitutions'] as List<dynamic>?)
                  ?.map((e) => Institution.fromJson(e as Map<String, dynamic>))
                  .toList() ??
              const [],
      hospitals: (json['hospitals'] as List<dynamic>?)
              ?.map((e) => Institution.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      offices: (json['offices'] as List<dynamic>?)
              ?.map((e) => Institution.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      connectivity: (json['connectivity'] as List<dynamic>?)
              ?.map((e) => Institution.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      bankName: json['bankName'] as String? ?? '',
      loanPercentage: (json['loanPercentage'] as num?)?.toInt() ?? 0,
      banks: (json['banks'] as List<dynamic>?)
              ?.map((e) => Bank.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      restaurants: (json['restaurants'] as List<dynamic>?)
              ?.map((e) => Institution.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      colleges: (json['colleges'] as List<dynamic>?)
              ?.map((e) => Institution.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      pharmacies: (json['pharmacies'] as List<dynamic>?)
              ?.map((e) => Institution.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      hotspots: (json['hotspots'] as List<dynamic>?)
              ?.map((e) => Institution.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      shopping: (json['shopping'] as List<dynamic>?)
              ?.map((e) => Institution.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      entertainment: (json['entertainment'] as List<dynamic>?)
              ?.map((e) => Institution.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$ProjectDetailsImplToJson(
        _$ProjectDetailsImpl instance) =>
    <String, dynamic>{
      'projectId': instance.projectId,
      'builderID': instance.builderID,
      'name': instance.name,
      'description': instance.description,
      'projectLocation': instance.projectLocation,
      'projectSize': instance.projectSize,
      'noOfFloors': instance.noOfFloors,
      'noOfFlats': instance.noOfFlats,
      'noOfTowers': instance.noOfTowers,
      'noOfFlatsPerFloor': instance.noOfFlatsPerFloor,
      'clubhousesize': instance.clubhousesize,
      'totalOpenSpace': instance.totalOpenSpace,
      'constructionType': instance.constructionType,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'reraID': instance.reraID,
      'projectType': instance.projectType,
      'projectLaunchedDate': instance.projectLaunchedDate,
      'projectPossession': instance.projectPossession,
      'pricePerSquareFeetRate': instance.pricePerSquareFeetRate,
      'totalArea': instance.totalArea,
      'landMark': instance.landMark,
      'nearByHighlights': instance.nearByHighlights,
      'amenities': instance.amenities,
      'clubHouseAmenities': instance.clubHouseAmenities,
      'outdoorAmenities': instance.outdoorAmenities,
      'specifications': instance.specifications,
      'projectHighlightsPoints': instance.projectHighlightsPoints,
      'builder': instance.builder,
      'educationalInstitutions': instance.educationalInstitutions,
      'hospitals': instance.hospitals,
      'offices': instance.offices,
      'connectivity': instance.connectivity,
      'bankName': instance.bankName,
      'loanPercentage': instance.loanPercentage,
      'banks': instance.banks,
      'restaurants': instance.restaurants,
      'colleges': instance.colleges,
      'pharmacies': instance.pharmacies,
      'hotspots': instance.hotspots,
      'shopping': instance.shopping,
      'entertainment': instance.entertainment,
    };

_$BankImpl _$$BankImplFromJson(Map<String, dynamic> json) => _$BankImpl(
      bankName: json['bankName'] as String? ?? '',
      bankLogo: json['bankLogo'] as String? ?? '',
      loanPercentage: (json['loanPercentage'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$BankImplToJson(_$BankImpl instance) =>
    <String, dynamic>{
      'bankName': instance.bankName,
      'bankLogo': instance.bankLogo,
      'loanPercentage': instance.loanPercentage,
    };

_$BuilderImpl _$$BuilderImplFromJson(Map<String, dynamic> json) =>
    _$BuilderImpl(
      CompanyPhone: json['CompanyPhone'] as String? ?? '',
      CompanyName: json['CompanyName'] as String? ?? '',
    );

Map<String, dynamic> _$$BuilderImplToJson(_$BuilderImpl instance) =>
    <String, dynamic>{
      'CompanyPhone': instance.CompanyPhone,
      'CompanyName': instance.CompanyName,
    };

_$InstitutionImpl _$$InstitutionImplFromJson(Map<String, dynamic> json) =>
    _$InstitutionImpl(
      name: json['name'] as String? ?? '',
      dist: json['dist'] as String? ?? '',
      time: json['time'] as String? ?? '',
    );

Map<String, dynamic> _$$InstitutionImplToJson(_$InstitutionImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'dist': instance.dist,
      'time': instance.time,
    };

_$UnitPlanConfigImpl _$$UnitPlanConfigImplFromJson(Map<String, dynamic> json) =>
    _$UnitPlanConfigImpl(
      bHKType: json['bHKType'] as String? ?? '',
      sizeInSqft: json['sizeInSqft'] as String? ?? '',
      facing: json['facing'] as String? ?? '',
      unitPlanConfigFiles: (json['unitPlanConfigFiles'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$UnitPlanConfigImplToJson(
        _$UnitPlanConfigImpl instance) =>
    <String, dynamic>{
      'bHKType': instance.bHKType,
      'sizeInSqft': instance.sizeInSqft,
      'facing': instance.facing,
      'unitPlanConfigFiles': instance.unitPlanConfigFiles,
    };
