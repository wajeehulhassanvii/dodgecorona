import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:get/get.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:trackcorona/bloc/core/shape_painter.dart';
import 'package:trackcorona/presentation/models/interacted_users/interected_users.dart';
import 'package:trackcorona/presentation/models/my_marker_element/my_marker_element.dart';
import 'package:trackcorona/utilities/constants.dart';
import 'maps_state.dart';
import 'package:trackcorona/utilities/person_condition_enum.dart';
import './bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:convert';
import 'package:latlong/latlong.dart';
import 'package:dio/dio.dart';
import 'package:trackcorona/bloc/map/maps_state.dart';
import 'package:flutter/services.dart';
import 'package:trackcorona/services/apis/api_provider.dart';

class MapsBloc extends Bloc<MapsEvent, MapsState> {
  List<PersonCondition> personList;
  List<Marker> markerList;

  double minimumSocialDistance = kMinimumSocialDistance;

  @override
  MapsState get initialState => NoInitialUsers();

  // MapEventToState Function
  @override
  Stream<MapsState> mapEventToState(
    MapsEvent event,
  ) async* {
    print('before if statement');
    if (event is GetUsersWithinDiameter) {
      print('inside GetUsersWithinDiameter i nMapsBloc');

      yield* _mapGetUserWithinDiameterToState(
          event.personCondition, event.userLocation, event.notifyOthers);

    } else if (event is DisconnectMap) {
      yield* mapDisconnectMapToState();

    } else if (event is MapPageInitializing) {
      yield NoInitialUsers();

    } else if (event is DeleteLastLocation) {
      yield* _mapDeleteLastLocationEventToState();

    } else if (event is GetTotalUsers) {
      yield* _mapGetTotalUsersToState();

    }
  } // MapEventToState Method ends here

  Stream<MapsState> _mapGetUserWithinDiameterToState(
      PersonCondition personCondition, LatLng userLocation, bool notifyOthers) async* {
    // change only to condition
    // we can generate gps latest location in here

    log('_mapGetUserWithinDiameterToState');

    Dio dio = await ApiProvider().getDioHttpClient();
    log('-------Api Provider loaded with access n refresh token --------------------- ');

    try {
      // first tell that there is no user
      yield NoInitialUsers();
      print('NoInitialUser yeilded');
      // then check if we have the permission
      // here we have the permission
      yield LookingUpForUsersInDatabase();

      List<Marker> listOfUserMarkersWithinGivenDiameter = [];
      List<MyMarkerElements> listOfMyMarkerElements = [];
      List<InteractedUsers> listOfInteractedUsers = [];

      Response response;
      Map<String, dynamic> decodedJsonData;

      // TODO change server to check if the users location is latest and within certain time
      try {
        response = await dio.post(
          "/getuserswithindiameter",
          data: jsonEncode(
            {
              "userLatitude": userLocation.latitude,
              "userLongitude": userLocation.longitude,
              "personCondition": PersonConditionHelper.personConditionToString(
                  personCondition),
            },
          ),
        );

        log('post method complete inside mapsbloc');
      } catch (e) {
        print(e);
        // we don't have the permission
        log('problem in /getuserswithindiameter post');
        yield FailedToFindUserWithinDiameter();
      }

      if (response.statusCode == 200) {
        decodedJsonData = json.decode(response.toString());
        log('decoding json done :');
        print(decodedJsonData);
        var varlistOfMyMarkerElements =
            decodedJsonData['list_of_user_location_and_health'];

        for (var e in varlistOfMyMarkerElements) {
          listOfMyMarkerElements.add(MyMarkerElements.fromJson(e));
          print(listOfMyMarkerElements.toString());
        }

        print('length ${listOfMyMarkerElements.length}');

        for (MyMarkerElements e in listOfMyMarkerElements) {

          if (e.getLatLng() == userLocation) {
            listOfUserMarkersWithinGivenDiameter.add(Marker(
              anchorPos: AnchorPos.align(AnchorAlign.center),
              height: 30,
              width: 30,
              point: e.getLatLng(),
              builder: (ctx) => Stack(
                children: [
                  CustomPaint(
                    painter: ShapesPainter(e.getPersonCondition()),
                    child: Icon(
                      LineAwesomeIcons.map_pin,
                      size: 15,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ));
          } else {
            listOfUserMarkersWithinGivenDiameter.add(Marker(
              anchorPos: AnchorPos.align(AnchorAlign.center),
              height: 30,
              width: 30,
              point: e.getLatLng(),
              builder: (ctx) => Stack(
                children: [
                  CustomPaint(
                    painter: ShapesPainter(e.getPersonCondition()),
//                    child: Icon(LineAwesomeIcons.map_pin, size: 15,color: Colors.white,),
                  ),
                ],
              ),
            ));
          }

        } // for loop ends here

        print(
            'if block finished, marker length ${listOfUserMarkersWithinGivenDiameter.length}');
        yield MarkerListFoundWithinDiameter(
            listOfUserMarkersWithinGivenDiameter);
      }

      log('-------------------- after MarkerListFoundWithinDiameter --------------------- ');

      for (MyMarkerElements e in listOfMyMarkerElements) {

        if (Distance()(e.getLatLng(), userLocation) < minimumSocialDistance) {

          log('distance is ${Distance()(e.getLatLng(), userLocation)}');
          print('Distance between two LatLng');
          print(Distance()(e.getLatLng(), userLocation));
          listOfInteractedUsers.add(InteractedUsers(e.lat, e.lng, e.personId));
        } else {

          log('distance is more than minimumSocialDistance');
        }
      }

      // TODO again check if the interaction happened within certain time
      if (listOfInteractedUsers.length > 0) {
        dio.post(
          '/interactedusers',
          data: jsonEncode(
            {
              "listOfInteractedUsers": listOfInteractedUsers,
            },
          ),
        );
      } else {
        log('no close interaction');
      }
    } on PlatformException catch (_) {
      yield FailedToFindUserWithinDiameter();
    }

    // TODO send push notification that health condition of the person have changed
    //  and that if they came in contact, be more cautious,

    if (notifyOthers){
      if (personCondition != PersonCondition.well) {
        Response interactionNotificationResponse;
        try {
          interactionNotificationResponse = await dio.post(
            "/interactionnotification",
            data: jsonEncode(
              {
                "person_condition": PersonConditionHelper.personConditionToString(
                    personCondition),
              },
            ),
          );
          log(interactionNotificationResponse.toString());
          log('post method complete inside mapsbloc');
        } catch (e) {
          print(e);
          // we don't have the permission
          yield FailedToFindUserWithinDiameter();
        }
      }
    }

  } // _mapGpsLoadingToState method ends here

// by simply send the user id stored in shared preference
  Stream<MapsState> mapFailedToFindUserWithinDiameterToState() async* {
    // Dio http request generator
    ApiProvider apiProvider = ApiProvider();
    // get already setup dio
    Dio dio = await apiProvider.getDioHttpClient();
    dio.delete('/removelastlocation', data: {
      // TODO replace 123 with user Id from shared preference
      "userId": 123
    });
    yield FailedToFindUserWithinDiameter();
  }

// by simply send the user id stored in shared preference
  Stream<MapsState> mapDisconnectMapToState() async* {
    // Dio http request generator
    ApiProvider apiProvider = ApiProvider();
    // get already setup dio
    Dio dio = await apiProvider.getDioHttpClient();
    dio.delete('/removelastlocation');
    yield DeletedUserRecord();
  }

  Stream<MapsState> _mapDeleteLastLocationEventToState() async* {
    yield SendingDeleteRequestToServer();
    // get user id from shared preference of jwt object
    Dio dio = await ApiProvider().getDioHttpClient();
//    dio.options.receiveTimeout = 20000;
//    dio.options.baseUrl = kBaseUrl;

    yield DeletedUserRecordInUserHealthAndLastLocation();
    print('before dio delete');

    try {
      dio.delete('/deleteuserhealthandlocation');

      Get.snackbar('records deleted', 'your marker has been removed',
          backgroundColor: Colors.grey[850],
          snackPosition: SnackPosition.TOP,
          colorText: Colors.white70,
          isDismissible: true);
    } catch (e) {
      Get.snackbar('Error', 'connection problem or other issue, try again',
          backgroundColor: Colors.grey[850],
          snackPosition: SnackPosition.TOP,
          colorText: Colors.white70,
          isDismissible: true);
    }

    yield UserHealthAndLocationRecordDeleted();
    print('after UserHealthAndLocationRecordDeleted');
  }

  Stream<MapsState> _mapGetTotalUsersToState() async* {
    // get user id from shared preference of jwt object
    Dio dio = await ApiProvider().getDioHttpClient();
//    dio.options.receiveTimeout = 20000;
//    dio.options.baseUrl = kBaseUrl;
    Response response;

    yield GetAppTotalRecord();
    try {
      response = await dio.get('/getappuserstats');
      // 1-symptoms, 2-infected, 3-well
      log('fetched total user stats');

      var totalSymptoms;
      var totalInfected;
      var totalWell;

      try {
        totalSymptoms = response.data['total_user_stats'][0][1];
      } catch (e) {
        totalSymptoms = 0;
      }
      try {
        totalInfected = response.data['total_user_stats'][1][1];
      } catch (e) {
        totalInfected = 0;
      }
      try {
        totalWell = response.data['total_user_stats'][2][1];
      } catch (e) {
        totalWell = 0;
      }
      log('loaded data from response');

      int tempTotalAppUser = totalSymptoms + totalInfected + totalWell;
      yield FetchedAppTotalRecord(
          tempTotalAppUser, totalWell, totalSymptoms, totalInfected);
      log('yielded FetchedAppTotalRecord');
    } catch (e) {}
  } // ends function _mapGetchAppTotalRecordToState

}
