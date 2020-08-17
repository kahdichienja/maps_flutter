import 'package:flutter/material.dart';
import '../Provider/MapProvider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../screens/SearchShop.dart';


class MapView extends StatefulWidget {
  @override
  _MapViewState createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  Widget _textField({
    TextEditingController controller,
    String label,
    String hint,
    String initialValue,
    double width,
    Icon prefixIcon,
    Widget suffixIcon,
    Function(String) locationCallback,
  }) {
    return Container(
      width: width * 0.8,
      child: TextField(
        onChanged: (value) {
          locationCallback(value);
        },
        controller: controller,
        // initialValue: initialValue,
        decoration: new InputDecoration(
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          labelText: label,
          filled: true,
          fillColor: Colors.white,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
            borderSide: BorderSide(
              color: Colors.grey[400],
              width: 2,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
            borderSide: BorderSide(
              color: Colors.blue[300],
              width: 2,
            ),
          ),
          contentPadding: EdgeInsets.all(15),
          hintText: hint,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mapState = Provider.of<MapState>(context);
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Container(
      height: height,
      width: width,
      child: Scaffold(
        key: mapState.scaffoldKey,
        body: Stack(
          children: <Widget>[
            // Map View
            GoogleMap(
              markers: mapState.markers != null
                  ? Set<Marker>.from(mapState.markers)
                  : null,
              initialCameraPosition: mapState.initialLocation,
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              mapType: mapState.currentMapType,
              zoomGesturesEnabled: true,
              zoomControlsEnabled: false,
              polylines: Set<Polyline>.of(mapState.polylines.values),
              onMapCreated: (GoogleMapController controller) {
                mapState.mapController = controller;
              },
            ),
            // Show zoom buttons
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ClipOval(
                      child: Material(
                        color: Colors.blue[100], // button color
                        child: InkWell(
                          splashColor: Colors.blue, // inkwell color
                          child: SizedBox(
                            width: 50,
                            height: 50,
                            child: Icon(Icons.add),
                          ),
                          onTap: () {
                            mapState.mapController.animateCamera(
                              CameraUpdate.zoomIn(),
                            );
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    ClipOval(
                      child: Material(
                        color: Colors.blue[100], // button color
                        child: InkWell(
                          splashColor: Colors.blue, // inkwell color
                          child: SizedBox(
                            width: 50,
                            height: 50,
                            child: Icon(Icons.remove),
                          ),
                          onTap: () {
                            mapState.mapController.animateCamera(
                              CameraUpdate.zoomOut(),
                            );
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    ClipOval(
                      child: Material(
                        color: Colors.blue[100], // button color
                        child: InkWell(
                          splashColor: Colors.blue, // inkwell color
                          child: SizedBox(
                            width: 50,
                            height: 50,
                            child: Icon(Icons.location_searching),
                          ),
                          onTap: () async {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SearchShops()));
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Show the place input fields & button for
            // showing the route
            SafeArea(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white70,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(25),
                      bottomRight: Radius.circular(25)),
                ),
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        'Places',
                        style: TextStyle(fontSize: 20.0),
                      ),
                      SizedBox(height: 10),
                      _textField(
                          label: 'Start',
                          hint: 'Choose starting point',
                          initialValue: mapState.currentAddress,
                          prefixIcon: Icon(Icons.looks_one),
                          suffixIcon: IconButton(
                            icon: Icon(Icons.my_location),
                            onPressed: () {
                              mapState.startAddressController.text =
                                  mapState.currentAddress;
                              mapState.startAddress = mapState.currentAddress;
                            },
                          ),
                          controller: mapState.startAddressController,
                          width: width,
                          locationCallback: (String value) {
                            setState(() {
                              mapState.startAddress = value;
                            });
                          }),
                      SizedBox(height: 10),
                      _textField(
                          label: 'Destination',
                          hint: 'Choose destination',
                          initialValue: '',
                          prefixIcon: Icon(Icons.looks_two),
                          controller: mapState.destinationAddressController,
                          width: width,
                          locationCallback: (String value) {
                            setState(() {
                              mapState.destinationAddress = value;
                            });
                          }),
                      SizedBox(height: 10),
                      Visibility(
                        visible: mapState.placeDistance == null ? false : true,
                        child: Text(
                          'DISTANCE:~ ${mapState.placeDistance} km',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: 5),
                      RaisedButton(
                        onPressed: (mapState.startAddress != '' &&
                                mapState.destinationAddress != '')
                            ? () async {
                                setState(() {
                                  if (mapState.markers.isNotEmpty)
                                    mapState.markers.clear();
                                  if (mapState.polylines.isNotEmpty)
                                    mapState.polylines.clear();
                                  if (mapState.polylineCoordinates.isNotEmpty)
                                    mapState.polylineCoordinates.clear();
                                  mapState.placeDistance = null;
                                });

                                mapState
                                    .calculateDistance()
                                    .then((isCalculated) {
                                  if (isCalculated) {
                                    mapState.scaffoldKey.currentState
                                        .showSnackBar(
                                      SnackBar(
                                        content: Text(
                                            'Distance Calculated Sucessfully'),
                                      ),
                                    );
                                  } else {
                                    mapState.scaffoldKey.currentState
                                        .showSnackBar(
                                      SnackBar(
                                        content:
                                            Text('Error Calculating Distance'),
                                      ),
                                    );
                                  }
                                });
                              }
                            : null,
                        color: Colors.blueAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Text(
                            'Show Route'.toUpperCase(),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.0,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Show current location button
            SafeArea(
              child: Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 10.0, bottom: 10.0),
                  child: ClipOval(
                    child: Material(
                      color: Colors.orange[100], // button color
                      child: InkWell(
                        splashColor: Colors.orange, // inkwell color
                        child: SizedBox(
                          width: 56,
                          height: 56,
                          child: Icon(Icons.my_location),
                        ),
                        onTap: () {
                          mapState.mapController.animateCamera(
                            CameraUpdate.newCameraPosition(
                              CameraPosition(
                                target: LatLng(
                                  mapState.currentPosition.latitude,
                                  mapState.currentPosition.longitude,
                                ),
                                zoom: 18.0,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),

            Positioned(
              bottom: 0.0,
              right: 0.0,
              left: 0.0,
              child: Container(
                height: 50.0,
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
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => SearchShops()));
                  },
                  cursorColor: Colors.blueAccent,
                  decoration: InputDecoration(
                    icon: Container(
                      margin: EdgeInsets.only(left: 20, top: 5),
                      width: 10,
                      height: 10,
                      child: Icon(
                        Icons.search,
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
        ),
      ),
    );
  }
}
