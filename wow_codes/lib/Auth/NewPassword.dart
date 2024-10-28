
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sms_otp_auto_verify/sms_otp_auto_verify.dart';
import 'package:http/http.dart' as http;
import 'package:wow_codes/Auth/Login.dart';
import 'package:wow_codes/Config/Config.dart';
import 'package:wow_codes/Usefull/Colors.dart';
import 'package:iconsax/iconsax.dart';

import '../Usefull/Functions.dart';




class NewPassword extends StatefulWidget {
  Map<String,String> data;
  NewPassword({super.key,required this.data});

  @override
  State<NewPassword> createState() => _NewPasswordState();
}

class _NewPasswordState extends State<NewPassword> {
  TextEditingController textEditingController = new TextEditingController(text: "");

  BoxDecoration get _pinPutDecoration {
    return BoxDecoration(
      color: bgColorLight,
      borderRadius: BorderRadius.circular(10.0),
    );
  }

  String otp = "";
  String password = "";
  bool isHide = false;
  bool showpass = false;
  final formKey = GlobalKey<FormState>();





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: Stack(
        children: [
          SafeArea(
            child: Padding(
              padding: (MediaQuery.of(context).size.width < 900)?EdgeInsets.symmetric(horizontal: 25.0,vertical: 25.0):EdgeInsets.symmetric(horizontal: 300.0,vertical: 25.0),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    mainTextLeft("Create new\nPassword", Colors.white, 30.0, FontWeight.bold, 2,"mons"),
                    SizedBox(height: 20.0,),



                    mainTextLeft("Enter OTP", Colors.white, 15.0, FontWeight.normal, 1,"mons"),
                    SizedBox(height: 10.0,),
                    TextFieldPin(
                        textController: textEditingController,
                        codeLength: 6,
                        alignment: MainAxisAlignment.spaceEvenly,
                        defaultBoxSize: 50.0,
                        margin: 5,
                        selectedBoxSize: 50.0,
                        textStyle: TextStyle(fontSize: 20,fontFamily: 'mons',color: Colors.white),
                        defaultDecoration: _pinPutDecoration,
                        selectedDecoration: _pinPutDecoration.copyWith(color: bgColorLight),


                        onChange: (code) {
                          setState(() {
                            otp = code;
                          });
                        }),

                    SizedBox(height: 20.0,),

                    TextFormField(
                      obscureText: !showpass,
                      maxLength: 28,

                      keyboardType:TextInputType.text,
                      cursorColor: Colors.white,

                      style: TextStyle(
                        fontFamily: 'pop',
                        fontSize: 15.0,
                        color: Colors.white,
                      ),
                      decoration: InputDecoration(
                          filled: true,

                          counterText: "",
                          fillColor:bgColorLight,
                          hintText: "    New Password",
                          prefixIcon: Icon(Icons.lock,color: bgColor,),
                          suffixIcon: (showpass)?IconButton(onPressed: (){
                            setState(() {
                              showpass = false;
                            });
                          }, icon: Icon(Iconsax.eye,color: Colors.grey,)):
                          IconButton(onPressed: (){
                            setState(() {
                              showpass = true;
                            });
                          }, icon: Icon(Iconsax.eye_slash,color: bgColor,)),
                          hintStyle: TextStyle(
                              fontFamily: 'pop',
                              color:Colors.grey
                          ),
                          labelStyle: TextStyle(
                              fontFamily: 'pop',
                              color:Colors.white
                          ),
                          errorStyle: TextStyle(
                              fontFamily: 'mons',
                              color: Colors.redAccent
                          ),
                          errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                  Radius.circular(13.0)),
                              borderSide:
                              BorderSide(color: Colors.redAccent)),

                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                  Radius.circular(13.0)),
                              borderSide:
                              BorderSide(color: bgColorLight)),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                  Radius.circular(13.0)),
                              borderSide:
                              BorderSide(color: Colors.grey)),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                  Radius.circular(13.0)),
                              borderSide:
                              BorderSide(color: Colors.transparent))),


                      onChanged: (text){
                        password = text;
                      },
                      validator: (value){
                        if(value!.length < 7){
                          return("Password Must be of 7 digits");
                        }
                      },
                    ),


                    SizedBox(height: 40.0,),
                    Row(
                      children: [
                        mainTextLeft("Update Password", Colors.white, 25.0, FontWeight.bold, 1,"mons"),
                        Spacer(),
                        FloatingActionButton(onPressed: (){
                          if(otp.length < 6){
                            toaster(context, "Pin must be more than 6 letters");
                          }
                          else if(formKey.currentState!.validate()){
                            ResetPassword();
                          }
                        },mini: false,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
                          backgroundColor: Colors.white, child: Icon(Icons.arrow_forward_sharp, color: Colors.black,),)
                      ],
                    ),

                  ],
                ),
              ),
            ),
          ),
          loaderss(isHide, context)
        ],
      ),
    );
  }

  ResetPassword() async{
    setState(() {
      isHide = true;
    });

    var url = Uri.parse(validatepasswordReset);

    Map<String,String> body = widget.data;
    body['otp'] = otp;
    body['password'] = password;

    print(body);

    var req = http.MultipartRequest('POST', url);
    req.fields.addAll(body);

    var res = await req.send();
    final resBody = await res.stream.bytesToString();

    if (res.statusCode >= 200 && res.statusCode < 300) {
      print(resBody);
      Map data = jsonDecode(resBody);
      List ll = data['JSON_DATA'];
      data = ll[0];
      if(data['success'] == "0"){
        toaster(context, data['msg']);
      }
      else{
        toaster(context, "Password Reset Successfully");
        Future.delayed((Duration(seconds: 1)),(){
          navScreen(Login(), context, true);
        });
      }
    }
    else {
      toaster(context, "Something went wrong");
      print(res.reasonPhrase);

    }
    setState(() {
      isHide = false;
    });
  }

}
