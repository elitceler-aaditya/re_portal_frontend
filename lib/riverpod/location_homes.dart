import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:re_portal_frontend/modules/home/models/location_homes_data.dart';

final locationHomesProvider = StateNotifierProvider<LocationHomesNotifier, LocationHomesData?>((ref) {
  return LocationHomesNotifier();
});

class LocationHomesNotifier extends StateNotifier<LocationHomesData?> {
  LocationHomesNotifier() : super(null);

  void setLocationHomesData(Map<String, dynamic> data) {
    state = LocationHomesData.fromJson(data);
  }

  void clearLocationHomesData() {
    state = null;
  }

  String getArea() {
    return state?.area ?? '';
  }

  String getSearchedLocation() {
    return state?.searchedLocation ?? '';
  }

  List<LocationProject> getProjects() {
    return state?.projects ?? [];
  }

  List<String> getLocations() {
    return state?.projects.map((e) => e.location).toList() ?? [];
  }

  LocationProject? getProjectByLocation(String location) {
    return state?.projects.firstWhere(
      (project) => project.location == location,
      orElse: () => const LocationProject(location: '', noOfProjects: 0, projects: []),
    );
  }
}
