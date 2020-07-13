import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class ListAbsentModel extends ChangeNotifier {
  DocumentSnapshot userSnapshot;
  FirebaseUser currentUser;
  bool isGet = false;
  String group;
  String position;
  String group_before = '';
  String position_before = '';
  String group_claim;
  Map<String, dynamic> claims = new Map<String, dynamic>();

  void getGroup() async {
    String group_before = group;
    String position_before = position;
    FirebaseAuth.instance.currentUser().then((user) {
      Firestore.instance.collection('user').where('uid', isEqualTo: user.uid).getDocuments().then((snapshot) {
        DocumentSnapshot documentSnapshot = snapshot.documents[0];
        group = documentSnapshot['group'];
        position = documentSnapshot['position'];
        if (group != group_before || position != position_before) {
          notifyListeners();
        }
      });
      user.getIdToken(refresh: true).then((value) {
        String group_claim_before = group_claim;
        group_claim = value.claims['group'];
        if(group_claim_before != group_claim) {
          notifyListeners();
        }
      });
    });
  }
}
