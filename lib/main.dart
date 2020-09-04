import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'Provider/MapProvider.dart';
import 'Provider/SearchProvider.dart';
import 'mpesa/access_token.dart';
import 'mpesa/lipa_na_mpesa_oline.dart';
import 'screens/MapPage.dart';
import 'utils/Buttons.dart';
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
      // home: MapView(),
      home: MpesaTest(),
    );
  }
}
class MpesaTest extends StatefulWidget {
  @override
  _MpesaTestState createState() => _MpesaTestState();
}

class _MpesaTestState extends State<MpesaTest> {
  @override
  Widget build(BuildContext context) {
    return Material(
          child: Container(
        
        child: Center(child: RaisedButton(
          onPressed: () => lipanampesa(),
                child: Icon(Icons.payment,),
        ),),
      ),
    );
  }
}
