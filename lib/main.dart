import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'Provider/MapProvider.dart';
import 'Provider/SearchProvider.dart';
import 'screens/MapPage.dart';
// import 'tests/search_test.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  return runApp(
    MultiProvider(providers: [
      ChangeNotifierProvider.value(value: MapState(),),
      ChangeNotifierProvider.value(value: SearchState(),)
  ],
  child: MyApp(),));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Maps',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // home: SearchPage(),
      home: MapView(),
    );
  }
}
