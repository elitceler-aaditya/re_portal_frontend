// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'builder_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

BuilderModel _$BuilderModelFromJson(Map<String, dynamic> json) {
  return _BuilderModel.fromJson(json);
}

/// @nodoc
mixin _$BuilderModel {
  String get companyName => throw _privateConstructorUsedError;
  String get reraId => throw _privateConstructorUsedError;
  String get logoLink => throw _privateConstructorUsedError;
  int get totalNoOfProjects => throw _privateConstructorUsedError;
  List<ApartmentModel> get apartments => throw _privateConstructorUsedError;

  /// Serializes this BuilderModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BuilderModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BuilderModelCopyWith<BuilderModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BuilderModelCopyWith<$Res> {
  factory $BuilderModelCopyWith(
          BuilderModel value, $Res Function(BuilderModel) then) =
      _$BuilderModelCopyWithImpl<$Res, BuilderModel>;
  @useResult
  $Res call(
      {String companyName,
      String reraId,
      String logoLink,
      int totalNoOfProjects,
      List<ApartmentModel> apartments});
}

/// @nodoc
class _$BuilderModelCopyWithImpl<$Res, $Val extends BuilderModel>
    implements $BuilderModelCopyWith<$Res> {
  _$BuilderModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BuilderModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? companyName = null,
    Object? reraId = null,
    Object? logoLink = null,
    Object? totalNoOfProjects = null,
    Object? apartments = null,
  }) {
    return _then(_value.copyWith(
      companyName: null == companyName
          ? _value.companyName
          : companyName // ignore: cast_nullable_to_non_nullable
              as String,
      reraId: null == reraId
          ? _value.reraId
          : reraId // ignore: cast_nullable_to_non_nullable
              as String,
      logoLink: null == logoLink
          ? _value.logoLink
          : logoLink // ignore: cast_nullable_to_non_nullable
              as String,
      totalNoOfProjects: null == totalNoOfProjects
          ? _value.totalNoOfProjects
          : totalNoOfProjects // ignore: cast_nullable_to_non_nullable
              as int,
      apartments: null == apartments
          ? _value.apartments
          : apartments // ignore: cast_nullable_to_non_nullable
              as List<ApartmentModel>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BuilderModelImplCopyWith<$Res>
    implements $BuilderModelCopyWith<$Res> {
  factory _$$BuilderModelImplCopyWith(
          _$BuilderModelImpl value, $Res Function(_$BuilderModelImpl) then) =
      __$$BuilderModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String companyName,
      String reraId,
      String logoLink,
      int totalNoOfProjects,
      List<ApartmentModel> apartments});
}

/// @nodoc
class __$$BuilderModelImplCopyWithImpl<$Res>
    extends _$BuilderModelCopyWithImpl<$Res, _$BuilderModelImpl>
    implements _$$BuilderModelImplCopyWith<$Res> {
  __$$BuilderModelImplCopyWithImpl(
      _$BuilderModelImpl _value, $Res Function(_$BuilderModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of BuilderModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? companyName = null,
    Object? reraId = null,
    Object? logoLink = null,
    Object? totalNoOfProjects = null,
    Object? apartments = null,
  }) {
    return _then(_$BuilderModelImpl(
      companyName: null == companyName
          ? _value.companyName
          : companyName // ignore: cast_nullable_to_non_nullable
              as String,
      reraId: null == reraId
          ? _value.reraId
          : reraId // ignore: cast_nullable_to_non_nullable
              as String,
      logoLink: null == logoLink
          ? _value.logoLink
          : logoLink // ignore: cast_nullable_to_non_nullable
              as String,
      totalNoOfProjects: null == totalNoOfProjects
          ? _value.totalNoOfProjects
          : totalNoOfProjects // ignore: cast_nullable_to_non_nullable
              as int,
      apartments: null == apartments
          ? _value._apartments
          : apartments // ignore: cast_nullable_to_non_nullable
              as List<ApartmentModel>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BuilderModelImpl implements _BuilderModel {
  const _$BuilderModelImpl(
      {this.companyName = "",
      this.reraId = "",
      this.logoLink = "",
      this.totalNoOfProjects = 0,
      final List<ApartmentModel> apartments = const []})
      : _apartments = apartments;

  factory _$BuilderModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$BuilderModelImplFromJson(json);

  @override
  @JsonKey()
  final String companyName;
  @override
  @JsonKey()
  final String reraId;
  @override
  @JsonKey()
  final String logoLink;
  @override
  @JsonKey()
  final int totalNoOfProjects;
  final List<ApartmentModel> _apartments;
  @override
  @JsonKey()
  List<ApartmentModel> get apartments {
    if (_apartments is EqualUnmodifiableListView) return _apartments;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_apartments);
  }

  @override
  String toString() {
    return 'BuilderModel(companyName: $companyName, reraId: $reraId, logoLink: $logoLink, totalNoOfProjects: $totalNoOfProjects, apartments: $apartments)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BuilderModelImpl &&
            (identical(other.companyName, companyName) ||
                other.companyName == companyName) &&
            (identical(other.reraId, reraId) || other.reraId == reraId) &&
            (identical(other.logoLink, logoLink) ||
                other.logoLink == logoLink) &&
            (identical(other.totalNoOfProjects, totalNoOfProjects) ||
                other.totalNoOfProjects == totalNoOfProjects) &&
            const DeepCollectionEquality()
                .equals(other._apartments, _apartments));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, companyName, reraId, logoLink,
      totalNoOfProjects, const DeepCollectionEquality().hash(_apartments));

  /// Create a copy of BuilderModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BuilderModelImplCopyWith<_$BuilderModelImpl> get copyWith =>
      __$$BuilderModelImplCopyWithImpl<_$BuilderModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BuilderModelImplToJson(
      this,
    );
  }
}

abstract class _BuilderModel implements BuilderModel {
  const factory _BuilderModel(
      {final String companyName,
      final String reraId,
      final String logoLink,
      final int totalNoOfProjects,
      final List<ApartmentModel> apartments}) = _$BuilderModelImpl;

  factory _BuilderModel.fromJson(Map<String, dynamic> json) =
      _$BuilderModelImpl.fromJson;

  @override
  String get companyName;
  @override
  String get reraId;
  @override
  String get logoLink;
  @override
  int get totalNoOfProjects;
  @override
  List<ApartmentModel> get apartments;

  /// Create a copy of BuilderModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BuilderModelImplCopyWith<_$BuilderModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
