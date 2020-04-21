import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getflutter/components/button/gf_button.dart';
import 'package:getflutter/size/gf_size.dart';
import 'package:getflutter/types/gf_button_type.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:trackcorona/utilities/constants.dart';

class FeedbackPage extends StatelessWidget {
  static String route = "/feedbackpage";

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
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 2, sigmaY: 6),
                child: Container(
                  color: Colors.black.withOpacity(0.6),
                ),
              ),
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
                      'We took the challenge to bring the economy back to its foot'
                          ', after the world got affected by COVID-19 '
                          'keeping in mind your privacy, see how we can achieve it together',
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
                  Material(
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                    elevation: 100,
                    child: Text('add form here')
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
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
                          icon: Icon(LineAwesomeIcons.send, color: Colors.white70,),
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
                                  'name': 'name',
                                  'email': 'email',
                                  'message': 'message',
                                }),
                            options: Options(contentType: ContentType.json.toString()));
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
