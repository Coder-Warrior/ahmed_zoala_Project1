import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UsernameProvider with ChangeNotifier {
  bool can = true;
  changetoTrue() {
    can = true;
    notifyListeners();
  }
  changetoFalse() {
    can = false;
    notifyListeners();
  }
  getBlockState() async {
    try {
      await FirebaseFirestore.instance.collection('canChat').snapshots().listen((event) {
        event.docs.forEach((element) {
          Map<String, dynamic> data = element.data() as Map<String, dynamic>;
          if (data['can'] == true) {
            changetoTrue();
          } else if (data['can'] == false) {
            changetoFalse();
          }
        });
      });
    } catch (e) {
      print('Error => $e');
    }
  }

}