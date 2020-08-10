import 'package:flutter/material.dart';
import '../Provider/SearchProvider.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {

  @override
  Widget build(BuildContext context) {
    final searchState = Provider.of<SearchState>(context);
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
                controller: searchState.controller,
                decoration: InputDecoration(
                    hintText: 'Search here ...', border: InputBorder.none),
                onChanged: searchState.onSearchTextChanged,
              ),
              trailing: IconButton(
                icon: Icon(Icons.cancel),
                onPressed: () {
                  searchState.controller.clear();
                  searchState.onSearchTextChanged('');
                },
              ),
            ),
          ),
          Expanded(
            child: searchState.searchResult.length != 0 || searchState.controller.text.isNotEmpty
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
                            title: Text("Name:\n${searchState.searchResult[i].company.name} \nCity: ${searchState.searchResult[i].address.city}"),
                            subtitle: Text("Website: ${searchState.searchResult[i].website}"),
                            trailing: Text("Phone: ${searchState.searchResult[i].phone}"),
                                onTap: () => searchState.onTapItem(context, searchState.shopDetails[i]),
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
                            title: Text(searchState.shopDetails[index].company.name +
                                ' ' +
                                searchState.shopDetails[index].address.city),
                            trailing:
                                Text('City: ${searchState.shopDetails[index].address.city}'),
                            subtitle: Text(searchState.shopDetails[index].phone),
                            onTap: () => searchState.onTapItem(context, searchState.shopDetails[index]),
                          ),
                          margin: const EdgeInsets.all(0.0),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
