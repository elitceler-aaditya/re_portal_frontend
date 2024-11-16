import 'package:freezed_annotation/freezed_annotation.dart';

part 'compare_property_data.freezed.dart';
part 'compare_property_data.g.dart';

@freezed
class ComparePropertyData with _$ComparePropertyData {
  const factory ComparePropertyData({
 @Default("") String name,
    @Default("") String builderName,
    @Default("") String projectType,
    @Default("") String projectLocation,
    @Default("") String RERAApproval,
    @Default("") String projectSize,
    @Default("") String noOfUnits,
    @Default("") String noOfFloors,
    @Default("") String noOfTowers,
    @Default("") String totalOpenSpace,
    @Default([]) List<String> unitPlanConfigs,
    @Default("") String flatSizes,
    @Default("") String configTitle,
    @Default("") String projectPossession,
    @Default("") String Clubhousesize,
    @Default("") String pricePerSquareFeetRate,
    @Default("") String constructionType,
    @Default(BuilderContact()) BuilderContact builder,
    @Default("") String budgetText,
  }) = _ComparePropertyData;

  factory ComparePropertyData.fromJson(Map<String, dynamic> json) =>
      _$ComparePropertyDataFromJson(json);
}

@freezed
class BuilderContact with _$BuilderContact {
  const factory BuilderContact({
    @Default("") String CompanyPhone,
    @Default("") String CompanyName,
  }) = _BuilderContact;

  factory BuilderContact.fromJson(Map<String, dynamic> json) =>
      _$BuilderContactFromJson(json);
}
