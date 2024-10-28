import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';
part 'user.g.dart';

@freezed
class User with _$User {
  const factory User({
    @Default("") String token,
    @Default("") String userId,
    @Default("") String name,
    @Default("") String email,
    @Default("") String phoneNumber,
     @Default(0) int iat,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
