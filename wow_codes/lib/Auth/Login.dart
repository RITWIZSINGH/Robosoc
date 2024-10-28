import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:iconsax/iconsax.dart';
import 'package:http/http.dart' as http;
import 'package:wow_codes/Helper/Helper.dart';
import 'package:wow_codes/Home/home_page.dart';

import 'dart:developer' as dev;

import 'package:wow_codes/Usefull/Colors.dart';

import '../Config/Config.dart';
import '../Usefull/Functions.dart';
import 'ForgotPassword.dart';
import 'Signup.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

// import 'package:google_sign_in/google_sign_in.dart';





class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final formKey = GlobalKey<FormState>();
  String email = "";
  String password = "";
  bool showpass = false;
  bool isHide = false;
  bool loginPhone = false;

  String countryCode = "";
  String phone = "";
  PhoneNumber number = PhoneNumber(dialCode: "+91",isoCode: "IN");



  @override
  void initState() {


  }






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
                    mainTextLeft("Welcome \nBack!", Colors.white, 30.0, FontWeight.bold, 2,'mons'),

                    SizedBox(height: 40.0,),
                    (!loginPhone)?TextFormField(
                      maxLength: 64,
                      keyboardType:TextInputType.emailAddress,
                      cursorColor: Colors.white,

                      style: TextStyle(
                        fontFamily: 'pop',
                        fontSize: 15.0,
                        color: Colors.white,
                      ),
                      decoration: InputDecoration(
                        filled: true,
                          counterText: "",
                          fillColor: bgColorLight,
                          hintText: "    Email",

                          prefixIcon: Icon(Icons.email,color: bgColor,),
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
                        email = text;
                      },
                      validator: (value){
                        bool emailValid = RegExp(
                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                            .hasMatch(value!);
                        if (!emailValid) {
                          return ("Please enter a valid email");
                        } else {
                          return null;
                        }
                      },
                    ): Card(
                      color:bgColorLight,
                      elevation: 0.0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          side: BorderSide(
                            color: bgColor,
                            width: 0.0,
                          )
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15.0,vertical: 5.0),
                        child: InternationalPhoneNumberInput(
                          onInputChanged: (PhoneNumber n){
                            print(n.toString());
                            phone = n.phoneNumber.toString();
                            countryCode = n.dialCode.toString();
                          },
                          textStyle: TextStyle(
                            fontFamily: 'mons',
                            fontSize: 13.0,
                            color: Colors.white,
                          ),

                          selectorConfig: SelectorConfig(
                              selectorType: PhoneInputSelectorType.BOTTOM_SHEET
                          ),
                          initialValue: number,

                          maxLength: 13,
                          keyboardType: TextInputType.number,
                          cursorColor: Colors.white,

                          selectorTextStyle: TextStyle(
                            fontFamily: 'mons',
                            fontSize: 13.0,
                            color: Colors.white,
                          ),

                          inputDecoration: InputDecoration(
                            filled: true,
                            fillColor: bgColorLight,
                            hintText: "Mobile Number",
                            suffixIcon: Icon(Iconsax.call,color: Colors.grey,size: 20.0,),
                            hintStyle: TextStyle(
                                fontFamily: 'mons',
                                color:Colors.grey
                            ),
                            labelStyle: TextStyle(
                                fontFamily: 'mons',
                                color:Colors.white
                            ),

                            errorStyle: TextStyle(
                                fontFamily: 'mons',
                                color: Colors.redAccent
                            ),
                            border: InputBorder.none,

                          ),
                          validator: (value){
                            if(value!.isEmpty){
                              return("Please Enter a Number");
                            }
                            else if(value.length < 10){
                              return("Number should be 10 digits long");
                            }
                            return null;
                          },
                        ),
                      ),
                    ),

                    SizedBox(height: 30.0,),
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
                          hintText: "    Password",
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

                    Row(
                      children: [
                        TextButton(onPressed: (){
                          setState(() {
                            loginPhone = !loginPhone;
                          });
                        }, child: mainTextLeft("Login with ${(loginPhone)?'Email':'Phone'}", Colors.white, 13.0, FontWeight.normal, 1,"mons")),
                        Spacer(),
                        TextButton(onPressed: (){
                          navScreen(forgotPassword(), context, false);
                          // navScreen(forgotPassword(), context, false);
                        }, child: mainTextLeft("Forgot Password?", Colors.white, 13.0, FontWeight.normal, 1,"mons"))
                      ],
                    ),

                    SizedBox(height: 30.0,),

                    Row(
                      children: [
                        mainTextLeft("Sign In", Colors.white, 25.0, FontWeight.bold, 1,"mons"),
                        Spacer(),
                        FloatingActionButton(onPressed: (){
                          if(formKey.currentState!.validate()){
                            LoginNow();
                          }
                        },mini: false,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
                          backgroundColor: Colors.white, child: Icon(Icons.arrow_forward_sharp, color: Colors.black,),)
                      ],
                    ),

                    SizedBox(height: 40.0,),

                    // Row(
                    //   children: [
                    //     Spacer(),
                    //     mainText("or sign in with", Colors.grey, 13.0, FontWeight.normal, 1,"mons"),
                    //     Spacer(),
                    //   ],
                    // ),
                    SizedBox(height: 20.0,),

                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.center,
                    //   children: [
                    //     FloatingActionButton(onPressed: (){
                    //       SigninwithGoogle();
                    //     },mini: true,
                    //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
                    //       backgroundColor: Colors.white, child: Image.asset('Assets/google.png',width: 25.0,)),
                    //
                    //     SizedBox(width: 20.0,),
                    //     FloatingActionButton(onPressed: (){},mini: true,
                    //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
                    //       backgroundColor: Colors.white, child: Image.asset('Assets/facebook.png',width: 25.0,)),
                    //
                    //     SizedBox(width: 20.0,),
                    //
                    //     FloatingActionButton(onPressed: (){},mini: true,
                    //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
                    //       backgroundColor: Colors.white, child: Image.asset('Assets/insta.png',width: 25.0,)),
                    //
                    //     SizedBox(width: 20.0,),
                    //
                    //     FloatingActionButton(onPressed: (){},mini: true,
                    //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
                    //       backgroundColor: Colors.white, child: Image.asset('Assets/x.png',width: 25.0,)),
                    //   ],
                    // ),
                    Spacer(),
                    Container(
                      alignment: Alignment.bottomCenter,
                      child: Row(
                        children: [
                          Spacer(),
                          mainText("Don't have an account?", Colors.grey, 13.0, FontWeight.bold, 1,"mons"),
                          TextButton(onPressed: (){
                            navScreen(Signup(), context, false);
                          },
                            child:mainText("Sign-up", Colors.white, 13.0, FontWeight.bold, 1,"mons"),
                          ),
                          Spacer(),

                        ],
                      ),
                    )
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

  LoginNow () async{
    setState(() {
      isHide = true;
    });

    var url = Uri.parse(loginUrl);

    var body = {

      'password': password
    };
    if(loginPhone){
      body['phone'] = removeCountryCode(countryCode, phone);
      body['country_code'] = countryCode.substring(1,countryCode.length);
    }
    else{
      body['email'] = email;
    }
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
      Helper().setUserData(data);
      if(data['success'] == "0"){
        toaster(context, data['msg']);
      }
      else{
        toaster(context, "Login Succesfully");
        Future.delayed((Duration(seconds: 1)),(){
          navScreen(Home_Page(), context, true);
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
