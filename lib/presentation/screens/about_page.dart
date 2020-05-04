import 'package:flutter/material.dart';
import 'package:getflutter/components/card/gf_card.dart';
import 'package:getflutter/components/list_tile/gf_list_tile.dart';
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
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 10),
            GFCard(title: GFListTile(titleText: 'everything you need to know'),
            content: Text('we don\'t store your data only your last location point goes to'
                'the server, for marker and interactions, it gets deleted as soon as you disconnect'
                ' the map, we don\'t sell your data unlike other companies, our sincere effort is to reduce'
                '  the effect of COVID-19 on the economy'),),

          ],
        ),
      ),
    );
  }
}
