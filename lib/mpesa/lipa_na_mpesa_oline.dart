// import requests
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'keys.dart' as keys;

Future<dynamic> formateDateToYMDHMS() async {
  try {
    var now = DateTime.now();
    var formartedtime =
        "${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}${now.hour.toString().padLeft(2, '0')}${now.minute.toString().padLeft(2, '0')}${now.second.toString().padLeft(2, '0')}";
    return formartedtime;
  } catch (e) {
    print(e);
  }
}

Future<String> _generatepassword() async {
  try {
    var formartedtime = await formateDateToYMDHMS();
    print(formartedtime);
    String _rawPassword =
        keys.business_short_code + keys.lipa_na_mpesa_passkey + formartedtime;

    List<int> passwordBytes = utf8.encode(_rawPassword);

    String password = base64.encode(passwordBytes);
    return password;
  } catch (e) {
    print(e);
    rethrow;
  }
}

Future<String> _authenticate() async {
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

void lipanampesa() async {
  var apiurl =
      "https://sandbox.safaricom.co.ke/mpesa/stkpush/v1/processrequest";

  var formartedtime = await formateDateToYMDHMS();
  var _password = await _generatepassword();
  var accesstoken = await _authenticate();

  String requestbody = json.encode({
    'BusinessShortCode': keys.business_short_code,
    'Password': _password,
    'Timestamp': formartedtime,
    'TransactionType': "CustomerPayBillOnline", //CustomerPayBillOnline
    'Amount': 1,
    'PartyA': keys.phone_number,
    'PartyB': keys.business_short_code,
    'PhoneNumber': keys.phone_number,
    'CallBackURL': "https://m-pay.herokuapp.com/api/payments/lnm/",
    'AccountReference': "Test004Clinton",
    'TransactionDesc': "Maber Payment"
  });
  try {
    http.Response response = await http.post(
      apiurl,
      body: requestbody,
      headers: {
        'Authorization': 'Bearer $accesstoken',
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      // {
      //   "MerchantRequestID":"20307-99562491-1"
      // "CheckoutRequestID":"ws_CO_030920202354219695",
      // "ResponseCode": "0",
      // "ResponseDescription":"Success. Request accepted for processing",
      // "CustomerMessage":"Success. Request accepted for processing"
      // }
      print(json.decode(response.body));
      var resObj = await json.decode(response.body);
      print(resObj.MerchantRequestID);
      print(resObj.CheckoutRequestID);
      print(resObj.ResponseCode);
      print(resObj.ResponseDescription);
      print(resObj.CustomerMessage);
      
      return json.decode(response.body);
    } else {
      throw json.decode(response.body);
    }
  } catch (e) {
    print(e);
  }
}
