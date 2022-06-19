// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_AppUser _$$_AppUserFromJson(Map<String, dynamic> json) => _$_AppUser(
      fullname: json['fullname'] as String,
      username: json['username'] as String,
      schoolName: json['schoolName'] as String,
      email: json['email'] as String,
      major: json['major'] as String,
      term: json['term'] as String,
    );

Map<String, dynamic> _$$_AppUserToJson(_$_AppUser instance) =>
    <String, dynamic>{
      'fullname': instance.fullname,
      'username': instance.username,
      'schoolName': instance.schoolName,
      'email': instance.email,
      'major': instance.major,
      'term': instance.term,
    };
