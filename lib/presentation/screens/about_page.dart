import 'package:flutter/material.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';

class AboutPage extends StatelessWidget {
  static String route = "/aboutpage";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('about', style: TextStyle(color: Colors.white70),),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(LineAwesomeIcons.smile_o, size: 60),
            SizedBox(height: 10),
            Text(
              'everything you need to know',
              style: TextStyle(fontSize: 50, color: Colors.black),
              textAlign: TextAlign.center,
            ),
            Text(
              'we don\'t store your data',
              style: TextStyle(fontSize: 25, color: Colors.black),
              textAlign: TextAlign.center,
            ),
            Text(
              'only your last location point goes to',
              style: TextStyle(fontSize: 25, color: Colors.black),
              textAlign: TextAlign.center,
            ),
            Text(
              'the server, for marker and interactions, it gets deleted as soon as you disconnect the map,',
              style: TextStyle(fontSize: 25, color: Colors.black),
              textAlign: TextAlign.center,
            ),
            Text(
              'we don\'t sell your data unlike other companies, our sincere effort is to reduce the effect '
                  'of COVID-19 on the economy',
              style: TextStyle(fontSize: 25, color: Colors.black),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
