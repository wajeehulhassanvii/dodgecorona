import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:trackcorona/presentation/screens/login_page.dart';
import 'package:trackcorona/presentation/screens/success_screen.dart';
import 'package:wc_form_validators/wc_form_validators.dart';
import 'package:trackcorona/utilities/loading_dialog.dart';
import 'package:get/get.dart';

class RegistrationPageFormBloc extends FormBloc<String, String> {
  Dio dio = new Dio();

  @override
  void dispose() {
    emailField.close();
    lastNameTextField.close();
    firstNameTextField.close();
    passwordField.close();
    phoneNumberField.close();
  }

  final emailField = TextFieldBloc(
    validators: [
      Validators.required('Email is required'),
      Validators.email('Invalid email address'),
    ],
  );
  final lastNameTextField = TextFieldBloc(
    validators: [
      Validators.maxLength(15, 'Less than 15 characters allowed'),
      Validators.minLength(3, 'Minimum length should be 3')
    ],
  );
  final firstNameTextField = TextFieldBloc(
    validators: [
      Validators.maxLength(15, 'Less than 15 characters allowed'),
      Validators.minLength(3, 'Minimum length should be 3')
    ],
  );
  final passwordField = TextFieldBloc(
    validators: [
      Validators.required('Please enter password'),
      Validators.minLength(8, 'Password shortest than 8 not allowed'),
      Validators.patternString(
          r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$',
          'Password requires at least 1 each [a-z] [A-Z] [0-9] and [!-*]')
    ],
  );
  final phoneNumberField = TextFieldBloc(
    validators: [
      Validators.maxLength(15, 'Less than 15 characters allowed'),
      Validators.patternRegExp(
          RegExp(
              "(([+][(]?[0-9]{1,3}[)]?)|([(]?[0-9]{4}[)]?))\s*[)]?[-\s\.]?[(]?[0-9]{1,3}[)]?([-\s\.]?[0-9]{3})([-\s\.]?[0-9]{3,4})"),
          "Phone number not correct, enter in international format")
    ],
  );

  RegistrationPageFormBloc() {
    addFieldBlocs(fieldBlocs: [
      firstNameTextField,
      lastNameTextField,
      emailField,
      passwordField,
      phoneNumberField
    ]);
  }

  void addErrors() {}

  @override
  void onSubmitting() async {
    Response response;
    Map<String, dynamic> decodedJsonData;

    try {
      try {
//        response = await dio.post("http://192.168.1.102:8000/sendregistrationdata",
//        response = await dio.post("http://127.0.0.1:8000/sendregistrationdata",

        response = await dio.post("http://10.0.2.2:8000/sendregistrationdata",
            data: jsonEncode({
              "email": emailField.value,
              "password": passwordField.value,
              "firstName": firstNameTextField.value,
              "lastName": lastNameTextField.value,
              "phoneNumber": phoneNumberField.value
            }));

        try {
          decodedJsonData = jsonDecode(response.toString());
          print(decodedJsonData['message']);
        } catch (e) {
          print(e);
        }
      } catch (e) {
        // exception during request
        print(e);
      } // inner ctry/catch block ends
//      emitSubmitting(progress: 0.2);

      await Future<void>.delayed(Duration(milliseconds: 500));
      if (response.statusCode == 200) {
        emitSubmitting(progress: 1);
        emitSuccess(canSubmitAgain: true);
      } else {
        Get.snackbar('failed to login', 'email phone number taken',
            backgroundColor: Colors.grey[850],
            snackPosition: SnackPosition.BOTTOM,
            colorText: Colors.white70,
            isDismissible: true);
        emitFailure();
      }
//      emitSubmitting(progress: 0.6);
//      emitSuccess(canSubmitAgain: true);
//
    } catch (e) {
      emitFailure();
    } // end of try/catch blocks
  }
} // RegistrationPageFormBloc

class RegistrationPage extends StatelessWidget {
  static String route = "/registrationpage";


  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RegistrationPageFormBloc(),
      child: Builder(
        builder: (context) {
          final registrationPageBloc =
              BlocProvider.of<RegistrationPageFormBloc>(context);
          return Theme(
            data: Theme.of(context).copyWith(
              inputDecorationTheme: InputDecorationTheme(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            child: Scaffold(
              floatingActionButton: Padding(
                padding: const EdgeInsets.fromLTRB(30, 5, 45, 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    FloatingActionButton.extended(
                      elevation: 20,
                      heroTag: 'herogobacktologin',
                      onPressed: () {
                        Get.offAll(LoginPage());
                      },
                      icon: Icon(Icons.backspace),
                      label: Text('back to\nlogin'),
                      backgroundColor: Colors.blue,
                    ),
                    SizedBox(width: 50),
                    FloatingActionButton.extended(
                      elevation: 20,
                      heroTag: 'heroLoginPageToRegistration',
                      onPressed: registrationPageBloc.submit,
                      icon: Icon(Icons.send),
                      backgroundColor: Colors.blue,
                      label: Text('submit'),


                    ),
                  ],
                ),
              ),
              body: Container(
                padding: EdgeInsets.symmetric(vertical: 20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                    Colors.blue,
                    Colors.blue
                  ], begin: Alignment.topCenter),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      height: 40,
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(40, 10, 20, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Registration',
                            style:
                                TextStyle(color: Colors.white, fontSize: 40),
                          ),
                          Row(
                            children: <Widget>[
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                'to track corona (COVID-19)',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    FormBlocListener<RegistrationPageFormBloc, String, String>(
                      onSubmitting: (context, state) {
                        LoadingDialog.show(context);
                      }, // OnSubmitting ends here
                      onSuccess: (context, state) {
                        LoadingDialog.hide(context);

                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (_) => SuccessScreen(
                              successMessage:
                                  'Success, Check\nemail\nfor\naccount\nactivation.',
                              nextPageButtonText: 'go to login page',
                              nextPage: LoginPage(),
                            ),
                          ),
                        ); // use either get or this method
                      }, // Success ends here
                      onFailure: (context, state) {
                        LoadingDialog.hide(context);

                        Get.snackbar(
                            'failed to register', 'check info or connection',
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
                                cursorColor: Colors.white54,
                                textFieldBloc:
                                    registrationPageBloc.firstNameTextField,
                                decoration: InputDecoration(
                                    labelText: 'first name ',
                                    labelStyle: TextStyle(color: Colors.white54),
                                    prefixIcon: Icon(Icons.assignment_ind, color: Colors.white54,)),
                              ),
                              TextFieldBlocBuilder(
                                cursorColor: Colors.white54,
                                textFieldBloc:
                                    registrationPageBloc.lastNameTextField,
                                decoration: InputDecoration(
                                    labelText: 'last name ',
                                    labelStyle: TextStyle(color: Colors.white54),
                                    prefixIcon: Icon(Icons.assignment_ind,color: Colors.white54,)),
                              ),
                              TextFieldBlocBuilder(
                                cursorColor: Colors.white54,
                                textFieldBloc:
                                    registrationPageBloc.phoneNumberField,
                                decoration: InputDecoration(
                                    labelText: 'phone number (intl format +)',
                                    labelStyle: TextStyle(color: Colors.white54),
                                    prefixIcon: Icon(Icons.phone, color: Colors.white54,)),
                              ),
                              TextFieldBlocBuilder(
                                cursorColor: Colors.white54,
                                textFieldBloc: registrationPageBloc.emailField,
                                decoration: InputDecoration(
                                    labelText: 'email field',
                                    labelStyle: TextStyle(color: Colors.white54),
                                    prefixIcon: Icon(Icons.email, color: Colors.white54,)),
                              ),
                              TextFieldBlocBuilder(
                                cursorColor: Colors.white54,
                                textFieldBloc:
                                    registrationPageBloc.passwordField,
                                suffixButton: SuffixButton.obscureText,
                                decoration: InputDecoration(
                                    labelText: 'password ',
                                    labelStyle: TextStyle(color: Colors.white54),
                                    prefixIcon: Icon(Icons.lock, color: Colors.white54,)),
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
} // Class RegistrationPage ends here
