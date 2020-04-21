import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:map_controller/map_controller.dart';
import 'package:trackcorona/utilities/constants.dart';

// ignore: must_be_immutable
class MapPageStateFlutterMap extends StatelessWidget {
  MapPageStateFlutterMap({
    Key key,
    @required this.mapController,
    @required this.centrePoints,
    @required this.defaultMapZoom,
    @required this.markers,
  }) : super(key: key);

  final MapController mapController;
  List centrePoints;
  final double defaultMapZoom;
  List<Marker> markers;

  @override
  Widget build(BuildContext context) {
    print('inside widget build');
    print('length ${markers.length}');

    return FlutterMap(
      mapController: mapController,
      options: MapOptions(
        center: centrePoints[0],
        zoom: defaultMapZoom,
        interactive: false,
        minZoom: 15,
        maxZoom: 19,
        plugins: [
          MarkerClusterPlugin(),
        ],
      ),
      layers: [
//        TileLayerOptions(
//          urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
//          subdomains: ['a', 'b', 'c'],
//        ),
//                      TileLayerOptions(
//                        tileProvider: AssetTileProvider(),
//                        urlTemplate: "assets/offlineMap/{z}/{x}/{y}.png",
//                      ),
//                      TileLayerOptions(
//                        urlTemplate: "https://api.tiles.mapbox.com/v4/"
//                            "{id}/{z}/{x}/{y}@2x.png?access_token={accessToken}",
//                        additionalOptions: {
//                          'accessToken': kMapboxStaticImageApiAccessToken,
//                          'id': 'mapbox.streets',
//                        },
//                      ),
        TileLayerOptions(
          urlTemplate: "https://api.tiles.mapbox.com/v4/"
              "{id}/{z}/{x}/{y}@2x.png?access_token={accessToken}",
          additionalOptions: {
            'accessToken': kMapboxStaticImageApiAccessToken,
            'id': 'mapbox.dark',
          },
        ),
//        MarkerClusterLayerOptions(
//          maxClusterRadius: 0,
//          size: Size(20, 20),
//          anchor: AnchorPos.align(AnchorAlign.center),
//          fitBoundsOptions: FitBoundsOptions(
//            padding: EdgeInsets.all(1),
//          ),
//          markers: markers,
//          polygonOptions: PolygonOptions(
//              borderColor: Colors.blueAccent,
//              color: Colors.black12,
//              borderStrokeWidth: 3),
//          builder: (context, markers) {
//            return FloatingActionButton(
//              heroTag: 'heroLoginPageSubmit',
//              child: Text(markers.length.toString()),
//              onPressed: null,
//            );
//          },
//        ),
        MarkerLayerOptions(
          markers: markers
        ),
      ],
    );
  }



  /// Updates visible markers on map.
  ///
  /// Adds new well markers or updates position of existing well on map.
  /// Deletes well marker if well was deleted.
//  void updateMarkers(StatefulMapController markerController ,
//      Map<String, Marker> markerMap) async {
//
//    if(markerController.markers.length < markerMap.length) {
//      markerController.addMarkers(markers: markerMap);
//    }
//    else if(markerController.markers.length > markerMap.length) {
//      List<String> removeMarkerList = List<String>();
//
//      if(userLocated) {
//        markerMap[locationMarkerName] = markerController.namedMarkers[locationMarkerName];
//      }
//
//      markerController.namedMarkers.forEach((name , _) {
//        if(!markerMap.containsKey(name)) {
//          removeMarkerList.add(name);
//        }
//      });
//
//      markerController.removeMarkers(names: removeMarkerList);
//    }
//    else {
//      markerController.addMarkers(markers: markerMap);
//    }
//  }

//  MapPageStateFlutterMap setCenterPointMarkerAndAnimatable(
//      List newCentrePoints,
//      List<Marker> newMarkers, bool isAnimatable){
//    this.centrePoints = newCentrePoints;
//    this.markers = newMarkers;
//    print(this.runtimeType);
//    return this;
//  }

}


//ignore: must_be_immutable
