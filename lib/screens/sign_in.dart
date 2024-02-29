// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:ahmed_zoala_shop/screens/home.dart';
import 'package:ahmed_zoala_shop/screens/register.dart';
import 'package:ahmed_zoala_shop/shared/constants.dart';
import 'package:ahmed_zoala_shop/shared/snackbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool isVisable = false;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isLoading = false;

  signIn() async {
    setState(() {
      isLoading = true;
    });
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);
     Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => Home())
     );
    } on FirebaseAuthException catch (e) {
         if ('${e.code}' == 'invalid-credential') {
               showSnackBar(context, "Account Not Found");
          } else {
      showSnackBar(context, "${e.code}");
      }
    }

// Stop indicator
    if (!mounted) return;
    setState(() {
      isLoading = false;
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    emailController.dispose();
    passwordController.dispose();
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
            child: Text('Sign In', style: TextStyle(color: Colors.blueGrey)),
          )
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(33.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 64,
                ),
                TextField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    obscureText: false,
                    decoration: decorationTextfield.copyWith(
                        hintText: "Enter Your Email : ",
                        suffixIcon: Icon(Icons.email),
                        fillColor: Color.fromARGB(255, 83, 102, 119)
                      )),
                const SizedBox(
                  height: 33,
                ),
                TextField(
                    controller: passwordController,
                    keyboardType: TextInputType.text,
                    obscureText: isVisable ? false : true,
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
                                : Icon(Icons.visibility_off),
                                ),
                                fillColor: Color.fromARGB(255, 83, 102, 119)
                                )),
                const SizedBox(
                  height: 33,
                ),
                ElevatedButton(
                  onPressed: () async {
                    await signIn();
                    if (!mounted) return;
                    // showSnackBar(context, "Done ... ");
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Color.fromARGB(255, 83, 102, 119)),
                    padding: MaterialStateProperty.all(EdgeInsets.all(12)),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8))),
                  ),
                  child: isLoading ? CircularProgressIndicator(
                          color: Colors.white,
                        ) : Text(
                    "Sign in",
                    style: TextStyle(fontSize: 19, color: Colors.blueGrey),
                  ),
                ),
                const SizedBox(
                  height: 33,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Do not have an account?",
                        style: TextStyle(fontSize: 18)),
                    TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => Register()),
                          );
                        },
                        child: Text('sign up',
                            style:
                                TextStyle(color: Colors.black, fontSize: 18))),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}