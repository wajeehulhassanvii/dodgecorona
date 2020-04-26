import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:get/get.dart';
import 'package:getflutter/components/button/gf_button.dart';
import 'package:getflutter/size/gf_size.dart';
import 'package:getflutter/types/gf_button_type.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:trackcorona/presentation/screens/landing_page.dart';
import 'package:trackcorona/utilities/constants.dart';

class FeedbackPage extends StatelessWidget {
  static String route = "/feedbackpage";
  final _subjectTextController = TextEditingController();
  final _nameTextController = TextEditingController();
  final _emailTextController = TextEditingController();
  final _messageTextController = TextEditingController();


  final GlobalKey<FormState> _subjectKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _nameKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _emailKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _messageKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _subjectTextController.dispose();
    _nameTextController.dispose();
    _emailTextController.dispose();
    _messageTextController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Center(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.blue[200],
                  Colors.blue[200],
                ]),
            color: Colors.blue,
            image: DecorationImage(
                image: AssetImage('assets/images/landing_page_background.png'),
                fit: BoxFit.cover),
          ),
          child: Stack(
            children: <Widget>[
              Stack(children: <Widget>[BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 1, sigmaY: 3),
                child: Container(
                  color: Colors.blue.withOpacity(0.35),
                ),
              ),
                BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 1, sigmaY: 3),
                  child: Container(
                    color: Colors.black.withOpacity(0.65),
                  ),
                ),],),
              Container(
                height: Get.height,
                width: Get.width,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(50, 10, 50, 10),
                    child: Text(
                      'Dodge Corona',
                      style: TextStyle(
                          fontSize: 44,
                          color: Colors.white,
                          fontFamily: 'Alegreya'),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(50, 10, 50, 10),
                    child: Text(
                      'please give us your feedback, thank you!!!',
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontFamily: 'Alegreya'),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text('FEEDBACK FORM'),
                    ],
                  ),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[],
                    ),
                  ),
                  Container(
                    height: 60,
                    padding: EdgeInsets.fromLTRB(30, 5, 30, 0),
                    child: Material(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        elevation: 100,
                        key: _nameKey,
                        child: TextFormField(
                          autovalidate: true,
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Please enter some text";
                            }
                            return null;
                          },
                          controller: _nameTextController,
                          decoration: InputDecoration(labelText: 'name'),
                        )),
                  ),
                  Container(
                    height: 60,
                    padding: EdgeInsets.fromLTRB(30, 5, 30, 0),
                    key: _emailKey,
                    child: Material(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        elevation: 100,
                        child: TextFormField(
                          autovalidate: true,
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Please enter some text";
                            }
                            if (!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value)){
                              return "please enter correct email";
                            }
                            return null;
                          },
                          controller: _emailTextController,
                          decoration: InputDecoration(labelText: 'email'),
                        )),
                  ),
                  Container(
                    height: 80,
                    key: _subjectKey,
                    padding: EdgeInsets.fromLTRB(30, 5, 30, 0),
                    child: Material(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        elevation: 100,
                        child: TextFormField(
                          autovalidate: true,
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Please enter some text";
                            }
                            return null;
                          },
                          maxLines: 2,
                          controller: _subjectTextController,
                          decoration: InputDecoration(labelText: 'subject'),
                        )),
                  ),
                  Container(
                    height: 350,
                    padding: EdgeInsets.fromLTRB(30, 20, 30, 0),
                    child: Material(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      elevation: 100,
                      key: _messageKey,
                      child: TextFormField(
                        autovalidate: true,
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Please enter some text";
                          }
                          return null;
                        },
                        maxLines: 15,
                        controller: _messageTextController,
                        decoration: InputDecoration(
                          labelText: 'your message in 1000 letters......',
                        ),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      GFButton(
                          text: 'back to landing page',
                          icon: Icon(
                            LineAwesomeIcons.backward,
                            color: Colors.white70,
                          ),
                          size: GFSize.SMALL,
                          color: Colors.white70,
                          type: GFButtonType.outline2x,
                          // TODO implement onPress
                          onPressed: () async {
                            Get.off(LandingPage());
                          }),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(50, 10, 50, 5),
                        child: Text(
                          'ios and android app under testing, will soon be released',
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontFamily: 'Alegreya'),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      GFButton(
                          text: 'send feedback',
                          icon: Icon(
                            LineAwesomeIcons.send,
                            color: Colors.white70,
                          ),
                          size: GFSize.SMALL,
                          color: Colors.white70,
                          type: GFButtonType.outline2x,
                          // TODO implement onPress
                          onPressed: () async {
                            log('inside on press');

                            Dio dio = Dio();
                            dio.options.baseUrl = kBaseUrl_chrome;

                            Response response = Response();
                            response = await dio.post("/feedback",
                                data: jsonEncode({
                                  'name': _nameTextController.text,
                                  'email': _emailTextController.text,
                                  'subject': _subjectTextController.text,
                                  'message': _messageTextController.text,
                                }),
                                options: Options(headers: {
                                  "Access-Control-Allow-Origin":
                                      "*", // Required for CORS support to work
                                  "Access-Control-Allow-Credentials":
                                      true, // Required for cookies, authorization headers with HTTPS
                                  "Access-Control-Allow-Headers":
                                      "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token",
                                  "Access-Control-Allow-Methods":
                                      "POST, OPTIONS"
                                }));
                            log(response.toString());

                            // ends here onPress
                          }),
                    ],
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
} // success screen class ends here
