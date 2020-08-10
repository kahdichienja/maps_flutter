import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import '../utils/ApiUrls.dart';
import '../Models/NeerShops.dart';


class SearchState with ChangeNotifier {
List<UserShopInfo> searchResult = [];

List<UserShopInfo> shopDetails = [];

final String url = usersShopUrl;
TextEditingController controller = TextEditingController();

  // Get json result and convert it to model. Then add
  Future<Null> getUserDetails() async {
    final response = await http.get(url);
    final responseJson = json.decode(response.body);
      for (Map user in responseJson) {
        shopDetails.add(UserShopInfo.fromJson(user));
      }
    notifyListeners();
  }


  @override
  SearchState() {
    getUserDetails();
  }

  onTapItem(BuildContext context, UserShopInfo info) {
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
                  child:
                      Image.network(info.profileUrl, height: 200, width: 500),
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
    searchResult.clear();
    if (text.isEmpty) {
      notifyListeners();
      return;
    }

    shopDetails.forEach((userDetail) {
      if (userDetail.company.name.contains(text) ||
          userDetail.address.city.contains(text)) searchResult.add(userDetail);
    });
    notifyListeners();
  }


}