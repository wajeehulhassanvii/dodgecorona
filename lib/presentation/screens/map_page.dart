import 'dart:async';
import 'dart:developer';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:jiffy/jiffy.dart';
import 'package:trackcorona/presentation/repositories/social_media_share_repository.dart';
import 'package:trackcorona/presentation/screens/account_settings_page.dart';
import 'package:trackcorona/presentation/widgets/map_page_state_flutter_map.dart';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get_it/get_it.dart';
import 'package:getflutter/components/drawer/gf_drawer.dart';
import 'package:getflutter/getflutter.dart';
import 'package:gps/gps.dart';
import 'package:latlong/latlong.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:location/location.dart';
import 'package:map_controller/map_controller.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:trackcorona/bloc/map/bloc.dart';
import 'package:trackcorona/bloc/map/maps_bloc.dart';
import 'package:trackcorona/presentation/repositories/map_repository.dart';
import 'package:trackcorona/presentation/screens/login_page.dart';
import 'package:trackcorona/services/apis/api_provider.dart';
import 'package:trackcorona/services/servicpush_notification_service/push_notification_service.dart';
import 'package:trackcorona/services/shared_preference_manager.dart';
import 'package:trackcorona/utilities/constants.dart';
import 'package:trackcorona/utilities/person_condition_enum.dart';
import 'package:background_location/background_location.dart';
import 'package:get/get.dart';
import 'package:collection/collection.dart';
import 'package:trackcorona/utilities/social_media_enum.dart';

class MapPage extends StatefulWidget {
  static String route = "/mappage";
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> with WidgetsBindingObserver {
  int initialGpsToggleState = 0;
  PersonCondition currentPersonCondition = PersonCondition.well;

  SharedPreferencesManager sharedPreferenceManager;

  List<Marker> markers;

  double defaultMapZoom = 14;
  double minZoom = 16;
  double maxZoom = 20;
  int pointIndex;

  List centrePoints = [
    LatLng(-27.411277, 153.022398),
    LatLng(51.5, -0.09),
    LatLng(49.8566, 3.3522),
  ];

  // Location package objects
  Location location = new Location();

  // variables related to map_controller package
  MapController mapController;
  StatefulMapController statefulMapController;
  StreamSubscription<StatefulMapControllerStateChange> streamSub;

  // Create Maps Bloc
  MapsBloc mapsBloc;

  // dependency injector
  GetIt getIt;

  // TODO prev state variables, also set it to zero when user deletes their data
  List<Marker> prevMarkerList = [];

  int prevTotalInfected = 0;
  int prevTotalSymptoms = 0;
  int prevTotalWell = 0;
  int prevTotalAppUser = 0;

  bool toggleSwitchOn = false;
  bool isPreviousStateMarkerListFoundWithinDiameter = false;
  var prevState = null;

  bool stealthSwitchOn;

  bool notifyOthers = false;

  SocialMediaShare socialMediaShare = SocialMediaShare();

  @override
  void initState() {
    pointIndex = 0;
    // marker must have at least and empty list of markers
    // related to BackgroundLocation

    // for observing the state of the widget
    WidgetsBinding.instance.addObserver(this);


    BackgroundLocation.getPermissions(
      onGranted: () {
        Get.snackbar('GPS Permission', 'Permission Granted, Tracking On',
            backgroundColor: Colors.grey[850],
            snackPosition: SnackPosition.BOTTOM,
            colorText: Colors.white70,
            isDismissible: true);
      },
      onDenied: () {
        Get.snackbar('GPS Permission', 'Permission Denied, map inactive',
            backgroundColor: Colors.grey[850],
            snackPosition: SnackPosition.BOTTOM,
            colorText: Colors.white70,
            isDismissible: true);
      },
    );

    // TODO on location changed, send the data if toggle button is on
    location.onLocationChanged.listen((LocationData currentLocation) {
      // Use current location
      if (toggleSwitchOn) {
        double tempLatitude = currentLocation.latitude;
        double tempLongitude = currentLocation.longitude;
        LatLng currentUserLocation = LatLng(tempLatitude, tempLongitude);

        log('onlocationchanged called, add mapbloc GetUsersWithinDiameter');
        mapsBloc.add(GetUsersWithinDiameter(
            currentUserLocation, currentPersonCondition, false));
      }
    });

    // related to map_controller
    mapController = MapController();
    statefulMapController = StatefulMapController(mapController: mapController);

    // wait for the controller to be ready before using it
    statefulMapController.onReady
        .then((_) => print("The map controller is ready"));

    /// [Important] listen to the changefeed to rebuild the map on changes:
    /// this will rebuild the map when for example addMarker or any method
    /// that mutates the map assets is called
    streamSub =
        statefulMapController.changeFeed.listen((change) => setState(() {}));

    // instantiate MapsBloc
    mapsBloc = MapsBloc();
    // initialize getIt
//    sharedPreferenceManager = await getIt<SharedPreferencesManager>();

    super.initState();
  } // ENDS initState

  @override
  Widget build(BuildContext context) {
    getIt = GetIt.instance;
    SharedPreferencesManager sharedPreferenceManager =
        getIt<SharedPreferencesManager>();

    String tempRecievedToken =
        sharedPreferenceManager.getString(kAccessTokenKey);
    print('--------inside mapspage--------- $tempRecievedToken');

    return BlocProvider(
      // BlocProvider given access to Scaffold
      create: (BuildContext context) => MapsBloc(),
      child: Scaffold(
        backgroundColor: Colors.blue[300],
        drawer: GFDrawer(
          gradient: LinearGradient(
            colors: [
              Colors.blue[700],
              Colors.blue[700],
              Colors.blue[500],
              Colors.blue[500]
            ],
            begin: Alignment.topCenter,
          ),
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              ListTile(
                title: Text(
                  'menu',
                  style: TextStyle(
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
              ListTile(
                title: Text(
                  'how to use',
                  style: TextStyle(color: Colors.white70),
                ),
                onTap: () {
                  Get.toNamed('/howtousepage');
                },
              ),
              ListTile(
                title: Text(
                  'about',
                  style: TextStyle(color: Colors.white70),
                ),
                onTap: () {
                  Get.toNamed('/aboutpage');
                },
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: ListTile(
                  title: Text(
                    'account settings',
                    style: TextStyle(color: Colors.white70),
                  ),
                  onTap: () async {
                    Get.toNamed(AccountSettingsPage.route);
                  },
                ),
              ),
              ListTile(
                title: Text(
                  'logout',
                  style: TextStyle(color: Colors.white70),
                ),
                onTap: () async {
                  AwesomeDialog(
                    btnCancelColor: Colors.blue,
                    btnOkColor: Colors.black,
                    context: context,
                    animType: AnimType.SCALE,
                    dialogType: DialogType.INFO,
                    tittle: 'Confirming again?',
                    desc: 'are you sure you want to logout?',
                    btnCancelOnPress: () {
                      showSnackBar('didn\'t logout!', 'logging out cancelled');
                    },
                    btnOkOnPress: () async {
                      String accessToken;
                      String refreshToken;


                      Dio dio = await ApiProvider().getDioHttpClient();
//                      dio.clear();
//                      dio.options.baseUrl = kBaseUrl;

                      Response logoutResponse;
                      Response refreshResponse;

                      Map<String, dynamic> decodedJsonData;

                      print(accessToken);

                      try {
                        accessToken =
                            sharedPreferenceManager.getString(kAccessTokenKey);
                        refreshToken =
                            sharedPreferenceManager.getString(kRefreshTokenKey);
                      } catch (e) {
                        print('token not found');
                        print(e);
                      }

//                  Options refreshOptions;
                      String refreshTokenBearer = "Bearer " + refreshToken;

                      String accessTokenBearer = "Bearer " + accessToken;

                      try {

                        dio.options.headers = {
                          "Authorization": accessTokenBearer
                        };

                         await dio.delete("/logout", data: {
                          "access_token": accessToken,
                          "refresh_token": refreshToken
                        }).then((logoutResponse) async {

                          Dio newDio = Dio();
                          newDio.options.baseUrl = kBaseUrl;
                          print('done logout, now remove refresh logout');

                          newDio.options.headers = {
                            "Authorization": refreshTokenBearer
                          };

                          await newDio.delete("/logoutrefresh",
                              data: {
                                "access_token": accessToken,
                                "refresh_token": refreshToken
                              }).then((refreshResponse) async {
                                log('when complete of logoutrefresh');
                              log('before clearning shared prefs');

                              // we don't clear shared preference because we are only logging out
                              // and we will need jwt to check if user is logged in
                              await sharedPreferenceManager.clearAll();
                              log('going to login screen');
                              Get.offNamed(LoginPage.route);

                            decodedJsonData =
                                jsonDecode(refreshResponse.toString());
                            print(decodedJsonData['message']);
                          });
                          print('trying to remove refresh logout');


                        });


                      } catch (e) {
                        print(e);
                      }
                    },
                  ).show();
                },
              ),
            ],
          ),
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.blue[900],
                Colors.blue[700],
                Colors.blue[300],
                Colors.blue[300]
              ],
              begin: Alignment.topCenter,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width * 0.99,
                height: MediaQuery.of(context).size.height * 0.55,
                padding: EdgeInsets.all(3.0),
                margin: EdgeInsets.all(5.0),
                decoration:
                    BoxDecoration(border: Border.all(color: Colors.black)),
                child: Stack(
                  children: <Widget>[
                    BlocBuilder<MapsBloc, MapsState>(
                      builder: (context, state) {
                        if (state is NoInitialUsers) {
                          print(' inside NoInitialUsers');
                          return MapPageStateFlutterMap(
                              mapController: mapController,
                              centrePoints: centrePoints,
                              defaultMapZoom: defaultMapZoom,
                              markers: []);
                        } else if (state is LookingUpForUsersInDatabase) {
                          print(' inside LookingUpForUsersInDatabase');

                          if (toggleSwitchOn == false) {
                            return Stack(
                              children: <Widget>[
                                MapPageStateFlutterMap(
                                    mapController: mapController,
                                    centrePoints: centrePoints,
                                    defaultMapZoom: mapController.zoom == null
                                        ? defaultMapZoom
                                        : mapController.zoom,
                                    markers: []),
                                Center(
                                  child: CircularProgressIndicator(),
                                ),
                              ],
                            );
                          }
                          return Stack(
                            children: <Widget>[
                              MapPageStateFlutterMap(
                                  mapController: mapController,
                                  centrePoints: centrePoints,
                                  defaultMapZoom: mapController.zoom == null
                                      ? defaultMapZoom
                                      : mapController.zoom,
                                  markers: prevMarkerList),
                            ],
                          );
                        } else if (state is MarkerListFoundWithinDiameter) {
                          print(' inside MarkerListFoundWithinDiameter');
                          prevMarkerList = state.listOfMarkers;

                          return MapPageStateFlutterMap(
                              mapController: mapController,
                              centrePoints: centrePoints,
                              defaultMapZoom: mapController.zoom == null
                                  ? defaultMapZoom
                                  : mapController.zoom,
                              markers: state.listOfMarkers);
                        } else if (state is FailedToFindUserWithinDiameter) {
                          print(' inside FailedToFindUserWithinDiameter');
                          return MapPageStateFlutterMap(
                              mapController: mapController,
                              centrePoints: centrePoints,
                              defaultMapZoom: mapController.zoom == null
                                  ? defaultMapZoom
                                  : mapController.zoom,
                              markers: []);
                        } else if (state is SendingDeleteRequestToServer) {
                          print(' inside SendingDeleteRequestToServer');
                          return MapPageStateFlutterMap(
                              mapController: mapController,
                              centrePoints: centrePoints,
                              defaultMapZoom: mapController.zoom == null
                                  ? defaultMapZoom
                                  : mapController.zoom,
                              markers: []);
                        } else if (state
                            is DeletedUserRecordInUserHealthAndLastLocation) {
                          print(
                              ' inside DeletedUserRecordInUserHealthAndLastLocation');
                          return MapPageStateFlutterMap(
                              mapController: mapController,
                              centrePoints: centrePoints,
                              defaultMapZoom: mapController.zoom == null
                                  ? defaultMapZoom
                                  : mapController.zoom,
                              markers: []);
                        } else if (state
                            is UserHealthAndLocationRecordDeleted) {
                          print(' inside UserHealthAndLocationRecordDeleted');
                          return MapPageStateFlutterMap(
                              mapController: mapController,
                              centrePoints: centrePoints,
                              defaultMapZoom: mapController.zoom == null
                                  ? defaultMapZoom
                                  : mapController.zoom,
                              markers: []);
                        } else if (state is FetchedAppTotalRecord) {
                          print(' inside FetchedAppTotalRecord');
                          return MapPageStateFlutterMap(
                              mapController: mapController,
                              centrePoints: centrePoints,
                              defaultMapZoom: mapController.zoom == null
                                  ? defaultMapZoom
                                  : mapController.zoom,
                              markers: prevMarkerList);
                        } else {
                          print(' inside default');
                          return MapPageStateFlutterMap(
                              mapController: mapController,
                              centrePoints: centrePoints,
                              defaultMapZoom: mapController.zoom == null
                                  ? defaultMapZoom
                                  : mapController.zoom,
                              markers: []);
                        }
                      },
                      bloc: mapsBloc,
                    ),
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        'Track Corona App',
                        style: TextStyle(
                          backgroundColor: Colors.grey[850],
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
//                          Material(
//                          elevation: 0,
//                          shape: ContinuousRectangleBorder(side: BorderSide(color: Colors.white, width: 4)),
//                          color: Colors.white,
//                          clipBehavior: Clip.antiAliasWithSaveLayer,
//                          child: Padding(
//                            padding: const EdgeInsets.fromLTRB(4, 1, 0, 0),
//                            child: Row(
//                              children: <Widget>[
//                                Text(
//                                  'stealth\n mode',
//                                  textAlign: TextAlign.end,
//                                  style: TextStyle(fontSize: 12),
//                                ),
//                                SizedBox(
//                                  width: 5,
//                                ),
//                                GFToggle(
//                                    type: GFToggleType.square,
//                                    enabledThumbColor: Colors.black,
//                                    enabledText: "yes",
//                                    enabledTrackColor: Colors.white,
//                                    enabledTextStyle: TextStyle(
//                                        color: Colors.black, fontSize: 10),
//                                    disabledThumbColor: Colors.black,
//                                    disabledText: "no",
//                                    disabledTextStyle: TextStyle(
//                                        color: Colors.black, fontSize: 10),
//                                    disabledTrackColor: Colors.white,
//                                    onChanged: (val) async {
//                                      if (val == false) {
//                                        // 0 means inactive = FALSE
//                                        stealthSwitchOn = false;
//                                        prevMarkerList = [];
//                                        mapsBloc.add(DeleteLastLocation(5));
//
//                                        BackgroundLocation.stopLocationService();
//                                        showSnackBar('GPS Permission',
//                                            'Permission Denied, Tracking Off');
//                                      } else {
//                                        // 1 means inactive = TRUE
//                                        stealthSwitchOn = true;
//
//                                        if (toggleSwitchOn==false){
//                                        GpsLatlng gpsLatlng =
//                                        await Gps.currentGps();
//                                        double tempLatitude =
//                                        double.parse(gpsLatlng.lat);
//                                        double tempLongitude =
//                                        double.parse(gpsLatlng.lng);
//                                        LatLng currentUserLocation =
//                                        LatLng(tempLatitude, tempLongitude);
//
//                                        print('before bloc call');
//                                        mapsBloc.add(GetUsersWithinDiameter(
//                                            currentUserLocation,
//                                            currentPersonCondition));
//                                        print('after bloc call');
//
//                                        BackgroundLocation.startLocationService();
//
//                                        showSnackBar('GPS Permission',
//                                            'Permission Granted, Tracking On');
//                                        } else {
//                                          showSnackBar('you are in live mode',
//                                              'turn off live mode to connect to stealth mode');
//                                        }
//                                      } // onToggle code ends here
//                                    }),
//                              ],
//                            ),
//                          ),
//                        ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                            child: FloatingActionButton(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Stack(
                                    children: <Widget>[
                                      Icon(
                                        LineAwesomeIcons.remove,
                                        color: Colors.white,
                                      ),
                                    ],
                                  ),
                                  Text(
                                    'clear',
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.white),
                                  )
                                ],
                              ),
                              backgroundColor: Colors.grey[850],
                              onPressed: () {
                                prevMarkerList = [];
                                mapsBloc.add(DeleteLastLocation());

                                BackgroundLocation.stopLocationService();
                                showSnackBar(
                                    'map disconnected', 'tracking off.......');

                                print('Floating Action Button Pressed On Map');
                              },
                              heroTag: 'delToLogin',
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                            child: FloatingActionButton(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Stack(
                                    children: <Widget>[
                                      Icon(
                                        LineAwesomeIcons.arrow_up,
                                        color: Colors.white,
                                      ),
                                    ],
                                  ),
                                  Text(
                                    'stats',
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.white),
                                  )
                                ],
                              ),
                              backgroundColor: Colors.grey[850],
                              onPressed: () {
                                mapsBloc.add(GetTotalUsers());
                              },
                              heroTag: 'mapStats',
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 5, 5),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                FloatingActionButton(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Stack(
                                        children: <Widget>[
                                          Icon(
                                            LineAwesomeIcons.plus,
                                            color: Colors.white,
                                          ),
                                        ],
                                      ),
                                      Text(
                                        'zoom',
                                        style: TextStyle(
                                            fontSize: 12, color: Colors.white),
                                      )
                                    ],
                                  ),
                                  backgroundColor: Colors.grey[850],
                                  onPressed: () {
                                    statefulMapController.zoomIn();

                                    print(
                                        'Floating Action Button Pressed On Map');
                                  },
                                  heroTag: 'mapZoomPlus',
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                FloatingActionButton(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Stack(
                                        children: <Widget>[
                                          Icon(
                                            LineAwesomeIcons.minus,
                                            color: Colors.white,
                                          ),
                                        ],
                                      ),
                                      Text(
                                        'zoom',
                                        style: TextStyle(
                                            fontSize: 12, color: Colors.white),
                                      )
                                    ],
                                  ),
                                  backgroundColor: Colors.grey[850],
                                  onPressed: () {
                                    statefulMapController.zoomOut();

                                    print(
                                        'Floating Action Button Pressed On Map');
                                  },
                                  heroTag: 'mapZoomMinus',
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                FloatingActionButton(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Stack(
                                        children: <Widget>[
                                          Icon(
                                            Icons.gps_fixed,
                                            color: Colors.white,
                                          ),
                                        ],
                                      ),
                                      Text(
                                        'center',
                                        style: TextStyle(
                                            fontSize: 12, color: Colors.white),
                                      ),
                                    ],
                                  ),
                                  backgroundColor: Colors.grey[850],
                                  onPressed: () async {
                                    GpsLatlng gpsLatlng =
                                        await Gps.currentGps();
                                    double tempLatitude =
                                        double.parse(gpsLatlng.lat);
                                    double tempLongitude =
                                        double.parse(gpsLatlng.lng);
                                    statefulMapController.centerOnPoint(
                                        LatLng(tempLatitude, tempLongitude));
                                    print(
                                        'Floating Action Button Pressed On Map');
                                  },
                                  heroTag: 'mapCenter',
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(5, 5, 0, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'estimations from dodge corona .app',
                              style: TextStyle(
                                color: Colors.white,
                                backgroundColor: Colors.grey[850],
                              ),
                            ),
                            // TOTAL USERS
                            BlocBuilder(
                              builder: (context, state) {
                                if (state is GetAppTotalRecord) {
                                  return Text(
                                    'total users:    \t\t0',
                                    style: TextStyle(
                                      backgroundColor: Colors.grey[850],
                                      color: Colors.white,
                                    ),
                                  );
                                } else if (state is FetchedAppTotalRecord) {
                                  prevTotalAppUser = state.totalAppUser;
                                  return Text(
                                    'total users:    \t\t${state.totalAppUser}',
                                    style: TextStyle(
                                      backgroundColor: Colors.grey[850],
                                      color: Colors.white,
                                    ),
                                  );
                                } else if (state
                                    is MarkerListFoundWithinDiameter) {
                                  ;
                                  return Text(
                                    'total users:    \t\t$prevTotalAppUser',
                                    style: TextStyle(
                                      backgroundColor: Colors.grey[850],
                                      color: Colors.white,
                                    ),
                                  );
                                } else {
                                  return Text(
                                    'total users:    \t\t0',
                                    style: TextStyle(
                                      backgroundColor: Colors.grey[850],
                                      color: Colors.white,
                                    ),
                                  );
                                }
                              },
                              bloc: mapsBloc,
                            ),
                            // TOTAL IN GOOD HEALTH
                            BlocBuilder(
                              builder: (context, state) {
                                if (state is GetAppTotalRecord) {
                                  return Text(
                                    'users in good health:    \t\t0',
                                    style: TextStyle(
                                      backgroundColor: Colors.grey[850],
                                      color: Colors.white,
                                    ),
                                  );
                                } else if (state is FetchedAppTotalRecord) {
                                  prevTotalWell = state.totalWell;
                                  return Text(
                                    'users in good health:    \t\t${state.totalWell}',
                                    style: TextStyle(
                                      backgroundColor: Colors.grey[850],
                                      color: Colors.white,
                                    ),
                                  );
                                } else if (state
                                    is MarkerListFoundWithinDiameter) {
                                  ;
                                  return Text(
                                    'users in good health:    \t\t$prevTotalWell',
                                    style: TextStyle(
                                      backgroundColor: Colors.grey[850],
                                      color: Colors.white,
                                    ),
                                  );
                                } else {
                                  return Text(
                                    'users in good health:    \t\t0',
                                    style: TextStyle(
                                      backgroundColor: Colors.grey[850],
                                      color: Colors.white,
                                    ),
                                  );
                                }
                              },
                              bloc: mapsBloc,
                            ),
                            // TOTAL HAVING SYMPTOMS
                            BlocBuilder(
                              builder: (context, state) {
                                if (state is GetAppTotalRecord) {
                                  return Text(
                                    'users with symptoms:    \t\t0',
                                    style: TextStyle(
                                      backgroundColor: Colors.grey[850],
                                      color: Colors.white,
                                    ),
                                  );
                                } else if (state is FetchedAppTotalRecord) {
                                  prevTotalSymptoms = state.totalSymptoms;
                                  return Text(
                                    'users with symptoms:    \t\t${state.totalSymptoms}',
                                    style: TextStyle(
                                      backgroundColor: Colors.grey[850],
                                      color: Colors.white,
                                    ),
                                  );
                                } else if (state
                                    is MarkerListFoundWithinDiameter) {
                                  ;
                                  return Text(
                                    'users with symptoms:    \t\t$prevTotalSymptoms',
                                    style: TextStyle(
                                      backgroundColor: Colors.grey[850],
                                      color: Colors.white,
                                    ),
                                  );
                                } else {
                                  return Text(
                                    'users with symptoms:    \t\t0',
                                    style: TextStyle(
                                      backgroundColor: Colors.grey[850],
                                      color: Colors.white,
                                    ),
                                  );
                                }
                              },
                              bloc: mapsBloc,
                            ),
                            // TOTAL INFECTED
                            BlocBuilder(
                              builder: (context, state) {
                                if (state is GetAppTotalRecord) {
                                  return Text(
                                    'infected users:    \t\t0',
                                    style: TextStyle(
                                      backgroundColor: Colors.grey[850],
                                      color: Colors.white,
                                    ),
                                  );
                                } else if (state is FetchedAppTotalRecord) {
                                  prevTotalInfected = state.totalInfected;
                                  return Text(
                                    'infected users:    \t\t${state.totalInfected}',
                                    style: TextStyle(
                                      backgroundColor: Colors.grey[850],
                                      color: Colors.white,
                                    ),
                                  );
                                } else if (state
                                    is MarkerListFoundWithinDiameter) {
                                  ;
                                  return Text(
                                    'infected users:    \t\t$prevTotalInfected',
                                    style: TextStyle(
                                      backgroundColor: Colors.grey[850],
                                      color: Colors.white,
                                    ),
                                  );
                                } else {
                                  return Text(
                                    'infected users:    \t\t0',
                                    style: TextStyle(
                                      backgroundColor: Colors.grey[850],
                                      color: Colors.white,
                                    ),
                                  );
                                }
                              },
                              bloc: mapsBloc,
                            ),
                            BlocBuilder(
                              builder: (context, state) {
                                if (state is GetAppTotalRecord) {
                                  return Text(
                                    'last update:    \t\t0',
                                    style: TextStyle(
                                      backgroundColor: Colors.grey[850],
                                      color: Colors.white,
                                    ),
                                  );
                                } else if (state is FetchedAppTotalRecord) {
                                  prevTotalInfected = state.totalInfected;
                                  return Text(
                                    'last update:    \t\t${Jiffy().yMMMdjm}',
                                    style: TextStyle(
                                      backgroundColor: Colors.grey[850],
                                      color: Colors.white,
                                    ),
                                  );
                                } else if (state
                                    is MarkerListFoundWithinDiameter) {
                                  return Text(
                                    'last update:    \t\t${Jiffy().yMMMdjm}',
                                    style: TextStyle(
                                      backgroundColor: Colors.grey[850],
                                      color: Colors.white,
                                    ),
                                  );
                                } else {
                                  return Text(
                                    'last update:    \t\t0',
                                    style: TextStyle(
                                      backgroundColor: Colors.grey[850],
                                      color: Colors.white,
                                    ),
                                  );
                                }
                              },
                              bloc: mapsBloc,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // TODO This sized box is the gap between the buttons bottom buttons
              // and the map at the top
              SizedBox(
                height: 5,
              ),
              Material(
                color: Colors.grey[850],
                shape: ContinuousRectangleBorder(
                    side: BorderSide(color: Colors.grey[850], width: 4),
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    ToggleSwitch(
                      minWidth: 100.0,
                      initialLabelIndex: 2,
                      activeBgColor: Colors.blue,
                      activeTextColor: Colors.grey[850],
                      inactiveBgColor: Colors.grey[850],
                      inactiveTextColor: Colors.white,
                      labels: ['well', 'symptoms', 'infected'],
                      onToggle: (index) async {
                        switch (index) {
                          case 0:
                            {
                              // TODO Check if GPS is enabled first then
                              //  change the marker color in all 3 cases
                              showSnackBar('Heath Status Updated',
                                  'Health Status Changed To Well');
                              currentPersonCondition = PersonCondition.well;

                              GpsLatlng gpsLatlng = await Gps.currentGps();
                              double tempLatitude = double.parse(gpsLatlng.lat);
                              double tempLongitude =
                                  double.parse(gpsLatlng.lng);
                              LatLng currentUserLocation =
                                  LatLng(tempLatitude, tempLongitude);

                              print('before bloc call');
                              mapsBloc.add(GetUsersWithinDiameter(
                                  currentUserLocation,
                                  currentPersonCondition,
                                  false));
                              print('after bloc call');
                            }
                            break;

                          case 1:
                            {
                              AwesomeDialog(
                                btnCancelColor: Colors.blue,
                                btnOkColor: Colors.black,
                                context: context,
                                animType: AnimType.SCALE,
                                dialogType: DialogType.INFO,
                                tittle:
                                    'Are you sure you want change your health status to SYMPTOMS?',
                                desc:
                                    'Other people you interacted with will recieve an email'
                                    'about their interaction with a person who had symptoms of COVID-19, your identity'
                                    'won\'t be disclosed to anyone',
                                btnCancelOnPress: () {
                                  showSnackBar('Heath Status Not Changed',
                                      'Health Status Changing Cancelled');
                                  index = 0;
                                },
                                btnOkOnPress: () async {
                                  AwesomeDialog(
                                    btnCancelColor: Colors.blue,
                                    btnOkColor: Colors.black,
                                    context: context,
                                    animType: AnimType.SCALE,
                                    dialogType: DialogType.INFO,
                                    tittle: 'notify others?',
                                    desc:
                                        'if pressed ok, other users will get notified, don\'t notify if you are not confirmed',
                                    btnCancelOnPress: () async {
                                      notifyOthers = false;
                                      AwesomeDialog(
                                        btnCancelColor: Colors.blue,
                                        btnOkColor: Colors.black,
                                        context: context,
                                        animType: AnimType.SCALE,
                                        dialogType: DialogType.INFO,
                                        tittle: 'Confirming again?',
                                        desc:
                                            'please only press OK, if you are showing symptoms of COVID-19 '
                                            'spamming will get you banned',
                                        btnCancelOnPress: () {
                                          showSnackBar(
                                              'Heath Status Not Changed',
                                              'Health Status Changing Cancelled');
                                          index = 0;
                                        },
                                        btnOkOnPress: () async {
                                          showSnackBar('health status changed',
                                              'your health status changed to symptoms');
                                          currentPersonCondition =
                                              PersonCondition.symptoms;
                                          GpsLatlng gpsLatlng =
                                              await Gps.currentGps();
                                          double tempLatitude =
                                              double.parse(gpsLatlng.lat);
                                          double tempLongitude =
                                              double.parse(gpsLatlng.lng);
                                          LatLng currentUserLocation = LatLng(
                                              tempLatitude, tempLongitude);

                                          print('before bloc call');
                                          mapsBloc.add(GetUsersWithinDiameter(
                                              currentUserLocation,
                                              currentPersonCondition,
                                              notifyOthers));
                                          print('after bloc call');
                                        },
                                      ).show();
                                      index = 0;
                                    },
                                    btnOkOnPress: () async {
                                      notifyOthers = true;
                                      AwesomeDialog(
                                        btnCancelColor: Colors.blue,
                                        btnOkColor: Colors.black,
                                        context: context,
                                        animType: AnimType.SCALE,
                                        dialogType: DialogType.INFO,
                                        tittle: 'Confirming again?',
                                        desc:
                                            'please only press OK, if you are showing symptoms of COVID-19',
                                        btnCancelOnPress: () {
                                          showSnackBar(
                                              'Heath Status Not Changed',
                                              'Health Status Changing Cancelled');
                                          index = 0;
                                        },
                                        btnOkOnPress: () async {
                                          showSnackBar('Heath Status Updated',
                                              'Health Status Changed To Symptoms');
                                          currentPersonCondition =
                                              PersonCondition.symptoms;
                                          GpsLatlng gpsLatlng =
                                              await Gps.currentGps();
                                          double tempLatitude =
                                              double.parse(gpsLatlng.lat);
                                          double tempLongitude =
                                              double.parse(gpsLatlng.lng);
                                          LatLng currentUserLocation = LatLng(
                                              tempLatitude, tempLongitude);

                                          print('before bloc call');
                                          mapsBloc.add(GetUsersWithinDiameter(
                                              currentUserLocation,
                                              currentPersonCondition,
                                              notifyOthers));
                                          print('after bloc call');
                                        },
                                      ).show();
                                    },
                                  ).show();
                                },
                              ).show();
                            }
                            break;
                          case 2:
                            {
                              AwesomeDialog(
                                btnCancelColor: Colors.blue,
                                btnOkColor: Colors.black,
                                context: context,
                                animType: AnimType.SCALE,
                                dialogType: DialogType.INFO,
                                tittle:
                                    'Are you sure you want change your health status to INFECTED?',
                                desc:
                                    'Other people you interacted with will recieve an email'
                                    'about their interaction with a person were potentially'
                                    ' infected of COVID-19, your identity'
                                    'won\'t be disclosed to anyone',
                                btnCancelOnPress: () {
                                  showSnackBar('health status unchanged',
                                      'did not change the health status');
                                  index = 0;
                                },
                                btnOkOnPress: () async {
                                  AwesomeDialog(
                                    btnCancelColor: Colors.blue,
                                    btnOkColor: Colors.black,
                                    context: context,
                                    animType: AnimType.SCALE,
                                    dialogType: DialogType.INFO,
                                    tittle: 'notify others?',
                                    desc:
                                        'if pressed ok, other users will get notified, don\'t notify if you are not confirmed',
                                    btnCancelOnPress: () async {
                                      notifyOthers = false;
                                      AwesomeDialog(
                                        btnCancelColor: Colors.blue,
                                        btnOkColor: Colors.black,
                                        context: context,
                                        animType: AnimType.SCALE,
                                        dialogType: DialogType.INFO,
                                        tittle: 'confirming again?',
                                        desc:
                                            'please only press OK, if you are confirmed infected '
                                            'spamming will get you banned',
                                        btnCancelOnPress: () {
                                          showSnackBar(
                                              'health status unchanged',
                                              'health status chaning cancelled');
                                          index = 0;
                                        },
                                        btnOkOnPress: () async {
                                          showSnackBar('health status changed',
                                              'your health status changed to symptoms');
                                          currentPersonCondition =
                                              PersonCondition.infected;
                                          GpsLatlng gpsLatlng =
                                              await Gps.currentGps();
                                          double tempLatitude =
                                              double.parse(gpsLatlng.lat);
                                          double tempLongitude =
                                              double.parse(gpsLatlng.lng);
                                          LatLng currentUserLocation = LatLng(
                                              tempLatitude, tempLongitude);

                                          print('before bloc call');
                                          mapsBloc.add(GetUsersWithinDiameter(
                                              currentUserLocation,
                                              currentPersonCondition,
                                              notifyOthers));
                                          print('after bloc call');
                                        },
                                      ).show();
                                      index = 0;
                                    },
                                    btnOkOnPress: () async {
                                      notifyOthers = true;
                                      AwesomeDialog(
                                        btnCancelColor: Colors.blue,
                                        btnOkColor: Colors.black,
                                        context: context,
                                        animType: AnimType.SCALE,
                                        dialogType: DialogType.INFO,
                                        tittle: 'confirming again?',
                                        desc:
                                            'please only press OK, if you are showing symptoms of COVID-19',
                                        btnCancelOnPress: () {
                                          showSnackBar(
                                              'health status unchanged',
                                              'health status changing cancelled');
                                          index = 0;
                                        },
                                        btnOkOnPress: () async {
                                          showSnackBar('Heath Status Updated',
                                              'Health Status Changed To Symptoms');
                                          currentPersonCondition =
                                              PersonCondition.infected;
                                          GpsLatlng gpsLatlng =
                                              await Gps.currentGps();
                                          double tempLatitude =
                                              double.parse(gpsLatlng.lat);
                                          double tempLongitude =
                                              double.parse(gpsLatlng.lng);
                                          LatLng currentUserLocation = LatLng(
                                              tempLatitude, tempLongitude);

                                          print('before bloc call');
                                          mapsBloc.add(
                                            GetUsersWithinDiameter(
                                                currentUserLocation,
                                                currentPersonCondition,
                                                notifyOthers),
                                          );
                                          print('after bloc call');
                                        },
                                      ).show();
                                    },
                                  ).show();
                                },
                              ).show();
                            }
                            break;
                        }
                        print('switched to: $index');
                      },
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Material(
                          elevation: 0,
                          shape: ContinuousRectangleBorder(
                              side: BorderSide(
                                  color: Colors.grey[850], width: 4)),
                          color: Colors.grey[850],
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(4, 1, 0, 0),
                            child: Row(
                              children: <Widget>[
                                Text(
                                  'live map\n connection',
                                  textAlign: TextAlign.end,
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.white),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                GFToggle(
                                    type: GFToggleType.square,
                                    enabledThumbColor: Colors.blue,
                                    enabledText: "yes",
                                    enabledTrackColor: Colors.white,
                                    enabledTextStyle: TextStyle(
                                        color: Colors.black87, fontSize: 10),
                                    disabledThumbColor: Colors.blue,
                                    disabledText: "no",
                                    disabledTextStyle: TextStyle(
                                        color: Colors.black87, fontSize: 10),
                                    disabledTrackColor: Colors.white,
                                    onChanged: (val) async {
                                      if (val == false) {
                                        // 0 means inactive = FALSE
                                        toggleSwitchOn = false;
                                        prevMarkerList = [];
                                        mapsBloc.add(DeleteLastLocation());

                                        BackgroundLocation
                                            .stopLocationService();
                                        showSnackBar('GPS Permission',
                                            'Permission Denied, Tracking Off');
                                      } else {
                                        // 1 means inactive = TRUE
                                        toggleSwitchOn = true;
                                        GpsLatlng gpsLatlng =
                                            await Gps.currentGps();
                                        double tempLatitude =
                                            double.parse(gpsLatlng.lat);
                                        double tempLongitude =
                                            double.parse(gpsLatlng.lng);
                                        LatLng currentUserLocation =
                                            LatLng(tempLatitude, tempLongitude);

                                        print('before bloc call');
                                        mapsBloc.add(GetUsersWithinDiameter(
                                            currentUserLocation,
                                            currentPersonCondition,
                                            false));
                                        print('after bloc call');

                                        BackgroundLocation
                                            .startLocationService();

                                        showSnackBar('GPS Permission',
                                            'Permission Granted, Tracking On');
                                      } // onToggle code ends here
                                    }),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 2,
                        ),
                        GFButton(
                          text: "update\nmap",
                          icon: Icon(
                            LineAwesomeIcons.refresh,
                            color: Colors.white,
                          ),
                          type: GFButtonType.solid,
                          color: Colors.grey[850],
                          size: GFSize.MEDIUM,
                          onPressed: () async {

                            if (toggleSwitchOn == false) {
                              GpsLatlng gpsLatlng = await Gps.currentGps();
                              double tempLatitude = double.parse(gpsLatlng.lat);
                              double tempLongitude =
                                  double.parse(gpsLatlng.lng);
                              LatLng currentUserLocation =
                                  LatLng(tempLatitude, tempLongitude);

                              print('before bloc call');
                              mapsBloc.add(GetUsersWithinDiameter(
                                  currentUserLocation,
                                  currentPersonCondition,
                                  false));
                              print('after bloc call');
                            } else {
                              showSnackBar(
                                  'map updating', 'you are in live mode');
                            }

                          },
                        ),
                        SizedBox(
                          width: 2,
                        ),
                        GFButton(
                            text: "share\nstatus",
                            icon: Icon(
                              LineAwesomeIcons.share,
                              color: Colors.white,
                            ),
                            type: GFButtonType.solid,
                            color: Colors.grey[850],
                            size: GFSize.MEDIUM,
                            onPressed: () {
                              // TODO implement bottom sheet here for sharing status
                              print('Share status button clicked');
                              Get.bottomSheet(builder: (_) {
                                mapsBloc.add(GetTotalUsers());
                                return Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(colors: [
                                      Colors.grey[600],
                                      Colors.grey[500],
                                      Colors.grey[400],
                                      Colors.grey[200]
                                    ], begin: Alignment.bottomRight),
                                  ),
                                  child: Wrap(
                                    children: <Widget>[
                                      ListTile(
                                          leading: Icon(
                                            LineAwesomeIcons.twitter_square,
                                            color: Colors.blue,
                                          ),
                                          title: Text('Twitter'),
                                          onTap: () async {
                                            socialMediaShare.postMessageToSocialMedia(
                                                'Total users $prevTotalAppUser\n'
                                                'Total people in good health $prevTotalWell\n'
                                                'Total people with symptoms $prevTotalSymptoms\n'
                                                'Total infected $prevTotalInfected',
                                                SocialMedia.twitter);
                                          }),
                                      ListTile(
                                        leading: Icon(
                                          LineAwesomeIcons.facebook_square,
                                          color: Colors.blue,
                                        ),
                                        title: Text('Facebook'),
                                        onTap: () async {
                                          Get.snackbar(
                                              'Cannot Share',
                                              'Cannot share, your privacy matters,\n'
                                                  'Facebooks wants developers to share their data if we use their api.',
                                              backgroundColor: Colors.grey[850],
                                              snackPosition:
                                                  SnackPosition.BOTTOM,
                                              colorText: Colors.white70,
                                              isDismissible: true);
                                        },
                                      ),
                                      ListTile(
                                        leading: Icon(
                                          LineAwesomeIcons.whatsapp,
                                          color: Colors.green,
                                        ),
                                        title: Text('Whatsapp'),
                                        onTap: () async {
                                          socialMediaShare.postMessageToSocialMedia(
                                              'Total users $prevTotalAppUser\n'
                                              'Total people in good health $prevTotalWell\n'
                                              'Total people with symptoms $prevTotalSymptoms\n'
                                              'Total infected $prevTotalInfected',
                                              SocialMedia.whatsapp);
                                        },
                                      ),
                                      ListTile(
                                        leading: Icon(
                                          LineAwesomeIcons.text_width,
                                          color: Colors.black,
                                        ),
                                        title: Text('Text / Message'),
                                        onTap: () async {
                                          socialMediaShare.postMessageToSocialMedia(
                                              'Total users $prevTotalAppUser\n'
                                              'Total people in good health $prevTotalWell\n'
                                              'Total people with symptoms $prevTotalSymptoms\n'
                                              'Total infected $prevTotalInfected',
                                              SocialMedia.sms);
                                        },
                                      ),
                                      ListTile(
                                        leading:
                                            Icon(LineAwesomeIcons.clipboard),
                                        title: Text('Copy text to clipboard'),
                                        onTap: () async {
                                          socialMediaShare.postMessageToSocialMedia(
                                              'Total users $prevTotalAppUser\n'
                                              'Total people in good health $prevTotalWell\n'
                                              'Total people with symptoms $prevTotalSymptoms\n'
                                              'Total infected $prevTotalInfected',
                                              SocialMedia.clipboard);
                                        },
                                      ),
                                    ],
                                  ),
                                );
                              });
                            }),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    streamSub.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      // TODO set local notification and change to pause
      log('send local notification whenever the state changes to pause');
      if (toggleSwitchOn) {
        _showNotificationWithSound(
            'dodge corona app is running in the background',
            'keep it running we will fight corona together');
      } else {
        _showNotificationWithSound(
            'dodge corona app is not running in the background',
            'to help you find bad interaction, keep map turned on');
      }
    }
    if (state == AppLifecycleState.detached) {
      // TODO set local notification and change to pause
      log('send local notification whenever the state changes to pause');
    }
  }

  void savePreviousStateInSharedPreference(String previousStateNameString) {
    sharedPreferenceManager.putString(
        "prev_state", previousStateNameString.toLowerCase());
  }

  Future _showNotificationWithSound(
      String notificationHead, String notificationBody) async {
    GetIt getIt = GetIt.instance;
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    getIt<FlutterLocalNotificationsPlugin>();
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        'your channel id', 'your channel name', 'your channel description',
//        sound: RawResourceAndroidNotificationSound('slow_spring_board'),
        importance: Importance.Max,
        priority: Priority.High);
    var iOSPlatformChannelSpecifics =
        new IOSNotificationDetails(sound: "slow_spring_board.aiff");
    var platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      notificationHead, notificationBody,
      platformChannelSpecifics,
//      payload: 'Custom_Sound',
    );
  }
}
