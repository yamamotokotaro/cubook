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
  Map<String, dynamic> claims = Map<String, dynamic>();

  void getGroup() async {
    final String groupBefore = group;
    final String teamPositionBefore = teamPosition;
    final User user = FirebaseAuth.instance.currentUser;
    FirebaseFirestore.instance
        .collection('user')
        .where('uid', isEqualTo: user.uid)
        .get()
        .then((snapshot) {
      final DocumentSnapshot userSnapshot = snapshot.docs[0];
      group = userSnapshot.get('group');
      team = userSnapshot.get('team');
      position = userSnapshot.get('position');
      teamPosition = userSnapshot.get('teamPosition');
      if (group != groupBefore || teamPosition != teamPositionBefore) {
        notifyListeners();
      }
    });
    user.getIdTokenResult(true).then((value) {
      final String groupClaimBefore = group_claim;
      group_claim = value.claims['group'];
      if (groupClaimBefore != group_claim) {
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

  Stream<QuerySnapshot> getUserSnapshot_less_team() {
    if (teamPosition != null) {
      if (teamPosition == 'teamLeader') {
        return FirebaseFirestore.instance
            .collection('user')
            .where('group', isEqualTo: group)
            .where('position', isEqualTo: 'scout')
            .orderBy('name')
            .snapshots();
      } else {
        return FirebaseFirestore.instance
            .collection('user')
            .where('group', isEqualTo: group)
            .where('position', isEqualTo: 'scout')
            .orderBy('name')
            .snapshots();
      }
    } else {
      return FirebaseFirestore.instance
          .collection('user')
          .where('group', isEqualTo: group)
          .where('position', isEqualTo: 'scout')
          .orderBy('name')
          .snapshots();
    }
  }
}
