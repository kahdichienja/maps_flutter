import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'Pages/Map.dart';
import 'Provider/MapProvider.dart';
void main() {
  return runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider.value(
        value: MapState(),
      )
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Google Maps',
      debugShowCheckedModeBanner: false,
      home: MapPage(),
    );
  }
}

