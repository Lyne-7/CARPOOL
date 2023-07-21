import 'package:carpool_users/global/global.dart';
import 'package:carpool_users/modals/user_modal.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  final nameTextEditingController = TextEditingController();
  final phoneTextEditingController = TextEditingController();
  DatabaseReference userRef = FirebaseDatabase.instance.reference().child("users");

  Future<void> showUserNameDialogAlert(BuildContext context, String name){
    bool darkTheme = MediaQuery.of(context).platformBrightness == Brightness.dark;
   return showDialog(
       context: context,
       builder: (context) {
         return AlertDialog(
           title: Text('Update'),
           content: SingleChildScrollView(
             child: Column(
               children: [
                 TextFormField(
                   controller: nameTextEditingController,
                 )
               ],
             ),
           ),
           actions: [
             TextButton(
               onPressed: () {

                 Navigator.pop(context);
               },
               child: Text('Cancel', style: TextStyle(color: Colors.red),),
             ),

             TextButton(
               onPressed: () {
                 userRef.child(FirebaseAuth.instance.currentUser!.uid).update({
                   'name' : nameTextEditingController.text.trim(),
                 }).then((value){
                   nameTextEditingController.clear();
                   Fluttertoast.showToast(msg: 'Update Successfully,reload app');
                 }).catchError((errorMessage){
                   Fluttertoast.showToast(msg: 'Error occurred');
                 });
                 Navigator.pop(context);
               },
               child: Text('OK', style: TextStyle(
                   color: darkTheme ? Colors.white : Colors.black),),
             ),
           ],

         );
       }
    );
  }

  Future<void> showUserPhoneDialogAlert(BuildContext context, String phone){
    bool darkTheme = MediaQuery.of(context).platformBrightness == Brightness.dark;
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Update'),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    controller: phoneTextEditingController,
                  )
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {

                  Navigator.pop(context);
                },
                child: Text('Cancel', style: TextStyle(color: Colors.red),),
              ),

              TextButton(
                onPressed: () {
                  userRef.child(FirebaseAuth.instance.currentUser!.uid).update({
                    'phone' : phoneTextEditingController.text.trim(),
                  }).then((value){
                    phoneTextEditingController.clear();
                    Fluttertoast.showToast(msg: 'Update Successfully,reload app');
                  }).catchError((errorMessage){
                    Fluttertoast.showToast(msg: 'Error occurred');
                  });
                  Navigator.pop(context);
                },
                child: Text('OK', style: TextStyle(
                    color: darkTheme ? Colors.white : Colors.black),),
              ),
            ],

          );
        }
    );
  }





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
          title: Text('Profile Screen', style: TextStyle(color: darkTheme ? Colors.white : Colors.black ,fontWeight: FontWeight.bold),),
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
                  child: Icon(Icons.person, color: Colors.white,),

                ),
                
                SizedBox(height: 30,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,

                  children: [
                  FutureBuilder<DataSnapshot>(
                      future: FirebaseDatabase.instance.ref().child('drivers').child(FirebaseAuth.instance.currentUser!.uid).get(),
                      builder: (context, snapShot) {
                        Map<Object?, Object?> data = snapShot.data!.value as Map<Object?, Object?>;
                        String name = data['name'].toString();
                        return Text('${name ?? "N/A"}',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      }
                  ),
                  IconButton(
                      onPressed: (){





                      },
                      icon: Icon(
                        Icons.edit,
                      )),
                ],
                ),
                Divider(
                 thickness: 1,
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,

                  children: [
                    FutureBuilder<DataSnapshot>(
                        future: FirebaseDatabase.instance.ref().child('drivers').child(FirebaseAuth.instance.currentUser!.uid).get(),
                        builder: (context, snapShot) {
                          Map<Object?, Object?> data = snapShot.data!.value as Map<Object?, Object?>;
                          String phone = data['phone'].toString();
                          return Text('${phone ?? "N/A"}',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        }
                    ),
                    IconButton(
                        onPressed: (){


                          },
                        icon: Icon(
                          Icons.edit,
                        )),
                  ],
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,

                  children: [
                    FutureBuilder<DataSnapshot>(
                        future: FirebaseDatabase.instance.ref().child('drivers').child(FirebaseAuth.instance.currentUser!.uid).child('car_details').get(),
                        builder: (context, snapShot) {
                          Map<Object?, Object?> data = snapShot.data!.value as Map<Object?, Object?>;
                          String car_model = data['car_model'].toString();
                          return Text('${car_model ?? "N/A"}',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        }
                    ),
                    IconButton(
                        onPressed: (){


                        },
                        icon: Icon(
                          Icons.edit,
                        )),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,

                  children: [
                    FutureBuilder<DataSnapshot>(
                        future: FirebaseDatabase.instance.ref().child('drivers').child(FirebaseAuth.instance.currentUser!.uid).child('car_details').get(),
                        builder: (context, snapShot) {
                          Map<Object?, Object?> data = snapShot.data!.value as Map<Object?, Object?>;
                          String car_number = data['car_number'].toString();
                          return Text('${car_number ?? "N/A"}',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        }
                    ),
                    IconButton(
                        onPressed: (){


                        },
                        icon: Icon(
                          Icons.edit,
                        )),
                  ],
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,

                  children: [
                    FutureBuilder<DataSnapshot>(
                        future: FirebaseDatabase.instance.ref().child('drivers').child(FirebaseAuth.instance.currentUser!.uid).child('car_details').get(),
                        builder: (context, snapShot) {
                          Map<Object?, Object?> data = snapShot.data!.value as Map<Object?, Object?>;
                          String car_color = data['car_color'].toString();
                          return Text('${car_color ?? "N/A"}',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        }
                    ),
                    IconButton(
                        onPressed: (){


                        },
                        icon: Icon(
                          Icons.edit,
                        )),
                  ],
                ),
                FutureBuilder<DataSnapshot>(
                    future: FirebaseDatabase.instance.ref().child('drivers').child(FirebaseAuth.instance.currentUser!.uid).get(),
                    builder: (context, snapShot) {
                      Map<Object?, Object?> data = snapShot.data!.value as Map<Object?, Object?>;
                      String email = data['email'].toString();
                      return Text('${email ?? "N/A"}',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    }
                ),



              ],
            ),
          ),
        ),

      ),
    );
  }
}
