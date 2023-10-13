import 'package:assigment_app/servies/auth.dart';
import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import '../../constants/description.dart';
import '../../constants/styles.dart';

class Register extends StatefulWidget {
  final Function toggle;
  const Register({Key? key, required this.toggle}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthServices _auth = AuthServices();

  //from key
  final _formKey = GlobalKey<FormState>();
  // states
  String email = "";
  String password = "";
  String fullName = "";
  String username = "";
  String address1 = "";
  String address2 = "";
  String address3 = "";
  String nicNo = "";
  String contact = "";

  String error = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgBlack,
      appBar: AppBar(
        title: const Text("REGISTER"),
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
                Center(
                    child: Text(
                  "Drive Care",
                  style: titleStyle,
                )),
                //descrption
                const Text(
                  description,
                  style: descriptionStyle,
                ),
                const SizedBox(height: 30),
                Center(
                  child: Image.asset(
                    'assets/images/man.png',
                    height: 200,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        // Full Name
                        TextFormField(
                          style: TextStyle(color: Colors.white),
                          decoration: textInputDecoration.copyWith(
                              hintText: "Full Name"),
                          validator: (val) =>
                              val!.isEmpty ? "Enter your full name" : null,
                          onChanged: (val) {
                            setState(() {
                              fullName = val;
                            });
                          },
                        ),
                        const SizedBox(height: 20),

                        // Username
                        TextFormField(
                          style: TextStyle(color: Colors.white),
                          decoration: textInputDecoration.copyWith(
                              hintText: "Username"),
                          validator: (val) =>
                              val!.isEmpty ? "Enter a valid username" : null,
                          onChanged: (val) {
                            setState(() {
                              username = val;
                            });
                          },
                        ),
                        const SizedBox(height: 20),

                        // Address 1
                        TextFormField(
                          style: TextStyle(color: Colors.white),
                          decoration: textInputDecoration.copyWith(
                              hintText: "Address 1"),
                          validator: (val) =>
                              val!.isEmpty ? "Enter Address 1" : null,
                          onChanged: (val) {
                            setState(() {
                              address1 = val;
                            });
                          },
                        ),
                        const SizedBox(height: 20),

                        // Address 2
                        TextFormField(
                          style: TextStyle(color: Colors.white),
                          decoration: textInputDecoration.copyWith(
                              hintText: "Address 2"),
                          onChanged: (val) {
                            setState(() {
                              address2 = val;
                            });
                          },
                        ),
                        const SizedBox(height: 20),

                        // Address 3
                        TextFormField(
                          style: TextStyle(color: Colors.white),
                          decoration: textInputDecoration.copyWith(
                              hintText: "Address 3"),
                          onChanged: (val) {
                            setState(() {
                              address3 = val;
                            });
                          },
                        ),
                        const SizedBox(height: 20),

                        // NIC Number
                        TextFormField(
                          style: TextStyle(color: Colors.white),
                          decoration: textInputDecoration.copyWith(
                              hintText: "NIC Number"),
                          validator: (val) =>
                              val!.isEmpty ? "Enter a valid NIC number" : null,
                          onChanged: (val) {
                            setState(() {
                              nicNo = val;
                            });
                          },
                        ),
                        const SizedBox(height: 20),

                        // Contact
                        TextFormField(
                          style: TextStyle(color: Colors.white),
                          decoration:
                              textInputDecoration.copyWith(hintText: "Contact"),
                          validator: (val) => val!.isEmpty
                              ? "Enter a valid contact number"
                              : null,
                          onChanged: (val) {
                            setState(() {
                              contact = val;
                            });
                          },
                        ),
                        const SizedBox(height: 20),

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
                          decoration: textInputDecoration.copyWith(
                              hintText: "Password"),
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
                              //go to the signin page
                              onTap: () {
                                widget.toggle();
                              },
                              child: const Text(
                                "LOGIN",
                                style: TextStyle(
                                    color: mainBlue,
                                    fontWeight: FontWeight.w600),
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
                            dynamic result =
                                await _auth.registerWithEmailAndPassword(
                                    email,
                                    password,
                                    fullName,
                                    username,
                                    address1,
                                    address2,
                                    address3,
                                    nicNo,
                                    contact);

                            if (result == null) {
                              //error
                              setState(() {
                                error = "please enter a valid email!";
                              });
                            }
                          },
                          child: Container(
                            height: 40,
                            width: 200,
                            decoration: BoxDecoration(
                                color: bgBlack,
                                borderRadius: BorderRadius.circular(100),
                                border:
                                    Border.all(width: 2, color: Colors.black)),
                            child: const Center(
                                child: Text(
                              "REGISTER",
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
