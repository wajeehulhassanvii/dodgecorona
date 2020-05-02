
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get_it/get_it.dart';
import 'package:trackcorona/services/apis/api_provider.dart';
import 'package:trackcorona/services/injector/injector.dart';
import 'package:trackcorona/services/shared_preference_manager.dart';

class PushNotificationService {
  static String fcmTokenKey = "fcm_token";
  final FirebaseMessaging _fcm = FirebaseMessaging();


  Future initialise() async {

    log('inside initialize PushNotification');
    if(Platform.isIOS){
      _fcm.requestNotificationPermissions(IosNotificationSettings());
      log('inside isIOS');
    }


    log('inside initialize before configure');
    _fcm.configure(

      // called when app is in foreground and we receive a push notification
      onMessage: (Map<String, dynamic> message) async {
        log('onMessage>>>>>>>>>>>: $message');
        _showNotificationWithSound(message['notification']['title'], message['notification']['body']);
      },

        // called when app has been completely closed
        onLaunch: (Map<String, dynamic> message) async {
          log('onLaunch>>>>>>>>>>>: $message');
          _showNotificationWithSound(message['notification']['title'], message['notification']['body']);
    },

        // called when app is in background and open app using
        // poush notification in notification drawer.
        onResume: (Map<String, dynamic> message) async {
          log('onResume>>>>>>>>>: $message');
          _showNotificationWithSound(message['notification']['title'], message['notification']['body']);
        },

      onBackgroundMessage: _myBackgroundMessageHandler,

    );

    log('inside initialize after configure');

    // just check the token
    String fcmToken = await _fcm.getToken();
    log('>>>>>>>>>>>>> fcmToken checking $fcmToken');


    _fcm.onTokenRefresh.listen((newToken) {

      // TODO Save newToken and also save in shared preference
//      Yes, as a workaround, you have to store the old token in sharedPreferences.
//      Everytime you get a onTokenRefresh call, you can compare it with the one on
//      SharedPreferences and store it only if they are different. Hope it helps

      log('refresh token getting called');
      _saveRefreshDeviceToken(newToken);

//      getIt = GetIt.instance;
//      SharedPreferencesManager sharedPreferenceManager= getIt<SharedPreferencesManager>();
//      sharedPreferenceManager.putString(fcmTokenKey, newToken);

    });


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

  static void saveDeviceToken() async {
    // TODO get the email or user_id
    // call this method after login

    getIt = GetIt.instance;
    SharedPreferencesManager sharedPreferenceManager= getIt<SharedPreferencesManager>();

    FirebaseMessaging _fcm = FirebaseMessaging();
    String fcmToken = await _fcm.getToken();
    log('>>>>>>>>>>>>> fcmToken $fcmToken');

    String oldFcmToken = sharedPreferenceManager.getString(fcmTokenKey);
    sharedPreferenceManager.putString(fcmTokenKey, fcmToken);
    
    // TODO save token to postgresql firebase_messaging database
    // check jwt and check if fcb_token is already present
    Dio dio = await ApiProvider().getDioHttpClient();
    Response response=Response();
    try{
    response = await dio.post('/savefcmtoken', data: jsonEncode({
      fcmTokenKey : fcmToken,
      "old_fcm_token": oldFcmToken
    }));}catch(e){
      log('exception caught at /savefcmtoken post in saveDeviceToken');
    }
    log(response.data.toString());
  }

  static void deleteDeviceToken() async {
    // TODO get the email or user_id
    // call this method after login
    FirebaseMessaging _fcm = FirebaseMessaging();
    String fcmToken = await _fcm.getToken();
    log('>>>>>>>>>>>>> fcmToken $fcmToken');

    getIt = GetIt.instance;
    SharedPreferencesManager sharedPreferenceManager= getIt<SharedPreferencesManager>();
    sharedPreferenceManager.clearKey(fcmTokenKey);

    // TODO save token to postgresql firebase_messaging database
    // check jwt and check if fcb_token is already present
    Dio dio = await ApiProvider().getDioHttpClient();
    Response response=Response();
    try{
      response = await dio.post('/deletefcmtoken', data: jsonEncode({
        fcmTokenKey : fcmToken
      }));}catch(e){
      log('exception caught at /deletefcmtoken post in saveDeviceToken');
    }
    log(response.data.toString());
  }


  _saveRefreshDeviceToken(String newToken) async {
    // TODO get the email or user_id
    // whenever there is refresh then check jwt and login then store
    // fcb_token in database


    getIt = GetIt.instance;
    SharedPreferencesManager sharedPreferenceManager= getIt<SharedPreferencesManager>();

    String newToken = await _fcm.getToken();


    // save newToken in database
    log('>>>>>>>>>>>>> fcmToken $newToken');

    String oldFcmToken = sharedPreferenceManager.getString(fcmTokenKey);
    sharedPreferenceManager.putString(fcmTokenKey, newToken);

    // TODO save token to postgresql firebase_messaging database
    // TODO delete old token if present and save new token

    // if user is logged in with jwt
    Dio dio = await ApiProvider().getDioHttpClient();

    Response response=Response();
    try{
    response = await dio.post('/savefcmtoken', data: jsonEncode({
      fcmTokenKey : newToken,
      "old_fcm_token": oldFcmToken
    }));} catch(e){
      log('exception caught at /savefcmtoken post in _saveRefreshDeviceToken');
    }

    log(response.data.toString());

  }


  static Future<dynamic> _myBackgroundMessageHandler(Map<String, dynamic> message) async {
    if (message.containsKey('data')) {
      // Handle data message
      // final dynamic data = message['data'];
    }

    if (message.containsKey('notification')) {
      // Handle notification message
      // final dynamic notification = message['notification'];
    }
    if (message.containsKey('click_action')) {
      log('>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>click_action>>>>>>>>>>>>>>>');
      // Handle notification message
      // final dynamic notification = message['notification'];
    }
    log(message.toString());

    // Or do other work.
  }
}

