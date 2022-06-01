import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.g.dart';
part 'user.freezed.dart';

@Freezed()
class AppUser with _$AppUser {
  const factory AppUser({
    required String email,
    required String password,
    required String name,
    required String surname,
}) = _AppUser;

  factory AppUser.fromJson(Map<String, dynamic> json) => _$AppUserFromJson(json);

}