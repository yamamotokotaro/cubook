import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DetailActivityModel extends ChangeNotifier {
  QuerySnapshot userSnapshot;
  FirebaseUser currentUser;
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
    FirebaseAuth.instance.currentUser().then((user) {
      Firestore.instance.collection('user').where('uid', isEqualTo: user.uid).getDocuments().then((snapshot) {
        DocumentSnapshot documentSnapshot = snapshot.documents[0];
        group = documentSnapshot['group'];
        position = documentSnapshot['position'];
        age = documentSnapshot['age'];
        if(group != group_before) {
          notifyListeners();
        }
        user.getIdToken(refresh: true).then((value) {
          String group_claim_before = group_claim;
          group_claim = value.claims['group'];
          if(group_claim_before != group_claim) {
            notifyListeners();
          }
        });
      });
    });
  }

  void deleteActivity(String documentID) async {
    Firestore.instance
        .collection('activity_personal')
        .where('group', isEqualTo: group)
        .where('activity', isEqualTo: documentID)
        .getDocuments()
        .then((value) {
      for (int i = 0; i < value.documents.length; i++) {
        DocumentSnapshot documentSnapshot = value.documents[i];
        Firestore.instance
            .collection('activity_personal')
            .document(documentSnapshot.documentID)
            .delete();
      }
    });
    Firestore.instance.collection('activity').document(documentID).delete();
  }
}
