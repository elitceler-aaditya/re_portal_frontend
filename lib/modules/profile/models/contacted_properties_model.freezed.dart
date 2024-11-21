// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'contacted_properties_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ContactedPropertyModel _$ContactedPropertyModelFromJson(
    Map<String, dynamic> json) {
  return _ContactedPropertyModel.fromJson(json);
}

/// @nodoc
mixin _$ContactedPropertyModel {
  String get leadId => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get phone => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;
  String get enquiryDetails => throw _privateConstructorUsedError;
  String? get apartmentId => throw _privateConstructorUsedError;
  String get projectId => throw _privateConstructorUsedError;
  String get builderId => throw _privateConstructorUsedError;
  bool get emailSent => throw _privateConstructorUsedError;
  String get createdAt => throw _privateConstructorUsedError;
  String get updatedAt => throw _privateConstructorUsedError;
  ProjectDetails get project => throw _privateConstructorUsedError;
  BuilderDetails get builder => throw _privateConstructorUsedError;

  /// Serializes this ContactedPropertyModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ContactedPropertyModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ContactedPropertyModelCopyWith<ContactedPropertyModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ContactedPropertyModelCopyWith<$Res> {
  factory $ContactedPropertyModelCopyWith(ContactedPropertyModel value,
          $Res Function(ContactedPropertyModel) then) =
      _$ContactedPropertyModelCopyWithImpl<$Res, ContactedPropertyModel>;
  @useResult
  $Res call(
      {String leadId,
      String userId,
      String name,
      String phone,
      String email,
      String enquiryDetails,
      String? apartmentId,
      String projectId,
      String builderId,
      bool emailSent,
      String createdAt,
      String updatedAt,
      ProjectDetails project,
      BuilderDetails builder});

  $ProjectDetailsCopyWith<$Res> get project;
  $BuilderDetailsCopyWith<$Res> get builder;
}

/// @nodoc
class _$ContactedPropertyModelCopyWithImpl<$Res,
        $Val extends ContactedPropertyModel>
    implements $ContactedPropertyModelCopyWith<$Res> {
  _$ContactedPropertyModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ContactedPropertyModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? leadId = null,
    Object? userId = null,
    Object? name = null,
    Object? phone = null,
    Object? email = null,
    Object? enquiryDetails = null,
    Object? apartmentId = freezed,
    Object? projectId = null,
    Object? builderId = null,
    Object? emailSent = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? project = null,
    Object? builder = null,
  }) {
    return _then(_value.copyWith(
      leadId: null == leadId
          ? _value.leadId
          : leadId // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      phone: null == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      enquiryDetails: null == enquiryDetails
          ? _value.enquiryDetails
          : enquiryDetails // ignore: cast_nullable_to_non_nullable
              as String,
      apartmentId: freezed == apartmentId
          ? _value.apartmentId
          : apartmentId // ignore: cast_nullable_to_non_nullable
              as String?,
      projectId: null == projectId
          ? _value.projectId
          : projectId // ignore: cast_nullable_to_non_nullable
              as String,
      builderId: null == builderId
          ? _value.builderId
          : builderId // ignore: cast_nullable_to_non_nullable
              as String,
      emailSent: null == emailSent
          ? _value.emailSent
          : emailSent // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as String,
      project: null == project
          ? _value.project
          : project // ignore: cast_nullable_to_non_nullable
              as ProjectDetails,
      builder: null == builder
          ? _value.builder
          : builder // ignore: cast_nullable_to_non_nullable
              as BuilderDetails,
    ) as $Val);
  }

  /// Create a copy of ContactedPropertyModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ProjectDetailsCopyWith<$Res> get project {
    return $ProjectDetailsCopyWith<$Res>(_value.project, (value) {
      return _then(_value.copyWith(project: value) as $Val);
    });
  }

  /// Create a copy of ContactedPropertyModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $BuilderDetailsCopyWith<$Res> get builder {
    return $BuilderDetailsCopyWith<$Res>(_value.builder, (value) {
      return _then(_value.copyWith(builder: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ContactedPropertyModelImplCopyWith<$Res>
    implements $ContactedPropertyModelCopyWith<$Res> {
  factory _$$ContactedPropertyModelImplCopyWith(
          _$ContactedPropertyModelImpl value,
          $Res Function(_$ContactedPropertyModelImpl) then) =
      __$$ContactedPropertyModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String leadId,
      String userId,
      String name,
      String phone,
      String email,
      String enquiryDetails,
      String? apartmentId,
      String projectId,
      String builderId,
      bool emailSent,
      String createdAt,
      String updatedAt,
      ProjectDetails project,
      BuilderDetails builder});

  @override
  $ProjectDetailsCopyWith<$Res> get project;
  @override
  $BuilderDetailsCopyWith<$Res> get builder;
}

/// @nodoc
class __$$ContactedPropertyModelImplCopyWithImpl<$Res>
    extends _$ContactedPropertyModelCopyWithImpl<$Res,
        _$ContactedPropertyModelImpl>
    implements _$$ContactedPropertyModelImplCopyWith<$Res> {
  __$$ContactedPropertyModelImplCopyWithImpl(
      _$ContactedPropertyModelImpl _value,
      $Res Function(_$ContactedPropertyModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of ContactedPropertyModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? leadId = null,
    Object? userId = null,
    Object? name = null,
    Object? phone = null,
    Object? email = null,
    Object? enquiryDetails = null,
    Object? apartmentId = freezed,
    Object? projectId = null,
    Object? builderId = null,
    Object? emailSent = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? project = null,
    Object? builder = null,
  }) {
    return _then(_$ContactedPropertyModelImpl(
      leadId: null == leadId
          ? _value.leadId
          : leadId // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      phone: null == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      enquiryDetails: null == enquiryDetails
          ? _value.enquiryDetails
          : enquiryDetails // ignore: cast_nullable_to_non_nullable
              as String,
      apartmentId: freezed == apartmentId
          ? _value.apartmentId
          : apartmentId // ignore: cast_nullable_to_non_nullable
              as String?,
      projectId: null == projectId
          ? _value.projectId
          : projectId // ignore: cast_nullable_to_non_nullable
              as String,
      builderId: null == builderId
          ? _value.builderId
          : builderId // ignore: cast_nullable_to_non_nullable
              as String,
      emailSent: null == emailSent
          ? _value.emailSent
          : emailSent // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as String,
      project: null == project
          ? _value.project
          : project // ignore: cast_nullable_to_non_nullable
              as ProjectDetails,
      builder: null == builder
          ? _value.builder
          : builder // ignore: cast_nullable_to_non_nullable
              as BuilderDetails,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ContactedPropertyModelImpl implements _ContactedPropertyModel {
  const _$ContactedPropertyModelImpl(
      {this.leadId = '',
      this.userId = '',
      this.name = '',
      this.phone = '',
      this.email = '',
      this.enquiryDetails = '',
      this.apartmentId = '',
      this.projectId = '',
      this.builderId = '',
      this.emailSent = false,
      this.createdAt = '',
      this.updatedAt = '',
      this.project = const ProjectDetails(name: '', projectLocation: ''),
      this.builder = const BuilderDetails(name: '', CompanyName: '')});

  factory _$ContactedPropertyModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ContactedPropertyModelImplFromJson(json);

  @override
  @JsonKey()
  final String leadId;
  @override
  @JsonKey()
  final String userId;
  @override
  @JsonKey()
  final String name;
  @override
  @JsonKey()
  final String phone;
  @override
  @JsonKey()
  final String email;
  @override
  @JsonKey()
  final String enquiryDetails;
  @override
  @JsonKey()
  final String? apartmentId;
  @override
  @JsonKey()
  final String projectId;
  @override
  @JsonKey()
  final String builderId;
  @override
  @JsonKey()
  final bool emailSent;
  @override
  @JsonKey()
  final String createdAt;
  @override
  @JsonKey()
  final String updatedAt;
  @override
  @JsonKey()
  final ProjectDetails project;
  @override
  @JsonKey()
  final BuilderDetails builder;

  @override
  String toString() {
    return 'ContactedPropertyModel(leadId: $leadId, userId: $userId, name: $name, phone: $phone, email: $email, enquiryDetails: $enquiryDetails, apartmentId: $apartmentId, projectId: $projectId, builderId: $builderId, emailSent: $emailSent, createdAt: $createdAt, updatedAt: $updatedAt, project: $project, builder: $builder)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ContactedPropertyModelImpl &&
            (identical(other.leadId, leadId) || other.leadId == leadId) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.enquiryDetails, enquiryDetails) ||
                other.enquiryDetails == enquiryDetails) &&
            (identical(other.apartmentId, apartmentId) ||
                other.apartmentId == apartmentId) &&
            (identical(other.projectId, projectId) ||
                other.projectId == projectId) &&
            (identical(other.builderId, builderId) ||
                other.builderId == builderId) &&
            (identical(other.emailSent, emailSent) ||
                other.emailSent == emailSent) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.project, project) || other.project == project) &&
            (identical(other.builder, builder) || other.builder == builder));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      leadId,
      userId,
      name,
      phone,
      email,
      enquiryDetails,
      apartmentId,
      projectId,
      builderId,
      emailSent,
      createdAt,
      updatedAt,
      project,
      builder);

  /// Create a copy of ContactedPropertyModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ContactedPropertyModelImplCopyWith<_$ContactedPropertyModelImpl>
      get copyWith => __$$ContactedPropertyModelImplCopyWithImpl<
          _$ContactedPropertyModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ContactedPropertyModelImplToJson(
      this,
    );
  }
}

abstract class _ContactedPropertyModel implements ContactedPropertyModel {
  const factory _ContactedPropertyModel(
      {final String leadId,
      final String userId,
      final String name,
      final String phone,
      final String email,
      final String enquiryDetails,
      final String? apartmentId,
      final String projectId,
      final String builderId,
      final bool emailSent,
      final String createdAt,
      final String updatedAt,
      final ProjectDetails project,
      final BuilderDetails builder}) = _$ContactedPropertyModelImpl;

  factory _ContactedPropertyModel.fromJson(Map<String, dynamic> json) =
      _$ContactedPropertyModelImpl.fromJson;

  @override
  String get leadId;
  @override
  String get userId;
  @override
  String get name;
  @override
  String get phone;
  @override
  String get email;
  @override
  String get enquiryDetails;
  @override
  String? get apartmentId;
  @override
  String get projectId;
  @override
  String get builderId;
  @override
  bool get emailSent;
  @override
  String get createdAt;
  @override
  String get updatedAt;
  @override
  ProjectDetails get project;
  @override
  BuilderDetails get builder;

  /// Create a copy of ContactedPropertyModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ContactedPropertyModelImplCopyWith<_$ContactedPropertyModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}

ProjectDetails _$ProjectDetailsFromJson(Map<String, dynamic> json) {
  return _ProjectDetails.fromJson(json);
}

/// @nodoc
mixin _$ProjectDetails {
  String get name => throw _privateConstructorUsedError;
  String get projectLocation => throw _privateConstructorUsedError;

  /// Serializes this ProjectDetails to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ProjectDetails
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProjectDetailsCopyWith<ProjectDetails> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProjectDetailsCopyWith<$Res> {
  factory $ProjectDetailsCopyWith(
          ProjectDetails value, $Res Function(ProjectDetails) then) =
      _$ProjectDetailsCopyWithImpl<$Res, ProjectDetails>;
  @useResult
  $Res call({String name, String projectLocation});
}

/// @nodoc
class _$ProjectDetailsCopyWithImpl<$Res, $Val extends ProjectDetails>
    implements $ProjectDetailsCopyWith<$Res> {
  _$ProjectDetailsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ProjectDetails
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? projectLocation = null,
  }) {
    return _then(_value.copyWith(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      projectLocation: null == projectLocation
          ? _value.projectLocation
          : projectLocation // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ProjectDetailsImplCopyWith<$Res>
    implements $ProjectDetailsCopyWith<$Res> {
  factory _$$ProjectDetailsImplCopyWith(_$ProjectDetailsImpl value,
          $Res Function(_$ProjectDetailsImpl) then) =
      __$$ProjectDetailsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String name, String projectLocation});
}

/// @nodoc
class __$$ProjectDetailsImplCopyWithImpl<$Res>
    extends _$ProjectDetailsCopyWithImpl<$Res, _$ProjectDetailsImpl>
    implements _$$ProjectDetailsImplCopyWith<$Res> {
  __$$ProjectDetailsImplCopyWithImpl(
      _$ProjectDetailsImpl _value, $Res Function(_$ProjectDetailsImpl) _then)
      : super(_value, _then);

  /// Create a copy of ProjectDetails
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? projectLocation = null,
  }) {
    return _then(_$ProjectDetailsImpl(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      projectLocation: null == projectLocation
          ? _value.projectLocation
          : projectLocation // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ProjectDetailsImpl implements _ProjectDetails {
  const _$ProjectDetailsImpl(
      {required this.name, required this.projectLocation});

  factory _$ProjectDetailsImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProjectDetailsImplFromJson(json);

  @override
  final String name;
  @override
  final String projectLocation;

  @override
  String toString() {
    return 'ProjectDetails(name: $name, projectLocation: $projectLocation)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProjectDetailsImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.projectLocation, projectLocation) ||
                other.projectLocation == projectLocation));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, name, projectLocation);

  /// Create a copy of ProjectDetails
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProjectDetailsImplCopyWith<_$ProjectDetailsImpl> get copyWith =>
      __$$ProjectDetailsImplCopyWithImpl<_$ProjectDetailsImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ProjectDetailsImplToJson(
      this,
    );
  }
}

abstract class _ProjectDetails implements ProjectDetails {
  const factory _ProjectDetails(
      {required final String name,
      required final String projectLocation}) = _$ProjectDetailsImpl;

  factory _ProjectDetails.fromJson(Map<String, dynamic> json) =
      _$ProjectDetailsImpl.fromJson;

  @override
  String get name;
  @override
  String get projectLocation;

  /// Create a copy of ProjectDetails
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProjectDetailsImplCopyWith<_$ProjectDetailsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

BuilderDetails _$BuilderDetailsFromJson(Map<String, dynamic> json) {
  return _BuilderDetails.fromJson(json);
}

/// @nodoc
mixin _$BuilderDetails {
  String get name => throw _privateConstructorUsedError;
  String get CompanyName => throw _privateConstructorUsedError;
  String get phoneNumber => throw _privateConstructorUsedError;

  /// Serializes this BuilderDetails to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BuilderDetails
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BuilderDetailsCopyWith<BuilderDetails> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BuilderDetailsCopyWith<$Res> {
  factory $BuilderDetailsCopyWith(
          BuilderDetails value, $Res Function(BuilderDetails) then) =
      _$BuilderDetailsCopyWithImpl<$Res, BuilderDetails>;
  @useResult
  $Res call({String name, String CompanyName, String phoneNumber});
}

/// @nodoc
class _$BuilderDetailsCopyWithImpl<$Res, $Val extends BuilderDetails>
    implements $BuilderDetailsCopyWith<$Res> {
  _$BuilderDetailsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BuilderDetails
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? CompanyName = null,
    Object? phoneNumber = null,
  }) {
    return _then(_value.copyWith(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      CompanyName: null == CompanyName
          ? _value.CompanyName
          : CompanyName // ignore: cast_nullable_to_non_nullable
              as String,
      phoneNumber: null == phoneNumber
          ? _value.phoneNumber
          : phoneNumber // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BuilderDetailsImplCopyWith<$Res>
    implements $BuilderDetailsCopyWith<$Res> {
  factory _$$BuilderDetailsImplCopyWith(_$BuilderDetailsImpl value,
          $Res Function(_$BuilderDetailsImpl) then) =
      __$$BuilderDetailsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String name, String CompanyName, String phoneNumber});
}

/// @nodoc
class __$$BuilderDetailsImplCopyWithImpl<$Res>
    extends _$BuilderDetailsCopyWithImpl<$Res, _$BuilderDetailsImpl>
    implements _$$BuilderDetailsImplCopyWith<$Res> {
  __$$BuilderDetailsImplCopyWithImpl(
      _$BuilderDetailsImpl _value, $Res Function(_$BuilderDetailsImpl) _then)
      : super(_value, _then);

  /// Create a copy of BuilderDetails
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? CompanyName = null,
    Object? phoneNumber = null,
  }) {
    return _then(_$BuilderDetailsImpl(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      CompanyName: null == CompanyName
          ? _value.CompanyName
          : CompanyName // ignore: cast_nullable_to_non_nullable
              as String,
      phoneNumber: null == phoneNumber
          ? _value.phoneNumber
          : phoneNumber // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BuilderDetailsImpl implements _BuilderDetails {
  const _$BuilderDetailsImpl(
      {this.name = '', this.CompanyName = '', this.phoneNumber = ''});

  factory _$BuilderDetailsImpl.fromJson(Map<String, dynamic> json) =>
      _$$BuilderDetailsImplFromJson(json);

  @override
  @JsonKey()
  final String name;
  @override
  @JsonKey()
  final String CompanyName;
  @override
  @JsonKey()
  final String phoneNumber;

  @override
  String toString() {
    return 'BuilderDetails(name: $name, CompanyName: $CompanyName, phoneNumber: $phoneNumber)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BuilderDetailsImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.CompanyName, CompanyName) ||
                other.CompanyName == CompanyName) &&
            (identical(other.phoneNumber, phoneNumber) ||
                other.phoneNumber == phoneNumber));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, name, CompanyName, phoneNumber);

  /// Create a copy of BuilderDetails
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BuilderDetailsImplCopyWith<_$BuilderDetailsImpl> get copyWith =>
      __$$BuilderDetailsImplCopyWithImpl<_$BuilderDetailsImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BuilderDetailsImplToJson(
      this,
    );
  }
}

abstract class _BuilderDetails implements BuilderDetails {
  const factory _BuilderDetails(
      {final String name,
      final String CompanyName,
      final String phoneNumber}) = _$BuilderDetailsImpl;

  factory _BuilderDetails.fromJson(Map<String, dynamic> json) =
      _$BuilderDetailsImpl.fromJson;

  @override
  String get name;
  @override
  String get CompanyName;
  @override
  String get phoneNumber;

  /// Create a copy of BuilderDetails
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BuilderDetailsImplCopyWith<_$BuilderDetailsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
