import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';

class MapState with ChangeNotifier {
  static LatLng _initialPosition;
  LatLng _lastPosition = _initialPosition;

  Completer<GoogleMapController> controller = Completer();

  final CameraPosition kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  final CameraPosition _kLake = CameraPosition(
    bearing: 192.8334901395799,
    target: LatLng(37.43296265331129, -122.08832357078792),
    tilt: 59.440717697143555,
    zoom: 19.151926040649414
  );

  MapState() {
    goToTheLake();

    // _loadingInitialPosition();
  }
  void goToTheLake() async {

    // final GoogleMapController controller = await controller.Future;
    // controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
    // notifyListeners();
  }

}