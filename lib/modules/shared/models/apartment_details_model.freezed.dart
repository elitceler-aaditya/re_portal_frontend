// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'apartment_details_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ApartmentDetailsResponse _$ApartmentDetailsResponseFromJson(
    Map<String, dynamic> json) {
  return _ApartmentDetailsResponse.fromJson(json);
}

/// @nodoc
mixin _$ApartmentDetailsResponse {
  String get message => throw _privateConstructorUsedError;
  List<ProjectImageModel> get projectImages =>
      throw _privateConstructorUsedError;
  ProjectDetails get projectDetails => throw _privateConstructorUsedError;
  List<UnitPlanConfig> get unitPlanConfigFilesFormatted =>
      throw _privateConstructorUsedError;

  /// Serializes this ApartmentDetailsResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ApartmentDetailsResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ApartmentDetailsResponseCopyWith<ApartmentDetailsResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ApartmentDetailsResponseCopyWith<$Res> {
  factory $ApartmentDetailsResponseCopyWith(ApartmentDetailsResponse value,
          $Res Function(ApartmentDetailsResponse) then) =
      _$ApartmentDetailsResponseCopyWithImpl<$Res, ApartmentDetailsResponse>;
  @useResult
  $Res call(
      {String message,
      List<ProjectImageModel> projectImages,
      ProjectDetails projectDetails,
      List<UnitPlanConfig> unitPlanConfigFilesFormatted});

  $ProjectDetailsCopyWith<$Res> get projectDetails;
}

/// @nodoc
class _$ApartmentDetailsResponseCopyWithImpl<$Res,
        $Val extends ApartmentDetailsResponse>
    implements $ApartmentDetailsResponseCopyWith<$Res> {
  _$ApartmentDetailsResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ApartmentDetailsResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
    Object? projectImages = null,
    Object? projectDetails = null,
    Object? unitPlanConfigFilesFormatted = null,
  }) {
    return _then(_value.copyWith(
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      projectImages: null == projectImages
          ? _value.projectImages
          : projectImages // ignore: cast_nullable_to_non_nullable
              as List<ProjectImageModel>,
      projectDetails: null == projectDetails
          ? _value.projectDetails
          : projectDetails // ignore: cast_nullable_to_non_nullable
              as ProjectDetails,
      unitPlanConfigFilesFormatted: null == unitPlanConfigFilesFormatted
          ? _value.unitPlanConfigFilesFormatted
          : unitPlanConfigFilesFormatted // ignore: cast_nullable_to_non_nullable
              as List<UnitPlanConfig>,
    ) as $Val);
  }

  /// Create a copy of ApartmentDetailsResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ProjectDetailsCopyWith<$Res> get projectDetails {
    return $ProjectDetailsCopyWith<$Res>(_value.projectDetails, (value) {
      return _then(_value.copyWith(projectDetails: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ApartmentDetailsResponseImplCopyWith<$Res>
    implements $ApartmentDetailsResponseCopyWith<$Res> {
  factory _$$ApartmentDetailsResponseImplCopyWith(
          _$ApartmentDetailsResponseImpl value,
          $Res Function(_$ApartmentDetailsResponseImpl) then) =
      __$$ApartmentDetailsResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String message,
      List<ProjectImageModel> projectImages,
      ProjectDetails projectDetails,
      List<UnitPlanConfig> unitPlanConfigFilesFormatted});

  @override
  $ProjectDetailsCopyWith<$Res> get projectDetails;
}

/// @nodoc
class __$$ApartmentDetailsResponseImplCopyWithImpl<$Res>
    extends _$ApartmentDetailsResponseCopyWithImpl<$Res,
        _$ApartmentDetailsResponseImpl>
    implements _$$ApartmentDetailsResponseImplCopyWith<$Res> {
  __$$ApartmentDetailsResponseImplCopyWithImpl(
      _$ApartmentDetailsResponseImpl _value,
      $Res Function(_$ApartmentDetailsResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of ApartmentDetailsResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
    Object? projectImages = null,
    Object? projectDetails = null,
    Object? unitPlanConfigFilesFormatted = null,
  }) {
    return _then(_$ApartmentDetailsResponseImpl(
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      projectImages: null == projectImages
          ? _value._projectImages
          : projectImages // ignore: cast_nullable_to_non_nullable
              as List<ProjectImageModel>,
      projectDetails: null == projectDetails
          ? _value.projectDetails
          : projectDetails // ignore: cast_nullable_to_non_nullable
              as ProjectDetails,
      unitPlanConfigFilesFormatted: null == unitPlanConfigFilesFormatted
          ? _value._unitPlanConfigFilesFormatted
          : unitPlanConfigFilesFormatted // ignore: cast_nullable_to_non_nullable
              as List<UnitPlanConfig>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ApartmentDetailsResponseImpl implements _ApartmentDetailsResponse {
  const _$ApartmentDetailsResponseImpl(
      {this.message = '',
      final List<ProjectImageModel> projectImages = const [],
      this.projectDetails = const ProjectDetails(),
      final List<UnitPlanConfig> unitPlanConfigFilesFormatted = const []})
      : _projectImages = projectImages,
        _unitPlanConfigFilesFormatted = unitPlanConfigFilesFormatted;

  factory _$ApartmentDetailsResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$ApartmentDetailsResponseImplFromJson(json);

  @override
  @JsonKey()
  final String message;
  final List<ProjectImageModel> _projectImages;
  @override
  @JsonKey()
  List<ProjectImageModel> get projectImages {
    if (_projectImages is EqualUnmodifiableListView) return _projectImages;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_projectImages);
  }

  @override
  @JsonKey()
  final ProjectDetails projectDetails;
  final List<UnitPlanConfig> _unitPlanConfigFilesFormatted;
  @override
  @JsonKey()
  List<UnitPlanConfig> get unitPlanConfigFilesFormatted {
    if (_unitPlanConfigFilesFormatted is EqualUnmodifiableListView)
      return _unitPlanConfigFilesFormatted;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_unitPlanConfigFilesFormatted);
  }

  @override
  String toString() {
    return 'ApartmentDetailsResponse(message: $message, projectImages: $projectImages, projectDetails: $projectDetails, unitPlanConfigFilesFormatted: $unitPlanConfigFilesFormatted)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ApartmentDetailsResponseImpl &&
            (identical(other.message, message) || other.message == message) &&
            const DeepCollectionEquality()
                .equals(other._projectImages, _projectImages) &&
            (identical(other.projectDetails, projectDetails) ||
                other.projectDetails == projectDetails) &&
            const DeepCollectionEquality().equals(
                other._unitPlanConfigFilesFormatted,
                _unitPlanConfigFilesFormatted));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      message,
      const DeepCollectionEquality().hash(_projectImages),
      projectDetails,
      const DeepCollectionEquality().hash(_unitPlanConfigFilesFormatted));

  /// Create a copy of ApartmentDetailsResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ApartmentDetailsResponseImplCopyWith<_$ApartmentDetailsResponseImpl>
      get copyWith => __$$ApartmentDetailsResponseImplCopyWithImpl<
          _$ApartmentDetailsResponseImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ApartmentDetailsResponseImplToJson(
      this,
    );
  }
}

abstract class _ApartmentDetailsResponse implements ApartmentDetailsResponse {
  const factory _ApartmentDetailsResponse(
          {final String message,
          final List<ProjectImageModel> projectImages,
          final ProjectDetails projectDetails,
          final List<UnitPlanConfig> unitPlanConfigFilesFormatted}) =
      _$ApartmentDetailsResponseImpl;

  factory _ApartmentDetailsResponse.fromJson(Map<String, dynamic> json) =
      _$ApartmentDetailsResponseImpl.fromJson;

  @override
  String get message;
  @override
  List<ProjectImageModel> get projectImages;
  @override
  ProjectDetails get projectDetails;
  @override
  List<UnitPlanConfig> get unitPlanConfigFilesFormatted;

  /// Create a copy of ApartmentDetailsResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ApartmentDetailsResponseImplCopyWith<_$ApartmentDetailsResponseImpl>
      get copyWith => throw _privateConstructorUsedError;
}

ProjectImageModel _$ProjectImageModelFromJson(Map<String, dynamic> json) {
  return _ProjectImageModel.fromJson(json);
}

/// @nodoc
mixin _$ProjectImageModel {
  String get title => throw _privateConstructorUsedError;
  List<String> get images => throw _privateConstructorUsedError;

  /// Serializes this ProjectImageModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ProjectImageModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProjectImageModelCopyWith<ProjectImageModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProjectImageModelCopyWith<$Res> {
  factory $ProjectImageModelCopyWith(
          ProjectImageModel value, $Res Function(ProjectImageModel) then) =
      _$ProjectImageModelCopyWithImpl<$Res, ProjectImageModel>;
  @useResult
  $Res call({String title, List<String> images});
}

/// @nodoc
class _$ProjectImageModelCopyWithImpl<$Res, $Val extends ProjectImageModel>
    implements $ProjectImageModelCopyWith<$Res> {
  _$ProjectImageModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ProjectImageModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? images = null,
  }) {
    return _then(_value.copyWith(
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      images: null == images
          ? _value.images
          : images // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ProjectImageModelImplCopyWith<$Res>
    implements $ProjectImageModelCopyWith<$Res> {
  factory _$$ProjectImageModelImplCopyWith(_$ProjectImageModelImpl value,
          $Res Function(_$ProjectImageModelImpl) then) =
      __$$ProjectImageModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String title, List<String> images});
}

/// @nodoc
class __$$ProjectImageModelImplCopyWithImpl<$Res>
    extends _$ProjectImageModelCopyWithImpl<$Res, _$ProjectImageModelImpl>
    implements _$$ProjectImageModelImplCopyWith<$Res> {
  __$$ProjectImageModelImplCopyWithImpl(_$ProjectImageModelImpl _value,
      $Res Function(_$ProjectImageModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of ProjectImageModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? images = null,
  }) {
    return _then(_$ProjectImageModelImpl(
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      images: null == images
          ? _value._images
          : images // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ProjectImageModelImpl implements _ProjectImageModel {
  const _$ProjectImageModelImpl(
      {this.title = '', final List<String> images = const []})
      : _images = images;

  factory _$ProjectImageModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProjectImageModelImplFromJson(json);

  @override
  @JsonKey()
  final String title;
  final List<String> _images;
  @override
  @JsonKey()
  List<String> get images {
    if (_images is EqualUnmodifiableListView) return _images;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_images);
  }

  @override
  String toString() {
    return 'ProjectImageModel(title: $title, images: $images)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProjectImageModelImpl &&
            (identical(other.title, title) || other.title == title) &&
            const DeepCollectionEquality().equals(other._images, _images));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, title, const DeepCollectionEquality().hash(_images));

  /// Create a copy of ProjectImageModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProjectImageModelImplCopyWith<_$ProjectImageModelImpl> get copyWith =>
      __$$ProjectImageModelImplCopyWithImpl<_$ProjectImageModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ProjectImageModelImplToJson(
      this,
    );
  }
}

abstract class _ProjectImageModel implements ProjectImageModel {
  const factory _ProjectImageModel(
      {final String title,
      final List<String> images}) = _$ProjectImageModelImpl;

  factory _ProjectImageModel.fromJson(Map<String, dynamic> json) =
      _$ProjectImageModelImpl.fromJson;

  @override
  String get title;
  @override
  List<String> get images;

  /// Create a copy of ProjectImageModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProjectImageModelImplCopyWith<_$ProjectImageModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ProjectDetails _$ProjectDetailsFromJson(Map<String, dynamic> json) {
  return _ProjectDetails.fromJson(json);
}

/// @nodoc
mixin _$ProjectDetails {
  String get projectId => throw _privateConstructorUsedError;
  String get builderID => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  String get projectLocation => throw _privateConstructorUsedError;
  String get projectSize => throw _privateConstructorUsedError;
  String get noOfFloors => throw _privateConstructorUsedError;
  String get noOfFlats => throw _privateConstructorUsedError;
  String get noOfTowers => throw _privateConstructorUsedError;
  String get noOfFlatsPerFloor => throw _privateConstructorUsedError;
  String get clubhousesize => throw _privateConstructorUsedError;
  String get totalOpenSpace => throw _privateConstructorUsedError;
  String get constructionType => throw _privateConstructorUsedError;
  double get latitude => throw _privateConstructorUsedError;
  double get longitude => throw _privateConstructorUsedError;
  String get reraID => throw _privateConstructorUsedError;
  String get projectType => throw _privateConstructorUsedError;
  String get projectLaunchedDate => throw _privateConstructorUsedError;
  String get projectPossession => throw _privateConstructorUsedError;
  String get pricePerSquareFeetRate => throw _privateConstructorUsedError;
  String get totalArea => throw _privateConstructorUsedError;
  String get landMark => throw _privateConstructorUsedError;
  String get nearByHighlights => throw _privateConstructorUsedError;
  String get amenities => throw _privateConstructorUsedError;
  String get clubHouseAmenities => throw _privateConstructorUsedError;
  String get outdoorAmenities => throw _privateConstructorUsedError;
  List<String> get specifications => throw _privateConstructorUsedError;
  List<String> get projectHighlightsPoints =>
      throw _privateConstructorUsedError;
  Builder get builder => throw _privateConstructorUsedError;
  List<Institution> get educationalInstitutions =>
      throw _privateConstructorUsedError;
  List<Institution> get hospitals => throw _privateConstructorUsedError;
  List<Institution> get offices => throw _privateConstructorUsedError;
  List<Institution> get connectivity => throw _privateConstructorUsedError;
  String get bankName => throw _privateConstructorUsedError;
  int get loanPercentage => throw _privateConstructorUsedError;
  List<Bank> get banks => throw _privateConstructorUsedError;
  List<Institution> get restaurants => throw _privateConstructorUsedError;
  List<Institution> get colleges => throw _privateConstructorUsedError;
  List<Institution> get pharmacies => throw _privateConstructorUsedError;
  List<Institution> get hotspots => throw _privateConstructorUsedError;
  List<Institution> get shopping => throw _privateConstructorUsedError;
  List<Institution> get entertainment => throw _privateConstructorUsedError;

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
  $Res call(
      {String projectId,
      String builderID,
      String name,
      String description,
      String projectLocation,
      String projectSize,
      String noOfFloors,
      String noOfFlats,
      String noOfTowers,
      String noOfFlatsPerFloor,
      String clubhousesize,
      String totalOpenSpace,
      String constructionType,
      double latitude,
      double longitude,
      String reraID,
      String projectType,
      String projectLaunchedDate,
      String projectPossession,
      String pricePerSquareFeetRate,
      String totalArea,
      String landMark,
      String nearByHighlights,
      String amenities,
      String clubHouseAmenities,
      String outdoorAmenities,
      List<String> specifications,
      List<String> projectHighlightsPoints,
      Builder builder,
      List<Institution> educationalInstitutions,
      List<Institution> hospitals,
      List<Institution> offices,
      List<Institution> connectivity,
      String bankName,
      int loanPercentage,
      List<Bank> banks,
      List<Institution> restaurants,
      List<Institution> colleges,
      List<Institution> pharmacies,
      List<Institution> hotspots,
      List<Institution> shopping,
      List<Institution> entertainment});

  $BuilderCopyWith<$Res> get builder;
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
    Object? projectId = null,
    Object? builderID = null,
    Object? name = null,
    Object? description = null,
    Object? projectLocation = null,
    Object? projectSize = null,
    Object? noOfFloors = null,
    Object? noOfFlats = null,
    Object? noOfTowers = null,
    Object? noOfFlatsPerFloor = null,
    Object? clubhousesize = null,
    Object? totalOpenSpace = null,
    Object? constructionType = null,
    Object? latitude = null,
    Object? longitude = null,
    Object? reraID = null,
    Object? projectType = null,
    Object? projectLaunchedDate = null,
    Object? projectPossession = null,
    Object? pricePerSquareFeetRate = null,
    Object? totalArea = null,
    Object? landMark = null,
    Object? nearByHighlights = null,
    Object? amenities = null,
    Object? clubHouseAmenities = null,
    Object? outdoorAmenities = null,
    Object? specifications = null,
    Object? projectHighlightsPoints = null,
    Object? builder = null,
    Object? educationalInstitutions = null,
    Object? hospitals = null,
    Object? offices = null,
    Object? connectivity = null,
    Object? bankName = null,
    Object? loanPercentage = null,
    Object? banks = null,
    Object? restaurants = null,
    Object? colleges = null,
    Object? pharmacies = null,
    Object? hotspots = null,
    Object? shopping = null,
    Object? entertainment = null,
  }) {
    return _then(_value.copyWith(
      projectId: null == projectId
          ? _value.projectId
          : projectId // ignore: cast_nullable_to_non_nullable
              as String,
      builderID: null == builderID
          ? _value.builderID
          : builderID // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      projectLocation: null == projectLocation
          ? _value.projectLocation
          : projectLocation // ignore: cast_nullable_to_non_nullable
              as String,
      projectSize: null == projectSize
          ? _value.projectSize
          : projectSize // ignore: cast_nullable_to_non_nullable
              as String,
      noOfFloors: null == noOfFloors
          ? _value.noOfFloors
          : noOfFloors // ignore: cast_nullable_to_non_nullable
              as String,
      noOfFlats: null == noOfFlats
          ? _value.noOfFlats
          : noOfFlats // ignore: cast_nullable_to_non_nullable
              as String,
      noOfTowers: null == noOfTowers
          ? _value.noOfTowers
          : noOfTowers // ignore: cast_nullable_to_non_nullable
              as String,
      noOfFlatsPerFloor: null == noOfFlatsPerFloor
          ? _value.noOfFlatsPerFloor
          : noOfFlatsPerFloor // ignore: cast_nullable_to_non_nullable
              as String,
      clubhousesize: null == clubhousesize
          ? _value.clubhousesize
          : clubhousesize // ignore: cast_nullable_to_non_nullable
              as String,
      totalOpenSpace: null == totalOpenSpace
          ? _value.totalOpenSpace
          : totalOpenSpace // ignore: cast_nullable_to_non_nullable
              as String,
      constructionType: null == constructionType
          ? _value.constructionType
          : constructionType // ignore: cast_nullable_to_non_nullable
              as String,
      latitude: null == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double,
      longitude: null == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double,
      reraID: null == reraID
          ? _value.reraID
          : reraID // ignore: cast_nullable_to_non_nullable
              as String,
      projectType: null == projectType
          ? _value.projectType
          : projectType // ignore: cast_nullable_to_non_nullable
              as String,
      projectLaunchedDate: null == projectLaunchedDate
          ? _value.projectLaunchedDate
          : projectLaunchedDate // ignore: cast_nullable_to_non_nullable
              as String,
      projectPossession: null == projectPossession
          ? _value.projectPossession
          : projectPossession // ignore: cast_nullable_to_non_nullable
              as String,
      pricePerSquareFeetRate: null == pricePerSquareFeetRate
          ? _value.pricePerSquareFeetRate
          : pricePerSquareFeetRate // ignore: cast_nullable_to_non_nullable
              as String,
      totalArea: null == totalArea
          ? _value.totalArea
          : totalArea // ignore: cast_nullable_to_non_nullable
              as String,
      landMark: null == landMark
          ? _value.landMark
          : landMark // ignore: cast_nullable_to_non_nullable
              as String,
      nearByHighlights: null == nearByHighlights
          ? _value.nearByHighlights
          : nearByHighlights // ignore: cast_nullable_to_non_nullable
              as String,
      amenities: null == amenities
          ? _value.amenities
          : amenities // ignore: cast_nullable_to_non_nullable
              as String,
      clubHouseAmenities: null == clubHouseAmenities
          ? _value.clubHouseAmenities
          : clubHouseAmenities // ignore: cast_nullable_to_non_nullable
              as String,
      outdoorAmenities: null == outdoorAmenities
          ? _value.outdoorAmenities
          : outdoorAmenities // ignore: cast_nullable_to_non_nullable
              as String,
      specifications: null == specifications
          ? _value.specifications
          : specifications // ignore: cast_nullable_to_non_nullable
              as List<String>,
      projectHighlightsPoints: null == projectHighlightsPoints
          ? _value.projectHighlightsPoints
          : projectHighlightsPoints // ignore: cast_nullable_to_non_nullable
              as List<String>,
      builder: null == builder
          ? _value.builder
          : builder // ignore: cast_nullable_to_non_nullable
              as Builder,
      educationalInstitutions: null == educationalInstitutions
          ? _value.educationalInstitutions
          : educationalInstitutions // ignore: cast_nullable_to_non_nullable
              as List<Institution>,
      hospitals: null == hospitals
          ? _value.hospitals
          : hospitals // ignore: cast_nullable_to_non_nullable
              as List<Institution>,
      offices: null == offices
          ? _value.offices
          : offices // ignore: cast_nullable_to_non_nullable
              as List<Institution>,
      connectivity: null == connectivity
          ? _value.connectivity
          : connectivity // ignore: cast_nullable_to_non_nullable
              as List<Institution>,
      bankName: null == bankName
          ? _value.bankName
          : bankName // ignore: cast_nullable_to_non_nullable
              as String,
      loanPercentage: null == loanPercentage
          ? _value.loanPercentage
          : loanPercentage // ignore: cast_nullable_to_non_nullable
              as int,
      banks: null == banks
          ? _value.banks
          : banks // ignore: cast_nullable_to_non_nullable
              as List<Bank>,
      restaurants: null == restaurants
          ? _value.restaurants
          : restaurants // ignore: cast_nullable_to_non_nullable
              as List<Institution>,
      colleges: null == colleges
          ? _value.colleges
          : colleges // ignore: cast_nullable_to_non_nullable
              as List<Institution>,
      pharmacies: null == pharmacies
          ? _value.pharmacies
          : pharmacies // ignore: cast_nullable_to_non_nullable
              as List<Institution>,
      hotspots: null == hotspots
          ? _value.hotspots
          : hotspots // ignore: cast_nullable_to_non_nullable
              as List<Institution>,
      shopping: null == shopping
          ? _value.shopping
          : shopping // ignore: cast_nullable_to_non_nullable
              as List<Institution>,
      entertainment: null == entertainment
          ? _value.entertainment
          : entertainment // ignore: cast_nullable_to_non_nullable
              as List<Institution>,
    ) as $Val);
  }

  /// Create a copy of ProjectDetails
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $BuilderCopyWith<$Res> get builder {
    return $BuilderCopyWith<$Res>(_value.builder, (value) {
      return _then(_value.copyWith(builder: value) as $Val);
    });
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
  $Res call(
      {String projectId,
      String builderID,
      String name,
      String description,
      String projectLocation,
      String projectSize,
      String noOfFloors,
      String noOfFlats,
      String noOfTowers,
      String noOfFlatsPerFloor,
      String clubhousesize,
      String totalOpenSpace,
      String constructionType,
      double latitude,
      double longitude,
      String reraID,
      String projectType,
      String projectLaunchedDate,
      String projectPossession,
      String pricePerSquareFeetRate,
      String totalArea,
      String landMark,
      String nearByHighlights,
      String amenities,
      String clubHouseAmenities,
      String outdoorAmenities,
      List<String> specifications,
      List<String> projectHighlightsPoints,
      Builder builder,
      List<Institution> educationalInstitutions,
      List<Institution> hospitals,
      List<Institution> offices,
      List<Institution> connectivity,
      String bankName,
      int loanPercentage,
      List<Bank> banks,
      List<Institution> restaurants,
      List<Institution> colleges,
      List<Institution> pharmacies,
      List<Institution> hotspots,
      List<Institution> shopping,
      List<Institution> entertainment});

  @override
  $BuilderCopyWith<$Res> get builder;
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
    Object? projectId = null,
    Object? builderID = null,
    Object? name = null,
    Object? description = null,
    Object? projectLocation = null,
    Object? projectSize = null,
    Object? noOfFloors = null,
    Object? noOfFlats = null,
    Object? noOfTowers = null,
    Object? noOfFlatsPerFloor = null,
    Object? clubhousesize = null,
    Object? totalOpenSpace = null,
    Object? constructionType = null,
    Object? latitude = null,
    Object? longitude = null,
    Object? reraID = null,
    Object? projectType = null,
    Object? projectLaunchedDate = null,
    Object? projectPossession = null,
    Object? pricePerSquareFeetRate = null,
    Object? totalArea = null,
    Object? landMark = null,
    Object? nearByHighlights = null,
    Object? amenities = null,
    Object? clubHouseAmenities = null,
    Object? outdoorAmenities = null,
    Object? specifications = null,
    Object? projectHighlightsPoints = null,
    Object? builder = null,
    Object? educationalInstitutions = null,
    Object? hospitals = null,
    Object? offices = null,
    Object? connectivity = null,
    Object? bankName = null,
    Object? loanPercentage = null,
    Object? banks = null,
    Object? restaurants = null,
    Object? colleges = null,
    Object? pharmacies = null,
    Object? hotspots = null,
    Object? shopping = null,
    Object? entertainment = null,
  }) {
    return _then(_$ProjectDetailsImpl(
      projectId: null == projectId
          ? _value.projectId
          : projectId // ignore: cast_nullable_to_non_nullable
              as String,
      builderID: null == builderID
          ? _value.builderID
          : builderID // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      projectLocation: null == projectLocation
          ? _value.projectLocation
          : projectLocation // ignore: cast_nullable_to_non_nullable
              as String,
      projectSize: null == projectSize
          ? _value.projectSize
          : projectSize // ignore: cast_nullable_to_non_nullable
              as String,
      noOfFloors: null == noOfFloors
          ? _value.noOfFloors
          : noOfFloors // ignore: cast_nullable_to_non_nullable
              as String,
      noOfFlats: null == noOfFlats
          ? _value.noOfFlats
          : noOfFlats // ignore: cast_nullable_to_non_nullable
              as String,
      noOfTowers: null == noOfTowers
          ? _value.noOfTowers
          : noOfTowers // ignore: cast_nullable_to_non_nullable
              as String,
      noOfFlatsPerFloor: null == noOfFlatsPerFloor
          ? _value.noOfFlatsPerFloor
          : noOfFlatsPerFloor // ignore: cast_nullable_to_non_nullable
              as String,
      clubhousesize: null == clubhousesize
          ? _value.clubhousesize
          : clubhousesize // ignore: cast_nullable_to_non_nullable
              as String,
      totalOpenSpace: null == totalOpenSpace
          ? _value.totalOpenSpace
          : totalOpenSpace // ignore: cast_nullable_to_non_nullable
              as String,
      constructionType: null == constructionType
          ? _value.constructionType
          : constructionType // ignore: cast_nullable_to_non_nullable
              as String,
      latitude: null == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double,
      longitude: null == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double,
      reraID: null == reraID
          ? _value.reraID
          : reraID // ignore: cast_nullable_to_non_nullable
              as String,
      projectType: null == projectType
          ? _value.projectType
          : projectType // ignore: cast_nullable_to_non_nullable
              as String,
      projectLaunchedDate: null == projectLaunchedDate
          ? _value.projectLaunchedDate
          : projectLaunchedDate // ignore: cast_nullable_to_non_nullable
              as String,
      projectPossession: null == projectPossession
          ? _value.projectPossession
          : projectPossession // ignore: cast_nullable_to_non_nullable
              as String,
      pricePerSquareFeetRate: null == pricePerSquareFeetRate
          ? _value.pricePerSquareFeetRate
          : pricePerSquareFeetRate // ignore: cast_nullable_to_non_nullable
              as String,
      totalArea: null == totalArea
          ? _value.totalArea
          : totalArea // ignore: cast_nullable_to_non_nullable
              as String,
      landMark: null == landMark
          ? _value.landMark
          : landMark // ignore: cast_nullable_to_non_nullable
              as String,
      nearByHighlights: null == nearByHighlights
          ? _value.nearByHighlights
          : nearByHighlights // ignore: cast_nullable_to_non_nullable
              as String,
      amenities: null == amenities
          ? _value.amenities
          : amenities // ignore: cast_nullable_to_non_nullable
              as String,
      clubHouseAmenities: null == clubHouseAmenities
          ? _value.clubHouseAmenities
          : clubHouseAmenities // ignore: cast_nullable_to_non_nullable
              as String,
      outdoorAmenities: null == outdoorAmenities
          ? _value.outdoorAmenities
          : outdoorAmenities // ignore: cast_nullable_to_non_nullable
              as String,
      specifications: null == specifications
          ? _value._specifications
          : specifications // ignore: cast_nullable_to_non_nullable
              as List<String>,
      projectHighlightsPoints: null == projectHighlightsPoints
          ? _value._projectHighlightsPoints
          : projectHighlightsPoints // ignore: cast_nullable_to_non_nullable
              as List<String>,
      builder: null == builder
          ? _value.builder
          : builder // ignore: cast_nullable_to_non_nullable
              as Builder,
      educationalInstitutions: null == educationalInstitutions
          ? _value._educationalInstitutions
          : educationalInstitutions // ignore: cast_nullable_to_non_nullable
              as List<Institution>,
      hospitals: null == hospitals
          ? _value._hospitals
          : hospitals // ignore: cast_nullable_to_non_nullable
              as List<Institution>,
      offices: null == offices
          ? _value._offices
          : offices // ignore: cast_nullable_to_non_nullable
              as List<Institution>,
      connectivity: null == connectivity
          ? _value._connectivity
          : connectivity // ignore: cast_nullable_to_non_nullable
              as List<Institution>,
      bankName: null == bankName
          ? _value.bankName
          : bankName // ignore: cast_nullable_to_non_nullable
              as String,
      loanPercentage: null == loanPercentage
          ? _value.loanPercentage
          : loanPercentage // ignore: cast_nullable_to_non_nullable
              as int,
      banks: null == banks
          ? _value._banks
          : banks // ignore: cast_nullable_to_non_nullable
              as List<Bank>,
      restaurants: null == restaurants
          ? _value._restaurants
          : restaurants // ignore: cast_nullable_to_non_nullable
              as List<Institution>,
      colleges: null == colleges
          ? _value._colleges
          : colleges // ignore: cast_nullable_to_non_nullable
              as List<Institution>,
      pharmacies: null == pharmacies
          ? _value._pharmacies
          : pharmacies // ignore: cast_nullable_to_non_nullable
              as List<Institution>,
      hotspots: null == hotspots
          ? _value._hotspots
          : hotspots // ignore: cast_nullable_to_non_nullable
              as List<Institution>,
      shopping: null == shopping
          ? _value._shopping
          : shopping // ignore: cast_nullable_to_non_nullable
              as List<Institution>,
      entertainment: null == entertainment
          ? _value._entertainment
          : entertainment // ignore: cast_nullable_to_non_nullable
              as List<Institution>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ProjectDetailsImpl implements _ProjectDetails {
  const _$ProjectDetailsImpl(
      {this.projectId = '',
      this.builderID = '',
      this.name = '',
      this.description = '',
      this.projectLocation = '',
      this.projectSize = '',
      this.noOfFloors = '',
      this.noOfFlats = '',
      this.noOfTowers = '',
      this.noOfFlatsPerFloor = '',
      this.clubhousesize = '',
      this.totalOpenSpace = '',
      this.constructionType = '',
      this.latitude = 0.0,
      this.longitude = 0.0,
      this.reraID = '',
      this.projectType = '',
      this.projectLaunchedDate = '',
      this.projectPossession = '',
      this.pricePerSquareFeetRate = '0',
      this.totalArea = '',
      this.landMark = '',
      this.nearByHighlights = '',
      this.amenities = '',
      this.clubHouseAmenities = '',
      this.outdoorAmenities = '',
      final List<String> specifications = const [],
      final List<String> projectHighlightsPoints = const [],
      this.builder = const Builder(),
      final List<Institution> educationalInstitutions = const [],
      final List<Institution> hospitals = const [],
      final List<Institution> offices = const [],
      final List<Institution> connectivity = const [],
      this.bankName = '',
      this.loanPercentage = 0,
      final List<Bank> banks = const [],
      final List<Institution> restaurants = const [],
      final List<Institution> colleges = const [],
      final List<Institution> pharmacies = const [],
      final List<Institution> hotspots = const [],
      final List<Institution> shopping = const [],
      final List<Institution> entertainment = const []})
      : _specifications = specifications,
        _projectHighlightsPoints = projectHighlightsPoints,
        _educationalInstitutions = educationalInstitutions,
        _hospitals = hospitals,
        _offices = offices,
        _connectivity = connectivity,
        _banks = banks,
        _restaurants = restaurants,
        _colleges = colleges,
        _pharmacies = pharmacies,
        _hotspots = hotspots,
        _shopping = shopping,
        _entertainment = entertainment;

  factory _$ProjectDetailsImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProjectDetailsImplFromJson(json);

  @override
  @JsonKey()
  final String projectId;
  @override
  @JsonKey()
  final String builderID;
  @override
  @JsonKey()
  final String name;
  @override
  @JsonKey()
  final String description;
  @override
  @JsonKey()
  final String projectLocation;
  @override
  @JsonKey()
  final String projectSize;
  @override
  @JsonKey()
  final String noOfFloors;
  @override
  @JsonKey()
  final String noOfFlats;
  @override
  @JsonKey()
  final String noOfTowers;
  @override
  @JsonKey()
  final String noOfFlatsPerFloor;
  @override
  @JsonKey()
  final String clubhousesize;
  @override
  @JsonKey()
  final String totalOpenSpace;
  @override
  @JsonKey()
  final String constructionType;
  @override
  @JsonKey()
  final double latitude;
  @override
  @JsonKey()
  final double longitude;
  @override
  @JsonKey()
  final String reraID;
  @override
  @JsonKey()
  final String projectType;
  @override
  @JsonKey()
  final String projectLaunchedDate;
  @override
  @JsonKey()
  final String projectPossession;
  @override
  @JsonKey()
  final String pricePerSquareFeetRate;
  @override
  @JsonKey()
  final String totalArea;
  @override
  @JsonKey()
  final String landMark;
  @override
  @JsonKey()
  final String nearByHighlights;
  @override
  @JsonKey()
  final String amenities;
  @override
  @JsonKey()
  final String clubHouseAmenities;
  @override
  @JsonKey()
  final String outdoorAmenities;
  final List<String> _specifications;
  @override
  @JsonKey()
  List<String> get specifications {
    if (_specifications is EqualUnmodifiableListView) return _specifications;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_specifications);
  }

  final List<String> _projectHighlightsPoints;
  @override
  @JsonKey()
  List<String> get projectHighlightsPoints {
    if (_projectHighlightsPoints is EqualUnmodifiableListView)
      return _projectHighlightsPoints;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_projectHighlightsPoints);
  }

  @override
  @JsonKey()
  final Builder builder;
  final List<Institution> _educationalInstitutions;
  @override
  @JsonKey()
  List<Institution> get educationalInstitutions {
    if (_educationalInstitutions is EqualUnmodifiableListView)
      return _educationalInstitutions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_educationalInstitutions);
  }

  final List<Institution> _hospitals;
  @override
  @JsonKey()
  List<Institution> get hospitals {
    if (_hospitals is EqualUnmodifiableListView) return _hospitals;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_hospitals);
  }

  final List<Institution> _offices;
  @override
  @JsonKey()
  List<Institution> get offices {
    if (_offices is EqualUnmodifiableListView) return _offices;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_offices);
  }

  final List<Institution> _connectivity;
  @override
  @JsonKey()
  List<Institution> get connectivity {
    if (_connectivity is EqualUnmodifiableListView) return _connectivity;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_connectivity);
  }

  @override
  @JsonKey()
  final String bankName;
  @override
  @JsonKey()
  final int loanPercentage;
  final List<Bank> _banks;
  @override
  @JsonKey()
  List<Bank> get banks {
    if (_banks is EqualUnmodifiableListView) return _banks;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_banks);
  }

  final List<Institution> _restaurants;
  @override
  @JsonKey()
  List<Institution> get restaurants {
    if (_restaurants is EqualUnmodifiableListView) return _restaurants;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_restaurants);
  }

  final List<Institution> _colleges;
  @override
  @JsonKey()
  List<Institution> get colleges {
    if (_colleges is EqualUnmodifiableListView) return _colleges;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_colleges);
  }

  final List<Institution> _pharmacies;
  @override
  @JsonKey()
  List<Institution> get pharmacies {
    if (_pharmacies is EqualUnmodifiableListView) return _pharmacies;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_pharmacies);
  }

  final List<Institution> _hotspots;
  @override
  @JsonKey()
  List<Institution> get hotspots {
    if (_hotspots is EqualUnmodifiableListView) return _hotspots;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_hotspots);
  }

  final List<Institution> _shopping;
  @override
  @JsonKey()
  List<Institution> get shopping {
    if (_shopping is EqualUnmodifiableListView) return _shopping;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_shopping);
  }

  final List<Institution> _entertainment;
  @override
  @JsonKey()
  List<Institution> get entertainment {
    if (_entertainment is EqualUnmodifiableListView) return _entertainment;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_entertainment);
  }

  @override
  String toString() {
    return 'ProjectDetails(projectId: $projectId, builderID: $builderID, name: $name, description: $description, projectLocation: $projectLocation, projectSize: $projectSize, noOfFloors: $noOfFloors, noOfFlats: $noOfFlats, noOfTowers: $noOfTowers, noOfFlatsPerFloor: $noOfFlatsPerFloor, clubhousesize: $clubhousesize, totalOpenSpace: $totalOpenSpace, constructionType: $constructionType, latitude: $latitude, longitude: $longitude, reraID: $reraID, projectType: $projectType, projectLaunchedDate: $projectLaunchedDate, projectPossession: $projectPossession, pricePerSquareFeetRate: $pricePerSquareFeetRate, totalArea: $totalArea, landMark: $landMark, nearByHighlights: $nearByHighlights, amenities: $amenities, clubHouseAmenities: $clubHouseAmenities, outdoorAmenities: $outdoorAmenities, specifications: $specifications, projectHighlightsPoints: $projectHighlightsPoints, builder: $builder, educationalInstitutions: $educationalInstitutions, hospitals: $hospitals, offices: $offices, connectivity: $connectivity, bankName: $bankName, loanPercentage: $loanPercentage, banks: $banks, restaurants: $restaurants, colleges: $colleges, pharmacies: $pharmacies, hotspots: $hotspots, shopping: $shopping, entertainment: $entertainment)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProjectDetailsImpl &&
            (identical(other.projectId, projectId) ||
                other.projectId == projectId) &&
            (identical(other.builderID, builderID) ||
                other.builderID == builderID) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.projectLocation, projectLocation) ||
                other.projectLocation == projectLocation) &&
            (identical(other.projectSize, projectSize) ||
                other.projectSize == projectSize) &&
            (identical(other.noOfFloors, noOfFloors) ||
                other.noOfFloors == noOfFloors) &&
            (identical(other.noOfFlats, noOfFlats) ||
                other.noOfFlats == noOfFlats) &&
            (identical(other.noOfTowers, noOfTowers) ||
                other.noOfTowers == noOfTowers) &&
            (identical(other.noOfFlatsPerFloor, noOfFlatsPerFloor) ||
                other.noOfFlatsPerFloor == noOfFlatsPerFloor) &&
            (identical(other.clubhousesize, clubhousesize) ||
                other.clubhousesize == clubhousesize) &&
            (identical(other.totalOpenSpace, totalOpenSpace) ||
                other.totalOpenSpace == totalOpenSpace) &&
            (identical(other.constructionType, constructionType) ||
                other.constructionType == constructionType) &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude) &&
            (identical(other.reraID, reraID) || other.reraID == reraID) &&
            (identical(other.projectType, projectType) ||
                other.projectType == projectType) &&
            (identical(other.projectLaunchedDate, projectLaunchedDate) ||
                other.projectLaunchedDate == projectLaunchedDate) &&
            (identical(other.projectPossession, projectPossession) ||
                other.projectPossession == projectPossession) &&
            (identical(other.pricePerSquareFeetRate, pricePerSquareFeetRate) ||
                other.pricePerSquareFeetRate == pricePerSquareFeetRate) &&
            (identical(other.totalArea, totalArea) ||
                other.totalArea == totalArea) &&
            (identical(other.landMark, landMark) ||
                other.landMark == landMark) &&
            (identical(other.nearByHighlights, nearByHighlights) ||
                other.nearByHighlights == nearByHighlights) &&
            (identical(other.amenities, amenities) ||
                other.amenities == amenities) &&
            (identical(other.clubHouseAmenities, clubHouseAmenities) ||
                other.clubHouseAmenities == clubHouseAmenities) &&
            (identical(other.outdoorAmenities, outdoorAmenities) ||
                other.outdoorAmenities == outdoorAmenities) &&
            const DeepCollectionEquality()
                .equals(other._specifications, _specifications) &&
            const DeepCollectionEquality().equals(
                other._projectHighlightsPoints, _projectHighlightsPoints) &&
            (identical(other.builder, builder) || other.builder == builder) &&
            const DeepCollectionEquality().equals(
                other._educationalInstitutions, _educationalInstitutions) &&
            const DeepCollectionEquality()
                .equals(other._hospitals, _hospitals) &&
            const DeepCollectionEquality().equals(other._offices, _offices) &&
            const DeepCollectionEquality()
                .equals(other._connectivity, _connectivity) &&
            (identical(other.bankName, bankName) ||
                other.bankName == bankName) &&
            (identical(other.loanPercentage, loanPercentage) ||
                other.loanPercentage == loanPercentage) &&
            const DeepCollectionEquality().equals(other._banks, _banks) &&
            const DeepCollectionEquality()
                .equals(other._restaurants, _restaurants) &&
            const DeepCollectionEquality().equals(other._colleges, _colleges) &&
            const DeepCollectionEquality()
                .equals(other._pharmacies, _pharmacies) &&
            const DeepCollectionEquality().equals(other._hotspots, _hotspots) &&
            const DeepCollectionEquality().equals(other._shopping, _shopping) &&
            const DeepCollectionEquality()
                .equals(other._entertainment, _entertainment));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        projectId,
        builderID,
        name,
        description,
        projectLocation,
        projectSize,
        noOfFloors,
        noOfFlats,
        noOfTowers,
        noOfFlatsPerFloor,
        clubhousesize,
        totalOpenSpace,
        constructionType,
        latitude,
        longitude,
        reraID,
        projectType,
        projectLaunchedDate,
        projectPossession,
        pricePerSquareFeetRate,
        totalArea,
        landMark,
        nearByHighlights,
        amenities,
        clubHouseAmenities,
        outdoorAmenities,
        const DeepCollectionEquality().hash(_specifications),
        const DeepCollectionEquality().hash(_projectHighlightsPoints),
        builder,
        const DeepCollectionEquality().hash(_educationalInstitutions),
        const DeepCollectionEquality().hash(_hospitals),
        const DeepCollectionEquality().hash(_offices),
        const DeepCollectionEquality().hash(_connectivity),
        bankName,
        loanPercentage,
        const DeepCollectionEquality().hash(_banks),
        const DeepCollectionEquality().hash(_restaurants),
        const DeepCollectionEquality().hash(_colleges),
        const DeepCollectionEquality().hash(_pharmacies),
        const DeepCollectionEquality().hash(_hotspots),
        const DeepCollectionEquality().hash(_shopping),
        const DeepCollectionEquality().hash(_entertainment)
      ]);

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
      {final String projectId,
      final String builderID,
      final String name,
      final String description,
      final String projectLocation,
      final String projectSize,
      final String noOfFloors,
      final String noOfFlats,
      final String noOfTowers,
      final String noOfFlatsPerFloor,
      final String clubhousesize,
      final String totalOpenSpace,
      final String constructionType,
      final double latitude,
      final double longitude,
      final String reraID,
      final String projectType,
      final String projectLaunchedDate,
      final String projectPossession,
      final String pricePerSquareFeetRate,
      final String totalArea,
      final String landMark,
      final String nearByHighlights,
      final String amenities,
      final String clubHouseAmenities,
      final String outdoorAmenities,
      final List<String> specifications,
      final List<String> projectHighlightsPoints,
      final Builder builder,
      final List<Institution> educationalInstitutions,
      final List<Institution> hospitals,
      final List<Institution> offices,
      final List<Institution> connectivity,
      final String bankName,
      final int loanPercentage,
      final List<Bank> banks,
      final List<Institution> restaurants,
      final List<Institution> colleges,
      final List<Institution> pharmacies,
      final List<Institution> hotspots,
      final List<Institution> shopping,
      final List<Institution> entertainment}) = _$ProjectDetailsImpl;

  factory _ProjectDetails.fromJson(Map<String, dynamic> json) =
      _$ProjectDetailsImpl.fromJson;

  @override
  String get projectId;
  @override
  String get builderID;
  @override
  String get name;
  @override
  String get description;
  @override
  String get projectLocation;
  @override
  String get projectSize;
  @override
  String get noOfFloors;
  @override
  String get noOfFlats;
  @override
  String get noOfTowers;
  @override
  String get noOfFlatsPerFloor;
  @override
  String get clubhousesize;
  @override
  String get totalOpenSpace;
  @override
  String get constructionType;
  @override
  double get latitude;
  @override
  double get longitude;
  @override
  String get reraID;
  @override
  String get projectType;
  @override
  String get projectLaunchedDate;
  @override
  String get projectPossession;
  @override
  String get pricePerSquareFeetRate;
  @override
  String get totalArea;
  @override
  String get landMark;
  @override
  String get nearByHighlights;
  @override
  String get amenities;
  @override
  String get clubHouseAmenities;
  @override
  String get outdoorAmenities;
  @override
  List<String> get specifications;
  @override
  List<String> get projectHighlightsPoints;
  @override
  Builder get builder;
  @override
  List<Institution> get educationalInstitutions;
  @override
  List<Institution> get hospitals;
  @override
  List<Institution> get offices;
  @override
  List<Institution> get connectivity;
  @override
  String get bankName;
  @override
  int get loanPercentage;
  @override
  List<Bank> get banks;
  @override
  List<Institution> get restaurants;
  @override
  List<Institution> get colleges;
  @override
  List<Institution> get pharmacies;
  @override
  List<Institution> get hotspots;
  @override
  List<Institution> get shopping;
  @override
  List<Institution> get entertainment;

  /// Create a copy of ProjectDetails
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProjectDetailsImplCopyWith<_$ProjectDetailsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Bank _$BankFromJson(Map<String, dynamic> json) {
  return _Bank.fromJson(json);
}

/// @nodoc
mixin _$Bank {
  String get bankName => throw _privateConstructorUsedError;
  String get bankLogo => throw _privateConstructorUsedError;
  int get loanPercentage => throw _privateConstructorUsedError;

  /// Serializes this Bank to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Bank
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BankCopyWith<Bank> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BankCopyWith<$Res> {
  factory $BankCopyWith(Bank value, $Res Function(Bank) then) =
      _$BankCopyWithImpl<$Res, Bank>;
  @useResult
  $Res call({String bankName, String bankLogo, int loanPercentage});
}

/// @nodoc
class _$BankCopyWithImpl<$Res, $Val extends Bank>
    implements $BankCopyWith<$Res> {
  _$BankCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Bank
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? bankName = null,
    Object? bankLogo = null,
    Object? loanPercentage = null,
  }) {
    return _then(_value.copyWith(
      bankName: null == bankName
          ? _value.bankName
          : bankName // ignore: cast_nullable_to_non_nullable
              as String,
      bankLogo: null == bankLogo
          ? _value.bankLogo
          : bankLogo // ignore: cast_nullable_to_non_nullable
              as String,
      loanPercentage: null == loanPercentage
          ? _value.loanPercentage
          : loanPercentage // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BankImplCopyWith<$Res> implements $BankCopyWith<$Res> {
  factory _$$BankImplCopyWith(
          _$BankImpl value, $Res Function(_$BankImpl) then) =
      __$$BankImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String bankName, String bankLogo, int loanPercentage});
}

/// @nodoc
class __$$BankImplCopyWithImpl<$Res>
    extends _$BankCopyWithImpl<$Res, _$BankImpl>
    implements _$$BankImplCopyWith<$Res> {
  __$$BankImplCopyWithImpl(_$BankImpl _value, $Res Function(_$BankImpl) _then)
      : super(_value, _then);

  /// Create a copy of Bank
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? bankName = null,
    Object? bankLogo = null,
    Object? loanPercentage = null,
  }) {
    return _then(_$BankImpl(
      bankName: null == bankName
          ? _value.bankName
          : bankName // ignore: cast_nullable_to_non_nullable
              as String,
      bankLogo: null == bankLogo
          ? _value.bankLogo
          : bankLogo // ignore: cast_nullable_to_non_nullable
              as String,
      loanPercentage: null == loanPercentage
          ? _value.loanPercentage
          : loanPercentage // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BankImpl implements _Bank {
  const _$BankImpl(
      {this.bankName = '', this.bankLogo = '', this.loanPercentage = 0});

  factory _$BankImpl.fromJson(Map<String, dynamic> json) =>
      _$$BankImplFromJson(json);

  @override
  @JsonKey()
  final String bankName;
  @override
  @JsonKey()
  final String bankLogo;
  @override
  @JsonKey()
  final int loanPercentage;

  @override
  String toString() {
    return 'Bank(bankName: $bankName, bankLogo: $bankLogo, loanPercentage: $loanPercentage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BankImpl &&
            (identical(other.bankName, bankName) ||
                other.bankName == bankName) &&
            (identical(other.bankLogo, bankLogo) ||
                other.bankLogo == bankLogo) &&
            (identical(other.loanPercentage, loanPercentage) ||
                other.loanPercentage == loanPercentage));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, bankName, bankLogo, loanPercentage);

  /// Create a copy of Bank
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BankImplCopyWith<_$BankImpl> get copyWith =>
      __$$BankImplCopyWithImpl<_$BankImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BankImplToJson(
      this,
    );
  }
}

abstract class _Bank implements Bank {
  const factory _Bank(
      {final String bankName,
      final String bankLogo,
      final int loanPercentage}) = _$BankImpl;

  factory _Bank.fromJson(Map<String, dynamic> json) = _$BankImpl.fromJson;

  @override
  String get bankName;
  @override
  String get bankLogo;
  @override
  int get loanPercentage;

  /// Create a copy of Bank
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BankImplCopyWith<_$BankImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Builder _$BuilderFromJson(Map<String, dynamic> json) {
  return _Builder.fromJson(json);
}

/// @nodoc
mixin _$Builder {
  String get CompanyPhone => throw _privateConstructorUsedError;
  String get CompanyName => throw _privateConstructorUsedError;

  /// Serializes this Builder to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Builder
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BuilderCopyWith<Builder> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BuilderCopyWith<$Res> {
  factory $BuilderCopyWith(Builder value, $Res Function(Builder) then) =
      _$BuilderCopyWithImpl<$Res, Builder>;
  @useResult
  $Res call({String CompanyPhone, String CompanyName});
}

/// @nodoc
class _$BuilderCopyWithImpl<$Res, $Val extends Builder>
    implements $BuilderCopyWith<$Res> {
  _$BuilderCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Builder
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? CompanyPhone = null,
    Object? CompanyName = null,
  }) {
    return _then(_value.copyWith(
      CompanyPhone: null == CompanyPhone
          ? _value.CompanyPhone
          : CompanyPhone // ignore: cast_nullable_to_non_nullable
              as String,
      CompanyName: null == CompanyName
          ? _value.CompanyName
          : CompanyName // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BuilderImplCopyWith<$Res> implements $BuilderCopyWith<$Res> {
  factory _$$BuilderImplCopyWith(
          _$BuilderImpl value, $Res Function(_$BuilderImpl) then) =
      __$$BuilderImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String CompanyPhone, String CompanyName});
}

/// @nodoc
class __$$BuilderImplCopyWithImpl<$Res>
    extends _$BuilderCopyWithImpl<$Res, _$BuilderImpl>
    implements _$$BuilderImplCopyWith<$Res> {
  __$$BuilderImplCopyWithImpl(
      _$BuilderImpl _value, $Res Function(_$BuilderImpl) _then)
      : super(_value, _then);

  /// Create a copy of Builder
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? CompanyPhone = null,
    Object? CompanyName = null,
  }) {
    return _then(_$BuilderImpl(
      CompanyPhone: null == CompanyPhone
          ? _value.CompanyPhone
          : CompanyPhone // ignore: cast_nullable_to_non_nullable
              as String,
      CompanyName: null == CompanyName
          ? _value.CompanyName
          : CompanyName // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BuilderImpl implements _Builder {
  const _$BuilderImpl({this.CompanyPhone = '', this.CompanyName = ''});

  factory _$BuilderImpl.fromJson(Map<String, dynamic> json) =>
      _$$BuilderImplFromJson(json);

  @override
  @JsonKey()
  final String CompanyPhone;
  @override
  @JsonKey()
  final String CompanyName;

  @override
  String toString() {
    return 'Builder(CompanyPhone: $CompanyPhone, CompanyName: $CompanyName)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BuilderImpl &&
            (identical(other.CompanyPhone, CompanyPhone) ||
                other.CompanyPhone == CompanyPhone) &&
            (identical(other.CompanyName, CompanyName) ||
                other.CompanyName == CompanyName));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, CompanyPhone, CompanyName);

  /// Create a copy of Builder
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BuilderImplCopyWith<_$BuilderImpl> get copyWith =>
      __$$BuilderImplCopyWithImpl<_$BuilderImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BuilderImplToJson(
      this,
    );
  }
}

abstract class _Builder implements Builder {
  const factory _Builder(
      {final String CompanyPhone, final String CompanyName}) = _$BuilderImpl;

  factory _Builder.fromJson(Map<String, dynamic> json) = _$BuilderImpl.fromJson;

  @override
  String get CompanyPhone;
  @override
  String get CompanyName;

  /// Create a copy of Builder
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BuilderImplCopyWith<_$BuilderImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Institution _$InstitutionFromJson(Map<String, dynamic> json) {
  return _Institution.fromJson(json);
}

/// @nodoc
mixin _$Institution {
  String get name => throw _privateConstructorUsedError;
  String get dist => throw _privateConstructorUsedError;
  String get time => throw _privateConstructorUsedError;

  /// Serializes this Institution to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Institution
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $InstitutionCopyWith<Institution> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $InstitutionCopyWith<$Res> {
  factory $InstitutionCopyWith(
          Institution value, $Res Function(Institution) then) =
      _$InstitutionCopyWithImpl<$Res, Institution>;
  @useResult
  $Res call({String name, String dist, String time});
}

/// @nodoc
class _$InstitutionCopyWithImpl<$Res, $Val extends Institution>
    implements $InstitutionCopyWith<$Res> {
  _$InstitutionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Institution
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? dist = null,
    Object? time = null,
  }) {
    return _then(_value.copyWith(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      dist: null == dist
          ? _value.dist
          : dist // ignore: cast_nullable_to_non_nullable
              as String,
      time: null == time
          ? _value.time
          : time // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$InstitutionImplCopyWith<$Res>
    implements $InstitutionCopyWith<$Res> {
  factory _$$InstitutionImplCopyWith(
          _$InstitutionImpl value, $Res Function(_$InstitutionImpl) then) =
      __$$InstitutionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String name, String dist, String time});
}

/// @nodoc
class __$$InstitutionImplCopyWithImpl<$Res>
    extends _$InstitutionCopyWithImpl<$Res, _$InstitutionImpl>
    implements _$$InstitutionImplCopyWith<$Res> {
  __$$InstitutionImplCopyWithImpl(
      _$InstitutionImpl _value, $Res Function(_$InstitutionImpl) _then)
      : super(_value, _then);

  /// Create a copy of Institution
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? dist = null,
    Object? time = null,
  }) {
    return _then(_$InstitutionImpl(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      dist: null == dist
          ? _value.dist
          : dist // ignore: cast_nullable_to_non_nullable
              as String,
      time: null == time
          ? _value.time
          : time // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$InstitutionImpl implements _Institution {
  const _$InstitutionImpl({this.name = '', this.dist = '', this.time = ''});

  factory _$InstitutionImpl.fromJson(Map<String, dynamic> json) =>
      _$$InstitutionImplFromJson(json);

  @override
  @JsonKey()
  final String name;
  @override
  @JsonKey()
  final String dist;
  @override
  @JsonKey()
  final String time;

  @override
  String toString() {
    return 'Institution(name: $name, dist: $dist, time: $time)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InstitutionImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.dist, dist) || other.dist == dist) &&
            (identical(other.time, time) || other.time == time));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, name, dist, time);

  /// Create a copy of Institution
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$InstitutionImplCopyWith<_$InstitutionImpl> get copyWith =>
      __$$InstitutionImplCopyWithImpl<_$InstitutionImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$InstitutionImplToJson(
      this,
    );
  }
}

abstract class _Institution implements Institution {
  const factory _Institution(
      {final String name,
      final String dist,
      final String time}) = _$InstitutionImpl;

  factory _Institution.fromJson(Map<String, dynamic> json) =
      _$InstitutionImpl.fromJson;

  @override
  String get name;
  @override
  String get dist;
  @override
  String get time;

  /// Create a copy of Institution
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$InstitutionImplCopyWith<_$InstitutionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

UnitPlanConfig _$UnitPlanConfigFromJson(Map<String, dynamic> json) {
  return _UnitPlanConfig.fromJson(json);
}

/// @nodoc
mixin _$UnitPlanConfig {
  String get bHKType => throw _privateConstructorUsedError;
  String get sizeInSqft => throw _privateConstructorUsedError;
  String get facing => throw _privateConstructorUsedError;
  List<String> get unitPlanConfigFiles => throw _privateConstructorUsedError;

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
  $Res call(
      {String bHKType,
      String sizeInSqft,
      String facing,
      List<String> unitPlanConfigFiles});
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
    Object? bHKType = null,
    Object? sizeInSqft = null,
    Object? facing = null,
    Object? unitPlanConfigFiles = null,
  }) {
    return _then(_value.copyWith(
      bHKType: null == bHKType
          ? _value.bHKType
          : bHKType // ignore: cast_nullable_to_non_nullable
              as String,
      sizeInSqft: null == sizeInSqft
          ? _value.sizeInSqft
          : sizeInSqft // ignore: cast_nullable_to_non_nullable
              as String,
      facing: null == facing
          ? _value.facing
          : facing // ignore: cast_nullable_to_non_nullable
              as String,
      unitPlanConfigFiles: null == unitPlanConfigFiles
          ? _value.unitPlanConfigFiles
          : unitPlanConfigFiles // ignore: cast_nullable_to_non_nullable
              as List<String>,
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
  $Res call(
      {String bHKType,
      String sizeInSqft,
      String facing,
      List<String> unitPlanConfigFiles});
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
    Object? bHKType = null,
    Object? sizeInSqft = null,
    Object? facing = null,
    Object? unitPlanConfigFiles = null,
  }) {
    return _then(_$UnitPlanConfigImpl(
      bHKType: null == bHKType
          ? _value.bHKType
          : bHKType // ignore: cast_nullable_to_non_nullable
              as String,
      sizeInSqft: null == sizeInSqft
          ? _value.sizeInSqft
          : sizeInSqft // ignore: cast_nullable_to_non_nullable
              as String,
      facing: null == facing
          ? _value.facing
          : facing // ignore: cast_nullable_to_non_nullable
              as String,
      unitPlanConfigFiles: null == unitPlanConfigFiles
          ? _value._unitPlanConfigFiles
          : unitPlanConfigFiles // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UnitPlanConfigImpl implements _UnitPlanConfig {
  const _$UnitPlanConfigImpl(
      {this.bHKType = '',
      this.sizeInSqft = '',
      this.facing = '',
      final List<String> unitPlanConfigFiles = const []})
      : _unitPlanConfigFiles = unitPlanConfigFiles;

  factory _$UnitPlanConfigImpl.fromJson(Map<String, dynamic> json) =>
      _$$UnitPlanConfigImplFromJson(json);

  @override
  @JsonKey()
  final String bHKType;
  @override
  @JsonKey()
  final String sizeInSqft;
  @override
  @JsonKey()
  final String facing;
  final List<String> _unitPlanConfigFiles;
  @override
  @JsonKey()
  List<String> get unitPlanConfigFiles {
    if (_unitPlanConfigFiles is EqualUnmodifiableListView)
      return _unitPlanConfigFiles;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_unitPlanConfigFiles);
  }

  @override
  String toString() {
    return 'UnitPlanConfig(bHKType: $bHKType, sizeInSqft: $sizeInSqft, facing: $facing, unitPlanConfigFiles: $unitPlanConfigFiles)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UnitPlanConfigImpl &&
            (identical(other.bHKType, bHKType) || other.bHKType == bHKType) &&
            (identical(other.sizeInSqft, sizeInSqft) ||
                other.sizeInSqft == sizeInSqft) &&
            (identical(other.facing, facing) || other.facing == facing) &&
            const DeepCollectionEquality()
                .equals(other._unitPlanConfigFiles, _unitPlanConfigFiles));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, bHKType, sizeInSqft, facing,
      const DeepCollectionEquality().hash(_unitPlanConfigFiles));

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
  const factory _UnitPlanConfig(
      {final String bHKType,
      final String sizeInSqft,
      final String facing,
      final List<String> unitPlanConfigFiles}) = _$UnitPlanConfigImpl;

  factory _UnitPlanConfig.fromJson(Map<String, dynamic> json) =
      _$UnitPlanConfigImpl.fromJson;

  @override
  String get bHKType;
  @override
  String get sizeInSqft;
  @override
  String get facing;
  @override
  List<String> get unitPlanConfigFiles;

  /// Create a copy of UnitPlanConfig
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UnitPlanConfigImplCopyWith<_$UnitPlanConfigImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
