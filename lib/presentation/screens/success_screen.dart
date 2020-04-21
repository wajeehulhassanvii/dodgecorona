import 'package:flutter/material.dart';
import 'package:getflutter/components/button/gf_button.dart';
import 'package:getflutter/size/gf_size.dart';
import 'package:getflutter/types/gf_button_type.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';

class SuccessScreen extends StatelessWidget {
  static String route = "/landingpage";

  final Widget nextPage;
  final String nextPageButtonText;
  final String successMessage;
  SuccessScreen({Key key, this.successMessage, this.nextPageButtonText, this.nextPage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.tag_faces, size: 100),
            SizedBox(height: 10),
            Text(
              successMessage,
              style: TextStyle(fontSize: 54, color: Colors.black),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
            GFButton(
              text: "back to\nlogin",
              icon: Icon(Icons.arrow_back),
              type: GFButtonType.outline2x,
              color: Colors.black,
              size: GFSize.SMALL,
              onPressed: () async {Navigator.push(
                  context, MaterialPageRoute(builder: (_) => nextPage));
              },
            ),
          ],
        ),
      ),
    );
  }
} // success screen class ends here
