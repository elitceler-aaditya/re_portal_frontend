import 'package:freezed_annotation/freezed_annotation.dart';

part 'builder_model.freezed.dart';
part 'builder_model.g.dart';

@freezed
class BuilderModel with _$BuilderModel {
  const factory BuilderModel({
    @Default("") String projectId,
    @Default("") String builderID,
    @Default("") String name,
    @Default("") String description,
    @Default("") String reraID,
    @Default("") String projectType,
    @Default("") String projectLaunchedDate,
    @Default("") String projectPossession,
    @Default(0) int pricePerSquareFeetRate,
    @Default("") String amenities,
    @Default("") String projectHighlights,
    @Default([]) List<String>? elevationImages,
    @Default([]) List<String>? unitSizes,
    @Default([]) List<String>? unitPlanFiles,
    @Default([]) List<String>? specifications,
  }) = _BuilderModel;

  factory BuilderModel.fromJson(Map<String, dynamic> json) =>
      _$BuilderModelFromJson(json);
}
