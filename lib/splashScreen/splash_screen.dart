import 'dart:async';

import 'package:carpool_users/assistant/assistant_methods.dart';
import 'package:carpool_users/global/global.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../screens/login_screen.dart';
import '../screens/main_screen.dart';

class splashScreen extends StatefulWidget {
  const splashScreen({super.key});

  @override
  State<splashScreen> createState() => _splashScreenState();
}

class _splashScreenState extends State<splashScreen> {

  startTimer(){
    Timer(Duration(seconds: 3), () async {
     if(await firebaseAuth.currentUser != null){
       firebaseAuth.currentUser != null ? AssistantMethods.readCurrentOnlineUserInfo() : null;
       Navigator.push(context, MaterialPageRoute(builder:(context) => MainScreen()));
     }
     else{
       Navigator.push(context, MaterialPageRoute(builder:(context) => LoginScreen()));
     }

    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startTimer();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'TRIPPO',
          style: TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.bold
          ),
        ),
      ),

    );
  }
}
