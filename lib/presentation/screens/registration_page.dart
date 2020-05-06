import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:getflutter/getflutter.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:trackcorona/presentation/screens/login_page.dart';
import 'package:trackcorona/presentation/screens/success_screen.dart';
import 'package:trackcorona/utilities/constants.dart';
import 'package:wc_form_validators/wc_form_validators.dart';
import 'package:trackcorona/utilities/loading_dialog.dart';
import 'package:get/get.dart';

class RegistrationPageFormBloc extends FormBloc<String, String> {

  @override
  void dispose() {
    emailField.close();
    lastNameTextField.close();
    firstNameTextField.close();
    passwordField.close();
    phoneNumberField.close();
    repeatPasswordField.close();
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
  final repeatPasswordField = TextFieldBloc(
    validators: [Validators.required('please confirm the password')],
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

  Validator<String> _confirmPassword(
      TextFieldBloc passwordTextFieldBloc
      ){
    return (String confirmPassword){
      if (confirmPassword == passwordTextFieldBloc.value){
        return null;
      }
      return "Both password must match, check again";
    };
  }

  RegistrationPageFormBloc() {
    addFieldBlocs(fieldBlocs: [
      firstNameTextField,
      lastNameTextField,
      emailField,
      passwordField,
      phoneNumberField,
      repeatPasswordField,
    ]);
    repeatPasswordField.addValidators([_confirmPassword(passwordField)]);
    repeatPasswordField.subscribeToFieldBlocs([passwordField]);
  }

  void addErrors() {}

  @override
  void onSubmitting() async {

    Dio dio = new Dio();
    Response response;
    Map<String, dynamic> decodedJsonData;
    log(emailField.value);
    log(passwordField.value);
    log(firstNameTextField.value);
    log(lastNameTextField.value);
    log(phoneNumberField.value);

    try {
      try {
      dio.options.baseUrl = kBaseUrl;
        response = await dio.post("/sendregistrationdata",
            data: jsonEncode({
              "email": emailField.value,
              "password": passwordField.value,
              "first_name": firstNameTextField.value,
              "last_name": lastNameTextField.value,
              "phone_number": phoneNumberField.value
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
      } else if (response.statusCode == 400){
        Get.snackbar('couldn\'t register account', response.data['message'],
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
                padding: EdgeInsets.symmetric(vertical: 5),
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                    Colors.blue,
                    Colors.blue
                  ], begin: Alignment.topCenter),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 30,
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
                            'could not register', 'try different phone number or email address\n'
                            'also make sure your internet connection is working properly',
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
                              Container(
                                width: 300,
                                height: 60,
                                child: TextFieldBlocBuilder(
                                  cursorColor: Colors.white54,
                                  textFieldBloc:
                                      registrationPageBloc.firstNameTextField,
                                  decoration: InputDecoration(
                                      labelText: 'first name ',
                                      labelStyle: TextStyle(fontSize: 13, color: Colors.white54),
                                      prefixIcon: Icon(Icons.assignment_ind, color: Colors.white54,)),
                                ),
                              ),
                              Container(
                                width: 300,
                                height: 60,
                                child: TextFieldBlocBuilder(
                                  cursorColor: Colors.white54,
                                  textFieldBloc:
                                      registrationPageBloc.lastNameTextField,
                                  decoration: InputDecoration(
                                      labelText: 'last name ',
                                      labelStyle: TextStyle(color: Colors.white54, fontSize: 13),
                                      prefixIcon: Icon(Icons.assignment_ind,color: Colors.white54,)),
                                ),
                              ),
                              Container(
                                width: 300,
                                height: 60,
                                child: TextFieldBlocBuilder(
                                  cursorColor: Colors.white54,
                                  textFieldBloc:
                                      registrationPageBloc.phoneNumberField,
                                  decoration: InputDecoration(
                                      labelText: 'phone number (intl format +)',
                                      labelStyle: TextStyle(color: Colors.white54, fontSize: 13),
                                      prefixIcon: Icon(Icons.phone, color: Colors.white54,)),
                                ),
                              ),
                              Container(
                                width: 300,
                                height: 60,
                                child: TextFieldBlocBuilder(
                                  cursorColor: Colors.white54,
                                  textFieldBloc: registrationPageBloc.emailField,
                                  decoration: InputDecoration(
                                      labelText: 'email field',
                                      labelStyle: TextStyle(color: Colors.white54, fontSize: 13),
                                      prefixIcon: Icon(Icons.email, color: Colors.white54,)),
                                ),
                              ),
                              Container(
                                width: 300,
                                height: 60,
                                child: TextFieldBlocBuilder(
                                  cursorColor: Colors.white54,
                                  textFieldBloc:
                                      registrationPageBloc.passwordField,
                                  suffixButton: SuffixButton.obscureText,
                                  decoration: InputDecoration(

                                      labelText: 'password ',
                                      labelStyle: TextStyle(color: Colors.white54, fontSize: 13),
                                      prefixIcon: Icon(Icons.lock, color: Colors.white54,)),
                                ),
                              ),
                              Container(
                                width: 300,
                                height: 60,
                                child: TextFieldBlocBuilder(
                                  cursorColor: Colors.white54,
                                  textFieldBloc:
                                  registrationPageBloc.repeatPasswordField,
                                  suffixButton: SuffixButton.obscureText,
                                  decoration: InputDecoration(
                                      labelText: 'repeat password ',
                                      labelStyle: TextStyle(color: Colors.white54, fontSize: 13),
                                      prefixIcon: Icon(Icons.lock, color: Colors.white54,)),
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
//                                  GFButton(text: 'back to login',
//                                      color: Colors.white70,
//                                      icon: Icon(LineAwesomeIcons.backward, color: Colors.white70,),
//                                      type: GFButtonType.outline,
//                                      onPressed: (){
//                                        Get.offAll(LoginPage());
//                                  }),
//                                  SizedBox(width: 50,),
//                                  GFButton(text: 'submit',
//                                      icon: Icon(LineAwesomeIcons.send, color: Colors.white70,),
//                                      type: GFButtonType.outline,
//                                      color: Colors.white70,
//                                      onPressed: (){
//                                        registrationPageBloc.submit;
//                                      }),
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
} // Class RegistrationPage ends here
