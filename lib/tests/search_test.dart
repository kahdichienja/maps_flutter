import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_maps/Models/NeerShops.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController controller = TextEditingController();

  // Get json result and convert it to model. Then add
  Future<Null> getUserDetails() async {
    final response = await http.get(url);
    final responseJson = json.decode(response.body);

    setState(() {
      for (Map user in responseJson) {
        _shopDetails.add(UserShopInfo.fromJson(user));
      }
    });
  }

  @override
  void initState() {
    super.initState();

    getUserDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Center(
          child: Text('Search Adresses Or Shop Name.'),
        ),
        elevation: 0.0,
      ),
      body: Column(
        children: <Widget>[
          Container(
            color: Colors.white70,
            child: ListTile(
              leading: Icon(Icons.search),
              title: TextField(
                controller: controller,
                decoration: InputDecoration(
                    hintText: 'Search here ...', border: InputBorder.none),
                onChanged: onSearchTextChanged,
              ),
              trailing: IconButton(icon: Icon(Icons.cancel), onPressed: () {
                controller.clear();
                onSearchTextChanged('');
              },),
            ),
          ),
          Expanded(
            child: _searchResult.length != 0 || controller.text.isNotEmpty
                ? ListView.builder(
              itemCount: _searchResult.length,
              itemBuilder: (context, i) {
                return Card(
                  child: ListTile(
                    leading: CircleAvatar(backgroundImage: NetworkImage(_searchResult[i].profileUrl,),),
                    title: Text(_searchResult[i].company.name + ' ' + _searchResult[i].address.city),
                  ),
                  margin: const EdgeInsets.all(0.0),
                );
              },
            )
                : ListView.builder(
              itemCount: _shopDetails.length,
              itemBuilder: (context, index) {
                return Card(
                  elevation: 0.0,
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(_shopDetails[index].profileUrl,),
                    ),
                    title: Text(_shopDetails[index].company.name + ' ' + _shopDetails[index].address.city),
                    trailing: Text('City: ${_shopDetails[index].address.city}'),
                    subtitle: Text(_shopDetails[index].phone),
                    onTap: () => _onTapItem(context, _shopDetails[index]),
                  ),
                  margin: const EdgeInsets.all(0.0),
                );
              },
            ),
          ),
        ],
      ),
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
                      info.profileUrl,
                      height: 200,
                      width: 500),
                ),
                SizedBox(
                  height: 5.0,
                ),
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
                      onTap: () => print(
                          '${info.address.geo.lat}, ${info.address.geo.lng}'),
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
                      onTap: () => print(
                          '${info.address.geo.lat}, ${info.address.geo.lng}'),
                    )
                  ]),
                ),
              ],
            ),
          );
        });
  }

  onSearchTextChanged(String text) async {
    _searchResult.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }

    _shopDetails.forEach((userDetail) {
      if (userDetail.company.name.contains(text) || userDetail.address.city.contains(text))
        _searchResult.add(userDetail);
    });

    setState(() {});
  }
}

List<UserShopInfo> _searchResult = [];

List<UserShopInfo> _shopDetails = [];

final String url = 'https://jsonplaceholder.typicode.com/users';


// class UserDetails {
//   final int id;
//   final String firstName, lastName, profileUrl;

//   UserDetails({this.id, this.firstName, this.lastName, this.profileUrl = 'https://i.amz.mshcdn.com/3NbrfEiECotKyhcUhgPJHbrL7zM=/950x534/filters:quality(90)/2014%2F06%2F02%2Fc0%2Fzuckheadsho.a33d0.jpg'});

//   factory UserDetails.fromJson(Map<String, dynamic> json) {
//     return UserDetails(
//       id: json['id'],
//       firstName: json['name'],
//       lastName: json['username'],
//     );
//   }
// }