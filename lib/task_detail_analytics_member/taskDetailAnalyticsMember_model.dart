import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class TaskDetailAnalyticsMemberModel extends ChangeNotifier{
  DocumentSnapshot userSnapshot;
  FirebaseUser currentUser;
  String group;
  String team;
  String group_claim;
  String teamPosition;
  bool isGet = false;

  void getGroup() async {
    String group_before = group;
    FirebaseAuth.instance.currentUser().then((user) {
      Firestore.instance.collection('user').where('uid', isEqualTo: user.uid).getDocuments().then((snapshot) {
        DocumentSnapshot userSnapshot = snapshot.documents[0];
        group = userSnapshot['group'];
        team = userSnapshot['team'];
        teamPosition = userSnapshot['teamPosition'];
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

  Stream<QuerySnapshot> getUserSnapshot() {
    if (teamPosition != null) {
      if (teamPosition == 'teamLeader') {
        return Firestore.instance
            .collection('user')
            .where('group', isEqualTo: group)
            .where('position', isEqualTo: 'scout')
            .where('team', isEqualTo: team)
            .snapshots();
      } else {
        return Firestore.instance
            .collection('user')
            .where('group', isEqualTo: group)
            .where('position', isEqualTo: 'scout')
            .snapshots();
      }
    } else {
      return Firestore.instance
          .collection('user')
          .where('group', isEqualTo: group)
          .where('position', isEqualTo: 'scout')
          .snapshots();
    }
  }
}