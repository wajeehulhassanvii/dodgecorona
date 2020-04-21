import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:universal_html/html.dart' as html;
import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getflutter/components/button/gf_button.dart';
import 'package:getflutter/components/carousel/gf_carousel.dart';
import 'package:getflutter/getflutter.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:trackcorona/presentation/screens/feedback_page.dart';
import 'package:trackcorona/utilities/constants.dart';

class LandingPage extends StatelessWidget {
  static String route = "/landingpage";

  @override
  Widget build(BuildContext context) {
    final List<String> imageList = [
      'assets/images/landing_page/landing_page_Sheet_1.png',
      'assets/images/landing_page/landing_page_Sheet_2.png',
      'assets/images/landing_page/landing_page_Sheet_3.png',
      'assets/images/landing_page/landing_page_Sheet_4.png',
      'assets/images/landing_page/landing_page_Sheet_5.png',
      'assets/images/landing_page/landing_page_Sheet_6.png'
    ];
    final subscribeEmailTextFieldController = TextEditingController();

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
                      Text(
                        'subscribe to stay updated :',
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontFamily: 'Alegreya'),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Container(
                        height: 30,
                        width: 300,
                        child: TextFormField(
                          style: TextStyle(color: Colors.white),
                          controller: subscribeEmailTextFieldController,
                          validator: (value) {
                            return validateEmailAndEmptyCheck(value);
                            return null;
                          },
                          decoration: InputDecoration(
                            labelStyle:
                                TextStyle(color: Colors.white, fontSize: 11),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            focusColor: Colors.white,
                            fillColor: Colors.white,
                            hoverColor: Colors.white,
                            labelText: 'enter email...',
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      GFButton(
                          text: 'subscribe',
                          size: GFSize.SMALL,
                          color: Colors.white70,
                          type: GFButtonType.outline2x,
                          // TODO implement onPress
                          onPressed: () async {
                            log('inside on press');

                            Dio dio = Dio();
                            dio.options.baseUrl = kBaseUrl_chrome;

                            Response response = Response();
                            response = await dio.post("/subscribepublic",
                                data: jsonEncode({
                                  "email": subscribeEmailTextFieldController
                                      .value
//                "rememberMe": rememberMeBooleanField.value
                                }));
                            log(response.toString());

                            // ends here onPress
                          }),
                      SizedBox(
                        width: 20,
                      ),
                    ],
                  ),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'slide the below image up or down to know more',
                        style: TextStyle(fontSize: 13, color: Colors.white),
                      ),
                      Icon(
                        Icons.unfold_more,
                        color: Colors.white,
                      ),
                    ],
                  ),
                  Material(
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                    elevation: 100,
                    child: GFCarousel(
//                pagination: true,
                      scrollDirection: Axis.vertical,
                      items: imageList.map(
                        (url) {
                          return Container(
                            height: 1000,
                            margin: EdgeInsets.all(8.0),
                            child: ClipRRect(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5.0)),
                              child: Image.asset(
                                url,
                                fit: BoxFit.cover,
                                width: 500.0,
                              ),
                            ),
                          );
                        },
                      ).toList(),
                    ),
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
                      FlatButton(
                        child: Text(
                          'click here to\ngive feedback',
                          style: TextStyle(color: Colors.white70),
                          textAlign: TextAlign.center,
                        ),
                        onPressed: () {
                          // TODO go to feedback page
                          Get.to(FeedbackPage());
                        },
                      ),
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

  String validateEmailAndEmptyCheck(String value) {
    if (value.isEmpty) {
      return 'Please enter some text';
    } else {
      RegExp regex = RegExp(
          r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");
      if (regex.hasMatch(value)) {
        // regex matched
        // null if matched
        return value;
      } else {
        return 'email incorrect';
      }
    }
  }
}
