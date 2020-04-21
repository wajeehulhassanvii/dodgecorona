// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'interected_users.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InteractedUsers _$InteractedUsersFromJson(Map<String, dynamic> json) {
  return InteractedUsers(
    json['lat'] as String,
    json['lng'] as String,
    (json['interacted_id'] as num).toDouble(),
  );
}

Map<String, dynamic> _$InteractedUsersToJson(InteractedUsers instance) =>
    <String, dynamic>{
      'lat': instance.lat,
      'lng': instance.lng,
      'interacted_id': instance.interactedId,
    };
