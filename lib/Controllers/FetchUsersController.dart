

import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import '../Models/NeerShops.dart';
import 'package:http/http.dart' as http;

/*
 * @desc: this is an async func that returns a json
 * @params: -String Url From Where Data Is To be Fetched.
 * 
 * 
 * -- Author: __ Agoo Clinton, Mail: agooclinton@gmail.com
 * --Lisence: MIT.
 */

Future<List<UserShopInfo>> fetchShopInfo(http.Client client, String uri) async {
  final response = await client.get(uri);

  return compute(parseUserShopInfo, response.body);
}

List<UserShopInfo> parseUserShopInfo(String responFroJson) {
  final parsed = json.decode(responFroJson).cast<Map<String, dynamic>>();

  return parsed
      .map<UserShopInfo>((json) => UserShopInfo.fromJson(json))
      .toList();
}