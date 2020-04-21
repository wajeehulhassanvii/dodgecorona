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
      appBar: AppBar(
        title: Text('account settings', style: TextStyle(color: Colors.white70),),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.delete, size: 40),
            SizedBox(height: 10),
            Text(
              'sure, you want to delete your account?',
              style: TextStyle(fontSize: 25, color: Colors.black),
              textAlign: TextAlign.center,
            ),
            Text(
              'all you data will be deleted,',
              style: TextStyle(fontSize: 25, color: Colors.black),
              textAlign: TextAlign.center,
            ),
            Text(
              'be safe, keep your family safe...',
              style: TextStyle(fontSize: 25, color: Colors.black),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),

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
          ],
        ),
      ),
    );
  }
}
