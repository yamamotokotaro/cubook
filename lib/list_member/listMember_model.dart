import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class ListMemberModel extends ChangeNotifier {
  QuerySnapshot userSnapshot;
  FirebaseUser currentUser;
  bool isGet = false;
  String group;
  dynamic team;
  String position;
  String teamPosition;
  String group_claim;
  Map<String, dynamic> claims = new Map<String, dynamic>();

  void getGroup() async {
    String group_before = group;
    String teamPosition_before = teamPosition;
    FirebaseAuth.instance.currentUser().then((user) {
      Firestore.instance
          .collection('user')
          .where('uid', isEqualTo: user.uid)
          .getDocuments()
          .then((snapshot) {
        DocumentSnapshot userSnapshot = snapshot.documents[0];
        group = userSnapshot['group'];
        team = userSnapshot['team'];
        position = userSnapshot['position'];
        teamPosition = userSnapshot['teamPosition'];
        if (group != group_before || teamPosition != teamPosition_before) {
          notifyListeners();
        }
      });
      user.getIdToken(refresh: true).then((value) {
        String group_claim_before = group_claim;
        group_claim = value.claims['group'];
        if (group_claim_before != group_claim) {
          notifyListeners();
        }
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
            .orderBy('age_turn', descending: true)
            .orderBy('name')
            .snapshots();
      } else {
        return Firestore.instance
            .collection('user')
            .where('group', isEqualTo: group)
            .where('position', isEqualTo: 'scout')
            .orderBy('team')
            .orderBy('age_turn', descending: true)
            .orderBy('name')
            .snapshots();
      }
    } else {
      return Firestore.instance
          .collection('user')
          .where('group', isEqualTo: group)
          .where('position', isEqualTo: 'scout')
          .orderBy('team')
          .orderBy('age_turn', descending: true)
          .orderBy('name')
          .snapshots();
    }
  }
}
