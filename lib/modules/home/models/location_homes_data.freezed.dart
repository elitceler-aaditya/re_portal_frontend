// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'location_homes_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

LocationHomesData _$LocationHomesDataFromJson(Map<String, dynamic> json) {
  return _LocationHomesData.fromJson(json);
}

/// @nodoc
mixin _$LocationHomesData {
  String get area => throw _privateConstructorUsedError;
  String get searchedLocation => throw _privateConstructorUsedError;
  List<LocationProject> get projects => throw _privateConstructorUsedError;

  /// Serializes this LocationHomesData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of LocationHomesData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LocationHomesDataCopyWith<LocationHomesData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LocationHomesDataCopyWith<$Res> {
  factory $LocationHomesDataCopyWith(
          LocationHomesData value, $Res Function(LocationHomesData) then) =
      _$LocationHomesDataCopyWithImpl<$Res, LocationHomesData>;
  @useResult
  $Res call(
      {String area, String searchedLocation, List<LocationProject> projects});
}

/// @nodoc
class _$LocationHomesDataCopyWithImpl<$Res, $Val extends LocationHomesData>
    implements $LocationHomesDataCopyWith<$Res> {
  _$LocationHomesDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LocationHomesData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? area = null,
    Object? searchedLocation = null,
    Object? projects = null,
  }) {
    return _then(_value.copyWith(
      area: null == area
          ? _value.area
          : area // ignore: cast_nullable_to_non_nullable
              as String,
      searchedLocation: null == searchedLocation
          ? _value.searchedLocation
          : searchedLocation // ignore: cast_nullable_to_non_nullable
              as String,
      projects: null == projects
          ? _value.projects
          : projects // ignore: cast_nullable_to_non_nullable
              as List<LocationProject>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$LocationHomesDataImplCopyWith<$Res>
    implements $LocationHomesDataCopyWith<$Res> {
  factory _$$LocationHomesDataImplCopyWith(_$LocationHomesDataImpl value,
          $Res Function(_$LocationHomesDataImpl) then) =
      __$$LocationHomesDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String area, String searchedLocation, List<LocationProject> projects});
}

/// @nodoc
class __$$LocationHomesDataImplCopyWithImpl<$Res>
    extends _$LocationHomesDataCopyWithImpl<$Res, _$LocationHomesDataImpl>
    implements _$$LocationHomesDataImplCopyWith<$Res> {
  __$$LocationHomesDataImplCopyWithImpl(_$LocationHomesDataImpl _value,
      $Res Function(_$LocationHomesDataImpl) _then)
      : super(_value, _then);

  /// Create a copy of LocationHomesData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? area = null,
    Object? searchedLocation = null,
    Object? projects = null,
  }) {
    return _then(_$LocationHomesDataImpl(
      area: null == area
          ? _value.area
          : area // ignore: cast_nullable_to_non_nullable
              as String,
      searchedLocation: null == searchedLocation
          ? _value.searchedLocation
          : searchedLocation // ignore: cast_nullable_to_non_nullable
              as String,
      projects: null == projects
          ? _value._projects
          : projects // ignore: cast_nullable_to_non_nullable
              as List<LocationProject>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$LocationHomesDataImpl implements _LocationHomesData {
  const _$LocationHomesDataImpl(
      {required this.area,
      required this.searchedLocation,
      required final List<LocationProject> projects})
      : _projects = projects;

  factory _$LocationHomesDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$LocationHomesDataImplFromJson(json);

  @override
  final String area;
  @override
  final String searchedLocation;
  final List<LocationProject> _projects;
  @override
  List<LocationProject> get projects {
    if (_projects is EqualUnmodifiableListView) return _projects;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_projects);
  }

  @override
  String toString() {
    return 'LocationHomesData(area: $area, searchedLocation: $searchedLocation, projects: $projects)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LocationHomesDataImpl &&
            (identical(other.area, area) || other.area == area) &&
            (identical(other.searchedLocation, searchedLocation) ||
                other.searchedLocation == searchedLocation) &&
            const DeepCollectionEquality().equals(other._projects, _projects));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, area, searchedLocation,
      const DeepCollectionEquality().hash(_projects));

  /// Create a copy of LocationHomesData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LocationHomesDataImplCopyWith<_$LocationHomesDataImpl> get copyWith =>
      __$$LocationHomesDataImplCopyWithImpl<_$LocationHomesDataImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LocationHomesDataImplToJson(
      this,
    );
  }
}

abstract class _LocationHomesData implements LocationHomesData {
  const factory _LocationHomesData(
      {required final String area,
      required final String searchedLocation,
      required final List<LocationProject> projects}) = _$LocationHomesDataImpl;

  factory _LocationHomesData.fromJson(Map<String, dynamic> json) =
      _$LocationHomesDataImpl.fromJson;

  @override
  String get area;
  @override
  String get searchedLocation;
  @override
  List<LocationProject> get projects;

  /// Create a copy of LocationHomesData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LocationHomesDataImplCopyWith<_$LocationHomesDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

LocationProject _$LocationProjectFromJson(Map<String, dynamic> json) {
  return _LocationProject.fromJson(json);
}

/// @nodoc
mixin _$LocationProject {
  String get location => throw _privateConstructorUsedError;
  int get noOfProjects => throw _privateConstructorUsedError;
  List<ApartmentModel> get projects => throw _privateConstructorUsedError;

  /// Serializes this LocationProject to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of LocationProject
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LocationProjectCopyWith<LocationProject> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LocationProjectCopyWith<$Res> {
  factory $LocationProjectCopyWith(
          LocationProject value, $Res Function(LocationProject) then) =
      _$LocationProjectCopyWithImpl<$Res, LocationProject>;
  @useResult
  $Res call({String location, int noOfProjects, List<ApartmentModel> projects});
}

/// @nodoc
class _$LocationProjectCopyWithImpl<$Res, $Val extends LocationProject>
    implements $LocationProjectCopyWith<$Res> {
  _$LocationProjectCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LocationProject
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? location = null,
    Object? noOfProjects = null,
    Object? projects = null,
  }) {
    return _then(_value.copyWith(
      location: null == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as String,
      noOfProjects: null == noOfProjects
          ? _value.noOfProjects
          : noOfProjects // ignore: cast_nullable_to_non_nullable
              as int,
      projects: null == projects
          ? _value.projects
          : projects // ignore: cast_nullable_to_non_nullable
              as List<ApartmentModel>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$LocationProjectImplCopyWith<$Res>
    implements $LocationProjectCopyWith<$Res> {
  factory _$$LocationProjectImplCopyWith(_$LocationProjectImpl value,
          $Res Function(_$LocationProjectImpl) then) =
      __$$LocationProjectImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String location, int noOfProjects, List<ApartmentModel> projects});
}

/// @nodoc
class __$$LocationProjectImplCopyWithImpl<$Res>
    extends _$LocationProjectCopyWithImpl<$Res, _$LocationProjectImpl>
    implements _$$LocationProjectImplCopyWith<$Res> {
  __$$LocationProjectImplCopyWithImpl(
      _$LocationProjectImpl _value, $Res Function(_$LocationProjectImpl) _then)
      : super(_value, _then);

  /// Create a copy of LocationProject
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? location = null,
    Object? noOfProjects = null,
    Object? projects = null,
  }) {
    return _then(_$LocationProjectImpl(
      location: null == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as String,
      noOfProjects: null == noOfProjects
          ? _value.noOfProjects
          : noOfProjects // ignore: cast_nullable_to_non_nullable
              as int,
      projects: null == projects
          ? _value._projects
          : projects // ignore: cast_nullable_to_non_nullable
              as List<ApartmentModel>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$LocationProjectImpl implements _LocationProject {
  const _$LocationProjectImpl(
      {required this.location,
      required this.noOfProjects,
      required final List<ApartmentModel> projects})
      : _projects = projects;

  factory _$LocationProjectImpl.fromJson(Map<String, dynamic> json) =>
      _$$LocationProjectImplFromJson(json);

  @override
  final String location;
  @override
  final int noOfProjects;
  final List<ApartmentModel> _projects;
  @override
  List<ApartmentModel> get projects {
    if (_projects is EqualUnmodifiableListView) return _projects;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_projects);
  }

  @override
  String toString() {
    return 'LocationProject(location: $location, noOfProjects: $noOfProjects, projects: $projects)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LocationProjectImpl &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.noOfProjects, noOfProjects) ||
                other.noOfProjects == noOfProjects) &&
            const DeepCollectionEquality().equals(other._projects, _projects));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, location, noOfProjects,
      const DeepCollectionEquality().hash(_projects));

  /// Create a copy of LocationProject
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LocationProjectImplCopyWith<_$LocationProjectImpl> get copyWith =>
      __$$LocationProjectImplCopyWithImpl<_$LocationProjectImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LocationProjectImplToJson(
      this,
    );
  }
}

abstract class _LocationProject implements LocationProject {
  const factory _LocationProject(
      {required final String location,
      required final int noOfProjects,
      required final List<ApartmentModel> projects}) = _$LocationProjectImpl;

  factory _LocationProject.fromJson(Map<String, dynamic> json) =
      _$LocationProjectImpl.fromJson;

  @override
  String get location;
  @override
  int get noOfProjects;
  @override
  List<ApartmentModel> get projects;

  /// Create a copy of LocationProject
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LocationProjectImplCopyWith<_$LocationProjectImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
