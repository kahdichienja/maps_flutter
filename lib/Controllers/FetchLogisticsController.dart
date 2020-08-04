import 'package:flutter/foundation.dart';
import '../Models/Logistics.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

// final String uri = '';
/*
 * @desc: this is an async func that returns a json
 * @params: -String Url From Where Data Is To be Fetched.
 * 
 * 
 * -- Author: __ Agoo Clinton, Mail: agooclinton@gmail.com
 * --Lisence: MIT.
 */
Future<List<Logistics>> fetchLogistics(http.Client client, String uri) async {
  final response = await client.get(uri);

  return compute(parseLogistics, response.body);
}

List<Logistics> parseLogistics(String responFroJson) {
  final parsed = json.decode(responFroJson).cast<Map<String, dynamic>>();

  return parsed
      .map<Logistics>((json) => Logistics.fromJson(json))
      .toList();
}

// init
// final String uri = '';
// Future<List<Logistics>> fn = fetchLogistics(http.Client(),  uri);
