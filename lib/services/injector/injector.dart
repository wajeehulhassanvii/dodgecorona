import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get_it/get_it.dart';
import 'package:trackcorona/services/servicpush_notification_service/push_notification_service.dart';
import 'package:trackcorona/services/shared_preference_manager.dart';

GetIt getIt = GetIt.instance;

Future setupLocator() async {

  SharedPreferencesManager sharedPreferencesManager = await SharedPreferencesManager.getInstance();
  if(sharedPreferencesManager!=null){print('share is loaded');}
  getIt.registerSingleton<SharedPreferencesManager>(sharedPreferencesManager);

  PushNotificationService pushNotificationService = PushNotificationService();
  getIt.registerLazySingleton(() => pushNotificationService);


  print('registered sharedpreferencesmanager');


  // Flutter local notification
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  // initializations for flutter local notification
  // app_icon is the icon of the app
  // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
  // If you have skipped STEP 3 then change app_icon to @mipmap/ic_launcher
  var initializationSettingsAndroid =
  new AndroidInitializationSettings('app_icon');
  var initializationSettingsIOS = new IOSInitializationSettings();
  var initializationSettings = new InitializationSettings(
      initializationSettingsAndroid, initializationSettingsIOS);
  flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
  flutterLocalNotificationsPlugin.initialize(initializationSettings,
//        onSelectNotification: onSelectNotification
  );


  getIt.registerLazySingleton(() => flutterLocalNotificationsPlugin);

}