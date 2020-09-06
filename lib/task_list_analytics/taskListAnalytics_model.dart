import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class TaskListAnalyticsModel extends ChangeNotifier{
  DocumentSnapshot userSnapshot;
  FirebaseUser currentUser;
  String group;
  String group_claim;
  bool isGet = false;

  void getGroup() async {
    String group_before = group;
    FirebaseAuth.instance.currentUser().then((user) {
      Firestore.instance.collection('user').where('uid', isEqualTo: user.uid).getDocuments().then((snapshot) {
        group = snapshot.documents[0]['group'];
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

  void getSnapshot(String uid) async {
    print(uid);
    FirebaseAuth.instance.currentUser().then((user) {
      currentUser = user;
      user.getIdToken().then((token) async {
        Firestore.instance.collection('user').where('group', isEqualTo: token.claims['group']).where('uid', isEqualTo: uid).snapshots().listen((data) {
          userSnapshot = data.documents[0];
          notifyListeners();
        });
        isGet = true;
      });
    });
  }
}