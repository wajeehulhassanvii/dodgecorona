import 'package:equatable/equatable.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:meta/meta.dart';
import 'package:trackcorona/utilities/person_condition_enum.dart';

abstract class MapsState extends Equatable {
  const MapsState();
  @override
  List<Object> get props => [];
}


//---------------------------------------
class ClosePersonListFound extends MapsState {

  final List<PersonCondition> personList;
  ClosePersonListFound({@required this.personList});

  @override
  String toString() {
    return 'FakePersonLocation ${personList.toString()} ';
  }

  @override
  List<Object> get props => [personList];
} // ClosePersonListFound class ends here


//---------------------------------------
class NoInitialUsers extends MapsState{
  @override
  List<Object> get props => [];
}


class LookingUpForUsersInDatabase extends MapsState{
  @override
  List<Object> get props => [];

}


class MarkerListFoundWithinDiameter extends MapsState{
  final List<Marker> listOfMarkers;

  MarkerListFoundWithinDiameter(this.listOfMarkers) ;

  @override
  List<Object> get props => listOfMarkers;
}


class FailedToFindUserWithinDiameter extends MapsState{
  @override
  List<Object> get props => [];}

class DeletedUserRecord extends MapsState{
  @override
  List<Object> get props => [];}

  // ------------ states for deleting the record -------------- //
class SendingDeleteRequestToServer extends MapsState{
  @override
  List<Object> get props => [];
}

class DeletedUserRecordInUserHealthAndLastLocation extends MapsState{}

class UserHealthAndLocationRecordDeleted extends MapsState{
  @override
  List<Object> get props => [];
}

// ------------ states for getting total records -------------- //
class GetAppTotalRecord extends MapsState{}

class FetchedAppTotalRecord extends MapsState{
  final int totalAppUser;
  final int totalInfected;
  final int totalSymptoms;
  final int totalWell;

  FetchedAppTotalRecord(this.totalAppUser, this.totalWell , this.totalSymptoms, this.totalInfected);

  @override
  List<Object> get props => [totalAppUser, totalWell, totalSymptoms, totalInfected];


}