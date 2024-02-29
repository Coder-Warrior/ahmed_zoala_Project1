// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, sort_child_properties_last

import 'package:ahmed_zoala_shop/providers/theme.dart';
import 'package:ahmed_zoala_shop/screens/home.dart';
import 'package:ahmed_zoala_shop/screens/sign_in.dart';
import 'package:ahmed_zoala_shop/shared/constants.dart';
import 'package:ahmed_zoala_shop/shared/snackbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

class UserEdit extends StatefulWidget {
  UserEdit({Key? key}) : super(key: key);

  @override
  State<UserEdit> createState() => _UserEditState();
}

class _UserEditState extends State<UserEdit> {

  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  final usernameController = TextEditingController();

  edit() async {
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
       List theIds = [];
       await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).update({
        'username': usernameController.text
       });

      Map<String, dynamic> currentUserData = {};

      DocumentSnapshot dd = await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).get();

      currentUserData = dd.data() as Map<String, dynamic>;       

       QuerySnapshot qq = await FirebaseFirestore.instance.collection('chats').get();

      print(currentUserData['username']);

       qq.docs.forEach((element) {
        Map<String, dynamic> data = element.data() as Map<String, dynamic>;
        if (data['uid'] == currentUserData['uid']) {
          print('newId Fround: ${data['msgOwner']}');
          theIds.add(data['newId']);
        } 
       });

       
       theIds.forEach((element) async {
          print('the newId Fround: $element');
        await FirebaseFirestore.instance.collection('chats').doc(element).update(
            {
          'msgOwner': currentUserData['username']
            }
        );
       });


        Navigator.pushReplacement(
          context, 
          MaterialPageRoute(
            builder: (context) => Home()
          )
      );
      }
    } catch (e) {
      print('error in editing username => $e');
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
    usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
  final thet = Provider.of<Themey>(context);

    return SafeArea(
      child: Scaffold(
      backgroundColor: thet.mode == 'Dark' ? Color.fromARGB(255, 47, 51, 54) : Colors.white,
      appBar: AppBar(
      backgroundColor: thet.mode == 'Dark' ? Color.fromARGB(255, 47, 51, 54) : Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back,
           color: thet.mode == 'Dark' ? Colors.white : Colors.black
          )
        ),
        title: Text('Edit Your Name', style: TextStyle(fontSize: 27, fontWeight: FontWeight.bold, color: thet.mode == 'Dark' ? Colors.white : Colors.black)),
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
                        obscureText: false,
                        decoration: decorationTextfield.copyWith(
                            hintText: "Enter Your Username : ",
                            suffixIcon: Icon(Icons.person),
                            fillColor: Color.fromARGB(255, 83, 102, 119), // لون التعبئة
                       )),

                    SizedBox(height: 25),

                    ElevatedButton(
                      onPressed: () {
                       if (_formKey.currentState!.validate()) {
                          edit();
                        }
                      },
                      child: isLoading
                          ? CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : Text(
                              "Edit Username",
                              style: TextStyle(fontSize: 19, color: Colors.blueGrey),
                            ),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Color.fromARGB(255, 83, 102, 119)),
                        padding: MaterialStateProperty.all(EdgeInsets.all(12)),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8))),
                      ),
                    ),

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