import 'package:freezed_annotation/freezed_annotation.dart';

part 'compare_property_data.freezed.dart';
part 'compare_property_data.g.dart';

@freezed
class ComparePropertyData with _$ComparePropertyData {
  const factory ComparePropertyData({
    required String name,
    @Default("") String projectType,
    @Default(0) int flatSizes,
    @Default("") String projectStatus,
    @Default(false) bool rERAApproval,
    @Default("") String projectSize,
    @Default("") String noOfTowers,
    @Default("") String noOfFloors,
    @Default([]) List<UnitPlanConfig> unitPlanConfigs,
    @Default("") String projectPossession,
    @Default("") String pricePerSquareFeetRate,
    @Default("") String clubhousesize,
    @Default("") String totalOpenSpace,
    @Default(0) int budget,
    @Default(BuilderContact(CompanyPhone: "")) BuilderContact builder,
  }) = _ComparePropertyData;

  factory ComparePropertyData.fromJson(Map<String, dynamic> json) =>
      _$ComparePropertyDataFromJson(json);
}

@freezed
class UnitPlanConfig with _$UnitPlanConfig {
  const factory UnitPlanConfig({
    required String BHKType,
  }) = _UnitPlanConfig;

  factory UnitPlanConfig.fromJson(Map<String, dynamic> json) =>
      _$UnitPlanConfigFromJson(json);
}

@freezed
class BuilderContact with _$BuilderContact {
  const factory BuilderContact({
    required String CompanyPhone,
  }) = _BuilderContact;

  factory BuilderContact.fromJson(Map<String, dynamic> json) =>
      _$BuilderContactFromJson(json);
}
