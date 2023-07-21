import 'package:carpool_users/screens/forgot_password_screen.dart';
import 'package:carpool_users/screens/view_drivers_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  @override
  Widget build(BuildContext context) {

    bool darkTheme = MediaQuery.of(context).platformBrightness == Brightness.dark;
    return GestureDetector(
      onTap: (){
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: IconButton(
            onPressed: (){
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios, color: darkTheme? Colors.white :Colors.black,
            ),
          ),
          title: Text('Admin Screen', style: TextStyle(color: darkTheme ? Colors.white : Colors.black ,fontWeight: FontWeight.bold),),
          centerTitle: true,

          elevation: 0.0,
        ),
        body: Center(
          child: Padding(
            padding: EdgeInsets.fromLTRB(20, 20, 20, 50),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(50),
                  decoration: BoxDecoration(
                    color: Colors.lightBlue,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.admin_panel_settings, color: Colors.white,),

                ),

                SizedBox(height: 80,),
                GestureDetector(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => ViewDriverScreen()));
                  },
                  child: Text(
                    'View Drivers',
                    style: TextStyle(
                      color: darkTheme ? Colors.amber.shade400 : Colors.blue,
                    ),
                  ),
                ),
                SizedBox(height: 80,),
                GestureDetector(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => ForgotPasswordScreen()));
                  },
                  child: Text(
                    'View Users',
                    style: TextStyle(
                      color: darkTheme ? Colors.amber.shade400 : Colors.blue,
                    ),
                  ),
                ),



              ],
            ),
          ),
        ),

      ),
    );
  }
}

