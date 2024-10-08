import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:re_portal_frontend/modules/shared/models/appartment_model.dart';

part 'builder_model.freezed.dart';
part 'builder_model.g.dart';

@freezed
class BuilderModel with _$BuilderModel {
  const factory BuilderModel({
    @Default("") String companyName,
    @Default("") String reraId,
    @Default("") String logoLink,
    @Default(0) int totalNoOfProjects,
    @Default([]) List<ApartmentModel> apartments,
  }) = _BuilderModel;

  factory BuilderModel.fromJson(Map<String, dynamic> json) =>
      _$BuilderModelFromJson(json);
}
