import 'package:ahmed_zoala_shop/providers/blockSafety.dart';
import 'package:ahmed_zoala_shop/providers/theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BlockedUsers extends StatefulWidget {
  const BlockedUsers({super.key});

  @override
  State<BlockedUsers> createState() => _BlockedUsersState();
}

class _BlockedUsersState extends State<BlockedUsers> {
  @override
    void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
       Provider.of<BlockSafety>(context, listen: false).getBlockState();
    });
  }
  Widget build(BuildContext context) {
  final safetyFirst = Provider.of<BlockSafety>(context);
  final thet = Provider.of<Themey>(context);
   
    return safetyFirst.blocked ? 
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

          },
          child: Text('BlockedUsers', style: TextStyle(fontSize: 27, fontWeight: FontWeight.bold, color: thet.mode == 'Dark' ? Colors.white : Colors.black))
        )),
      ),
      body: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .where('blocked', isEqualTo: true)
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
                      return Row(
                        children: [
                           Text(data['username'], style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: thet.mode == 'Dark' ? Colors.white : Colors.black)),
                           SizedBox(width: 20),
                           ElevatedButton(onPressed: () async {
                 await FirebaseFirestore.instance.collection('users').doc(data['uid']).update({'blocked': false});
                           },
             child: Text('Unblock From Community', style: TextStyle(color: const Color.fromARGB(255, 14, 143, 199))),
                           style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(Colors.transparent),
                           ),
                           ),
                        ]
                      );
                    }).toList(),
                  );
                },
              )
    );
  }
}