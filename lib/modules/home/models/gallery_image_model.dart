import 'package:freezed_annotation/freezed_annotation.dart';

part 'gallery_image_model.freezed.dart';
part 'gallery_image_model.g.dart';

@freezed
class GalleryImageModel with _$GalleryImageModel {
  const factory GalleryImageModel({
    @Default("") String title,
    @Default("") String imageUrl,
  }) = _GalleryImageModel;

  factory GalleryImageModel.fromJson(Map<String, dynamic> json) =>
      _$GalleryImageModelFromJson(json);
}
