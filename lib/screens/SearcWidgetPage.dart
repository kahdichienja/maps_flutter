import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Provider/SearchProvider.dart';

class SearchWidgetPage extends StatefulWidget {
  @override
  _SearchWidgetPageState createState() => _SearchWidgetPageState();
}

class _SearchWidgetPageState extends State<SearchWidgetPage> {
  @override
  Widget build(BuildContext context) {
    final searchState = Provider.of<SearchState>(context);
    return Column(
      children: <Widget>[
        Container(
          color: Colors.white70,
          child: ListTile(
            leading: Icon(Icons.search),
            title: TextField(
              controller: searchState.controller,
              decoration: InputDecoration(
                  hintText: 'Search Merchant By Location Or Price here ...', border: InputBorder.none),
              onChanged: searchState.onSearchTextChanged,
            ),
            trailing: IconButton(
              icon: Icon(Icons.refresh),
              onPressed: () {
                searchState.controller.clear();
                searchState.onSearchTextChanged('');
              },
            ),
          ),
        ),
        Expanded(
          child: searchState.searchResult.length != 0 ||
                  searchState.controller.text.isNotEmpty
              ? ListView.builder(
                  itemCount: searchState.searchResult.length,
                  itemBuilder: (context, i) {
                    return Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Card(
                        color: Colors.white,
                        elevation: 3.0,
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.white,
                            backgroundImage: NetworkImage(
                              searchState.searchResult[i].profileUrl,
                            ),
                          ),
                          title: Text(
                              "${searchState.searchResult[i].company.name} ${searchState.searchResult[i].address.city}"),
                          subtitle:
                              Text("\n${searchState.searchResult[i].phone}"),
                          trailing: Text(
                              'City: ${searchState.shopDetails[i].address.city}'),
                          onTap: () => searchState.onTapSearchItem(
                              context, searchState.shopDetails[i]),
                        ),
                        margin: const EdgeInsets.all(0.0),
                      ),
                    );
                  },
                )
              : ListView.builder(
                  itemCount: searchState.shopDetails.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Card(
                        elevation: 0.0,
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(
                              searchState.shopDetails[index].profileUrl,
                            ),
                          ),
                          title: Text(
                              searchState.shopDetails[index].company.name +
                                  ' ' +
                                  searchState.shopDetails[index].address.city),
                          trailing: Text(
                              'City: ${searchState.shopDetails[index].address.city}'),
                          subtitle: Text(searchState.shopDetails[index].phone),
                          onTap: () => searchState.onTapItem(
                              context, searchState.shopDetails[index]),
                        ),
                        margin: const EdgeInsets.all(0.0),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
