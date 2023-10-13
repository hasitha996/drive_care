import 'package:assigment_app/constants/colors.dart';
import 'package:assigment_app/constants/description.dart';
import 'package:assigment_app/servies/auth.dart';
import 'package:flutter/material.dart';
import '../../constants/styles.dart';


class SignIn extends StatefulWidget {
  //function
  final Function toggle;
  const SignIn({Key? key, required this.toggle}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  //ref for the AuthServices class
  final AuthServices _auth = AuthServices();

  //from key
  final _formKey = GlobalKey<FormState>();
  //email password states
  String email = "";
  String password = "";
  String error = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
    
      appBar: AppBar(
        title: const Text("SIGN IN"),
        elevation: 0,
       backgroundColor: bgBlack,
      ),
         body: Container(
    decoration: BoxDecoration(
      gradient: LinearGradient(
        // Define the gradient colors here
        colors: [Colors.blue, Colors.white],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
    ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 15, right: 10),
          child: Column(
            children: [
              //descrption
              const Text(
                appname,
                style: titleStyle,
              ),

              Center(
                child: Image.asset(
                  'assets/images/man.png',
                  height: 150,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      //email
                      TextFormField(
                        style: TextStyle(color: Colors.white),
                        decoration: textInputDecoration,
                        validator: (val) =>
                            val!.isEmpty ? "Enter a valid email" : null,
                        onChanged: (val) {
                          setState(() {
                            email = val;
                          });
                        },
                      ),
                      const SizedBox(height: 20),

                      //password
                      TextFormField(
                        obscureText: true,
                        style: TextStyle(color: Colors.white),
                        decoration:
                            textInputDecoration.copyWith(hintText: "password"),
                        validator: (val) => val!.length < 6
                            ? "Password must be at least 6 characters"
                            : null,
                        onChanged: (val) {
                          setState(() {
                            password = val;
                          });
                        },
                      ),
                      const SizedBox(height: 20),

                      Text(
                        error,
                        style: TextStyle(color: Colors.red),
                      ),
                     
                      const SizedBox(height: 20),
                      //register
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Do not have an account?",
                            style: descriptionStyle,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          GestureDetector(
                            //go to the register page

                            onTap: () {
                              widget.toggle();
                            },

                            child: const Text(
                              "REGISTER",
                              style: TextStyle(
                                  color: mainBlue, fontWeight: FontWeight.w600),
                            ),
                          )
                        ],
                      ),

                      //button
                      const SizedBox(
                        height: 20,
                      ),
                      GestureDetector(
                        //methode for login user
                        onTap: () async {
                          dynamic result = await _auth
                              .signInUsingEmailAndPassword(email, password);

                          if (result == null) {
                            setState(() {
                              error = "Could not signin with those credentials";
                            });
                          }
                        },
                        child: Container(
                          height: 40,
                          width: 200,
                          decoration: BoxDecoration(
                              color: bgBlack,
                              borderRadius: BorderRadius.circular(100),
                              border: Border.all(width: 2, color: Colors.black)),
                          child: const Center(
                              child: Text(
                            "LOGIN",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500),
                          )),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                     
                    ],
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
