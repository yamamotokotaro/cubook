import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class TaskListAnalyticsModel extends ChangeNotifier {
  DocumentSnapshot userSnapshot;
  User currentUser;
  String group;
  String team;
  String group_claim;
  String teamPosition;
  bool isGet = false;

  void getGroup() async {
    final String groupBefore = group;
    final User user = FirebaseAuth.instance.currentUser;
    FirebaseFirestore.instance
        .collection('user')
        .where('uid', isEqualTo: user.uid)
        .get()
        .then((snapshot) {
      final DocumentSnapshot userSnapshot = snapshot.docs[0];
      group = userSnapshot.get('group');
      team = userSnapshot.get('team');
      teamPosition = userSnapshot.get('teamPosition');
      if (group != groupBefore) {
        notifyListeners();
      }
      user.getIdTokenResult().then((value) {
        final String groupClaimBefore = group_claim;
        group_claim = value.claims['group'];
        if (groupClaimBefore != group_claim) {
          notifyListeners();
        }
      });
    });
  }

  void getSnapshot(String uid) async {
    print(uid);
    final User user = FirebaseAuth.instance.currentUser;
    currentUser = user;
    user.getIdTokenResult().then((token) async {
      FirebaseFirestore.instance
          .collection('user')
          .where('group', isEqualTo: token.claims['group'])
          .where('uid', isEqualTo: uid)
          .snapshots()
          .listen((data) {
        userSnapshot = data.docs[0];
        notifyListeners();
      });
      isGet = true;
    });
  }

  Stream<QuerySnapshot> getUserSnapshot() {
    if (teamPosition != null) {
      if (teamPosition == 'teamLeader') {
        return FirebaseFirestore.instance
            .collection('user')
            .where('group', isEqualTo: group)
            .where('position', isEqualTo: 'scout')
            .where('team', isEqualTo: team)
            .snapshots();
      } else {
        return FirebaseFirestore.instance
            .collection('user')
            .where('group', isEqualTo: group)
            .where('position', isEqualTo: 'scout')
            .snapshots();
      }
    } else {
      return FirebaseFirestore.instance
          .collection('user')
          .where('group', isEqualTo: group)
          .where('position', isEqualTo: 'scout')
          .snapshots();
    }
  }
}
