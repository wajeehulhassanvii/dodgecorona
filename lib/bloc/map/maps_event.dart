import 'package:equatable/equatable.dart';
import 'package:latlong/latlong.dart';
import 'package:trackcorona/utilities/person_condition_enum.dart';

abstract class MapsEvent extends Equatable {
  const MapsEvent();

  @override
  List<Object> get props => [];
} // abstract class MapsEvents ends here


// event for getting sending user location and getting set of markers
class GetUsersWithinDiameter extends MapsEvent{
  final LatLng userLocation;
  final PersonCondition personCondition;
  final bool notifyOthers;

  GetUsersWithinDiameter(this.userLocation, this.personCondition, this.notifyOthers);

}

// event for getting sending user location and getting set of markers
class DisconnectMap extends MapsEvent{
  // call this when the toggle button switches off
  final int idFromToken;
  DisconnectMap(this.idFromToken);
}


// event for getting sending user location and getting set of markers
class MapPageInitializing extends MapsEvent{
}


// event for getting sending user location and getting set of markers
class DeleteLastLocation extends MapsEvent{
}

// to get the current total, total infected and  total symptoms user
class GetTotalUsers extends MapsEvent{
}



