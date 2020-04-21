import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:getflutter/getflutter.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';

class HowToUsePage extends StatelessWidget {
  static String route = "/howtousepage";
  @override
  Widget build(BuildContext context) {
    final List<String> imageList = [
      'assets/images/how_to_use_app_stats.png',
      'assets/images/how_to_use_health_toggle.png',
      'assets/images/how_to_use_live_map.jpg',
      'assets/images/how_to_use_share_status.png',
      'assets/images/how_to_use_update_map.png'
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('how to use', style: TextStyle(color: Colors.white70),),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
//                  Text(
//                    'swipe for tips',
//                    style: TextStyle(fontSize: 20, color: Colors.black),
//                    textAlign: TextAlign.center,
//                  ),
//                  Icon(LineAwesomeIcons.smile_o, size: 30),

                ],
              ),
            ),
            GFCarousel(items: imageList.map(
                  (url) {
                return Container(
                  height: 100,
                  margin: EdgeInsets.all(8.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    child: Image.asset(
                        url,
                        fit: BoxFit.cover,
                        width: 1000.0,
                    ),
                  ),
                );
              },
            ).toList(),),
          ],
        ),
      ),
    );
  }
}
