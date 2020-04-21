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

}