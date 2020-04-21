import 'package:latlong/latlong.dart';
import 'package:trackcorona/utilities/person_condition_enum.dart';

class UserHealth{
  LatLng latlng;
  PersonCondition personCondition;

  UserHealth(LatLng latLng, PersonCondition personCondition);

  LatLng getLatLng(){
    return latlng;
  }

  PersonCondition getPersonCondition(){
    return personCondition;
  }

  String getPersonConditionString(PersonCondition personCondition){
    return PersonConditionHelper.personConditionToString(personCondition);
  }


}