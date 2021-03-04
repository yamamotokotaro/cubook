import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ListTaskWaitingModel extends ChangeNotifier {
  QuerySnapshot taskSnapshot;
  String group;
  String team;
  String teamPosition;
  String group_claim;
  bool isGet = false;
  bool isLoaded = false;

  void getSnapshot() async {
    String group_before = group;
    String teamPosition_before = teamPosition;
    User user = await FirebaseAuth.instance.currentUser;
    FirebaseFirestore.instance
        .collection('user')
        .where('uid', isEqualTo: user.uid)
        .get()
        .then((snapshot) {
      DocumentSnapshot userSnapshot = snapshot.docs[0];
      group = userSnapshot.data()['group'];
      team = userSnapshot.data()['team'];
      teamPosition = userSnapshot.data()['teamPosition'];
      if (group != group_before || teamPosition != teamPosition_before) {
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

  Stream<QuerySnapshot> getTaskSnapshot() {
    if (teamPosition != null) {
      if (teamPosition == 'teamLeader') {
        return FirebaseFirestore.instance
            .collection('task')
            .where('group', isEqualTo: group)
            .where('team', isEqualTo: team)
            .where('phase', isEqualTo: 'wait')
            .snapshots();
      } else {
        return FirebaseFirestore.instance
            .collection('task')
            .where('group', isEqualTo: group)
            .where('phase', isEqualTo: 'wait')
            .snapshots();
      }
    } else {
      return FirebaseFirestore.instance
          .collection('task')
          .where('group', isEqualTo: group)
          .where('phase', isEqualTo: 'wait')
          .snapshots();
    }
  }
}
