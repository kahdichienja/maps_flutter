import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:locapp/Models/NeerShops.dart';
import 'package:locapp/utils/ProgressCircle.dart';

class SearchShops extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Search Near Shop'),
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.location_searching),
                onPressed: () =>
                    {showSearch(context: context, delegate: Searches())})
          ],
        ),
        body: NearShopsW());
  }
}

class NearShopsW extends StatefulWidget {
  @override
  _NearShopsWState createState() => _NearShopsWState();
}

class _NearShopsWState extends State<NearShopsW> {
  final String uri =
      'https://my-json-server.typicode.com/kahdichienja/fakeplaceapi/neerShops';

  Future<List<NeerShops>> _fetchNeerShops() async {
    var data = await http.get(uri);

    var jsonData = json.decode(data.body);

    List<NeerShops> neerShops = [];

    for (var n in jsonData) {
      NeerShops neerShop = NeerShops(n["id"], n["shopname"], n["rating"],
          n["imgUrl"], n["geocode"], n["description"]);
      neerShops.add(neerShop);
    }
    print(
        '=========================================================== ${neerShops.length}');
    return neerShops;
    // var response = await http.get(uri);

    //     if (response.statusCode == 200) {
    //       final items = json.decode(response.body).cast<Map<String, dynamic>>();
    //       List<NeerShops> listOfNeerShops = items.map<NeerShops>((json) {
    //         return NeerShops.fromJson(json);
    //       }).toList();
    // print(response);
    //       return listOfNeerShops;
    //     } else {
    //       throw Exception('Failed to load internet');
    //     }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _fetchNeerShops(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.data == null) {
          return Center(child: ColorLoader2(
            color1: Colors.blueAccent,
            color2: Colors.redAccent,
            color3: Colors.purpleAccent,
          ));
        } else {
          return ListView.builder(
              itemCount: snapshot.data.legnth,
              itemBuilder: (BuildContext context, int id) {
                return ListTile(
                  title: Text(snapshot.data['shopname']),
                  subtitle: Text(snapshot.data['rating']),
                  leading: CircleAvatar(
                    // backgroundColor: Colors.red,
                    child: Text(snapshot.data['imgUrl'],
                        style: TextStyle(
                          fontSize: 18.0,
                          color: Colors.white,
                        )),
                  ),
                );
              });
        }
      },
    );
  }
}

class Searches extends SearchDelegate<String> {
  final cities = [
    "Kisumu",
    "Nairobi",
    "Kisii",
    "Nyamira",
    "eldoret",
    "jumia kisumu",
    "Kisii nakumatt",
    "Ali Nyamira",
    "jiji Kisumu",
    "Sos Nairobi",
    "Maber Kisii",
    "jiji Nyamira"
  ];
  final recentCities = ["Kisii", "Kisumu", "Nairobi", "Kisii", "Nyamira"];
  @override
  List<Widget> buildActions(BuildContext context) {
    // TODO: implement buildActions AppBar
    return [
      IconButton(icon: Icon(Icons.clear), onPressed: () => {query = ""})
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // TODO: implement buildLeading icon
    return IconButton(
        icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow,
          progress: transitionAnimation,
        ),
        onPressed: () => {close(context, null)});
  }

  @override
  Widget buildResults(BuildContext context) {
    // TODO: implement buildResults
    return Container(
      height: 100.0,
      width: 100.0,
      child: Card(
        color: Colors.white12,
        shape: StadiumBorder(),
        child: Center(child: Text(query)),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // TODO: implement buildSuggestions suggestion

    final suggestionList = query.isEmpty
        ? recentCities
        : cities.where((p) => p.startsWith(query)).toList();

    return ListView.builder(
      itemBuilder: (context, index) => ListTile(
        onTap: () {
          showResults(context);
        },
        leading: Icon(Icons.location_city),
        title: RichText(
            text: TextSpan(
                text: suggestionList[index].substring(0, query.length),
                style: TextStyle(
                    color: Colors.blueAccent, fontWeight: FontWeight.w100),
                children: [
              TextSpan(
                  text: suggestionList[index].substring(query.length),
                  style: TextStyle(color: Colors.black))
            ])),
      ),
      itemCount: suggestionList.length,
    );
  }
}
