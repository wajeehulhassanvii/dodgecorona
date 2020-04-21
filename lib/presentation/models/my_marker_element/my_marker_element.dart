import 'package:trackcorona/utilities/person_condition_enum.dart';
import 'package:latlong/latlong.dart';
import 'package:json_annotation/json_annotation.dart';

part "my_marker_element.g.dart";

@JsonSerializable(nullable: false)
class MyMarkerElements{

  @JsonKey(name: 'latest_lat')
  String lat;

  @JsonKey(name: 'latest_lng')
  String lng;

  @JsonKey(name: 'person_id')
  double personId;

  @JsonKey(name: 'user_health')
  String userCondition;

  MyMarkerElements(this.lat, this.lng, this.personId, this.userCondition);
  factory MyMarkerElements.fromJson(Map<String, dynamic> json) => _$MyMarkerElementsFromJson(json);
  Map<String, dynamic> toJson() => _$MyMarkerElementsToJson(this);

  LatLng getLatLng(){
    return LatLng(double.parse(lat), double.parse(lng));
  }
  double getLatitude(){
    return double.parse(lat);
  }
  double getLongitude(){
    return double.parse(lng);
  }

  PersonCondition getPersonCondition(){
    return PersonConditionHelper.convertStringToPersonCondition(userCondition);
  }

  String toString(){
    return "MyMarkerElements<lat=$lat, lng=$lng, personId=$personId, userCondition=$userCondition >";
  }

}