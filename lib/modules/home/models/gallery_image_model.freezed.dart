// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'gallery_image_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

GalleryImageModel _$GalleryImageModelFromJson(Map<String, dynamic> json) {
  return _GalleryImageModel.fromJson(json);
}

/// @nodoc
mixin _$GalleryImageModel {
  String get title => throw _privateConstructorUsedError;
  String get imageUrl => throw _privateConstructorUsedError;

  /// Serializes this GalleryImageModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of GalleryImageModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GalleryImageModelCopyWith<GalleryImageModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GalleryImageModelCopyWith<$Res> {
  factory $GalleryImageModelCopyWith(
          GalleryImageModel value, $Res Function(GalleryImageModel) then) =
      _$GalleryImageModelCopyWithImpl<$Res, GalleryImageModel>;
  @useResult
  $Res call({String title, String imageUrl});
}

/// @nodoc
class _$GalleryImageModelCopyWithImpl<$Res, $Val extends GalleryImageModel>
    implements $GalleryImageModelCopyWith<$Res> {
  _$GalleryImageModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GalleryImageModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? imageUrl = null,
  }) {
    return _then(_value.copyWith(
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      imageUrl: null == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$GalleryImageModelImplCopyWith<$Res>
    implements $GalleryImageModelCopyWith<$Res> {
  factory _$$GalleryImageModelImplCopyWith(_$GalleryImageModelImpl value,
          $Res Function(_$GalleryImageModelImpl) then) =
      __$$GalleryImageModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String title, String imageUrl});
}

/// @nodoc
class __$$GalleryImageModelImplCopyWithImpl<$Res>
    extends _$GalleryImageModelCopyWithImpl<$Res, _$GalleryImageModelImpl>
    implements _$$GalleryImageModelImplCopyWith<$Res> {
  __$$GalleryImageModelImplCopyWithImpl(_$GalleryImageModelImpl _value,
      $Res Function(_$GalleryImageModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of GalleryImageModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? imageUrl = null,
  }) {
    return _then(_$GalleryImageModelImpl(
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      imageUrl: null == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$GalleryImageModelImpl implements _GalleryImageModel {
  const _$GalleryImageModelImpl({this.title = "", this.imageUrl = ""});

  factory _$GalleryImageModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$GalleryImageModelImplFromJson(json);

  @override
  @JsonKey()
  final String title;
  @override
  @JsonKey()
  final String imageUrl;

  @override
  String toString() {
    return 'GalleryImageModel(title: $title, imageUrl: $imageUrl)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GalleryImageModelImpl &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, title, imageUrl);

  /// Create a copy of GalleryImageModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GalleryImageModelImplCopyWith<_$GalleryImageModelImpl> get copyWith =>
      __$$GalleryImageModelImplCopyWithImpl<_$GalleryImageModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GalleryImageModelImplToJson(
      this,
    );
  }
}

abstract class _GalleryImageModel implements GalleryImageModel {
  const factory _GalleryImageModel(
      {final String title, final String imageUrl}) = _$GalleryImageModelImpl;

  factory _GalleryImageModel.fromJson(Map<String, dynamic> json) =
      _$GalleryImageModelImpl.fromJson;

  @override
  String get title;
  @override
  String get imageUrl;

  /// Create a copy of GalleryImageModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GalleryImageModelImplCopyWith<_$GalleryImageModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
