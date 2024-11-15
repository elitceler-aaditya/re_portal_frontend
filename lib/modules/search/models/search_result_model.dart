import 'package:re_portal_frontend/modules/shared/models/appartment_model.dart';

class SearchResultModel {
  final List<ApartmentModel> projects;
  final List<BuilderModel> builders;
  final List<String> locations;

  SearchResultModel({
    required this.projects,
    required this.builders, 
    required this.locations,
  });

  factory SearchResultModel.fromJson(Map<String, dynamic> json) {
    return SearchResultModel(
      projects: (json['projects'] as List)
          .map((project) => ApartmentModel.fromJson(project))
          .toList(),
      builders: (json['builders'] as List)
          .map((builder) => BuilderModel.fromJson(builder))
          .toList(),
      locations: List<String>.from(json['locations']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'projects': projects.map((project) => project.toJson()).toList(),
      'builders': builders.map((builder) => builder.toJson()).toList(),
      'locations': locations,
    };
  }
}

class BuilderModel {
  final String name;
  final String? logo;

  BuilderModel({
    required this.name,
    this.logo,
  });

  factory BuilderModel.fromJson(Map<String, dynamic> json) {
    return BuilderModel(
      name: json['name'],
      logo: json['logo'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'logo': logo,
    };
  }
}
