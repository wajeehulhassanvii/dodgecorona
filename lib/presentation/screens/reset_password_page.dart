import 'package:flutter/material.dart';
import 'package:getflutter/components/button/gf_button.dart';
import 'package:getflutter/size/gf_size.dart';
import 'package:getflutter/types/gf_button_type.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:trackcorona/services/injector/injector.dart';
import 'package:trackcorona/services/shared_preference_manager.dart';

class ResetPasswordPage extends StatefulWidget {
  static String route = "/resetpassswordpage";
  @override
  _ResetPasswordPageState createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  @override
  Widget build(BuildContext context) {
    SharedPreferencesManager sharedPreferenceManager =
    getIt<SharedPreferencesManager>();

    return Scaffold(
      appBar: AppBar(
        title: Text('account settings'),
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(LineAwesomeIcons.user, size: 40),
            SizedBox(height: 10),
            Text(
              'forgotten password?',
              style: TextStyle(fontSize: 25, color: Colors.black),
              textAlign: TextAlign.center,
            ),
            Text(
              'enter your email below',
              style: TextStyle(fontSize: 25, color: Colors.black),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 5,),
            Text(
              'then follow the procedure...',
              style: TextStyle(fontSize: 15, color: Colors.black),
              textAlign: TextAlign.center,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(70, 10, 70, 10),
              child: TextField(),
            ),
            SizedBox(height: 10),

            GFButton(
              text: "reset\npassword",
              icon: Icon(LineAwesomeIcons.refresh),
              type: GFButtonType.outline2x,
              color: Colors.black,

              size: GFSize.SMALL,
              onPressed: () async {
                return AlertDialog(
                  title: Text('Rewind and remember'),);
              },
            ),


          ],
        ),
      ),
    );

  }
}
