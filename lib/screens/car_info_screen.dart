import 'package:carpool_users/global/global.dart';
import 'package:carpool_users/screens/forgot_password_screen.dart';
import 'package:carpool_users/screens/login_screen.dart';
import 'package:carpool_users/screens/main_screen.dart';
import 'package:carpool_users/splashScreen/splash_screen.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class CarInfoScreen extends StatefulWidget {
  const CarInfoScreen({super.key});

  @override
  State<CarInfoScreen> createState() => _CarInfoScreenState();
}

class _CarInfoScreenState extends State<CarInfoScreen> {

  final carModelTextEditingController = TextEditingController();
  final carNumberTextEditingController = TextEditingController();
  final carColorTextEditingController = TextEditingController();
  final carSeatTextEditingController = TextEditingController();

  List<String> carType = ['Car','Van'];
  String? selectedCarType;
  int? selectedCarSeat;

  final _formKey = GlobalKey<FormState>();

  File? licenseFile;

  _submit(){
    if(_formKey.currentState!.validate()){

  Map driverCarInfoMap = {
    'car_model': carModelTextEditingController.text.trim(),
    'car_number': carNumberTextEditingController.text.trim(),
    'car_color': carColorTextEditingController.text.trim(),
    'selectedCarSeat':carSeatTextEditingController.text.trim(),
    'license_file': licenseFile != null ? licenseFile!.path : null,
  };

  // DatabaseReference carRef = FirebaseDatabase.instance.ref().child("car_details");
  // carRef.child(currentUser!.uid).set(driverCarInfoMap); // Set the car details for the current user/driver
  //
  // DatabaseReference driverRef = FirebaseDatabase.instance.ref().child("drivers");
  // driverRef.child(currentUser!.uid).child('car_details').set(driverCarInfoMap); // Set the car details inside the driver node
  // driverRef.child(currentUser!.uid).set(driverCarInfoMap); // Set the remaining driver information


  DatabaseReference carRef = FirebaseDatabase.instance.ref().child("drivers");
  carRef.child(currentUser!.uid).child('car_details').set(driverCarInfoMap);

  Fluttertoast.showToast(msg: "Car details have been saved.Congratulations1");
  Navigator.push(context, MaterialPageRoute(builder: (context) => MainScreen()));


}
}

   Future<void> _chooseLicenseFile() async {
     final picker = ImagePicker();
     final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      licenseFile = pickedFile != null ? File(pickedFile.path) : null;
     });
   }


  @override
  Widget build(BuildContext context) {

    bool darkTheme = MediaQuery.of(context).platformBrightness == Brightness.dark;

    return  GestureDetector(
      onTap: (){
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: ListView(
          padding: EdgeInsets.all(0),
          children: [
            Column(
              children: [
                Image.asset(darkTheme ? 'images/carpool2.jpg' : 'images/carpool1.jpg'),

                SizedBox(height: 20,),

                Text(
                  "Add car details",
                  style: TextStyle(
                    color: darkTheme ? Colors.amber.shade400 : Colors.blue,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.fromLTRB(15,20,15,50),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(50)
                              ],
                              decoration: InputDecoration(
                                hintText: "Car Model",
                                hintStyle: TextStyle(
                                  color: Colors.grey,
                                ),

                                filled: true,
                                fillColor: darkTheme ? Colors.black45 : Colors.grey.shade200,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(40),
                                    borderSide: BorderSide(
                                      width: 0,
                                      style: BorderStyle.none,
                                    )

                                ),
                                prefixIcon: Icon(Icons.person, color: darkTheme ? Colors.amber.shade400 : Colors.grey,),

                              ),
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              validator: (text) {
                                if(text == null || text.isEmpty){
                                  return "Name can\'t be empty";
                                }
                                if(text.length < 3) {
                                  return "Please enter a valid name";
                                }
                                if(text.length > 49){
                                  return "Name can\'t be more than 50 characters";
                                }
                              },
                              onChanged: (text) => setState(() {
                                carModelTextEditingController.text = text;
                              }),

                            ),
                            SizedBox(height: 20),
                            TextFormField(
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(50)
                              ],
                              decoration: InputDecoration(
                                hintText: "Car Number",
                                hintStyle: TextStyle(
                                  color: Colors.grey,
                                ),

                                filled: true,
                                fillColor: darkTheme ? Colors.black45 : Colors.grey.shade200,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(40),
                                    borderSide: BorderSide(
                                      width: 0,
                                      style: BorderStyle.none,
                                    )

                                ),
                                prefixIcon: Icon(Icons.person, color: darkTheme ? Colors.amber.shade400 : Colors.grey,),

                              ),
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              validator: (text) {
                                if(text == null || text.isEmpty){
                                  return "Name can\'t be empty";
                                }
                                if(text.length < 3) {
                                  return "Please enter a valid name";
                                }
                                if(text.length > 49){
                                  return "Name can\'t be more than 50 characters";
                                }
                              },
                              onChanged: (text) => setState(() {
                                carNumberTextEditingController.text = text;
                              }),

                            ),
                            SizedBox(height: 20),
                            TextFormField(
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(50)
                              ],
                              decoration: InputDecoration(
                                hintText: "Car Color",
                                hintStyle: TextStyle(
                                  color: Colors.grey,
                                ),

                                filled: true,
                                fillColor: darkTheme ? Colors.black45 : Colors.grey.shade200,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(40),
                                    borderSide: BorderSide(
                                      width: 0,
                                      style: BorderStyle.none,
                                    )

                                ),
                                prefixIcon: Icon(Icons.person, color: darkTheme ? Colors.amber.shade400 : Colors.grey,),

                              ),
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              validator: (text) {
                                if(text == null || text.isEmpty){
                                  return "Name can\'t be empty";
                                }
                                if(text.length < 3) {
                                  return "Please enter a valid name";
                                }
                                if(text.length > 49){
                                  return "Name can\'t be more than 50 characters";
                                }
                              },
                              onChanged: (text) => setState(() {
                                carColorTextEditingController.text = text;
                              }),

                            ),

                            SizedBox(height: 20),
                            DropdownButtonFormField(
                              decoration: InputDecoration(
                                hintText: "Please choose car type",
                                prefixIcon: Icon(Icons.car_crash, color: darkTheme? Colors.amber.shade400 : Colors.grey),
                                filled: true,
                                fillColor: darkTheme? Colors.black45 : Colors.grey.shade200,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(40),
                                  borderSide: BorderSide(
                                    width: 0,
                                    style: BorderStyle.none,
                                  )
                                )
                              ),
                                items: carType.map((car) {
                                  return DropdownMenuItem(
                                    child: Text(
                                      car,
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                    value: car,
                                  );

                                }).toList(),
                                onChanged: (newValue){
                                setState(() {
                                  selectedCarType = newValue.toString();
                                });
                                }
                            ),

                            SizedBox(height: 20),
                            DropdownButtonFormField<int>(
                              decoration: InputDecoration(
                                hintText: 'Number of Car Seats',
                                hintStyle: TextStyle(color: Colors.grey),
                                filled: true,
                                fillColor: darkTheme ? Colors.black45 : Colors.grey.shade200,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(40),
                                  borderSide: BorderSide(
                                    width: 0,
                                    style: BorderStyle.none,
                                  ),
                                ),
                                prefixIcon: Icon(
                                  Icons.car_crash,
                                  color: darkTheme ? Colors.amber.shade400 : Colors.grey,
                                ),
                              ),
                              value: selectedCarSeat,
                              onChanged: (int? value) {
                                setState(() {
                                  selectedCarSeat = value;
                                });
                              },
                              items: List.generate(
                                10,
                                    (index) => DropdownMenuItem<int>(
                                  value: index + 1,
                                  child: Text((index + 1).toString()),
                                ),
                              ),
                            ),



                            SizedBox(height: 20),

                            ElevatedButton(
                              onPressed: _chooseLicenseFile,
                              style: ElevatedButton.styleFrom(
                                primary: darkTheme ? Colors.amber.shade400 : Colors.blue,
                                onPrimary: Colors.white,
                              ),
                              child: Text(
                                licenseFile != null ? 'Change License File' : 'Choose License File',
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            ),



                            SizedBox(height: 20,),

                            ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: darkTheme ? Colors.amber.shade400 : Colors.blue,
                                  onPrimary: darkTheme ? Colors.black : Colors.white,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(32),
                                  ),
                                  minimumSize: Size(double.infinity, 50),
                                ),
                                onPressed: (){
                                  _submit();
                                },
                                child: Text(
                                  'Confirm',
                                  style: TextStyle(
                                    fontSize: 20,
                                  ),
                                )
                            ),

                            SizedBox(height: 20,),
                            GestureDetector(
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context) => ForgotPasswordScreen()));
                              },
                              child: Text(
                                'Forgot password',
                                style: TextStyle(
                                  color: darkTheme ? Colors.amber.shade400 : Colors.blue,
                                ),
                              ),
                            ),

                            SizedBox(height: 20,),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Have an account?",
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 15,
                                  ),
                                ),

                                SizedBox(width: 5,),

                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
                                  },
                                  child: Text(
                                    "Sign in",
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: darkTheme ? Colors.amber.shade400 : Colors.blue,


                                    ),
                                  ),
                                )
                              ],
                            )




                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
