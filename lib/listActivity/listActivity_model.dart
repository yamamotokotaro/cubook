import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class ListActivityModel extends ChangeNotifier{
  QuerySnapshot userSnapshot;
  User currentUser;
  bool isGet = false;
  String group;
  String group_claim;
  Map<String, dynamic> claims = new Map<String, dynamic>();

  void getGroup() async {
    String group_before = group;
    User user = await FirebaseAuth.instance.currentUser;
      FirebaseFirestore.instance.collection('user').where('uid', isEqualTo: user.uid).getDocuments().then((snapshot) {
        group = snapshot.docs[0].data()['group'];
        if(group != group_before) {
          notifyListeners();
        }
        /*user.getIdToken(refresh: true).then((value) {
          String group_claim_before = group_claim;
          group_claim = value.claims['group'];
          if(group_claim_before != group_claim) {
            notifyListeners();
          }
        });*/
      });
  }
}