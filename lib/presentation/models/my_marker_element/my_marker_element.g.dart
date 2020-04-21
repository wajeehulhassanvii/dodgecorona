// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'my_marker_element.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MyMarkerElements _$MyMarkerElementsFromJson(Map<String, dynamic> json) {
  return MyMarkerElements(
    json['latest_lat'] as String,
    json['latest_lng'] as String,
    (json['person_id'] as num).toDouble(),
    json['user_health'] as String,
  );
}

Map<String, dynamic> _$MyMarkerElementsToJson(MyMarkerElements instance) =>
    <String, dynamic>{
      'latest_lat': instance.lat,
      'latest_lng': instance.lng,
      'person_id': instance.personId,
      'user_health': instance.userCondition,
    };
