import 'package:ahmed_zoala_shop/providers/blockSafety.dart';
import 'package:ahmed_zoala_shop/providers/theme.dart';
import 'package:ahmed_zoala_shop/providers/usernameProvider.dart';
import 'package:ahmed_zoala_shop/screens/community_info.dart';
import 'package:ahmed_zoala_shop/shared/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';

class Community extends StatefulWidget {
  const Community({super.key});

  @override
  State<Community> createState() => _CommunityState();
}

class _CommunityState extends State<Community> {
  final msgController = TextEditingController();
  Map<String, dynamic> theDataOfCurrentUser = {};
  bool gettingTheDataOfCurrentUser = false;
  getTheDataOfCurrentUser() async {
    setState(() {
      gettingTheDataOfCurrentUser = true;
    });
    try {
      //  DocumentSnapshot d = await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).get();
       await FirebaseFirestore.instance.collection('users').snapshots().listen((event) { 
        event.docs.forEach((element) {
          Map<String, dynamic> miniMapy = element.data() as Map<String, dynamic>;
          if (miniMapy['uid'] == FirebaseAuth.instance.currentUser!.uid) {
           theDataOfCurrentUser = miniMapy;
          }
        });
       });
       print('got theDataOfCurrentUser!');
    } catch (e) {
      print('Err In theDataOfCurrentUser: $e');
    }
      setState(() {
      gettingTheDataOfCurrentUser = false;
    });
  }

  sendMsg(msg) async {
    String newId = Uuid().v1();
    try {
      await FirebaseFirestore.instance.collection('chats').doc(newId).set(
        {
          'msgContent': msg,
          'uid': FirebaseAuth.instance.currentUser!.uid,
          'datePublished': DateTime.now(),
          'msgOwner': theDataOfCurrentUser['username'],
          'newId': newId
        }
      );
      print('Msg Sent <3');
    } catch (e) {
      print('Erorr In Sending Msg: $e');
    }
  }

  getById(List arr, String id) async {
    for (int i = 0; i < arr.length; i++) {
      Map<String, dynamic> anaZeh2t = arr[i].data() as Map<String, dynamic>;
      if (anaZeh2t['uid'] == id) {
        return anaZeh2t['username'];
      }
    }
  }

  @override
    void initState() {
    super.initState();
    // استدعاء الدالة عند فتح الصفحة
    getTheDataOfCurrentUser();
       Future.delayed(Duration.zero, () {
       Provider.of<BlockSafety>(context, listen: false).getBlockState();
    });
    Future.delayed(Duration.zero, () {
       Provider.of<UsernameProvider>(context, listen: false).getBlockState();
    });
  }

  @override
  void dispose() {
    msgController.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
  final safetyFirst = Provider.of<BlockSafety>(context);
  final theVariableruserName = Provider.of<UsernameProvider>(context);
  final thet = Provider.of<Themey>(context);
 
    return gettingTheDataOfCurrentUser ? Scaffold(
      backgroundColor: thet.mode == 'Dark' ? Color.fromARGB(255, 47, 51, 54) : Colors.white,
      body: Center(
        child: CircularProgressIndicator(color: thet.mode == 'Dark' ? Colors.white : Colors.blueGrey)
      )
    ) : safetyFirst.blocked ? 
    Scaffold(
      backgroundColor: thet.mode == 'Dark' ? Color.fromARGB(255, 47, 51, 54) : Colors.white,
      body: Center(
        child: Text('You Have Been Blocked :)', style: TextStyle(color: Colors.red, fontSize: 25))
      )
    ) : Scaffold(
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
        title: Center(child: GestureDetector(
          onTap: () {
            Navigator.push(
              context, 
              MaterialPageRoute(
                builder: (context) => CommunityInfo()
              )
            );
          },
          child: Text('Community', style: TextStyle(fontSize: 27, fontWeight: FontWeight.bold, color: thet.mode == 'Dark' ? Colors.white : Colors.black))
        )),
      ),

     body: Center(
       child: Column(
        children: [
          Expanded (
          child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('chats')
                    .orderBy('datePublished', descending: false)
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

                      return data['uid'] == FirebaseAuth.instance.currentUser!.uid ? 
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          padding: EdgeInsets.all(7),
                          margin: EdgeInsets.fromLTRB(10,0,0,10),
                            constraints: BoxConstraints(
    maxWidth: 300,
  ),
                          decoration: BoxDecoration(
                            color: Colors.lightBlue,
                            borderRadius: BorderRadius.circular(7),
                          ),
                          child: Text('You: ${data['msgContent']}', style: TextStyle(fontSize: 20))
                        ),
                      ) :
                          Container(
                        alignment: Alignment.centerRight,
                        child: Container(
                          padding: EdgeInsets.all(7),
                          margin: EdgeInsets.fromLTRB(0,0,10,10),
                            constraints: BoxConstraints(
                             maxWidth: 300,
                           ),
                          decoration: BoxDecoration(
                            color: Colors.blueGrey,
                            borderRadius: BorderRadius.circular(7),
                          ),
                          child: Text('${data['msgOwner']}: ${data['msgContent']}', style: TextStyle(fontSize: 20))
                        ),
                      );


                    }).toList(),
                  );

                },
              )
          ),

              
                  if (theDataOfCurrentUser['username'] != "AhmedZoala")
                  theVariableruserName.can ? TextField(
                  controller: msgController,
                    keyboardType: TextInputType.text,
                    obscureText: false,
                    decoration: decorationTextfield.copyWith(
                        hintText: "Type Your Msg <3 ",
                        filled: thet.mode == 'Dark' ? false : true,
                        hintStyle: TextStyle(color: thet.mode == 'Dark' ? Colors.white : Colors.black),
                        suffixIcon: IconButton(
                            onPressed: () async {
                              if (msgController.text.length > 0) {
                              String msg = msgController.text;
                              msgController.clear();
                              await sendMsg(msg);
                              }
                            }, icon: Icon(Icons.send, color: thet.mode == 'Dark' ? Colors.white : Colors.black)))) : Text('AhmedZoala Turned Off Chat :)', style: TextStyle(fontSize: 20, color: Colors.red)) else
                            TextField(
                  controller: msgController,
                    keyboardType: TextInputType.text,
                    obscureText: false,
                    decoration: decorationTextfield.copyWith(
                        hintText: "Type Your Msg <3 ",
                        filled: thet.mode == 'Dark' ? false : true,
                        hintStyle: TextStyle(color: thet.mode == 'Dark' ? Colors.white : Colors.black),
                        suffixIcon: IconButton(
                            onPressed: () async {
                              if (msgController.text.length > 0) {
                              String msg = msgController.text;
                              msgController.clear();
                              await sendMsg(msg);
                              }
                            }, icon: Icon(Icons.send, color: thet.mode == 'Dark' ? Colors.white : Colors.black))))

        ],
       ),
     )

    );
  }
}