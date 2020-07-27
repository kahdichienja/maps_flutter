import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../Provider/MapProvider.dart';
import 'package:provider/provider.dart';

import 'package:flutter/widgets.dart';

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
  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;

  Position _currentPosition;
  String _currentAddress = '';

  @override
  Widget build(BuildContext context) {
    final mapState = Provider.of<MapState>(context);
    return new Scaffold(
      body: Stack(
              children: <Widget>[
                // GoogleMap(
                //   mapType: MapType.normal,
                //   initialCameraPosition: mapState.kGooglePlex,
                //   onMapCreated: (GoogleMapController controller) {
                //     mapState.controller.complete(controller);
                //   },
                // ),
                GoogleMap(
                  initialCameraPosition: CameraPosition(
                      target: LatLng(-4.0624, 39.6599), zoom: 10.0),
                  onMapCreated: mapState.onCreated,
                  myLocationEnabled: true,
                  mapType: MapType.normal,
                  compassEnabled: true,
                  markers: mapState.markers,
                  onCameraMove: mapState.onCameraMove,
                  polylines: mapState.polyLines,
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
                          margin: EdgeInsets.only(left: 20, top: 0),
                          // width: 10,
                          // height: 10,
                          child: Icon(
                            Icons.place,
                            color: Colors.blueAccent,
                          ),
                        ),
                        hintText: 'My Location',
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
                            Icons.business,
                            color: Colors.blueAccent,
                          ),
                        ),
                        hintText: "Search Near Shop...",
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.only(left: 15.0, top: 16.0),
                      ),
                    ),
                  ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        child: IconButton(
          icon: Icon(Icons.place),
          onPressed: () => _getCurrentLocation,
        ),
      ),
    );
  }

  @override
  initState() {
    setState(() {
      super.initState();

      _getCurrentLocation();
      this._currentAddress = _currentAddress;
    });
  }

  _getCurrentLocation() {
    geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
      });
      print('worlllllllllll');

      _getAddressFromLatLng();
    }).catchError((e) {
      print(e);
    });
  }

  _getAddressFromLatLng() async {
    try {
      List<Placemark> p = await geolocator.placemarkFromCoordinates(
          _currentPosition.latitude, _currentPosition.longitude);

      Placemark place = p[0];

      setState(() {
        _currentAddress =
            "${place.locality}, ${place.postalCode}, ${place.country}";
      });

      print(1231212312442144234);
    } catch (e) {
      print(e);
    }
  }
}
