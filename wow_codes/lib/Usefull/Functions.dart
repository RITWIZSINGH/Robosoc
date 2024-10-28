import 'package:flutter/material.dart';

navScreen(Widget a,BuildContext context,bool replace){
  if(replace){
    Navigator.pushReplacement(context,MaterialPageRoute(builder:
        (context){
      return a;
    }));
  }
  else {
    Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(builder: (context){
      return a;
    }));
    // Navigator.push(context,rootN MaterialPageRoute(builder:
    //     (context) {
    //   return a;
    // }));
  }
}

String removeCountryCode(String countryCode, String phoneNumber) {
  // Escape the country code for special regex characters and remove it from the phone number
  String pattern = '^' + RegExp.escape(countryCode);
  return phoneNumber.replaceFirst(RegExp(pattern), '').trim();
}
