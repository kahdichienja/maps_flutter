import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:locapp/utils/dot_type.dart';
import '../utils/ColorLoaders.dart';
import 'package:locapp/utils/core.dart';
import 'package:provider/provider.dart';
import '../Provider/MapProvider.dart';
import 'SearchShop.dart';

class MapPage extends StatefulWidget {
  MapPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Map());
  }
}

class Map extends StatefulWidget {
  @override
  _MapState createState() => _MapState();
}

class _MapState extends State<Map> {

  

  @override
  Widget build(BuildContext context) {
    final mapState = Provider.of<MapState>(context);
    return mapState.initialPosition == null
        ? Container(
            alignment: Alignment.center,
            child: Center(
              child: ColorLoader4(
                dotOneColor: Colors.pink,
                dotType: DotType.circle,
              ),
            ),
          )
        : Stack(
            children: <Widget>[
              GoogleMap(
                initialCameraPosition: CameraPosition(
                  tilt: 59.440717697143555,
                  bearing: 192.8334901395799,
                  target: mapState.initialPosition,
                  zoom: 16.23423412432543,
                ),
                onMapCreated: mapState.onCreated,
                myLocationEnabled: true,
                mapType: mapState.currentMapType,
                compassEnabled: true,
                markers: mapState.markers,
                onCameraMove: mapState.onCameraMove,
                polylines: mapState.polyLines,
              ),
              Positioned(
                top: 10.0,
                right: 15.0,
                left: 15.0,
                child: Container(
                  height: 29.0,
                  width: double.infinity,
                  child: Center(
                    child: Text(
                      'Distance: ~ ${((mapState.distanceInMeters)/1000).ceil()} Km', 
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.redAccent
                      ),
                    )
                  ),
                ),
              ),

              Positioned(
                top: 50.0,
                right: 15.0,
                left: 15.0,
                child: Container(
                  height: 50.0,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3.0),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey,
                          offset: Offset(1.0, 5.0),
                          blurRadius: 10,
                          spreadRadius: 3)
                    ],
                  ),
                  child: TextField(
                    cursorColor: Colors.black,
                    controller: mapState.locationController,
                    decoration: InputDecoration(
                      icon: Container(
                        margin: EdgeInsets.only(left: 20, top: 5),
                        width: 10,
                        height: 10,
                        child: Icon(
                          Icons.my_location,
                          color: blueaccent,
                        ),
                      ),
                      hintText: "pick up",
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.only(left: 15.0, top: 16.0),
                    ),
                  ),
                ),
              ),

              Positioned(
                top: 105.0,
                right: 15.0,
                left: 15.0,
                child: Container(
                  height: 50.0,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3.0),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey,
                          offset: Offset(1.0, 5.0),
                          blurRadius: 10,
                          spreadRadius: 3)
                    ],
                  ),
                  child: TextField(
                    cursorColor: Colors.black,
                    controller: mapState.destinationController,
                    textInputAction: TextInputAction.go,
                    onSubmitted: (value) {
                      mapState.sendRequest(value);
                    },
                    decoration: InputDecoration(
                      icon: Container(
                        margin: EdgeInsets.only(left: 20, top: 5),
                        width: 10,
                        height: 10,
                        child: Icon(
                          Icons.shopping_cart,
                          color: blueaccent,
                        ),
                      ),
                      hintText: "Enter Near SHop Delivery To Show Route?",
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.only(left: 15.0, top: 16.0),
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 0.0,
                right: 0.0,
                left: 0.0,
                child: Container(
                  height: 70.0,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15)),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey,
                          offset: Offset(1.0, 5.0),
                          blurRadius: 10,
                          spreadRadius: 5)
                    ],
                  ),
                  child: TextField(
                    onTap: () async {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SearchShops()));
                    },
                    cursorColor: blueaccent,
                    decoration: InputDecoration(
                      icon: Container(
                        margin: EdgeInsets.only(left: 20, top: 5),
                        width: 10,
                        height: 10,
                        child: Icon(
                          Icons.location_searching,
                          color: blueaccent,
                        ),
                      ),
                      hintText: "Search Neer Deliveries ..?",
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.only(left: 15.0, top: 16.0),
                    ),
                  ),
                ),
              ),

              //  Positioned(
              //    top: 40,
              //    right: 10,
              //    child: FloatingActionButton(onPressed: _onAddMarkerPressed,
              //    tooltip: "aadd marker",
              //    backgroundColor: black,
              //    child: Icon(Icons.add_location, color: white,),
              //    ),
              //  )
              Positioned(
                  bottom: 80.0,
                  right: 5.0,
                  // left: 0.0,
                  child: FloatingActionButton(
                    backgroundColor: Colors.redAccent,
                    onPressed: () => mapState.onMapTypeButtonPressed(),
                    child: Icon(Icons.map, color: Colors.white),
                  )),
            ],
          );
  }
}
