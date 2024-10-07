// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'compare_property_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ComparePropertyData _$ComparePropertyDataFromJson(Map<String, dynamic> json) {
  return _ComparePropertyData.fromJson(json);
}

/// @nodoc
mixin _$ComparePropertyData {
  String get name => throw _privateConstructorUsedError;
  String get projectType => throw _privateConstructorUsedError;
  int get flatSizes => throw _privateConstructorUsedError;
  String get projectStatus => throw _privateConstructorUsedError;
  bool get rERAApproval => throw _privateConstructorUsedError;
  String get projectSize => throw _privateConstructorUsedError;
  String get noOfTowers => throw _privateConstructorUsedError;
  String get noOfFloors => throw _privateConstructorUsedError;
  List<UnitPlanConfig> get unitPlanConfigs =>
      throw _privateConstructorUsedError;
  String get projectPossession => throw _privateConstructorUsedError;
  String get pricePerSquareFeetRate => throw _privateConstructorUsedError;
  String get clubhousesize => throw _privateConstructorUsedError;
  String get totalOpenSpace => throw _privateConstructorUsedError;
  int get budget => throw _privateConstructorUsedError;
  BuilderContact get builder => throw _privateConstructorUsedError;

  /// Serializes this ComparePropertyData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ComparePropertyData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ComparePropertyDataCopyWith<ComparePropertyData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ComparePropertyDataCopyWith<$Res> {
  factory $ComparePropertyDataCopyWith(
          ComparePropertyData value, $Res Function(ComparePropertyData) then) =
      _$ComparePropertyDataCopyWithImpl<$Res, ComparePropertyData>;
  @useResult
  $Res call(
      {String name,
      String projectType,
      int flatSizes,
      String projectStatus,
      bool rERAApproval,
      String projectSize,
      String noOfTowers,
      String noOfFloors,
      List<UnitPlanConfig> unitPlanConfigs,
      String projectPossession,
      String pricePerSquareFeetRate,
      String clubhousesize,
      String totalOpenSpace,
      int budget,
      BuilderContact builder});

  $BuilderContactCopyWith<$Res> get builder;
}

/// @nodoc
class _$ComparePropertyDataCopyWithImpl<$Res, $Val extends ComparePropertyData>
    implements $ComparePropertyDataCopyWith<$Res> {
  _$ComparePropertyDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ComparePropertyData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? projectType = null,
    Object? flatSizes = null,
    Object? projectStatus = null,
    Object? rERAApproval = null,
    Object? projectSize = null,
    Object? noOfTowers = null,
    Object? noOfFloors = null,
    Object? unitPlanConfigs = null,
    Object? projectPossession = null,
    Object? pricePerSquareFeetRate = null,
    Object? clubhousesize = null,
    Object? totalOpenSpace = null,
    Object? budget = null,
    Object? builder = null,
  }) {
    return _then(_value.copyWith(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      projectType: null == projectType
          ? _value.projectType
          : projectType // ignore: cast_nullable_to_non_nullable
              as String,
      flatSizes: null == flatSizes
          ? _value.flatSizes
          : flatSizes // ignore: cast_nullable_to_non_nullable
              as int,
      projectStatus: null == projectStatus
          ? _value.projectStatus
          : projectStatus // ignore: cast_nullable_to_non_nullable
              as String,
      rERAApproval: null == rERAApproval
          ? _value.rERAApproval
          : rERAApproval // ignore: cast_nullable_to_non_nullable
              as bool,
      projectSize: null == projectSize
          ? _value.projectSize
          : projectSize // ignore: cast_nullable_to_non_nullable
              as String,
      noOfTowers: null == noOfTowers
          ? _value.noOfTowers
          : noOfTowers // ignore: cast_nullable_to_non_nullable
              as String,
      noOfFloors: null == noOfFloors
          ? _value.noOfFloors
          : noOfFloors // ignore: cast_nullable_to_non_nullable
              as String,
      unitPlanConfigs: null == unitPlanConfigs
          ? _value.unitPlanConfigs
          : unitPlanConfigs // ignore: cast_nullable_to_non_nullable
              as List<UnitPlanConfig>,
      projectPossession: null == projectPossession
          ? _value.projectPossession
          : projectPossession // ignore: cast_nullable_to_non_nullable
              as String,
      pricePerSquareFeetRate: null == pricePerSquareFeetRate
          ? _value.pricePerSquareFeetRate
          : pricePerSquareFeetRate // ignore: cast_nullable_to_non_nullable
              as String,
      clubhousesize: null == clubhousesize
          ? _value.clubhousesize
          : clubhousesize // ignore: cast_nullable_to_non_nullable
              as String,
      totalOpenSpace: null == totalOpenSpace
          ? _value.totalOpenSpace
          : totalOpenSpace // ignore: cast_nullable_to_non_nullable
              as String,
      budget: null == budget
          ? _value.budget
          : budget // ignore: cast_nullable_to_non_nullable
              as int,
      builder: null == builder
          ? _value.builder
          : builder // ignore: cast_nullable_to_non_nullable
              as BuilderContact,
    ) as $Val);
  }

  /// Create a copy of ComparePropertyData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $BuilderContactCopyWith<$Res> get builder {
    return $BuilderContactCopyWith<$Res>(_value.builder, (value) {
      return _then(_value.copyWith(builder: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ComparePropertyDataImplCopyWith<$Res>
    implements $ComparePropertyDataCopyWith<$Res> {
  factory _$$ComparePropertyDataImplCopyWith(_$ComparePropertyDataImpl value,
          $Res Function(_$ComparePropertyDataImpl) then) =
      __$$ComparePropertyDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String name,
      String projectType,
      int flatSizes,
      String projectStatus,
      bool rERAApproval,
      String projectSize,
      String noOfTowers,
      String noOfFloors,
      List<UnitPlanConfig> unitPlanConfigs,
      String projectPossession,
      String pricePerSquareFeetRate,
      String clubhousesize,
      String totalOpenSpace,
      int budget,
      BuilderContact builder});

  @override
  $BuilderContactCopyWith<$Res> get builder;
}

/// @nodoc
class __$$ComparePropertyDataImplCopyWithImpl<$Res>
    extends _$ComparePropertyDataCopyWithImpl<$Res, _$ComparePropertyDataImpl>
    implements _$$ComparePropertyDataImplCopyWith<$Res> {
  __$$ComparePropertyDataImplCopyWithImpl(_$ComparePropertyDataImpl _value,
      $Res Function(_$ComparePropertyDataImpl) _then)
      : super(_value, _then);

  /// Create a copy of ComparePropertyData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? projectType = null,
    Object? flatSizes = null,
    Object? projectStatus = null,
    Object? rERAApproval = null,
    Object? projectSize = null,
    Object? noOfTowers = null,
    Object? noOfFloors = null,
    Object? unitPlanConfigs = null,
    Object? projectPossession = null,
    Object? pricePerSquareFeetRate = null,
    Object? clubhousesize = null,
    Object? totalOpenSpace = null,
    Object? budget = null,
    Object? builder = null,
  }) {
    return _then(_$ComparePropertyDataImpl(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      projectType: null == projectType
          ? _value.projectType
          : projectType // ignore: cast_nullable_to_non_nullable
              as String,
      flatSizes: null == flatSizes
          ? _value.flatSizes
          : flatSizes // ignore: cast_nullable_to_non_nullable
              as int,
      projectStatus: null == projectStatus
          ? _value.projectStatus
          : projectStatus // ignore: cast_nullable_to_non_nullable
              as String,
      rERAApproval: null == rERAApproval
          ? _value.rERAApproval
          : rERAApproval // ignore: cast_nullable_to_non_nullable
              as bool,
      projectSize: null == projectSize
          ? _value.projectSize
          : projectSize // ignore: cast_nullable_to_non_nullable
              as String,
      noOfTowers: null == noOfTowers
          ? _value.noOfTowers
          : noOfTowers // ignore: cast_nullable_to_non_nullable
              as String,
      noOfFloors: null == noOfFloors
          ? _value.noOfFloors
          : noOfFloors // ignore: cast_nullable_to_non_nullable
              as String,
      unitPlanConfigs: null == unitPlanConfigs
          ? _value._unitPlanConfigs
          : unitPlanConfigs // ignore: cast_nullable_to_non_nullable
              as List<UnitPlanConfig>,
      projectPossession: null == projectPossession
          ? _value.projectPossession
          : projectPossession // ignore: cast_nullable_to_non_nullable
              as String,
      pricePerSquareFeetRate: null == pricePerSquareFeetRate
          ? _value.pricePerSquareFeetRate
          : pricePerSquareFeetRate // ignore: cast_nullable_to_non_nullable
              as String,
      clubhousesize: null == clubhousesize
          ? _value.clubhousesize
          : clubhousesize // ignore: cast_nullable_to_non_nullable
              as String,
      totalOpenSpace: null == totalOpenSpace
          ? _value.totalOpenSpace
          : totalOpenSpace // ignore: cast_nullable_to_non_nullable
              as String,
      budget: null == budget
          ? _value.budget
          : budget // ignore: cast_nullable_to_non_nullable
              as int,
      builder: null == builder
          ? _value.builder
          : builder // ignore: cast_nullable_to_non_nullable
              as BuilderContact,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ComparePropertyDataImpl implements _ComparePropertyData {
  const _$ComparePropertyDataImpl(
      {required this.name,
      this.projectType = "",
      this.flatSizes = 0,
      this.projectStatus = "",
      this.rERAApproval = false,
      this.projectSize = "",
      this.noOfTowers = "",
      this.noOfFloors = "",
      final List<UnitPlanConfig> unitPlanConfigs = const [],
      this.projectPossession = "",
      this.pricePerSquareFeetRate = "",
      this.clubhousesize = "",
      this.totalOpenSpace = "",
      this.budget = 0,
      this.builder = const BuilderContact(CompanyPhone: "")})
      : _unitPlanConfigs = unitPlanConfigs;

  factory _$ComparePropertyDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$ComparePropertyDataImplFromJson(json);

  @override
  final String name;
  @override
  @JsonKey()
  final String projectType;
  @override
  @JsonKey()
  final int flatSizes;
  @override
  @JsonKey()
  final String projectStatus;
  @override
  @JsonKey()
  final bool rERAApproval;
  @override
  @JsonKey()
  final String projectSize;
  @override
  @JsonKey()
  final String noOfTowers;
  @override
  @JsonKey()
  final String noOfFloors;
  final List<UnitPlanConfig> _unitPlanConfigs;
  @override
  @JsonKey()
  List<UnitPlanConfig> get unitPlanConfigs {
    if (_unitPlanConfigs is EqualUnmodifiableListView) return _unitPlanConfigs;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_unitPlanConfigs);
  }

  @override
  @JsonKey()
  final String projectPossession;
  @override
  @JsonKey()
  final String pricePerSquareFeetRate;
  @override
  @JsonKey()
  final String clubhousesize;
  @override
  @JsonKey()
  final String totalOpenSpace;
  @override
  @JsonKey()
  final int budget;
  @override
  @JsonKey()
  final BuilderContact builder;

  @override
  String toString() {
    return 'ComparePropertyData(name: $name, projectType: $projectType, flatSizes: $flatSizes, projectStatus: $projectStatus, rERAApproval: $rERAApproval, projectSize: $projectSize, noOfTowers: $noOfTowers, noOfFloors: $noOfFloors, unitPlanConfigs: $unitPlanConfigs, projectPossession: $projectPossession, pricePerSquareFeetRate: $pricePerSquareFeetRate, clubhousesize: $clubhousesize, totalOpenSpace: $totalOpenSpace, budget: $budget, builder: $builder)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ComparePropertyDataImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.projectType, projectType) ||
                other.projectType == projectType) &&
            (identical(other.flatSizes, flatSizes) ||
                other.flatSizes == flatSizes) &&
            (identical(other.projectStatus, projectStatus) ||
                other.projectStatus == projectStatus) &&
            (identical(other.rERAApproval, rERAApproval) ||
                other.rERAApproval == rERAApproval) &&
            (identical(other.projectSize, projectSize) ||
                other.projectSize == projectSize) &&
            (identical(other.noOfTowers, noOfTowers) ||
                other.noOfTowers == noOfTowers) &&
            (identical(other.noOfFloors, noOfFloors) ||
                other.noOfFloors == noOfFloors) &&
            const DeepCollectionEquality()
                .equals(other._unitPlanConfigs, _unitPlanConfigs) &&
            (identical(other.projectPossession, projectPossession) ||
                other.projectPossession == projectPossession) &&
            (identical(other.pricePerSquareFeetRate, pricePerSquareFeetRate) ||
                other.pricePerSquareFeetRate == pricePerSquareFeetRate) &&
            (identical(other.clubhousesize, clubhousesize) ||
                other.clubhousesize == clubhousesize) &&
            (identical(other.totalOpenSpace, totalOpenSpace) ||
                other.totalOpenSpace == totalOpenSpace) &&
            (identical(other.budget, budget) || other.budget == budget) &&
            (identical(other.builder, builder) || other.builder == builder));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      name,
      projectType,
      flatSizes,
      projectStatus,
      rERAApproval,
      projectSize,
      noOfTowers,
      noOfFloors,
      const DeepCollectionEquality().hash(_unitPlanConfigs),
      projectPossession,
      pricePerSquareFeetRate,
      clubhousesize,
      totalOpenSpace,
      budget,
      builder);

  /// Create a copy of ComparePropertyData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ComparePropertyDataImplCopyWith<_$ComparePropertyDataImpl> get copyWith =>
      __$$ComparePropertyDataImplCopyWithImpl<_$ComparePropertyDataImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ComparePropertyDataImplToJson(
      this,
    );
  }
}

abstract class _ComparePropertyData implements ComparePropertyData {
  const factory _ComparePropertyData(
      {required final String name,
      final String projectType,
      final int flatSizes,
      final String projectStatus,
      final bool rERAApproval,
      final String projectSize,
      final String noOfTowers,
      final String noOfFloors,
      final List<UnitPlanConfig> unitPlanConfigs,
      final String projectPossession,
      final String pricePerSquareFeetRate,
      final String clubhousesize,
      final String totalOpenSpace,
      final int budget,
      final BuilderContact builder}) = _$ComparePropertyDataImpl;

  factory _ComparePropertyData.fromJson(Map<String, dynamic> json) =
      _$ComparePropertyDataImpl.fromJson;

  @override
  String get name;
  @override
  String get projectType;
  @override
  int get flatSizes;
  @override
  String get projectStatus;
  @override
  bool get rERAApproval;
  @override
  String get projectSize;
  @override
  String get noOfTowers;
  @override
  String get noOfFloors;
  @override
  List<UnitPlanConfig> get unitPlanConfigs;
  @override
  String get projectPossession;
  @override
  String get pricePerSquareFeetRate;
  @override
  String get clubhousesize;
  @override
  String get totalOpenSpace;
  @override
  int get budget;
  @override
  BuilderContact get builder;

  /// Create a copy of ComparePropertyData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ComparePropertyDataImplCopyWith<_$ComparePropertyDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

UnitPlanConfig _$UnitPlanConfigFromJson(Map<String, dynamic> json) {
  return _UnitPlanConfig.fromJson(json);
}

/// @nodoc
mixin _$UnitPlanConfig {
  String get BHKType => throw _privateConstructorUsedError;

  /// Serializes this UnitPlanConfig to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UnitPlanConfig
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UnitPlanConfigCopyWith<UnitPlanConfig> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UnitPlanConfigCopyWith<$Res> {
  factory $UnitPlanConfigCopyWith(
          UnitPlanConfig value, $Res Function(UnitPlanConfig) then) =
      _$UnitPlanConfigCopyWithImpl<$Res, UnitPlanConfig>;
  @useResult
  $Res call({String BHKType});
}

/// @nodoc
class _$UnitPlanConfigCopyWithImpl<$Res, $Val extends UnitPlanConfig>
    implements $UnitPlanConfigCopyWith<$Res> {
  _$UnitPlanConfigCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UnitPlanConfig
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? BHKType = null,
  }) {
    return _then(_value.copyWith(
      BHKType: null == BHKType
          ? _value.BHKType
          : BHKType // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UnitPlanConfigImplCopyWith<$Res>
    implements $UnitPlanConfigCopyWith<$Res> {
  factory _$$UnitPlanConfigImplCopyWith(_$UnitPlanConfigImpl value,
          $Res Function(_$UnitPlanConfigImpl) then) =
      __$$UnitPlanConfigImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String BHKType});
}

/// @nodoc
class __$$UnitPlanConfigImplCopyWithImpl<$Res>
    extends _$UnitPlanConfigCopyWithImpl<$Res, _$UnitPlanConfigImpl>
    implements _$$UnitPlanConfigImplCopyWith<$Res> {
  __$$UnitPlanConfigImplCopyWithImpl(
      _$UnitPlanConfigImpl _value, $Res Function(_$UnitPlanConfigImpl) _then)
      : super(_value, _then);

  /// Create a copy of UnitPlanConfig
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? BHKType = null,
  }) {
    return _then(_$UnitPlanConfigImpl(
      BHKType: null == BHKType
          ? _value.BHKType
          : BHKType // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UnitPlanConfigImpl implements _UnitPlanConfig {
  const _$UnitPlanConfigImpl({required this.BHKType});

  factory _$UnitPlanConfigImpl.fromJson(Map<String, dynamic> json) =>
      _$$UnitPlanConfigImplFromJson(json);

  @override
  final String BHKType;

  @override
  String toString() {
    return 'UnitPlanConfig(BHKType: $BHKType)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UnitPlanConfigImpl &&
            (identical(other.BHKType, BHKType) || other.BHKType == BHKType));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, BHKType);

  /// Create a copy of UnitPlanConfig
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UnitPlanConfigImplCopyWith<_$UnitPlanConfigImpl> get copyWith =>
      __$$UnitPlanConfigImplCopyWithImpl<_$UnitPlanConfigImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UnitPlanConfigImplToJson(
      this,
    );
  }
}

abstract class _UnitPlanConfig implements UnitPlanConfig {
  const factory _UnitPlanConfig({required final String BHKType}) =
      _$UnitPlanConfigImpl;

  factory _UnitPlanConfig.fromJson(Map<String, dynamic> json) =
      _$UnitPlanConfigImpl.fromJson;

  @override
  String get BHKType;

  /// Create a copy of UnitPlanConfig
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UnitPlanConfigImplCopyWith<_$UnitPlanConfigImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

BuilderContact _$BuilderContactFromJson(Map<String, dynamic> json) {
  return _BuilderContact.fromJson(json);
}

/// @nodoc
mixin _$BuilderContact {
  String get CompanyPhone => throw _privateConstructorUsedError;

  /// Serializes this BuilderContact to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BuilderContact
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BuilderContactCopyWith<BuilderContact> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BuilderContactCopyWith<$Res> {
  factory $BuilderContactCopyWith(
          BuilderContact value, $Res Function(BuilderContact) then) =
      _$BuilderContactCopyWithImpl<$Res, BuilderContact>;
  @useResult
  $Res call({String CompanyPhone});
}

/// @nodoc
class _$BuilderContactCopyWithImpl<$Res, $Val extends BuilderContact>
    implements $BuilderContactCopyWith<$Res> {
  _$BuilderContactCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BuilderContact
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? CompanyPhone = null,
  }) {
    return _then(_value.copyWith(
      CompanyPhone: null == CompanyPhone
          ? _value.CompanyPhone
          : CompanyPhone // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BuilderContactImplCopyWith<$Res>
    implements $BuilderContactCopyWith<$Res> {
  factory _$$BuilderContactImplCopyWith(_$BuilderContactImpl value,
          $Res Function(_$BuilderContactImpl) then) =
      __$$BuilderContactImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String CompanyPhone});
}

/// @nodoc
class __$$BuilderContactImplCopyWithImpl<$Res>
    extends _$BuilderContactCopyWithImpl<$Res, _$BuilderContactImpl>
    implements _$$BuilderContactImplCopyWith<$Res> {
  __$$BuilderContactImplCopyWithImpl(
      _$BuilderContactImpl _value, $Res Function(_$BuilderContactImpl) _then)
      : super(_value, _then);

  /// Create a copy of BuilderContact
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? CompanyPhone = null,
  }) {
    return _then(_$BuilderContactImpl(
      CompanyPhone: null == CompanyPhone
          ? _value.CompanyPhone
          : CompanyPhone // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BuilderContactImpl implements _BuilderContact {
  const _$BuilderContactImpl({required this.CompanyPhone});

  factory _$BuilderContactImpl.fromJson(Map<String, dynamic> json) =>
      _$$BuilderContactImplFromJson(json);

  @override
  final String CompanyPhone;

  @override
  String toString() {
    return 'BuilderContact(CompanyPhone: $CompanyPhone)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BuilderContactImpl &&
            (identical(other.CompanyPhone, CompanyPhone) ||
                other.CompanyPhone == CompanyPhone));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, CompanyPhone);

  /// Create a copy of BuilderContact
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BuilderContactImplCopyWith<_$BuilderContactImpl> get copyWith =>
      __$$BuilderContactImplCopyWithImpl<_$BuilderContactImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BuilderContactImplToJson(
      this,
    );
  }
}

abstract class _BuilderContact implements BuilderContact {
  const factory _BuilderContact({required final String CompanyPhone}) =
      _$BuilderContactImpl;

  factory _BuilderContact.fromJson(Map<String, dynamic> json) =
      _$BuilderContactImpl.fromJson;

  @override
  String get CompanyPhone;

  /// Create a copy of BuilderContact
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BuilderContactImplCopyWith<_$BuilderContactImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
