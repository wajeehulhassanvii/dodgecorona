import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:trackcorona/presentation/screens/about_page.dart';
import 'package:trackcorona/presentation/screens/account_settings_page.dart';
import 'package:trackcorona/presentation/screens/how_to_use_page.dart';
import 'package:trackcorona/presentation/screens/landing_page.dart';
import 'package:trackcorona/presentation/screens/login_page.dart';
import 'package:trackcorona/presentation/screens/map_page.dart';
import 'package:trackcorona/presentation/screens/registration_page.dart';
import 'package:trackcorona/presentation/screens/reset_password_page.dart';
import 'package:trackcorona/services/apis/api_provider.dart';
import 'package:trackcorona/services/injector/injector.dart';
import 'package:trackcorona/services/shared_preference_manager.dart';
import 'package:trackcorona/services/servicpush_notification_service/push_notification_service.dart';

void main() async {
  // setupLocator is getIt instance
  try {
    WidgetsFlutterBinding.ensureInitialized();
    setupLocator();
  } catch (e) {
    log(e);
  }


  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context){


    return FutureBuilder(
        future: _checkLogin(),
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot){
          var user = snapshot.data; //
          print("snapshot1"+snapshot.toString()); //
          print("snapshot.data" + snapshot.data.runtimeType.toString());
          print("snapshot.data" + snapshot.data.toString());// th
          // islogin=true means jwt isn't revoked
          if(GetPlatform.isWeb){

            return MaterialApp(
                navigatorKey: Get.key,
                title: 'Flutter Demo',
//                initialRoute: '/map',
                routes: {
//        '/': (context) => LandingPage(),
                  '/login': (context) => LoginPage(),
                  '/registration': (context) => RegistrationPage(),
                  '/map': (context) => MapPage(),
                  '/accountsettings': (context) => AccountSettingsPage(),
                  '/resetpage': (context) => ResetPasswordPage(),
                  '/aboutpage': (context) => AboutPage(),
                  '/howtousepage': (context) => HowToUsePage(),
                },
                theme: ThemeData(
                  primarySwatch: Colors.grey,
                  textTheme: TextTheme(),
                ),
                home:LandingPage()
            );
          } else {
          if (snapshot.data==true){
            log('inside isLoggedIn true');
            var user = snapshot.data; //
            print(snapshot); //
            print(snapshot.data);// this is your user instance
            /// is because there is user already logged
            return MaterialApp(
                navigatorKey: Get.key,
                title: 'Flutter Demo',
//                initialRoute: '/map',
                routes: {
//        '/': (context) => LandingPage(),
                  '/login': (context) => LoginPage(),
                  '/registration': (context) => RegistrationPage(),
                  '/map': (context) => MapPage(),
                  '/accountsettings': (context) => AccountSettingsPage(),
                  '/resetpage': (context) => ResetPasswordPage(),
                  '/aboutpage': (context) => AboutPage(),
                  '/howtousepage': (context) => HowToUsePage(),
                },
                theme: ThemeData(
                  primarySwatch: Colors.grey,
                  textTheme: TextTheme(),
                ),
                home:MapPage()
            );

          } else {
            /// other way there is no user logged.
            return MaterialApp(
                navigatorKey: Get.key,
                title: 'Flutter Demo',
//              initialRoute: '/login',
                routes: {
//        '/': (context) => LandingPage(),
                  '/login': (context) => LoginPage(),
                  '/registration': (context) => RegistrationPage(),
                  '/map': (context) => MapPage(),
                  '/accountsettings': (context) => AccountSettingsPage(),
                  '/resetpage': (context) => ResetPasswordPage(),
                  '/aboutpage': (context) => AboutPage(),
                  '/howtousepage': (context) => HowToUsePage(),
                },
                theme: ThemeData(
                  primarySwatch: Colors.grey,
                  textTheme: TextTheme(),
                ),
                home:LoginPage()
            );

          }
          } // else if not web

        }
    );
  }


  Future<bool> _checkLogin() async{
    getIt = GetIt.instance;
    SharedPreferencesManager sharedPreferenceManager =
      await SharedPreferencesManager.getInstance();


    PushNotificationService pushNotificationService=PushNotificationService();
    pushNotificationService.initialise();

    var isLoggedIn = false;
    String storedAccessToken;

    try{
      storedAccessToken = sharedPreferenceManager.getString('access_token');
      if (storedAccessToken == null){
        return  isLoggedIn;
      }
    }catch(e){
      log('no access token');
      return isLoggedIn;

    }

    Response checkLoginResponse= Response();

    Dio dio = await ApiProvider().getDioHttpClient();
    checkLoginResponse = await dio.get('/checklogin');

    Map<String, dynamic> decodedJsonData;

    log('dio checklogin done');

    //-----

    try {

      if (checkLoginResponse.statusCode == 200) {
        log('yes logged in but better to check the content returned');
        isLoggedIn=true;
        log('going to login screen');
      }

      decodedJsonData = jsonDecode(checkLoginResponse.toString());
      bool isRevoked = decodedJsonData['is_jwt_revoked'];
      log(isLoggedIn.toString());
      if(isRevoked){
        isLoggedIn=false;
      } else {
        isLoggedIn=true;
      }
      return isLoggedIn;
    } catch (e) {
      print(e);
    }

    return isLoggedIn;
    //-----
  }
}

