// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'builder_data_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

BuilderDataModel _$BuilderDataModelFromJson(Map<String, dynamic> json) {
  return _BuilderDataModel.fromJson(json);
}

/// @nodoc
mixin _$BuilderDataModel {
  String get builderId => throw _privateConstructorUsedError;
  String get builderName => throw _privateConstructorUsedError;
  String get CompanyName => throw _privateConstructorUsedError;
  String get CompanyLogo => throw _privateConstructorUsedError;
  int get builderTotalProjects => throw _privateConstructorUsedError;
  List<ApartmentModel> get projects => throw _privateConstructorUsedError;

  /// Serializes this BuilderDataModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BuilderDataModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BuilderDataModelCopyWith<BuilderDataModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BuilderDataModelCopyWith<$Res> {
  factory $BuilderDataModelCopyWith(
          BuilderDataModel value, $Res Function(BuilderDataModel) then) =
      _$BuilderDataModelCopyWithImpl<$Res, BuilderDataModel>;
  @useResult
  $Res call(
      {String builderId,
      String builderName,
      String CompanyName,
      String CompanyLogo,
      int builderTotalProjects,
      List<ApartmentModel> projects});
}

/// @nodoc
class _$BuilderDataModelCopyWithImpl<$Res, $Val extends BuilderDataModel>
    implements $BuilderDataModelCopyWith<$Res> {
  _$BuilderDataModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BuilderDataModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? builderId = null,
    Object? builderName = null,
    Object? CompanyName = null,
    Object? CompanyLogo = null,
    Object? builderTotalProjects = null,
    Object? projects = null,
  }) {
    return _then(_value.copyWith(
      builderId: null == builderId
          ? _value.builderId
          : builderId // ignore: cast_nullable_to_non_nullable
              as String,
      builderName: null == builderName
          ? _value.builderName
          : builderName // ignore: cast_nullable_to_non_nullable
              as String,
      CompanyName: null == CompanyName
          ? _value.CompanyName
          : CompanyName // ignore: cast_nullable_to_non_nullable
              as String,
      CompanyLogo: null == CompanyLogo
          ? _value.CompanyLogo
          : CompanyLogo // ignore: cast_nullable_to_non_nullable
              as String,
      builderTotalProjects: null == builderTotalProjects
          ? _value.builderTotalProjects
          : builderTotalProjects // ignore: cast_nullable_to_non_nullable
              as int,
      projects: null == projects
          ? _value.projects
          : projects // ignore: cast_nullable_to_non_nullable
              as List<ApartmentModel>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BuilderDataModelImplCopyWith<$Res>
    implements $BuilderDataModelCopyWith<$Res> {
  factory _$$BuilderDataModelImplCopyWith(_$BuilderDataModelImpl value,
          $Res Function(_$BuilderDataModelImpl) then) =
      __$$BuilderDataModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String builderId,
      String builderName,
      String CompanyName,
      String CompanyLogo,
      int builderTotalProjects,
      List<ApartmentModel> projects});
}

/// @nodoc
class __$$BuilderDataModelImplCopyWithImpl<$Res>
    extends _$BuilderDataModelCopyWithImpl<$Res, _$BuilderDataModelImpl>
    implements _$$BuilderDataModelImplCopyWith<$Res> {
  __$$BuilderDataModelImplCopyWithImpl(_$BuilderDataModelImpl _value,
      $Res Function(_$BuilderDataModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of BuilderDataModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? builderId = null,
    Object? builderName = null,
    Object? CompanyName = null,
    Object? CompanyLogo = null,
    Object? builderTotalProjects = null,
    Object? projects = null,
  }) {
    return _then(_$BuilderDataModelImpl(
      builderId: null == builderId
          ? _value.builderId
          : builderId // ignore: cast_nullable_to_non_nullable
              as String,
      builderName: null == builderName
          ? _value.builderName
          : builderName // ignore: cast_nullable_to_non_nullable
              as String,
      CompanyName: null == CompanyName
          ? _value.CompanyName
          : CompanyName // ignore: cast_nullable_to_non_nullable
              as String,
      CompanyLogo: null == CompanyLogo
          ? _value.CompanyLogo
          : CompanyLogo // ignore: cast_nullable_to_non_nullable
              as String,
      builderTotalProjects: null == builderTotalProjects
          ? _value.builderTotalProjects
          : builderTotalProjects // ignore: cast_nullable_to_non_nullable
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
class _$BuilderDataModelImpl implements _BuilderDataModel {
  const _$BuilderDataModelImpl(
      {this.builderId = '',
      this.builderName = '',
      this.CompanyName = '',
      this.CompanyLogo = '',
      this.builderTotalProjects = 0,
      final List<ApartmentModel> projects = const []})
      : _projects = projects;

  factory _$BuilderDataModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$BuilderDataModelImplFromJson(json);

  @override
  @JsonKey()
  final String builderId;
  @override
  @JsonKey()
  final String builderName;
  @override
  @JsonKey()
  final String CompanyName;
  @override
  @JsonKey()
  final String CompanyLogo;
  @override
  @JsonKey()
  final int builderTotalProjects;
  final List<ApartmentModel> _projects;
  @override
  @JsonKey()
  List<ApartmentModel> get projects {
    if (_projects is EqualUnmodifiableListView) return _projects;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_projects);
  }

  @override
  String toString() {
    return 'BuilderDataModel(builderId: $builderId, builderName: $builderName, CompanyName: $CompanyName, CompanyLogo: $CompanyLogo, builderTotalProjects: $builderTotalProjects, projects: $projects)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BuilderDataModelImpl &&
            (identical(other.builderId, builderId) ||
                other.builderId == builderId) &&
            (identical(other.builderName, builderName) ||
                other.builderName == builderName) &&
            (identical(other.CompanyName, CompanyName) ||
                other.CompanyName == CompanyName) &&
            (identical(other.CompanyLogo, CompanyLogo) ||
                other.CompanyLogo == CompanyLogo) &&
            (identical(other.builderTotalProjects, builderTotalProjects) ||
                other.builderTotalProjects == builderTotalProjects) &&
            const DeepCollectionEquality().equals(other._projects, _projects));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      builderId,
      builderName,
      CompanyName,
      CompanyLogo,
      builderTotalProjects,
      const DeepCollectionEquality().hash(_projects));

  /// Create a copy of BuilderDataModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BuilderDataModelImplCopyWith<_$BuilderDataModelImpl> get copyWith =>
      __$$BuilderDataModelImplCopyWithImpl<_$BuilderDataModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BuilderDataModelImplToJson(
      this,
    );
  }
}

abstract class _BuilderDataModel implements BuilderDataModel {
  const factory _BuilderDataModel(
      {final String builderId,
      final String builderName,
      final String CompanyName,
      final String CompanyLogo,
      final int builderTotalProjects,
      final List<ApartmentModel> projects}) = _$BuilderDataModelImpl;

  factory _BuilderDataModel.fromJson(Map<String, dynamic> json) =
      _$BuilderDataModelImpl.fromJson;

  @override
  String get builderId;
  @override
  String get builderName;
  @override
  String get CompanyName;
  @override
  String get CompanyLogo;
  @override
  int get builderTotalProjects;
  @override
  List<ApartmentModel> get projects;

  /// Create a copy of BuilderDataModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BuilderDataModelImplCopyWith<_$BuilderDataModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
