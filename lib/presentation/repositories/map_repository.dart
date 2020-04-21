
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:trackcorona/bloc/core/shape_painter.dart';
import 'package:trackcorona/presentation/models/my_marker_element/my_marker_element.dart';

void showSnackBar(String snackbarHeaderMSG, String snackbarBodyMSG) {

  Get.snackbar(snackbarHeaderMSG,
      snackbarBodyMSG,
      backgroundColor: Colors.grey[850],
      snackPosition: SnackPosition.BOTTOM,
      colorText: Colors.white70,
      isDismissible: true);
} // showSnackBar, better be placed in a utility class


Future<List<Marker>> getMarkerListFromMyMarkerElementList(
    List<MyMarkerElements> listOfMyMarkerElements) async {

  List<Marker> markerList;

  print('inside getMarkerListFromMyMarkerElementList method');
  for (MyMarkerElements markerElement in listOfMyMarkerElements){
    print('adding a new one to the list');
    markerList.add(
        Marker(
          anchorPos: AnchorPos.align(AnchorAlign.center),
          height: 30,
          width: 30,
          point: markerElement.getLatLng(),
          builder: (ctx) => Stack(
            children: [
              CustomPaint(
                painter: ShapesPainter(markerElement.getPersonCondition()),
                child: Icon(Icons.pin_drop, color: Colors.white,),
              ),
            ],
          ),
        ));
    print('added');
  } // For loop ends for adding creating fakeMarkerList for fakePersonList

  return markerList;
}// method ends here
