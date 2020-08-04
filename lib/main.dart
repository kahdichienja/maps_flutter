import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'Provider/MapProvider.dart';
// import 'screens/LoginPage.dart';
import 'screens/Map.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  return runApp(MultiProvider(providers: [
      ChangeNotifierProvider.value(value: MapState(),)
  ],
  child: MyApp(),));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MapPage(),
    );
  }
}
