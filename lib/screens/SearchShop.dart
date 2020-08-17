import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import '../utils/ApiUrls.dart';
import '../Controllers/FetchUsersController.dart';
import '../Models/NeerShops.dart';
import '../utils/ColorLoaders.dart';

import 'SearchPage.dart';

class SearchShops extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder<List<UserShopInfo>>(
          future: fetchShopInfo(http.Client(), usersShopUrl),
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
        floatingActionButton: FloatingActionButton(
          onPressed: () => {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => SearchPage())),
          },
          child: IconButton(
            icon: Icon(
              Icons.location_searching,
              color: Colors.indigo[100],
            ), onPressed: () {  },
          ),
        ));
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
}
