import 'dart:math' show cos, sqrt, asin;

import 'package:flutter/material.dart';
import 'package:flutter_maps/utils/ApiUrls.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapState with ChangeNotifier {
  CameraPosition initialLocation = CameraPosition(
      target: LatLng(0.0, 0.0),
      // zoom: 16.124325,
      bearing: 192.8334901395799,
      tilt: 59.440717697143555);
  GoogleMapController mapController;

  final Geolocator geolocator = Geolocator();

  Position currentPosition;
  String currentAddress;

  final startAddressController = TextEditingController();
  final destinationAddressController = TextEditingController();

  String startAddress = '';
  String destinationAddress = '';
  String placeDistance;

  Set<Marker> markers = {};

  PolylinePoints polylinePoints;
  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];

  MapType currentMapType = MapType.normal;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  // Method for retrieving the current location
  void _getCurrentLocation() async {
    await geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.bestForNavigation).then((Position position) async {
        currentPosition = position;
        print('CURRENT POS: $currentPosition');
        mapController.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: LatLng(position.latitude, position.longitude),
              zoom: 16.124325,
              bearing: 192.8334901395799,
              tilt: 59.440717697143555
            ),
          ),
        );
      notifyListeners();
      await _getAddress();
    }).catchError((e) {
      print(e);
    });
  }

  // Method for retrieving the address
  _getAddress() async {
    try {
      List<Placemark> p = await geolocator.placemarkFromCoordinates(
          currentPosition.latitude, currentPosition.longitude);

      Placemark place = p[0];

        currentAddress =
            "${place.name}, ${place.locality}, ${place.postalCode}, ${place.country}";
        startAddressController.text = currentAddress;
        startAddress = currentAddress;

      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  // Method for calculating the distance between two places
  Future<bool> calculateDistance() async {
    try {
      // Retrieving placemarks from addresses
      List<Placemark> startPlacemark = await geolocator.placemarkFromAddress(startAddress);
      List<Placemark> destinationPlacemark = await geolocator.placemarkFromAddress(destinationAddress);
      if (startPlacemark != null && destinationPlacemark != null) {
        // Use the retrieved coordinates of the current position,
        // instead of the address if the start position is user's
        // current position, as it results in better accuracy.
        Position startCoordinates = startAddress == currentAddress ? Position(
          latitude: currentPosition.latitude,
          longitude: currentPosition.longitude)
          : startPlacemark[0].position;
        Position destinationCoordinates = destinationPlacemark[0].position;

        // Start Location Marker
        Marker startMarker = Marker(
          markerId: MarkerId('$startCoordinates'),
          position: LatLng(
            startCoordinates.latitude,
            startCoordinates.longitude,
          ),
          infoWindow: InfoWindow(
            title: 'Start',
            snippet: startAddress,
          ),
          icon: BitmapDescriptor.defaultMarker,
        );

        // Destination Location Marker
        Marker destinationMarker = Marker(
          markerId: MarkerId('$destinationCoordinates'),
          position: LatLng(
            destinationCoordinates.latitude,
            destinationCoordinates.longitude,
          ),
          infoWindow: InfoWindow(
            title: 'Destination',
            snippet: destinationAddress,
          ),
          icon: BitmapDescriptor.defaultMarker,
        );

        // Adding the markers to the list
        markers.add(startMarker);
        markers.add(destinationMarker);

        print('START COORDINATES: $startCoordinates');
        print('DESTINATION COORDINATES: $destinationCoordinates');

        Position northeastCoordinates;
        Position southwestCoordinates;

        // Calculating to check that
        // southwest coordinate <= northeast coordinate
        if (startCoordinates.latitude <= destinationCoordinates.latitude) {
          southwestCoordinates = startCoordinates;
          northeastCoordinates = destinationCoordinates;
        } else {
          southwestCoordinates = destinationCoordinates;
          northeastCoordinates = startCoordinates;
        }

        // Accomodate the two locations within the
        // camera view of the map
        mapController.animateCamera(
          CameraUpdate.newLatLngBounds(
            LatLngBounds(
              northeast: LatLng(
                northeastCoordinates.latitude,
                northeastCoordinates.longitude,
              ),
              southwest: LatLng(
                southwestCoordinates.latitude,
                southwestCoordinates.longitude,
              ),
            ),
            100.0,
          ),
        );

        // Calculating the distance between the start and the end positions
        // with a straight path, without considering any route
        // double distanceInMeters = await Geolocator().bearingBetween(
        //   startCoordinates.latitude,
        //   startCoordinates.longitude,
        //   destinationCoordinates.latitude,
        //   destinationCoordinates.longitude,
        // );

        await createPolylines(startCoordinates, destinationCoordinates);

        double totalDistance = 0.0;

        // Calculating the total distance by adding the distance
        // between small segments
        for (int i = 0; i < polylineCoordinates.length - 1; i++) {
          totalDistance += coordinateDistance(
            polylineCoordinates[i].latitude,
            polylineCoordinates[i].longitude,
            polylineCoordinates[i + 1].latitude,
            polylineCoordinates[i + 1].longitude,
          );
        }

        // setState(() {
          placeDistance = totalDistance.toStringAsFixed(2);
          print('DISTANCE: $placeDistance km');
        // });
        notifyListeners();

        return true;
      }
    } catch (e) {
      print(e);
    }
    notifyListeners();
    return false;
    
  }

  // Formula for calculating distance between two coordinates
  // https://stackoverflow.com/a/54138876/11910277
  double coordinateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
        notifyListeners();
    return 12742 * asin(sqrt(a));
  }

  // Create the polylines for showing the route between two places
   void createPolylines(Position start, Position destination) async {
    polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      API_KEY, // Google Maps API Key
      PointLatLng(start.latitude, start.longitude),
      PointLatLng(destination.latitude, destination.longitude),
      travelMode: TravelMode.transit,
    );

    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }

    PolylineId id = PolylineId('poly');
    Polyline polyline = Polyline(
      polylineId: id,
      color: Colors.blueAccent,
      points: polylineCoordinates,
      width: 3,
    );
    polylines[id] = polyline;

    notifyListeners();
  }

  @override
  MapState() {
    _getCurrentLocation();
  }

  void onMapTypeButtonPressed() {
    currentMapType = currentMapType == MapType.normal ? MapType.satellite : MapType.normal;
    notifyListeners();
  }
}