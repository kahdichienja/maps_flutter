import 'package:http/http.dart' as http;
import 'dart:convert';
import 'keys.dart' as keys;

Future<String> authenticate() async {
  var _accessToken = base64Url
      .encode((keys.consumer_key + ":" + keys.consumer_secret).codeUnits);
  var apiURL =
      "https://sandbox.safaricom.co.ke/oauth/v1/generate?grant_type=client_credentials";
  try {
    http.Response response = await http.get(
      apiURL,
      headers: {
        "Authorization": "Basic $_accessToken",
      },
    );
    var data = json.decode(response.body);
    return data["access_token"];
  } catch (e) {
    print(e);
    rethrow;
  }
}
