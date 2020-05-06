import 'dart:convert';
import 'dart:developer';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getflutter/components/alert/gf_alert.dart';
import 'package:getflutter/components/button/gf_button.dart';
import 'package:getflutter/size/gf_size.dart';
import 'package:getflutter/types/gf_button_type.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:trackcorona/presentation/repositories/map_repository.dart';
import 'package:trackcorona/services/injector/injector.dart';
import 'package:trackcorona/services/shared_preference_manager.dart';
import 'package:trackcorona/utilities/constants.dart';

import 'login_page.dart';

class AccountSettingsPage extends StatelessWidget {
  static String route = "/accountsettingspage";
  @override
  Widget build(BuildContext context) {
    SharedPreferencesManager sharedPreferenceManager =
        getIt<SharedPreferencesManager>();

    return Scaffold(
      backgroundColor: Colors.blue[100],
      appBar: AppBar(
        title: Text('account settings', style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 10,),
            Container(
              color: Colors.white70,
              width: Get.width * 0.90,
              height: Get.height * 0.1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  SizedBox(width: 10),
                  Icon(Icons.delete, size: 30),
                  SizedBox(width: 10),
                  Text(
                    'delete account?',
                    style: TextStyle(fontSize: 16, color: Colors.black),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(width: 10),

                  GFButton(
                    text: "delete\naccount",
                    icon: Icon(LineAwesomeIcons.remove),
                    type: GFButtonType.outline2x,
                    color: Colors.black,
                    size: GFSize.SMALL,
                    onPressed: () async {
                      // delete the account from here

                      AwesomeDialog(
                        btnCancelColor: Colors.blue,
                        btnOkColor: Colors.black,
                        context: context,
                        animType: AnimType.SCALE,
                        dialogType: DialogType.ERROR,
                        tittle: 'are you sure you want to delete your account?',
                        desc:
                        'all your interactions and any kind of residuals will be deleted, and you '
                            'won\'t be able to recover that data again even if you make another account,',
                        btnCancelOnPress: () {
                          showSnackBar('account not deleted',
                              'Account deletion cancelled by the user.');},
                        btnOkOnPress: () async {
                          String accessToken;
                        String refreshToken;

                        try {
                          accessToken =
                              sharedPreferenceManager.getString(kAccessTokenKey);
                          refreshToken =
                              sharedPreferenceManager.getString(kRefreshTokenKey);
                        } catch (e) {
                          print('token not found');
                          print(e);
                        }

                        Dio dio = Dio();
                        dio.clear();
                        dio.options.baseUrl = kBaseUrl;

                        Response deleteResponse;

                        Map<String, dynamic> decodedJsonData;

                        print(accessToken);

                        String accessTokenBearer = "Bearer " + accessToken;

                        try {
                          dio.options.headers = {"Authorization": accessTokenBearer};
                          deleteResponse = await dio.delete("/deleteuser", data: {
                            "access_token": accessToken,
                            "refresh_token": refreshToken
                          });
                          print('done logout, now remove refresh logout');

                          if (deleteResponse.statusCode == 200) {
                            log('before clearning shared prefs');
                            await sharedPreferenceManager.clearAll();
                            log('going to login screen');
                            Get.off(LoginPage());
                            Get.removeRoute('/map');

                          }

                          decodedJsonData = jsonDecode(deleteResponse.toString());
                          print(decodedJsonData['message']);
                        } catch (e) {
                          print(e);
                        }
                        },

                      ).show();

                      //--------------

                    },
                  ),
                  SizedBox(width: 10),
                ],
              ),
            ),
            SizedBox(height: 10,),
            Container(
              color: Colors.white70,
              width: Get.width * 0.90,
              height: Get.height * 0.1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  SizedBox(width: 10),
                  Icon(Icons.delete, size: 30),
                  SizedBox(width: 10),
                  Text(
                    'delete your\nuser interactions',
                    style: TextStyle(fontSize: 16, color: Colors.black),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(width: 10),

                  GFButton(
                    text: "delete",
                    icon: Icon(LineAwesomeIcons.remove),
                    type: GFButtonType.outline2x,
                    color: Colors.black,
                    size: GFSize.SMALL,
                    onPressed: () async {
                      // delete the account from here

                      AwesomeDialog(
                        btnCancelColor: Colors.blue,
                        btnOkColor: Colors.black,
                        context: context,
                        animType: AnimType.SCALE,
                        dialogType: DialogType.ERROR,
                        tittle: 'are you sure you want to delete your account?',
                        desc:
                        'all your interactions and any kind of residuals will be deleted, and you '
                            'won\'t be able to recover that data again even if you make another account,',
                        btnCancelOnPress: () {
                          showSnackBar('account not deleted',
                              'Account deletion cancelled by the user.');},
                        btnOkOnPress: () async {
                          String accessToken;
                          String refreshToken;

                          try {
                            accessToken =
                                sharedPreferenceManager.getString(kAccessTokenKey);
                            refreshToken =
                                sharedPreferenceManager.getString(kRefreshTokenKey);
                          } catch (e) {
                            print('token not found');
                            print(e);
                          }

                          Dio dio = Dio();
                          dio.clear();
                          dio.options.baseUrl = kBaseUrl;

                          Response deleteResponse;

                          Map<String, dynamic> decodedJsonData;

                          print(accessToken);

                          String accessTokenBearer = "Bearer " + accessToken;

                          try {
                            dio.options.headers = {"Authorization": accessTokenBearer};
                            deleteResponse = await dio.delete("/deleteuser", data: {
                              "access_token": accessToken,
                              "refresh_token": refreshToken
                            });
                            print('done logout, now remove refresh logout');

                            if (deleteResponse.statusCode == 200) {
                              log('before clearning shared prefs');
                              await sharedPreferenceManager.clearAll();
                              log('going to login screen');
                              Get.off(LoginPage());
                              Get.removeRoute('/map');

                            }

                            decodedJsonData = jsonDecode(deleteResponse.toString());
                            print(decodedJsonData['message']);
                          } catch (e) {
                            print(e);
                          }
                        },

                      ).show();

                      //--------------

                    },
                  ),
                  SizedBox(width: 10),
                ],
              ),
            ),
            SizedBox(height: 10,),
            Container(
              color: Colors.white70,
              width: Get.width * 0.90,
              height: Get.height * 0.1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  SizedBox(width: 10),
                  Icon(Icons.delete, size: 30),
                  SizedBox(width: 10),
                  Text(
                      'delete others\nuser interactions',
                    style: TextStyle(fontSize: 16, color: Colors.black),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(width: 10),

                  GFButton(
                    text: "delete",
                    icon: Icon(LineAwesomeIcons.remove),
                    type: GFButtonType.outline2x,
                    color: Colors.black,
                    size: GFSize.SMALL,
                    onPressed: () async {
                      // delete the account from here

                      AwesomeDialog(
                        btnCancelColor: Colors.blue,
                        btnOkColor: Colors.black,
                        context: context,
                        animType: AnimType.SCALE,
                        dialogType: DialogType.ERROR,
                        tittle: 'are you sure you want to delete your account?',
                        desc:
                        'all your interactions and any kind of residuals will be deleted, and you '
                            'won\'t be able to recover that data again even if you make another account,',
                        btnCancelOnPress: () {
                          showSnackBar('account not deleted',
                              'Account deletion cancelled by the user.');},
                        btnOkOnPress: () async {
                          String accessToken;
                          String refreshToken;

                          try {
                            accessToken =
                                sharedPreferenceManager.getString(kAccessTokenKey);
                            refreshToken =
                                sharedPreferenceManager.getString(kRefreshTokenKey);
                          } catch (e) {
                            print('token not found');
                            print(e);
                          }

                          Dio dio = Dio();
                          dio.clear();
                          dio.options.baseUrl = kBaseUrl;

                          Response deleteResponse;

                          Map<String, dynamic> decodedJsonData;

                          print(accessToken);

                          String accessTokenBearer = "Bearer " + accessToken;

                          try {
                            dio.options.headers = {"Authorization": accessTokenBearer};
                            dio.options.headers['access_token'] =accessToken;
                            dio.options.headers['refresh_token'] =refreshToken;
                                deleteResponse = await dio.delete("/deleteuser");
                            print('done logout, now remove refresh logout');

                            if (deleteResponse.statusCode == 200) {
                              log('before clearning shared prefs');
                              await sharedPreferenceManager.clearAll();
                              log('going to login screen');
                              Get.off(LoginPage());
                              Get.removeRoute('/map');

                            }

                            decodedJsonData = jsonDecode(deleteResponse.toString());
                            print(decodedJsonData['message']);
                          } catch (e) {
                            print(e);
                          }
                        },

                      ).show();

                      //--------------

                    },
                  ),
                  SizedBox(width: 10),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
