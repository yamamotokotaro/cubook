import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class ListMemberModel extends ChangeNotifier {
  QuerySnapshot userSnapshot;
  User currentUser;
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
    User user = await FirebaseAuth.instance.currentUser;
    FirebaseFirestore.instance
        .collection('user')
        .where('uid', isEqualTo: user.uid)
        .get()
        .then((snapshot) {
      DocumentSnapshot userSnapshot = snapshot.docs[0];
      group = userSnapshot.data()['group'];
      team = userSnapshot.data()['team'];
      position = userSnapshot.data()['position'];
      teamPosition = userSnapshot.data()['teamPosition'];
      if (group != group_before || teamPosition != teamPosition_before) {
        notifyListeners();
      }
    });
    user.getIdTokenResult(true).then((value) {
      String group_claim_before = group_claim;
      group_claim = value.claims['group'];
      if (group_claim_before != group_claim) {
        notifyListeners();
      }
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
            .orderBy('age_turn', descending: true)
            .orderBy('name')
            .snapshots();
      } else {
        return FirebaseFirestore.instance
            .collection('user')
            .where('group', isEqualTo: group)
            .where('position', isEqualTo: 'scout')
            .orderBy('team')
            .orderBy('age_turn', descending: true)
            .orderBy('name')
            .snapshots();
      }
    } else {
      return FirebaseFirestore.instance
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
