
import 'dart:developer';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotificationService {
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
      },

        // called when app has been completely closed
        onLaunch: (Map<String, dynamic> message) async {
          log('onLaunch>>>>>>>>>>>: $message');
    },

        // called when app is in background and open app using
        // poush notification in notification drawer.
        onResume: (Map<String, dynamic> message) async {
          log('onResume>>>>>>>>>: $message');
        },

      onBackgroundMessage: _myBackgroundMessageHandler,

    );

    log('inside initialize after configure');

    _saveDeviceToken();

  }

  _saveDeviceToken() async {
    // TODO get the email or user_id
    String fcmToken = await _fcm.getToken();
    log('>>>>>>>>>>>>> fcmToken $fcmToken');

    // TODO save token to postgresql
  }

  Future<dynamic> _myBackgroundMessageHandler(Map<String, dynamic> message) async {
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

