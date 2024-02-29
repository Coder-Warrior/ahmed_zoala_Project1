import 'package:ahmed_zoala_shop/providers/blockSafety.dart';
import 'package:ahmed_zoala_shop/providers/theme.dart';
import 'package:ahmed_zoala_shop/providers/usernameProvider.dart';
import 'package:ahmed_zoala_shop/screens/blocked_users.dart';
import 'package:ahmed_zoala_shop/screens/home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CommunityInfo extends StatefulWidget {
  const CommunityInfo({Key? key}) : super(key: key);

  @override
  State<CommunityInfo> createState() => _CommunityInfoState();
}

class _CommunityInfoState extends State<CommunityInfo> {
  String state = '';
  bool isLoading = false;
  bool enjzny = false;
  bool chat = true;
  Future<void> checkForPermession() async {
    setState(() {
      isLoading = true;
    });
    try {
      QuerySnapshot q =
          await FirebaseFirestore.instance.collection('users').get();
      q.docs.forEach((element) {
        Map<String, dynamic> userData = element.data() as Map<String, dynamic>;
        if (userData['uid'] == FirebaseAuth.instance.currentUser!.uid &&
            userData['Rank'] == 'Owner') {
          setState(() {
            state = 'Owner';
          });
        } else if (userData['uid'] == FirebaseAuth.instance.currentUser!.uid &&
            userData['Rank'] == 'Admin') {
          setState(() {
            state = 'Admin';
          });
        }
      });
    } catch (e) {
      print('Error In Community Info In Check For Permession: $e');
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    
       Future.delayed(Duration.zero, () {
       Provider.of<BlockSafety>(context, listen: false).getBlockState();
    });
        Future.delayed(Duration.zero, () {
       Provider.of<UsernameProvider>(context, listen: false).getBlockState();
    });
    checkForPermession();
  }

  @override
  Widget build(BuildContext context) {
  final safetyFirst = Provider.of<BlockSafety>(context);
  final theVariableruserName = Provider.of<UsernameProvider>(context);
  final thet = Provider.of<Themey>(context);
   
    return safetyFirst.blocked
        ? Scaffold(
      backgroundColor: thet.mode == 'Dark' ? Color.fromARGB(255, 47, 51, 54) : Colors.white,
            body: Center(
                child: Text('You Have Been Blocked :)',
                    style: TextStyle(color: Colors.red, fontSize: 25))))
        : isLoading
            ? Scaffold(
     backgroundColor: thet.mode == 'Dark' ? Color.fromARGB(255, 47, 51, 54) : Colors.white,
                body: Center(
                    child: CircularProgressIndicator(color: thet.mode == 'Dark' ? Colors.white : Colors.blueGrey)))
            : Scaffold(
     backgroundColor: thet.mode == 'Dark' ? Color.fromARGB(255, 47, 51, 54) : Colors.white,
                appBar: AppBar(
     backgroundColor: thet.mode == 'Dark' ? Color.fromARGB(255, 47, 51, 54) : Colors.white,
                  leading: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.arrow_back,
            color: thet.mode == 'Dark' ? Colors.white : Colors.black
                      )),
                  title: Center(
                      child: GestureDetector(
                          onTap: () {},
                          child: Text('Community Info',
                              style: TextStyle(
                                  fontSize: 27, fontWeight: FontWeight.bold, color: thet.mode == 'Dark' ? Colors.white : Colors.black)))),
                  actions: [
                    if (state == "Owner")
                      IconButton(
                          onPressed: () async {
                            if (theVariableruserName.can) {
                              await FirebaseFirestore.instance.collection('canChat').doc('theState').update(
                                {
                                  'can': false
                                }
                              );
                              } else {
                           await FirebaseFirestore.instance.collection('canChat').doc('theState').update(
                                {
                                  'can': true
                                }
                              );
                      }
                          },
                          icon: theVariableruserName.can ? Icon(Icons.chat, color: thet.mode == 'Dark' ? Colors.white : Colors.black) : Icon(Icons.receipt, color: thet.mode == 'Dark' ? Colors.white : Colors.black)),
                    if (state.length != 0)
                      IconButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => BlockedUsers()));
                          },
                          icon: Icon(Icons.block, color: thet.mode == 'Dark' ? Colors.white : Colors.black))
                  ],
                ),
                body: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .orderBy('ord', descending: false)
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

                        if (data['blocked'] == true) {
                          return SizedBox();
                        }

                        return state == 'Owner'
                            ? Row(
                                children: [
                                  if (data['uid'] ==
                                      FirebaseAuth.instance.currentUser!.uid)
                                    Text('You: ${data['username']}',
                                        style: TextStyle(
                                            fontSize: 23,
                                            fontWeight: FontWeight.bold, color: Colors.lightBlue))
                                  else
                                    Row(
                                      children: [
                                        Text('${data['username']}',
                                            style: TextStyle(
                                                fontSize: 23,
                                                fontWeight: FontWeight.bold, color: thet.mode == 'Dark' ? Colors.white : Colors.black)),
                                        if (data['Rank'] == 'Admin')
                                          Container(
                                              margin: EdgeInsets.only(left: 10),
                                              child: Text(data['Rank'],
                                                  style: TextStyle(
                                                      color: Colors.green,
                                                      fontSize: 22,
                                                      ))),
                                        IconButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder:
                        (BuildContext context) {
                      return AlertDialog(
                        backgroundColor: thet.mode == 'Dark' ? Colors.blueGrey : Colors.white,
                        title: Text('You Will', style: TextStyle(color: thet.mode == 'Dark' ? Colors.white : Colors.black)),
                        content: Column(
                          mainAxisSize:
                              MainAxisSize.min,
                          children: [
                            data['Rank'] != 'Admin'
                                ? ElevatedButton(
                                    onPressed:
                                        () async {
                                      await FirebaseFirestore
                                          .instance
                                          .collection(
                                              'users')
                                          .doc(data[
                                              'uid'])
                                          .update({
                                        'Rank':
                                            'Admin',
                                        'ord': 2
                                      });
                                      Navigator.of(
                                              context)
                                          .pop();
                                    },
                                    child: Text(
                                        'Make As Admin',
                                        style: TextStyle(
                                            fontSize:
                                                20,
                                             color: thet.mode == 'Dark' ? Colors.white : Colors.black
                                                )),
                                  style: ButtonStyle(
                                      backgroundColor: MaterialStateProperty.all(
                                      Colors.transparent
                                      ),
                                    ),
                                  )
                                : ElevatedButton(
                                    onPressed:
                                        () async {
                                      await FirebaseFirestore
                                          .instance
                                          .collection(
                                              'users')
                                          .doc(data[
                                              'uid'])
                                          .update({
                                        'Rank':
                                            'member',
                                        'ord': 3
                                      });
                                      Navigator.of(
                                              context)
                                          .pop();
                                    },
                                    child: Text(
                                        'Remove Admin',
                                        style: TextStyle(
                                            fontSize:
                                                20,
                                             color: thet.mode == 'Dark' ? Colors.white : Colors.black
                                            
                                            )),
                                  style: ButtonStyle(
                                      backgroundColor: MaterialStateProperty.all(
                                      Colors.transparent
                                      ),
                                    ),
                                  ),
                            ElevatedButton(
                                onPressed:
                                    () async {
                                  await FirebaseFirestore
                                      .instance
                                      .collection(
                                          'users')
                                      .doc(data[
                                          'uid'])
                                      .update({
                                    'blocked': true,
                                    'Rank':
                                        'member',
                                    'ord': 3
                                  });
                                  Navigator.pop(
                                      context);
                                },
                                child: Text(
                                    'Remove User',
                                    style: TextStyle(
                                        fontSize:
                                            20,
                                             color: thet.mode == 'Dark' ? Colors.white : Colors.black
                                        )),
                                    style: ButtonStyle(
                                      backgroundColor: MaterialStateProperty.all(
                                      Colors.transparent
                                      ),
                                    ),    
                                    )
                          ],
                        ),
                                                  );
                                                },
                                              );
                                            },
                                            icon: Icon(Icons.list, color: thet.mode == 'Dark' ? Colors.white : Colors.black))
                                      ],
                                    )
                                ],
                              )
                            : state == 'Admin'
                                ? Row(
                                    children: [
                                      if (data['uid'] ==
                                          FirebaseAuth
                                              .instance.currentUser!.uid)
                                        Text('You: ${data['username']}',
                                            style: TextStyle(
                                                fontSize: 23,
                                                fontWeight: FontWeight.bold, color: Colors.lightBlue))
                                      else
                                        Row(
                                          children: [
                                            Text('${data['username']}',
                                                style: TextStyle(
                                                    fontSize: 23,
                                                    fontWeight:
                                                        FontWeight.bold, color: thet.mode == 'Dark' ? Colors.white : Colors.black)),
                                            if (data['Rank'] == 'Admin')
                                              Container(
                                                  margin:
                                                      EdgeInsets.only(left: 10),
                                                  child: Text(data['Rank'],
                                                      style: TextStyle(
                                                          color: Colors.green,
                                                          fontSize: 22)))
                                            else if (data['Rank'] == 'Owner')
                                              Container(
                                                margin:
                                                    EdgeInsets.only(left: 10),
                                                child: Text(data['Rank'],
                                                    style: TextStyle(
                                                        color: Colors.blueGrey,
                                                        fontSize: 22)),
                                              ),
                                            data['Rank'] != 'Owner'
                                                ? IconButton(
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext
                                        context) {
                                      return AlertDialog(
                        backgroundColor: thet.mode == 'Dark' ? Colors.blueGrey : Colors.white,
                                        title: Text(
                                            'You Will'),
                                        content: Column(
                                          mainAxisSize:
                                              MainAxisSize
                                                  .min,
                                          children: [
                                            data['Rank'] !=
                                                    'Admin'
                                                ? ElevatedButton(
                                                    onPressed:
                                                        () async {
                                                                          await FirebaseFirestore
                                      .instance
                                      .collection(
                                          'users')
                                      .doc(data[
                                          'uid'])
                                      .update({
                                    'Rank':
                                        'Admin',
                                    'ord':
                                        2
                                  });
                                  Navigator.of(context)
                                      .pop();
                                },
                                child: Text(
                                    'Make As Admin',
                                    style:
                                        TextStyle(fontSize: 20, color: thet.mode == 'Dark' ? Colors.white : Colors.black)),
                                                                            style: ButtonStyle(
                                      backgroundColor: MaterialStateProperty.all(
                                      Colors.transparent
                                      ),
                                    ),
                              )
                            : ElevatedButton(
                                onPressed:
                                    () async {
                                  await FirebaseFirestore
                                      .instance
                                      .collection(
                                          'users')
                                      .doc(data[
                                          'uid'])
                                      .update({
                                    'Rank':
                                        'member',
                                    'ord':
                                        3
                                  });
                                  Navigator.of(context)
                                      .pop();
                                },
                                child: Text(
                                   'Remove Admin',
                                               style:
                                                   TextStyle(fontSize: 20, color: thet.mode == 'Dark' ? Colors.white : Colors.black)),
                                                                             style: ButtonStyle(
                                      backgroundColor: MaterialStateProperty.all(
                                      Colors.transparent
                                      ),
                                    ),
                                         ),
                                   ElevatedButton(
                                       onPressed:
                                           () async {
                                         await FirebaseFirestore
                                             .instance
                                             .collection(
                                                 'users')
                                             .doc(data[
                                                 'uid'])
                                             .update({
                                           'blocked':
                                               true,
                                           'Rank':
                                               'member',
                                           'ord': 3
                                         });
                                         Navigator.pop(
                                             context);
                                       },
                                       child: Text(
                                           'Remove User',
                                           style: TextStyle(
                                               fontSize:
                                                20,
                                                 color: thet.mode == 'Dark' ? Colors.white : Colors.black)),
                                                
                                   style: ButtonStyle(
                                      backgroundColor: MaterialStateProperty.all(
                                      Colors.transparent
                                      ),
                                    ),

                                                )
                                                              ],
                                                            ),
                                                          );
                                                        },
                                                      );
                                                    },
                                                    icon: Icon(Icons.list, color: thet.mode == 'Dark' ? Colors.white : Colors.black))
                                                : SizedBox()
                                          ],
                                        )
                                    ],
                                  )
                                : Row(
                                    children: [
                                      if (data['uid'] ==
                                          FirebaseAuth
                                              .instance.currentUser!.uid)
                                        Text('You: ${data['username']}',
                                            style: TextStyle(
                                                fontSize: 23,
                                                fontWeight: FontWeight.bold, color: Colors.lightBlue))
                                      else
                                        Row(
                                          children: [
                                            Text('${data['username']}',
                                                style: TextStyle(
                                                    fontSize: 23,
                                                    fontWeight:
                                                        FontWeight.bold,
                                                        color: thet.mode == 'Dark' ? Colors.white : Colors.black
                                                        )),
                                            if (data['Rank'] == 'Admin')
                                              Container(
                                                  margin:
                                                      EdgeInsets.only(left: 10),
                                                  child: Text(data['Rank'],
                                                      style: TextStyle(
                                                          color: Colors.green,
                                                          fontSize: 22)))
                                            else if (data['Rank'] == 'Owner')
                                              Container(
                                                margin:
                                                    EdgeInsets.only(left: 10),
                                                child: Text(data['Rank'],
                                                    style: TextStyle(
                                                        color: Colors.blueGrey,
                                                        fontSize: 22)),
                                              ),
                                          ],
                                        )
                                    ],
                                  );
                      }).toList(),
                    );
                  },
                ));
  }
}
