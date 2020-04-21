import 'package:json_annotation/json_annotation.dart';
import 'package:latlong/latlong.dart';

part 'interected_users.g.dart';

@JsonSerializable(nullable: false)
class InteractedUsers{

  @JsonKey(name: 'lat')
  String lat;

  @JsonKey(name: 'lng')
  String lng;

  @JsonKey(name: 'interacted_id')
  double interactedId;

  InteractedUsers(this.lat, this.lng, this.interactedId);

  factory InteractedUsers.fromJson(Map<String, dynamic> json) => _$InteractedUsersFromJson(json);
  Map<String, dynamic> toJson() => _$InteractedUsersToJson(this);

  LatLng getLatLng(){
    return LatLng(double.parse(lat), double.parse(lng));
  }

  String toString(){
    return "MyMarkerElements<lat=$lat, lng=$lng, interacted_id=$interactedId >";
  }


}