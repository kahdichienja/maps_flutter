import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import '../Provider/MapRequests.dart';
import 'package:provider/provider.dart';
import 'app_state.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
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
    final appState = Provider.of<AppState>(context);
    return appState.initialPosition == null
        ? Container(
            alignment: Alignment.center,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : Stack(
            children: <Widget>[
              GoogleMap(
                initialCameraPosition: CameraPosition(
                    target: appState.initialPosition, zoom: 10.0),
                onMapCreated: appState.onCreated,
                myLocationEnabled: true,
                mapType: MapType.normal,
                compassEnabled: true,
                markers: appState.markers,
                onCameraMove: appState.onCameraMove,
                polylines: appState.polyLines,
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
                    controller: appState.locationController,
                    decoration: InputDecoration(
                      icon: Container(
                        margin: EdgeInsets.only(left: 20, top: 5),
                        width: 10,
                        height: 10,
                        child: Icon(
                          Icons.my_location,
                          color: Colors.blueAccent,
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
                    controller: appState.destinationController,
                    textInputAction: TextInputAction.go,
                    onSubmitted: (value) {
                      appState.sendRequest(value);
                    },
                    decoration: InputDecoration(
                      icon: Container(
                        margin: EdgeInsets.only(left: 20, top: 5),
                        width: 10,
                        height: 10,
                        child: Icon(
                          Icons.shopping_cart,
                          color: Colors.blueAccent,
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
                      Prediction p = await PlacesAutocomplete.show(
                          context: context,
                          apiKey: apiKey,
                          language: "en",
                          components: [Component(Component.country, "KE")]);
                      if (p != null) {
                        // Todo: Implement places to Coordinate.
                        // appState.sendRequest();
                      }
                    },
                    cursorColor: Colors.blueAccent,
                    // controller: appState.destinationController,
                    // textInputAction: TextInputAction.go,
                    // onSubmitted: (value) {
                    //   appState.sendRequest(value);
                    // },
                    decoration: InputDecoration(
                      icon: Container(
                        margin: EdgeInsets.only(left: 20, top: 5),
                        width: 10,
                        height: 10,
                        child: Icon(
                          Icons.location_searching,
                          color: Colors.blueAccent,
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
            ],
          );
  }
}
