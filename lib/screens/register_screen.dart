import 'package:carpool_users/global/global.dart';
import 'package:carpool_users/screens/main_screen.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'car_info_screen.dart';

import 'forgot_password_screen.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {

  final nameTextEditingController= TextEditingController();
  final emailTextEditingController= TextEditingController();
  final phoneTextEditingController= TextEditingController();
  final passwordTextEditingController= TextEditingController();
  final confirmTextEditingController= TextEditingController();

  bool passwordVisible = false;

  //declare global key
  final _formKey = GlobalKey<FormState>();

void _submit() async{
  //validate all the form fields
  if (_formKey.currentState!.validate()) {
await firebaseAuth.createUserWithEmailAndPassword(
    email: emailTextEditingController.text.trim(),
    password: passwordTextEditingController.text.trim()
).then((auth) async{
currentUser = auth.user;

if(currentUser !=null) {
  await currentUser!.sendEmailVerification();
  Map userMap = {
    "id": currentUser!.uid,
    "name": nameTextEditingController.text.trim(),
    "email": emailTextEditingController.text.trim(),
    "phone": phoneTextEditingController.text.trim(),

  };
  DatabaseReference userRef = FirebaseDatabase.instance.reference().child("drivers");
  userRef.child(currentUser!.uid).set(userMap);

}
await Fluttertoast.showToast(msg: "Succesfully Registered.We have sent an email verification");
Navigator.push(context, MaterialPageRoute(builder: (context) => CarInfoScreen()));

}).catchError((errorMessage){
  Fluttertoast.showToast(msg: "Error occurred");
});
  }
  else {
    Fluttertoast.showToast(msg: "Not all fields are valid");
  }

}


  @override
  Widget build(BuildContext context) {

    bool darkTheme = MediaQuery.of(context).platformBrightness == Brightness.dark;
    return GestureDetector(
      onTap: () {
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
                  'Register',
                  style: TextStyle(
                    color: darkTheme ? Colors.amber.shade400 : Colors.blue,
                    fontSize: 25,
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
                                hintText: "Name",
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
                                nameTextEditingController.text = text;
                              }),

                            ),

                            SizedBox(height: 20,),
                            TextFormField(
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(100)
                              ],
                              decoration: InputDecoration(
                                hintText: "Email",
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
                                  return "Email can\'t be empty";
                                }
                                if(EmailValidator.validate(text) == true){
                                  return null;
                                }

                                if(text.length < 3) {
                                  return "Please enter a valid email";
                                }
                                if(text.length > 99){
                                  return "Email can\'t be more than 100 characters";
                                }
                              },
                              onChanged: (text) => setState(() {
                                emailTextEditingController.text = text;
                              }),

                            ),

                            SizedBox(height: 20,),

                            IntlPhoneField(
                              showCountryFlag: false,
                              dropdownIcon: Icon(
                                Icons.arrow_drop_down,
                                color: darkTheme ? Colors.amber.shade400 : Colors.grey,
                              ),
                              decoration: InputDecoration(
                                hintText: "Phone",
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


                              ),
                              initialCountryCode: 'KE',
                              onChanged: (text) => setState(() {
                                phoneTextEditingController.text = text.completeNumber;
                              }),
                            ),

                            SizedBox(height: 10,),
                            TextFormField(
                              obscureText: !passwordVisible,
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(50)
                              ],
                              decoration: InputDecoration(
                                hintText: "Password",
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
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    passwordVisible ? Icons.visibility : Icons.visibility_off,
                                    color: darkTheme ? Colors.amber.shade400 : Colors.grey,



                                  ),
                                  onPressed: () {
                                    //update the state i.e toggle the state of passwordVisible variable
                                    setState(() {
                                    passwordVisible = !passwordVisible;
                                    });


                                  },
                                )

                              ),
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              validator: (text) {
                                if(text == null || text.isEmpty){
                                  return "Password can\'t be empty";
                                }
                                List<String> errors = [];
                                if (text.length < 8) {
                                  errors.add("Password should be at least 8 characters long");
                                }
                                if (!RegExp(r'[0-9]').hasMatch(text)) {
                                  errors.add("Password should include at least one number");
                                }
                                if (!RegExp(r'[A-Z]').hasMatch(text)) {
                                  errors.add("Password should include at least one capital letter");
                                }
                                if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(text)) {
                                  errors.add("Password should include at least one special character");
                                }
                                if (errors.isNotEmpty) {
                                  return errors.join(', ');
                                }
                                return null;
                              },
                              onChanged: (text) => setState(() {
                                passwordTextEditingController.text = text;
                              }),

                            ),

                            SizedBox(height: 10,),
                            TextFormField(
                              obscureText: !passwordVisible,
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(50)
                              ],
                              decoration: InputDecoration(
                                  hintText: "confirm Password",
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
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      passwordVisible ? Icons.visibility : Icons.visibility_off,
                                      color: darkTheme ? Colors.amber.shade400 : Colors.grey,



                                    ),
                                    onPressed: () {
                                      //update the state i.e toggle the state of passwordVisible variable
                                      setState(() {
                                        passwordVisible = !passwordVisible;
                                      });


                                    },
                                  )

                              ),
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              validator: (text) {
                                if(text == null || text.isEmpty){
                                  return "confirm Password can\'t be empty";
                                }
                                if(text !=passwordTextEditingController.text){
                                  return "password doesn\'t match";
                                }
                                if(text.length < 8) {
                                  return "Please enter a valid password";
                                }
                                if (!RegExp(r'[0-9]').hasMatch(text)) {
                                  return "Password must include at least one digit";
                                }
                                if (!RegExp(r'[A-Z]').hasMatch(text)) {
                                  return "Password must include at least one capital letter";
                                }
                                if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(text)) {
                                  return "Password must include at least one special character";
                                }
                                if(text.length > 49){
                                  return "Password can\'t be more than 50 characters";
                                }
                                return null;
                              },
                              onChanged: (text) => setState(() {
                                confirmTextEditingController.text = text;
                              }),

                            ),
                            
                            SizedBox(height: 20),

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
                                  'Register',
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
