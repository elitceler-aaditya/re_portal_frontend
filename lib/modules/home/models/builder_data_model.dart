import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:re_portal_frontend/modules/shared/models/appartment_model.dart';

part 'builder_data_model.freezed.dart';
part 'builder_data_model.g.dart';

@freezed
class BuilderDataModel with _$BuilderDataModel {
  const factory BuilderDataModel({
    @Default('') String builderId,
    @Default('') String builderName,
    @Default('') String CompanyName,
    @Default('') String CompanyLogo,
    @Default(0) int builderTotalProjects,
    @Default([]) List<ApartmentModel> projects,
  }) = _BuilderDataModel;

  factory BuilderDataModel.fromJson(Map<String, dynamic> json) =>
      _$BuilderDataModelFromJson(json);
}
