import 'package:carpool_users/global/global.dart';
import 'package:carpool_users/modals/user_modal.dart';
import 'package:carpool_users/screens/profile_screen.dart';
import 'package:carpool_users/splashScreen/splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';


class DrawerScreen extends StatelessWidget {
  const DrawerScreen({super.key});


  @override
  Widget build(BuildContext context) {
    UserModal? userModalCurrentInfo ;

    return Container(
      width: 220,
      child: Drawer(
        child: Padding(
          padding: EdgeInsets.fromLTRB(30, 50, 0, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
             Column(
               crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                 Container(
                   padding: EdgeInsets.all(30),
                   decoration: BoxDecoration(
                     color: Colors.lightBlue,
                     shape: BoxShape.circle,
                   ),
                   child: Icon(
                     Icons.person,
                     color: Colors.white,
                   ),
                 ),

                 SizedBox(height: 20,),

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

                 SizedBox(height: 10,),
                 GestureDetector(
                   onTap: (){
                     Navigator.push(context, MaterialPageRoute(builder:(c) => ProfileScreen()));

                   },
                   child: Text(
                     'Edit Profile',
                     style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: Colors.blue,
                     ),
                   ),
                 ),

                 SizedBox(height: 20,),
                 Text('Your trips', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),),


                 SizedBox(height: 20,),

                 Text('Payments', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),),

                 SizedBox(height: 20,),

                 Text('Notifications', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),),


                 SizedBox(height: 20,),
                 Text('Help', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),),


                 SizedBox(height: 20,),

               ],
             ),

              GestureDetector(
                onTap: (){
                  firebaseAuth.signOut();
                  Navigator.push(context, MaterialPageRoute(builder:(c) => splashScreen()));

                },
                child: Text(
                  'LogOut',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.red,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
