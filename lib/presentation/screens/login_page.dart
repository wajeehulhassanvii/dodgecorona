import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:trackcorona/presentation/screens/about_page.dart';
import 'package:trackcorona/presentation/screens/map_page.dart';
import 'package:trackcorona/presentation/screens/registration_page.dart';
import 'package:trackcorona/services/apis/api_provider.dart';
import 'package:trackcorona/services/servicpush_notification_service/push_notification_service.dart';
import 'package:trackcorona/services/shared_preference_manager.dart';
import 'package:wc_form_validators/wc_form_validators.dart';
import 'package:trackcorona/utilities/loading_dialog.dart';

class LoginPageFormBloc extends FormBloc<String, String> {

//  Dio dio = Dio();
  GetIt getIt;

  @override
  dispose(){
    emailField.close();
    passwordField.close();
    rememberMeBooleanField.close();
  }

  final emailField = TextFieldBloc(
    validators: [
      Validators.required('Email is required'),
      Validators.email('Invalid email address'),
    ],
  );

  final passwordField = TextFieldBloc(
    validators: [
      Validators.maxLength(20, 'Less than 20 characters allowed'),
      Validators.required("please enter your password!!")
    ],
  );

  // TODO have to add a field for remember me and store it in a cookie
  final rememberMeBooleanField = BooleanFieldBloc(
    name: "remember me",
  );

  //to add progress bar
  LoginPageFormBloc() {
    addFieldBlocs(
        fieldBlocs: [emailField, passwordField, rememberMeBooleanField]);
  }

  void addErrors() {}

  // modifying onSubmitting
  @override
  void onSubmitting() async {

    Dio dio = await ApiProvider().getDioHttpClient();

    Response response;
    Map<String, dynamic> decodedJsonData;
    try {
      try {
        response = await dio.post("/login",
            data: jsonEncode(
                {"email": emailField.value,
                 "password": passwordField.value,
                  "rememberMe": true
//                "rememberMe": rememberMeBooleanField.value
                }));

        decodedJsonData=jsonDecode(response.toString());
        print(decodedJsonData);

        PushNotificationService.saveDeviceToken();

        // initialize getIt
        getIt = GetIt.instance;
        SharedPreferencesManager sharedPreferenceManager= getIt<SharedPreferencesManager>();

        await sharedPreferenceManager.putAccessToken(decodedJsonData['access_token']).whenComplete(() => print(' access token stored'));
        await sharedPreferenceManager.putRefreshToken(decodedJsonData['refresh_token']).whenComplete(() => print('refresh token stored'));

        String tempAccessToken = sharedPreferenceManager.getString('access_token');
        print('--------------------- $tempAccessToken');

      } catch (e) {
        print(e);
      } // inner ctry/catch block ends

      await Future<void>.delayed(Duration(milliseconds: 1000));

      if (response.statusCode == 200) {
        emitSubmitting(progress: 1);
        emitSuccess(canSubmitAgain: true);
      } else {
        emitFailure();
      }
//      emitSubmitting(progress: 0.6);
//      emitSuccess(canSubmitAgain: true);
//
    } catch (e) {
      emitFailure();
    } // end of try/catch blocks
  }
} // RegistrationPageFormBloc class ends here

class LoginPage extends StatelessWidget {
  static String route = "/loginpage";

  @override
  Widget build(BuildContext context) {

    return BlocProvider(
      create: (context) => LoginPageFormBloc(),
      child: Builder(
        builder: (context) {
          final loginPageBloc =
              BlocProvider.of<LoginPageFormBloc>(context);
          return Theme(
            data: Theme.of(context).copyWith(
              inputDecorationTheme: InputDecorationTheme(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            child: Scaffold(
              floatingActionButton: Column(

                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  SizedBox(height: 12),
                  FloatingActionButton.extended(
                    elevation: 20,
                    heroTag: ['heroLoginPageSubmit', 'delToLogin'],
                    onPressed: loginPageBloc.submit,
                    backgroundColor: Colors.blue,
                    icon: Icon(Icons.send, color: Colors.white70),
                    label: Text('login', style: TextStyle(color: Colors.white70,
                    ),),
                  ),
                ],
              ),
              body: Container(
                padding: EdgeInsets.symmetric(vertical: 30),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    colors: [
                      Colors.blue,
                      Colors.blue
                    ],
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      height: 80,
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 30, 20, 30),
                      child: Row(
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              Text('Login',
                                  style: TextStyle(
                                      fontSize: 50,
                                      color: Colors.white,
                                      fontFamily: 'Alegreya', letterSpacing: 9),),
                              SizedBox(height: 10),
                              Padding(
                                padding: const EdgeInsets.only(left: 50),
                                child: Text('lets track corona',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20, letterSpacing: 3),),
                              ),
                            ],
                          ),
//                          Image(image: AssetImage('assets/images/track_corona_generic.png'),
//                          height: 120, width: 120,)
                        ],
                      ),
                    ),
                    FormBlocListener<LoginPageFormBloc, String, String>(
                      onSubmitting: (context, state) {
                        LoadingDialog.show(context);
                      }, // OnSubmitting ends here
                      onSuccess: (context, state) {
                        LoadingDialog.hide(context);
                        Get.snackbar(
                            'success!!!', 'watch out for infected person',
                            backgroundColor: Colors.grey[850],
                            snackPosition: SnackPosition.BOTTOM,
                            colorText: Colors.white70,
                            isDismissible: true);
                        loginPageBloc.passwordField.clear();
                        loginPageBloc.emailField.clear();
                        Get.offAll(MapPage());
//                        Get.removeRoute(LoginPage());
                      }, // Success ends here

                      onFailure: (context, state) {
                        LoadingDialog.hide(context);
                        Get.snackbar(
                            'failed to login', 'incorrect email/password',
                            backgroundColor: Colors.grey[850],
                            snackPosition: SnackPosition.BOTTOM,
                            colorText: Colors.white70,
                            isDismissible: true);
                      }, // Failure ends here
                      child: SingleChildScrollView(
                        physics: ClampingScrollPhysics(),
                        child: Padding(
                          padding: EdgeInsets.all(24.0),
                          child: Column(
                            children: <Widget>[
                              TextFieldBlocBuilder(

                                cursorColor: Colors.white70,
                                textFieldBloc: loginPageBloc.emailField,
                                decoration: InputDecoration(

                                    labelText: 'email ',
                                    labelStyle: TextStyle(color: Colors.white70),
                                    prefixIcon: Icon(Icons.email, color: Colors.white70,)),
                              ),
                              TextFieldBlocBuilder(
                                cursorColor: Colors.white70,
                                textFieldBloc:
                                    loginPageBloc.passwordField,
                                suffixButton: SuffixButton.obscureText,
                                decoration: InputDecoration(
                                    labelText: 'password ',
                                    labelStyle: TextStyle(color: Colors.white70),
                                    prefixIcon: Icon(Icons.lock, color: Colors.white70,)),
                              ),
//                              Padding(
//                                padding: EdgeInsets.only(left: 0),
//                                child: CheckboxFieldBlocBuilder(
//                                  booleanFieldBloc: loginPageBloc
//                                      .rememberMeBooleanField,
//                                  body: Container(
//                                    alignment: Alignment.centerLeft,
//                                    child: Text(
//                                      'remember me',
//                                      style: TextStyle(color: Colors.grey[600]),
//                                    ),
//                                  ),
//                                ),
//                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  FlatButton(
                                    onPressed: () {
                                      Navigator.of(context).pushReplacement(
                                          MaterialPageRoute(
                                              builder: (_) => RegistrationPage()));
                                    },
                                    child: Text(
                                      'create account',
                                      style: TextStyle(color: Colors.white70),
                                    ),
                                  ),
//                                  Text(",",
//                                      style: TextStyle(color: Colors.white70),),
                                  FlatButton(
                                    onPressed: () {
                                      Get.to(AboutPage());
                                    },
                                    child: Text(
                                      'about',
                                      style: TextStyle(color: Colors.white70),
                                    ),
                                  ),
//                                  Text('OR', style: TextStyle(color: Colors.grey[600]),),
//                                  FlatButton(
//                                    onPressed: () {
//                                      Get.toNamed('/resetpage');
//                                      // TODO implement password reset by sending user to password reset page
//                                    },
//                                    child: Text(
//                                      'reset password',
//                                      style: TextStyle(color: Colors.grey),
//                                    ),
//                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

} // loginPage ends here
