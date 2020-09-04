import 'dart:convert';
import 'keys.dart' as keys;

generatepassword() async {
  try {
  var now = DateTime.now();
  // time formatting
  var formartedtime =
      "${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}${now.hour.toString().padLeft(2, '0')}${now.minute.toString().padLeft(2, '0')}${now.second.toString().padLeft(2, '0')}";
  //  base64 encode
  // var decodedpassword = generatepassword(formartedtime);
print(formartedtime);
  var rawPassword =
      keys.business_short_code + keys.lipa_na_mpesa_passkey + formartedtime;

  List<int> passwordBytes = utf8.encode(rawPassword);

  var password = base64.encode(passwordBytes);
  return password;
  } catch (e) {
    print(e);
  }
}

// import base64
// from . import keys

// def generate_password(formarted_time):

//     # base64 encode
//     data_to_encode = keys.business_short_code + keys.lipa_na_mpesa_passkey + formarted_time

//     encoded_string = base64.b64encode(data_to_encode.encode())

//     decoded_password = encoded_string.decode("utf-8")

//     # print(decoded_password)
//     return decoded_password
