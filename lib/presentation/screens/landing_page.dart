import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:trackcorona/presentation/screens/login_page.dart';
import 'package:trackcorona/presentation/widgets/platform_dependent_text.dart';
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

  final GlobalKey<FormState> _subscribeKey = GlobalKey<FormState>();

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
              SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(50, 10, 50, 10),
                      child: Text(
                        'Dodge Corona',
                        style: TextStyle(
                            fontSize: 80,
                            color: Colors.white,
                            fontFamily: 'Alegreya'
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Container(
                      width: 800,
                      color: Colors.black38.withOpacity(0.3),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(50, 10, 50, 10),
                        child: Text(
                          'We took the challenge to bring the economy back to its foot'
                          ', after the world got affected by variants of COVID-19 '
                          'keeping in mind your privacy, see how we can achieve it together',
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontFamily: 'Alegreya'
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    Container(
                      color: Colors.black38.withOpacity(0.3),
                      width: 800,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          PlatformDependantText(
                            mainText: 'subscribe to\nstay updated :',
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontFamily: 'Alegreya'),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Container(
                            height: 40,
                            width: 250,
                            child: TextFormField(
                              key: _subscribeKey,
                              style: TextStyle(color: Colors.white),
                              controller: subscribeEmailTextFieldController,
                              validator: (String value) {
                                if (value.isEmpty) {
                                  return "Please enter some text";
                                }
                                if (!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value)){
                                  return "please enter correct email";
                                }
                                return null;
                              },
                              autovalidate: true,
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
                          GFButton(text: 'subscribe',
                          type: GFButtonType.outline2x,
                          color: Colors.white70,
                          onPressed: () async {

                            log('inside on press');

                            Dio dio = Dio();
                            dio.options.baseUrl = kBaseUrl000;

                            Response response = Response();
                            response = await dio.post("/subscribepublic",
                                data: jsonEncode({
                                  "email": subscribeEmailTextFieldController.text
                                }),
                                options: Options(
                                    headers: {
                                      "Access-Control-Allow-Origin": "*", // Required for CORS support to work
                                      "Access-Control-Allow-Credentials": true, // Required for cookies, authorization headers with HTTPS
                                      "Access-Control-Allow-Headers": "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token",
                                      "Access-Control-Allow-Methods": "POST, OPTIONS"
                                    }));
                            log(response.toString());

                            // ends here onPress

                          },),
                          SizedBox(
                            width: 20,
                          ),
                        ],
                      ),
                    ),
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[],
                      ),
                    ),
                    Container(
                      color: Colors.black38.withOpacity(0.3),
                      width: 800,
                      child: Row(
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
                    ),
                    SizedBox(height: 10,),
                    Container(
                      width: 800,
                      child: Material(
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                        elevation: 100,
                        shadowColor: Colors.white,
                        type: MaterialType.card,
                        child: GFCarousel(
//                pagination: true,
                          scrollDirection: Axis.vertical,
                          items: imageList.map(
                            (url) {
                              return ClipRRect(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5.0)),
                                child: Image.asset(
                                  url,
                                  fit: BoxFit.cover,
                                  width: 500.0,
                                ),
                              );
                            },
                          ).toList(),
                        ),
                      ),
                    ),
                    SizedBox(height: 10,),
                    Container(
                      width: 800,
                      color: Colors.black38.withOpacity(0.3),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.fromLTRB(50, 10, 50, 5),
                            child: PlatformDependantText(
                              mainText: 'ios and android app under testing, will soon be released',
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontFamily: 'Alegreya'),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          FlatButton(
                            child: PlatformDependantText(
                              mainText: 'feedback?',
                              style: TextStyle(color: Colors.white70,
                              fontSize: 12),
                              textAlign: TextAlign.center,
                            ),
                            onPressed: () {
                              // TODO go to feedback page
                              Get.to(FeedbackPage());
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10,),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                      Container(
                        width: 800,
                        color: Colors.black38.withOpacity(0.3),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: Text('MORE DETAILED INFORMATION BELOW',
                            textAlign: TextAlign.start,
                            style: TextStyle(fontSize: 50, color: Colors.white70),
                          ),
                        ),
                      ),
                      Container(
                        color: Colors.black38,
                        width: 800,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20, top: 15),
                          child: Text('This application has been designed for data sensitive people.\n'
                              'Its perfect for people who don\'t want to share their data with with'
                              'different organizations and private companies who sell their data for'
                              ' generating revenue.\n'
                              'This software has been built by an indie developer.\n'
                              'Our mode of revenue generation is ads or donation, to keep the server running.'
                              '\nThis application has not been designed for in house use.'
                              ' \nThe accuracy of this application is dependant on the accuracy of GPS,'
                              ' but it is still good enough to tackle the issue.\nThis application requires'
                              ' push notification to be enabled in order to get the notification from the'
                              ' other person who marked themselves infected of with symptoms.\n'
                              'The information will not be shared with any organization at any cost.\n'
                              'For any future changes please keep visiting this website.\n',
                            textAlign: TextAlign.start,
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                        ),
                      ),

                        SizedBox(height: 10,),
                    ],),

                    Container(
                      color: Colors.black38,
                      width: 800,
                      child: Padding(
                        padding: const EdgeInsets.only(),
                        child: Text('HOW DOES IT WORK?',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 50, color: Colors.white70),
                        ),
                      ),
                    ),
                    Container(
                      color: Colors.black38.withOpacity(0.3),
                      width: 800,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 10, 30, 10),
                        child: PlatformDependantText(mainText: 'Step 1:\n'
                            'Download the app and ask friends and family to download it as well.\n'
                            '\nStep 2:\n'
                            'Turn on GPS, which is usually on.\n'
                            '\nStep 3:\n'
                            'Turn on map from the application, and keep it turned on.'
                            '\n\nStep 4:\n'
                            'You\'ll get notified from us if you came in contact with any person with'
                            'symptoms of COVID-19 infection.'
                            '\n\nStep 5:\n'
                            'You can also notify others if by selecting symptoms or infected option if'
                            'you came in contact with a potential pathogen.'
                            '\n\nStep 6:\n'
                            'You can status from the app to different social media or friends and family'
                            'as well to make them aware of COVID-19..',
                          textAlign: TextAlign.start,
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                      Text('Thank you',
                        style: TextStyle(fontSize: 15, color: Colors.white70),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(width: 30,),
                      FlatButton(
                        child: Text(
                          'login page',
                          style: TextStyle(color: Colors.white70),
                          textAlign: TextAlign.center,
                        ),
                        onPressed: () {
                          // TODO go to feedback page
                          Get.to(LoginPage());
                        },
                      ),
                    ],),
                  ],
                ),
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
