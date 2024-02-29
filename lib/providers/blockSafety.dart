import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class BlockSafety with ChangeNotifier {
  bool blocked = false;
  changeToTrue() {
    blocked = true;
    notifyListeners();
  }
  changeToFalse() {
    blocked = false;
    notifyListeners();
  }

  getBlockState() async {
    try {

      await FirebaseFirestore.instance.collection('users').snapshots().listen((event) {

        event.docs.forEach((element) {
          Map<String, dynamic> e = element.data() as Map<String, dynamic>;
          if (e['uid'] == FirebaseAuth.instance.currentUser!.uid) {
            if (e['blocked'] == true) {
              changeToTrue();
            } else {
              changeToFalse();
            }
          }
        });

      });
    } catch (e) {
      print('Error In Get Block State In Community: $e');
    }
    notifyListeners();
  }

}