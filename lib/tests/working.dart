import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:locapp/Models/NeerShops.dart';
import '../utils/ColorLoaders.dart';

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
        body: NearShopsW());
  }
}

class NearShopsW extends StatefulWidget {
  @override
  _NearShopsWState createState() => _NearShopsWState();
}

class _NearShopsWState extends State<NearShopsW> {
  final String uri = 'https://jsonplaceholder.typicode.com/users';

  Future<List<UserShopInfo>> _fetchUsers() async {
    var response = await http.get(uri);

    if (response.statusCode == 200) {
      final items = json.decode(response.body).cast<Map<String, dynamic>>();
      List<UserShopInfo> listOfUsers = items.map<UserShopInfo>((json) {
        return UserShopInfo.fromJson(json);
      }).toList();

      return listOfUsers;
    } else {
      throw Exception('Failed to load internet');
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<UserShopInfo>>(
      future: _fetchUsers(),
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return Center(
              child: ColorLoader2(
            color3: Colors.blueAccent,
            color2: Colors.greenAccent,
            color1: Colors.redAccent,
          ));

        return ListView(
          children: snapshot.data
              .map((user) => Card(
                    child: ListTile(
                      onTap: () => {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailScreen(id: user.id),
                            ))
                      },
                      title: Text(user.company.name),
                      trailing: Text(user.phone),
                      subtitle: Text(user.email),
                      leading: CircleAvatar(
                        backgroundColor: Colors.blueAccent,
                        child: Text(user.name[0],
                            style: TextStyle(
                              fontSize: 18.0,
                              color: Colors.white,
                            )),
                      ),
                    ),
                  ))
              .toList(),
        );
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

class DetailScreen extends StatefulWidget {
  int id;

  DetailScreen({Key key, @required this.id}) : super(key: key);

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  String get id => null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
          body: Container(
        child: Center(
          child: Text(id),
        ),
      ),
    );
  }
}
