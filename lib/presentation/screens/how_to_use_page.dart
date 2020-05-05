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
      backgroundColor: Colors.blue[100],
      appBar: AppBar(
        title: Text('how to use', style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.blue,
      ),
      body: Scrollbar(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                GFCard(title: GFListTile(titleText: 'update map button'),
                  content: Text('Clicking \'update map\' button will update the map with your latest'
                      ' location. Your location will be removed instantly and won\'t be stored in'
                      ' server.'),
                image: Image(image: AssetImage("assets/images/how_to_use/ho_to_use_update_map_button.png")),),
                SizedBox(height: 10),
                GFCard(title: GFListTile(titleText: 'live map connection toggle button'),
                  content: Text('When the toggle button is switched on for live map connection, only '
                      'your last location will be communicated with the server and removed as soon '
                      'as the toggle is switched off. This feature should always be kept switched on '
                      'so we can save your interactions, which will be used to notify you about '
                      'any possible pathogen interaction. It will use GPS signal not bluetooth so '
                      'your mobile battery don\' drain.'),
                  image: Image(image: AssetImage("assets/images/how_to_use/ho_to_use_live_map_connection.png")),),
                SizedBox(height: 10),
                GFCard(title: GFListTile(titleText: 'clear button'),
                  content: Text('Once you updated your location by clicking update map button, your'
                      'latest location will updated and it will stay on the map unless the button '
                      'clear is clicked.'),
                  image: Image(image: AssetImage("assets/images/how_to_use/ho_to_use_clear_button.png")),),
                SizedBox(height: 10),
                GFCard(title: GFListTile(titleText: 'stats button'),
                  content: Text('clicking on stats button will update and display the latest total '
                      'number of healthy, infected and people with symptoms from the app, which is just '
                      'an approximation.'),
                  image: Image(image: AssetImage("assets/images/how_to_use/ho_to_use_stats.png")),),
                SizedBox(height: 10),
                GFCard(title: GFListTile(titleText: 'health toggle switch'),
                  content: Text('Selecting any health status will change the color of your marker on the map. '
                      'Also you will be asked to choose if you want to notify other users if you selected '
                      '\'symptoms\' or \'infected\'. If you chose to notify others whom you interacted with'
                      'within last 14 days, those users will receive a push notification about the '
                      'interaction.'),
                  image: Image(image: AssetImage("assets/images/how_to_use/ho_to_use_toggle_well_symptoms_infected.png")),),
                SizedBox(height: 10),
                GFCard(title: GFListTile(titleText: 'current status from the app'),
                  content: Text('On the top left corner of the screen, some stats are shown'
                      'from the application'),
                  image: Image(image: AssetImage("assets/images/how_to_use/ho_to_use_status_on_screen.png")),),
                SizedBox(height: 10),
                GFCard(title: GFListTile(titleText: 'share status button'),
                  content: Text('The currest status from the app can be shared with other users through '
                      'different channels.'),
                  image: Image(image: AssetImage("assets/images/how_to_use/ho_to_use_share_status.png")),),
                SizedBox(height: 10),
                GFCard(title: GFListTile(titleText: 'zoom in and zoom out button'),
                  content: Text('To zoom in and out of the the map, press relative button.'),
                  image: Image(image: AssetImage("assets/images/how_to_use/ho_to_use_zoom_buttons.png")),),
                SizedBox(height: 10),
//            GFCarousel(items: imageList.map(
//                  (url) {
//                return Container(
//                  height: 80,
//                  margin: EdgeInsets.all(8.0),
//                  child: ClipRRect(
//                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
//                    child: Image.asset(
//                        url,
//                        fit: BoxFit.cover,
//                        width: 1000.0,
//                    ),
//                  ),
//                );
//              },
//            ).toList(),),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
