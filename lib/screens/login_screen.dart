import 'package:carpool_users/screens/forgot_password_screen.dart';
import 'package:carpool_users/screens/register_screen.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../global/global.dart';
import 'main_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final emailTextEditingController= TextEditingController();
  final passwordTextEditingController= TextEditingController();

  //declare global key
  final _formKey = GlobalKey<FormState>();

  bool passwordVisible = false;

  void _submit() async{
    //validate all the form fields
    if (_formKey.currentState!.validate()) {
      await firebaseAuth.signInWithEmailAndPassword(
          email: emailTextEditingController.text.trim(),
          password: passwordTextEditingController.text.trim()
      ).then((auth) async{
        currentUser = auth.user;


        await Fluttertoast.showToast(msg: "Succesfully logged in");
        Navigator.push(context, MaterialPageRoute(builder: (context) => MainScreen()));

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
                  'Login',
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
                                if(text.length < 8) {
                                  return "Please enter a valid password";
                                }
                                if(text.length > 49){
                                  return "Password can\'t be more than 50 characters";
                                }
                                return null;
                              },
                              onChanged: (text) => setState(() {
                                passwordTextEditingController.text = text;
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
                                  'Login',
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
                                  "Don't have an account?",
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 15,
                                  ),
                                ),

                                SizedBox(width: 5,),

                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterScreen()));
                                  },
                                  child: Text(
                                    "Register",
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
