import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class AnalyticsScoutCompletionModel extends ChangeNotifier {
  DocumentSnapshot? userSnapshot;
  User? currentUser;
  String? group;
  String? team;
  String? group_claim;
  String? teamPosition;
  bool isGet = false;

  Future<void> getGroup() async {
    final String? groupBefore = group;
    final User user = FirebaseAuth.instance.currentUser!;
    FirebaseFirestore.instance
        .collection('user')
        .where('uid', isEqualTo: user.uid)
        .get()
        .then((QuerySnapshot<Map<String, dynamic>> snapshot) {
      final DocumentSnapshot userSnapshot = snapshot.docs[0];
      group = userSnapshot.get('group');
      if (userSnapshot.get('position') == 'scout') {
        team = userSnapshot.get('team');
        teamPosition = userSnapshot.get('teamPosition');
      }
      if (group != groupBefore) {
        notifyListeners();
      }
      user.getIdTokenResult().then((IdTokenResult value) {
        final String? groupClaimBefore = group_claim;
        group_claim = value.claims!['group'];
        if (groupClaimBefore != group_claim) {
          notifyListeners();
        }
      });
    });
  }

  Future<void> getSnapshot(String uid) async {
    final User user = FirebaseAuth.instance.currentUser!;
    currentUser = user;
    user.getIdTokenResult().then((IdTokenResult token) async {
      FirebaseFirestore.instance
          .collection('user')
          .where('group', isEqualTo: token.claims!['group'])
          .where('uid', isEqualTo: uid)
          .snapshots()
          .listen((QuerySnapshot<Map<String, dynamic>> data) {
        userSnapshot = data.docs[0];
        notifyListeners();
      });
      isGet = true;
    });
  }

  Stream<QuerySnapshot> getUserSnapshot(String? type) {
    if (type == 'challenge' || type == 'gino') {
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
    } else if (type == 'tukinowa') {
      if (teamPosition != null) {
        if (teamPosition == 'teamLeader') {
          return FirebaseFirestore.instance
              .collection('user')
              .where('group', isEqualTo: group)
              .where('position', isEqualTo: 'scout')
              .where('age', isEqualTo: 'kuma')
              .where('team', isEqualTo: team)
              .orderBy('age_turn', descending: true)
              .orderBy('name')
              .snapshots();
        } else {
          return FirebaseFirestore.instance
              .collection('user')
              .where('group', isEqualTo: group)
              .where('position', isEqualTo: 'scout')
              .where('age', isEqualTo: 'kuma')
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
            .where('age', isEqualTo: 'kuma')
            .orderBy('team')
            .orderBy('age_turn', descending: true)
            .orderBy('name')
            .snapshots();
      }
    } else {
      if (teamPosition != null) {
        if (teamPosition == 'teamLeader') {
          return FirebaseFirestore.instance
              .collection('user')
              .where('group', isEqualTo: group)
              .where('position', isEqualTo: 'scout')
              .where('age', isEqualTo: type)
              .where('team', isEqualTo: team)
              .orderBy('age_turn', descending: true)
              .orderBy('name')
              .snapshots();
        } else {
          return FirebaseFirestore.instance
              .collection('user')
              .where('group', isEqualTo: group)
              .where('position', isEqualTo: 'scout')
              .where('age', isEqualTo: type)
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
            .where('age', isEqualTo: type)
            .orderBy('team')
            .orderBy('age_turn', descending: true)
            .orderBy('name')
            .snapshots();
      }
    }
  }
}
