import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:locapp/Models/NeerShops.dart';
import 'package:locapp/utils/ProgressCircle.dart';
import 'dart:async';

final String uri = 'https://jsonplaceholder.typicode.com/users';

Future<List<UserShopInfo>> fetchPosts(http.Client client) async {
  final response = await client.get(uri);

  return compute(parseUserShopInfo, response.body);
}

List<UserShopInfo> parseUserShopInfo(String responFroJson) {
  final parsed = json.decode(responFroJson).cast<Map<String, dynamic>>();

  return parsed
      .map<UserShopInfo>((json) => UserShopInfo.fromJson(json))
      .toList();
}

class SearchShops extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text('Search Near Shop'),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.location_searching),
              onPressed: () =>
                  {showSearch(context: context, delegate: Searches())})
        ],
      ),
      body: FutureBuilder<List<UserShopInfo>>(
        future: fetchPosts(http.Client()),
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);

          return snapshot.hasData
              ? ShopView(shopInfo: snapshot.data)
              : Center(
                  child: ColorLoader2(
                  color3: Colors.blueAccent,
                  color2: Colors.greenAccent,
                  color1: Colors.redAccent,
                ));
        },
      ),
    );
  }
}

class ShopView extends StatelessWidget {
  final List<UserShopInfo> shopInfo;

  ShopView({Key key, this.shopInfo}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
          itemCount: shopInfo.length,
          padding: const EdgeInsets.all(15.0),
          itemBuilder: (context, position) {
            // ${shopInfo[position].company.name}
            return ListTile(
              title: Text(
                '${shopInfo[position].company.name}',
              ),
              subtitle: Text(
                '${shopInfo[position].email}',
                style: new TextStyle(
                  fontSize: 18.0,
                  fontStyle: FontStyle.italic,
                ),
              ),
              leading: Column(
                children: <Widget>[
                  CircleAvatar(
                      backgroundColor: Colors.blueAccent,
                      child: Text(shopInfo[position].name[0],
                          style: TextStyle(
                            fontSize: 18.0,
                            color: Colors.white,
                          )))
                ],
              ),
              onTap: () => _onTapItem(context, shopInfo[position]),
            );
          }),
    );
  }

  _onTapItem(BuildContext context, UserShopInfo info) {
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
                  child: Image.network(
                      "https://source.unsplash.com/random/1500x700",
                      height: 200,
                      width: 500),
                ),
                SizedBox(height: 5.0,),
                Card(
                  elevation: 0.0,
                  child:
                      Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
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
                      onTap: () => print('${info.address.geo.lat}, ${info.address.geo.lng}'),
                    )
                  ]),
                ),
                 Card(
                  elevation: 0.0,
                  child:
                      Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                    ListTile(
                      leading: Icon(Icons.business),
                      title: Text(info.phone),
                      subtitle: Text('City ${info.address.city}'),
                      trailing: Text('Zipcode. ${info.address.zipcode}'),
                      onTap: () => print('${info.address.geo.lat}, ${info.address.geo.lng}'),
                    )
                  ]),
                ),
              ],
            ),
          );
        });
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
        child: Center(
            child: Text(
          query,
          style: TextStyle(color: Colors.black),
        )),
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
