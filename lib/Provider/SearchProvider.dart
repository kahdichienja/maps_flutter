import 'dart:async';
import 'dart:convert';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter_maps/utils/Buttons.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/ApiUrls.dart';
import '../Models/NeerShops.dart';
import 'MapProvider.dart';

class SearchState with ChangeNotifier {
  List<UserShopInfo> searchResult = [];

  List<UserShopInfo> shopDetails = [];

  final String url = usersShopUrl;
  TextEditingController controller = TextEditingController();

  // Get json result and convert it to model. Then add
  Future<Null> getUserDetails() async {
    final response = await http.get(url);
    final responseJson = json.decode(response.body);
    for (Map user in responseJson) {
      shopDetails.add(UserShopInfo.fromJson(user));
    }
    notifyListeners();
  }

  @override
  SearchState() {
    getUserDetails();
  }

  onTapItem(BuildContext context, UserShopInfo info) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bcx) {
          return Container(
            height: 600.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15), topRight: Radius.circular(15)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Card(
                  child:
                      Image.network(info.profileUrl, height: 100, width: 500),
                ),
                SizedBox(
                  height: 0.10,
                ),
                InkWell(
                  // onTap: () => {},
                  // print('${info.address.geo.lat}, ${info.address.geo.lng}'),
                  child: Card(
                    elevation: 0.0,
                    child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          ListTile(
                            leading: CircleAvatar(
                                backgroundColor: Colors.blueAccent,
                                child: Text(info.name[0],
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      color: Colors.white,
                                    ))),
                            title: Text(info.company.name),
                            subtitle: Text('Street ${info.address.street}'),
                            trailing: Text('Websitelink. ${info.website}'),
                          ),
                        ]),
                  ),
                ),
                InkWell(
                  // onTap: () =>
                  //     print('${info.address.geo.lat}, ${info.address.geo.lng}'),
                  child: Card(
                    elevation: 0.0,
                    child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          ListTile(
                            leading: Icon(Icons.business),
                            title: Text(info.phone),
                            subtitle: Text('City ${info.address.city}'),
                            trailing: Text('Zipcode. ${info.address.zipcode}'),
                            // onTap: () => print(
                            //     '${info.address.geo.lat}, ${info.address.geo.lng}'),
                          )
                        ]),
                  ),
                ),
                Card(
                  elevation: 0.0,
                  child:
                      Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                    ListTile(
                      leading: Icon(Icons.location_on),
                      title: Text(info.phone),
                    )
                  ]),
                ),
                SimpleRoundIconButton(
                    icon: Icon(Icons.location_on),
                    iconColor: Colors.blueAccent,
                    buttonText: Text('Pin Location On Map.'),
                    backgroundColor: Colors.indigo[100],
                    onPressed: () => createMakerFromCoord(
                        context,
                        double.parse(info.address.geo.lat),
                        double.parse(info.address.geo.lng))
                    // print('========================${info.address.geo.lat}, ${info.address.geo.lng}')
                    ),
              ],
            ),
          );
        });
  }

  final Geolocator geolocator = Geolocator();
  String currentAddress;
  Position currentPosition;
  // Set<Marker> markers = {};
  createMakerFromCoord(BuildContext context, lat, lng) async {
    final mapState = Provider.of<MapState>(context, listen: false);
    LatLng pinPosition = LatLng(lat, lng);
    // retrieving the address
    List<Placemark> p = await geolocator.placemarkFromCoordinates(lat, lng);

    Placemark place = p[0];
    currentAddress =
        "${place.name}, ${place.locality}, ${place.postalCode}, ${place.country}";

    print(currentAddress);

    CameraPosition shopLocation =
        CameraPosition(zoom: 16, bearing: 30, target: pinPosition);

    mapState.initialLocation = shopLocation;
    // setting new address in the destination controller

    mapState.markers.add(Marker(
      infoWindow: InfoWindow(
        title: '$currentAddress',
        snippet: 'Shop Location: $currentAddress',
      ),
      markerId: MarkerId('$currentAddress'),
      position: pinPosition,
    ));
    mapState.destinationAddressController.text = currentAddress;
    // calculate distance.
    await geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.bestForNavigation)
        .then((Position position) async {
      currentPosition = position;
      // Calculating the distance between the start and the end positions
      // with a straight path, without considering any route
      double distanceInMeters = await geolocator.distanceBetween(
        position.latitude,
        position.longitude,
        lat,
        lng,
      );
      mapState.placeDistance = ((distanceInMeters) / 1000).ceil().toString();
      int dialogDistance = ((distanceInMeters) / 1000).ceil();

      AwesomeDialog(
        context: context,
        animType: AnimType.SCALE,
        dialogType: DialogType.SUCCES,
        body: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
          Card(
            elevation: 1.0,
            child: ListTile(
              leading: Icon(
                Icons.location_on,
                color: Colors.greenAccent,
              ),
              title: Text('Distance: ~ $dialogDistance Km'),
            ),
          ),
          Container(
            child: Center(
              child: Text('Deliveries In This Area',
                style: TextStyle(fontSize: 20, letterSpacing: 2.5),
              )
            )
          ),
          Card(
            elevation: 1.0,
            child: ListTile(
              leading: Icon(
                Icons.view_compact,
                color: Colors.blueAccent,
              ),
              title: Text('Wells Fugo\n'),
              subtitle: Text('Delivery Price: 12/= Per Km'),
              trailing:
                  Text('Total:' + (dialogDistance * 12).toString() + '/='),
            ),
          ),
          Card(
            elevation: 1.0,
            child: ListTile(
              leading: Icon(
                Icons.business,
                color: Colors.blue,
              ),
              title: Text('Curris Ent.\n'),
              subtitle: Text('Delivery Price: 7/= Per Km'),
              trailing: Text('Total:' + (dialogDistance * 7).toString() + '/='),
            ),
          ),
          Card(
            elevation: 1.0,
            child: ListTile(
              leading: Icon(
                Icons.verified_user,
                color: Colors.lightBlue,
              ),
              title: Text('Maber Currios Inc.\n'),
              subtitle: Text('Delivery Price: 5.90/= Per Km'),
              trailing: Text(
                  'Total:' + (dialogDistance * 5.90).ceil().toString() + '/='),
            ),
          ),
        ]),
        title: 'This is Ignored',
        desc: 'This is also Ignored',
        btnOkOnPress: () {},
      )..show();
      notifyListeners();
      print(
          '========================= CURRENT POS: $currentPosition Distance: $distanceInMeters ==============================');
    });
    notifyListeners();
  }

  onTapSearchItem(BuildContext context, UserShopInfo info) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bcx) {
          return Container(
            height: 500.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15), topRight: Radius.circular(15)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Card(
                  child:
                      Image.network(info.profileUrl, height: 200, width: 500),
                ),
                SizedBox(
                  height: 5.0,
                ),
                InkWell(
                  // onTap: () =>
                  //     print('${info.address.geo.lat}, ${info.address.geo.lng}'),
                  child: Card(
                    elevation: 0.0,
                    child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          ListTile(
                            leading: CircleAvatar(
                                backgroundColor: Colors.blueAccent,
                                child: Text(info.name[0],
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      color: Colors.white,
                                    ))),
                            title: Text(info.company.name),
                            subtitle: Text('Street ${info.address.street}'),
                            trailing: Text('Websitelink. ${info.website}'),
                            // onTap: () => print(
                            //     '${info.address.geo.lat}, ${info.address.geo.lng}'),
                          ),
                          SimpleRoundIconButton(
                              icon: Icon(Icons.location_on),
                              iconColor: Colors.blueAccent,
                              buttonText: Text('Pin Location On Map.'),
                              backgroundColor: Colors.indigo[100],
                              onPressed: () => createMakerFromCoord(
                                  context,
                                  double.parse(info.address.geo.lat),
                                  double.parse(info.address.geo.lng))
                              // onPressed: () => print('========================${info.address.geo.lat}, ${info.address.geo.lng}')
                              ),
                        ]),
                  ),
                ),
              ],
            ),
          );
        });
  }

  onSearchTextChanged(String text) async {
    searchResult.clear();
    if (text.isEmpty) {
      notifyListeners();
      return;
    }

    shopDetails.forEach((userDetail) {
      if (userDetail.company.name.contains(text) ||
          userDetail.address.city.contains(text)) searchResult.add(userDetail);
    });
    notifyListeners();
  }
}
