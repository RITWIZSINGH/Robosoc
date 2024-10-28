import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

String homeUrl = "https://new.wowcodes.in/api.php?get_home_shop=";
String imageUrl = "http://new.wowcodes.in/seller/images";
String thumbnailUrl = "http://new.wowcodes.in/seller/images/thumbs/";

String loginUrl = "https://new.wowcodes.in/api.php?login=";
String SignUpUrl = "https://new.wowcodes.in/api.php?register=";


String initiatepasswordReset = "https://new.wowcodes.in/api.php?initiate_password_reset=";
String validatepasswordReset = "https://new.wowcodes.in/api.php?validate_password_reset=";
Future<Map> getHomData() async{

  var url = Uri.parse(homeUrl);

  var req = http.Request('GET', url);

  var res = await req.send();
  final resBody = await res.stream.bytesToString();

  if (res.statusCode >= 200 && res.statusCode < 300) {
    Map data = jsonDecode(resBody);
    List alldata = data['JSON_DATA'];
    data = alldata[0];
    return data;
    print(resBody);
  }
  else {
    print(res.reasonPhrase);
  }
  return {};
}