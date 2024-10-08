import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:re_portal_frontend/modules/shared/models/appartment_model.dart';

part 'location_homes_data.freezed.dart';
part 'location_homes_data.g.dart';

@freezed
class LocationHomesData with _$LocationHomesData {
  const factory LocationHomesData({
    required String area,
    required String searchedLocation,
    required List<LocationProject> projects,
  }) = _LocationHomesData;

  factory LocationHomesData.fromJson(Map<String, dynamic> json) =>
      _$LocationHomesDataFromJson(json);
}

@freezed
class LocationProject with _$LocationProject {
  const factory LocationProject({
    required String location,
    required int noOfProjects,
    required List<ApartmentModel> projects,
  }) = _LocationProject;

  factory LocationProject.fromJson(Map<String, dynamic> json) =>
      _$LocationProjectFromJson(json);
}
