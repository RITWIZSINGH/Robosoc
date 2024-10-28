import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';


class Helper{

  static String userIdKey = "userId";
  static String userDataKey = "userDataId";




  setUserId(String userKey) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(userIdKey, userKey);
  }

  getUsetId() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userIdKey);
  }



  setUserData(Map data) async{
    String dd = "";
    try {
      dd = jsonEncode(data);
    }
    catch(e){

    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(userDataKey, dd);
  }

  getUserData() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? a = prefs.getString(userDataKey);
    if(a == null || a.isEmpty){
      return null;
    }
    Map data = jsonDecode(a);
    return data;
  }




}