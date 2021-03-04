import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DetailActivityModel extends ChangeNotifier {
  QuerySnapshot userSnapshot;
  User currentUser;
  bool isGet = false;
  String group;
  String position;
  String age;
  DateTime date = DateTime.now();
  TextEditingController titleController = TextEditingController();
  bool isLoading = false;
  Map<String, bool> uid_check = new Map<String, bool>();
  Map<String, dynamic> claims = new Map<String, dynamic>();
  String group_claim;

  void getGroup() async {
    String group_before = group;
    User user = await FirebaseAuth.instance.currentUser;
    FirebaseFirestore.instance
        .collection('user')
        .where('uid', isEqualTo: user.uid)
        .get()
        .then((snapshot) {
      DocumentSnapshot documentSnapshot = snapshot.docs[0];
      group = documentSnapshot.data()['group'];
      position = documentSnapshot.data()['position'];
      age = documentSnapshot.data()['age'];
      if (group != group_before) {
        notifyListeners();
      }
      /*user.getIdToken(refresh: true).then((value) {
        String group_claim_before = group_claim;
        group_claim = value.claims['group'];
        if (group_claim_before != group_claim) {
          notifyListeners();
        }
      });*/
    });
  }

  void deleteActivity(String documentID) async {
    FirebaseFirestore.instance
        .collection('activity_personal')
        .where('group', isEqualTo: group)
        .where('activity', isEqualTo: documentID)
        .get()
        .then((value) {
      for (int i = 0; i < value.docs.length; i++) {
        DocumentSnapshot documentSnapshot = value.docs[i];
        FirebaseFirestore.instance
            .collection('activity_personal')
            .doc(documentSnapshot.id)
            .delete();
      }
    });
    FirebaseFirestore.instance
        .collection('activity')
        .doc(documentID)
        .delete();
  }
}
