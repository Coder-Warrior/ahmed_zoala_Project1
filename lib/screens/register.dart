// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, sort_child_properties_last

import 'package:ahmed_zoala_shop/screens/home.dart';
import 'package:ahmed_zoala_shop/screens/sign_in.dart';
import 'package:ahmed_zoala_shop/shared/constants.dart';
import 'package:ahmed_zoala_shop/shared/snackbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Register extends StatefulWidget {
  Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  bool isVisable = true;

  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final usernameController = TextEditingController();

  bool isPassword8Char = false;
  bool isPasswordHas1Number = false;
  bool hasUppercase = false;
  bool hasLowercase = false;
  bool hasSpecialCharacters = false;

  onPasswordChanged(String password) {
    isPassword8Char = false;
    isPasswordHas1Number = false;
    hasUppercase = false;
    hasLowercase = false;
    hasSpecialCharacters = false;
    setState(() {
      if (password.contains(RegExp(r'.{8,}'))) {
        isPassword8Char = true;
      }

      if (password.contains(RegExp(r'[0-9]'))) {
        isPasswordHas1Number = true;
      }

       if (password.contains(  RegExp(r'[A-Z]')     )) {
        hasUppercase = true;
      }

   if (password.contains(  RegExp(r'[a-z]')     )) {
        hasLowercase = true;
      }

 if (password.contains( RegExp(r'[!@#$%^&*(),.?":{}|<>]')     )) {
        hasSpecialCharacters = true;
      }



    });
  }

  register() async {
    setState(() {
      isLoading = true;
    });
  
   bool usernameExsists = false;

    try {
      QuerySnapshot q = await FirebaseFirestore.instance.collection('users').get();
      q.docs.forEach((element) {
        Map<String, dynamic> myData = element.data() as Map<String, dynamic>;
        if (myData['username'] == usernameController.text) {
          usernameExsists = true;
        }
      });
      if (usernameExsists) {
        showSnackBar(context, 'Username Already Used');
      } else {

                  final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      await FirebaseFirestore.instance.collection('users').doc(credential.user!.uid).set(
        {
          'username': usernameController.text,
          'email': emailController.text,
          'password': passwordController.text,
          'Rank': 'member',
          'ord': 3,
          'uid': credential.user!.uid,
          'blocked': false
        }
      );

        Navigator.pushReplacement(
          context, 
          MaterialPageRoute(
            builder: (context) => Home()
          )
      );
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        showSnackBar(context, "The password provided is too weak.");
      } else if (e.code == 'email-already-in-use') {
        showSnackBar(context, "The account already exists for that email.");
      }
    } catch (err) {
      showSnackBar(context, err.toString());
    }

    setState(() {
      isLoading = false;
    });
  }

bool containsSpecialCharacters(String text) {
  // Pattern to match special characters other than underscore (_)
  final RegExp specialChars = RegExp(r'[^\w\s]');
  return specialChars.hasMatch(text);
}

  @override
  void dispose() {
    // TODO: implement dispose
    emailController.dispose();
    passwordController.dispose();
    usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color.fromARGB(255, 247, 247, 247),
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 50, 60, 70),
          elevation: 0,
          title: Center(
            child: Text('Register', style: TextStyle(color: Colors.blueGrey)),
          )
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(33.0),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                        // we return "null" when something is valid
                        validator: (value) {
                          return value!.length < 3
                              ? 'Username Must Be At Least 3 Characters'
                              : value!.length > 25 
                              ? "Username Cant Be Morethan 25 Characters"
                              : containsSpecialCharacters(value) 
                              ? "Username Cant Contains Special Characters"
                              : null;
                        },
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: usernameController,
                        keyboardType: TextInputType.emailAddress,
                        obscureText: false,
                        decoration: decorationTextfield.copyWith(
                            hintText: "Enter Your Username : ",
                            suffixIcon: Icon(Icons.email),
                             fillColor: Color.fromARGB(255, 83, 102, 119), // لون التعبئة
                       )),
                    const SizedBox(
                      height: 33,
                    ),
                    TextFormField(
                        // we return "null" when something is valid
                        validator: (email) {
                          return email!.contains(RegExp(
                                  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+"))
                              ? null
                              : "Enter a valid email";
                        },
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        obscureText: false,
                        decoration: decorationTextfield.copyWith(
                            hintText: "Enter Your Email : ",
                            suffixIcon: Icon(Icons.email),
                             fillColor: Color.fromARGB(255, 83, 102, 119), // لون التعبئة
                            )),
                    const SizedBox(
                      height: 33,
                    ),
                    TextFormField(
                        onChanged: (password) {
                          onPasswordChanged(password);
                        },
                        // we return "null" when something is valid
                        validator: (value) {
                          return value!.length < 8
                              ? "Enter at least 8 characters"
                              : value!.length > 25
                              ? "Password Cant Be Morethan 25 Characters"
                              : null;
                        },
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: passwordController,
                        keyboardType: TextInputType.text,
                        obscureText: isVisable ? true : false,
                        decoration: decorationTextfield.copyWith(
                            hintText: "Enter Your Password : ",
                            suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    isVisable = !isVisable;
                                  });
                                },
                                icon: isVisable
                                    ? Icon(Icons.visibility)
                                    : Icon(Icons.visibility_off)),
                                    
                             fillColor: Color.fromARGB(255, 83, 102, 119) // لون التعبئة


                                    )),
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      children: [
                        Container(
                          child: Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 15,
                          ),
                          height: 20,
                          width: 20,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color:
                                isPassword8Char ? Colors.green : Colors.white,
                            border: Border.all(
                                color: Color.fromARGB(255, 189, 189, 189)),
                          ),
                        ),
                        SizedBox(
                          width: 11,
                        ),
                        Text("At least 8 characters"),
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      children: [
                        Container(
                          child: Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 15,
                          ),
                          height: 20,
                          width: 20,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isPasswordHas1Number
                                ? Colors.green
                                : Colors.white,
                            border: Border.all(
                                color: Color.fromARGB(255, 189, 189, 189)),
                          ),
                        ),
                        SizedBox(
                          width: 11,
                        ),
                        Text("At least 1 number"),
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      children: [
                        Container(
                          child: Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 15,
                          ),
                          height: 20,
                          width: 20,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: hasUppercase? Colors.green:  Colors.white,
                            border: Border.all(
                                color: Color.fromARGB(255, 189, 189, 189)),
                          ),
                        ),
                        SizedBox(
                          width: 11,
                        ),
                        Text("Has Uppercase"),
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      children: [
                        Container(
                          child: Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 15,
                          ),
                          height: 20,
                          width: 20,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: hasLowercase? Colors.green : Colors.white,
                            border: Border.all(
                                color: Color.fromARGB(255, 189, 189, 189)),
                          ),
                        ),
                        SizedBox(
                          width: 11,
                        ),
                        Text("Has  Lowercase "),
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      children: [
                        Container(
                          child: Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 15,
                          ),
                          height: 20,
                          width: 20,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: hasSpecialCharacters? Colors.green :  Colors.white,
                            border: Border.all(
                                color: Color.fromARGB(255, 189, 189, 189)),
                          ),
                        ),
                        SizedBox(
                          width: 11,
                        ),
                        Text("Has  Special Characters "),
                      ],
                    ),
                    const SizedBox(
                      height: 33,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (isPasswordHas1Number == false || hasLowercase == false || hasSpecialCharacters == false || hasUppercase == false) {
                          if (isPasswordHas1Number == false) {
                          showSnackBar(context, "Password Must Be Has At Least 1 Number");
                          } else if (hasLowercase == false) {
                          showSnackBar(context, "Password Must Be Has Lowercase");
                          } else if (hasUppercase == false) {
                          showSnackBar(context, "Password Must Be Has Uppercase");
                          } else if (hasSpecialCharacters == false) {
                          showSnackBar(context, "Password Must Be Has At Least 1 Special Character");
                          }
                        } else if (_formKey.currentState!.validate()) {
                          register();
                        }
                      },
                      child: isLoading
                          ? CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : Text(
                              "Register",
                              style: TextStyle(fontSize: 19, color: Colors.blueGrey),
                            ),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Color.fromARGB(255, 83, 102, 119)),
                        padding: MaterialStateProperty.all(EdgeInsets.all(12)),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8))),
                      ),
                    ),
                    const SizedBox(
                      height: 33,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Already Have An Account?",
                            style: TextStyle(fontSize: 18)),
                        TextButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Login()
                                ),
                              );
                            },
                            child: Text('sign in',
                                style: TextStyle(
                                    color: Colors.black, fontSize: 18))),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}