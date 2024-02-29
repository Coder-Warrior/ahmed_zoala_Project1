import 'dart:io';

import 'package:ahmed_zoala_shop/providers/theme.dart';
import 'package:ahmed_zoala_shop/screens/about.dart';
import 'package:ahmed_zoala_shop/screens/add_course.dart';
import 'package:ahmed_zoala_shop/screens/community.dart';
import 'package:ahmed_zoala_shop/screens/course_info.dart';
import 'package:ahmed_zoala_shop/screens/edit_course.dart';
import 'package:ahmed_zoala_shop/screens/settings.dart';
import 'package:ahmed_zoala_shop/screens/sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart' as launcher;

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool gettingData = false;
  Map<String, dynamic> myData = {};
  getData() async {
    setState(() {
      gettingData = true;
    });
    try {
      DocumentSnapshot document = await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();
      myData = document.data()! as Map<String, dynamic>;
    } catch (e) {
      print('Error In Getting Data In Home: $e');
    }
    setState(() {
      gettingData = false;
    });
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  Widget build(BuildContext context) {  
  final thet = Provider.of<Themey>(context);
    return gettingData
        ? Scaffold(
              backgroundColor: thet.mode == 'Dark' ? Color.fromARGB(255, 47, 51, 54) : Colors.white,
            body: Center(
                child: CircularProgressIndicator(color: thet.mode == 'Dark' ? Colors.white : Colors.blueGrey)))
        : Scaffold(
              backgroundColor: thet.mode == 'Dark' ? Color.fromARGB(255, 47, 51, 54) : Colors.white,
            appBar: AppBar(
              backgroundColor: thet.mode == 'Dark' ? Color.fromARGB(255, 58, 63, 66) : Colors.white,
              title: Text("Welcome: ${myData['username']}", style: TextStyle(color: thet.mode == 'Dark' ? Colors.white : Colors.black)),
        iconTheme: IconThemeData(
            color: thet.mode == 'Dark' ? Colors.white : Colors.black, // Change the color here
          ),
              ),
            drawer: Drawer(
              backgroundColor: thet.mode == 'Dark' ? Color.fromARGB(255, 47, 51, 54) : Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 65),
                    child: Column(
                      children: [
                        ListTile(
                            title: Text("Home", style: TextStyle(color: thet.mode == 'Dark' ? Colors.white : Colors.black)),
                            leading: Icon(Icons.home, color: thet.mode == 'Dark' ? Colors.white : Colors.black),
                            onTap: () {}),
                        ListTile(
                            title: Text("About", style: TextStyle(color: thet.mode == 'Dark' ? Colors.white : Colors.black)),
                            leading: Icon(Icons.help_center, color: thet.mode == 'Dark' ? Colors.white : Colors.black),
                            onTap: () {
                              Navigator.push(
                                  (context),
                                  MaterialPageRoute(
                                      builder: (context) => AboutZoala()));
                            }),
                        ListTile(
                            title: Text("Settings", style: TextStyle(color: thet.mode == 'Dark' ? Colors.white : Colors.black)),
                            leading: Icon(Icons.settings, color: thet.mode == 'Dark' ? Colors.white : Colors.black),
                            onTap: () {
                     Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => UserSettings())
                              );
                            }),
                        ListTile(
                            title: Text("Community", style: TextStyle(color: thet.mode == 'Dark' ? Colors.white : Colors.black)),
                            leading: Icon(Icons.people, color: thet.mode == 'Dark' ? Colors.white : Colors.black),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => Community())
                              );
                            }
                            ),
                        myData['username'] == "AhmedZoala"
                            ? ListTile(
                                title: Text("AddCourse", style: TextStyle(color: thet.mode == 'Dark' ? Colors.white : Colors.black)),
                                leading: Icon(Icons.add, color: thet.mode == 'Dark' ? Colors.white : Colors.black),
                                onTap: () async {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => AddCourse()));
                                })
                            : SizedBox(),
                        ListTile(
                            title: Text("Logout", style: TextStyle(color: thet.mode == 'Dark' ? Colors.white : Colors.black)),
                            leading: Icon(Icons.exit_to_app, color: thet.mode == 'Dark' ? Colors.white : Colors.black),
                            onTap: () async {
                              await FirebaseAuth.instance.signOut();
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => Login())
                              );
                            }),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 12),
                    child: Text("Developed by Ali Fathi © 2024",
                        style: TextStyle(fontSize: 16, color: thet.mode == 'Dark' ? Colors.white : Colors.black)),
                  )
                ],
              ),
            ),

            body: Container(
              margin: EdgeInsets.only(top: 63),
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('courses')
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Text('Something went wrong');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Text("Loading");
                  }

                  return ListView(
                    children:
                        snapshot.data!.docs.map((DocumentSnapshot document) {
                      Map<String, dynamic> data =
                          document.data()! as Map<String, dynamic>;
                      return data['courseName'] == null
                          ? SizedBox()
                          : theCourse(data['courseName'], data['courseTitle'],
                              data['courseImg'], data, thet);
                    }).toList(),
                  );
                },
              ),
            ));
  }

  Widget theCourse(name, title, img, data, thet) {
    return Container(
      width: MediaQuery.of(context).size.width - 50,
      margin: EdgeInsets.only(bottom: 67),
      child: GestureDetector(
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => CourseInfo(data: data)));
        },
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width - 50,
              child: ClipRRect(
                // لتطبيق حواف منحنية على الصورة
                borderRadius: BorderRadius.circular(5),
                child: Image.network(img),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width - 50,
              margin: EdgeInsets.only(top: 5),
              child: Text(
               name,
               style: TextStyle(
                 fontSize: 23,
                 fontWeight: FontWeight.bold,
                 color: thet.mode == 'Dark' ? Colors.white : Colors.black
               ),
               overflow: TextOverflow.ellipsis,
               maxLines: 1,
                            )
            ),
            Container(
              width: MediaQuery.of(context).size.width - 50,
              margin: EdgeInsets.only(top: 5),
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: thet.mode == 'Dark' ? Colors.white : Colors.black
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
          myData['username'] == "AhmedZoala" ? Row(
            mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => EditCourse(myUrl: [data['courseImg'], data['courseId']])));
                    }, 
                    icon: Icon(Icons.edit, color: thet.mode == 'Dark' ? Colors.white : Colors.black)
                  ),
                  IconButton(
                    onPressed: () async {
                      await FirebaseFirestore.instance.collection('courses').doc(data['courseId']).delete();
                    }, 
                    icon: Icon(Icons.delete, color: thet.mode == 'Dark' ? Colors.white : Colors.black)
                  )
                ],
               ) : SizedBox(),
          ],
        ),
      ),
    );
  }
}
