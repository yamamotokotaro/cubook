import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class LeaderHomeModel extends ChangeNotifier {
  QuerySnapshot? taskSnapshot;
  bool isLoaded = false;
  bool isGet = false;
  String? group;
  String? group_claim;
  dynamic team;
  String? teamPosition;
  String? uid;
  Map<String, dynamic> claims = <String, dynamic>{};

  Future<void> getSnapshot(BuildContext context) async {
    final String? groupBefore = group;
    final String? teamPositionBefore = teamPosition;
    final User user = FirebaseAuth.instance.currentUser!;
    FirebaseFirestore.instance
        .collection('user')
        .where('uid', isEqualTo: user.uid)
        .get()
        .then((QuerySnapshot<Map<String, dynamic>> snapshot) async {
      final DocumentSnapshot userSnapshot = snapshot.docs[0];
      group = userSnapshot['group'];
      if (userSnapshot.get('position') == 'scout') {
        team = userSnapshot.get('team');
        teamPosition = userSnapshot.get('teamPosition');
      }
      user.getIdTokenResult(true).then((IdTokenResult value) {
        final String? groupClaimBefore = group_claim;
        group_claim = value.claims!['group'];
        if (groupClaimBefore != group_claim) {
          notifyListeners();
        }
      });
      if (group != groupBefore || teamPosition != teamPositionBefore) {
        notifyListeners();
      }
    });
  }

  Stream<QuerySnapshot> getTaskSnapshot(String? group) {
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

Future<void> launchTermURL() async {
  const String url =
      'https://github.com/yamamotokotaro/cubook/blob/master/Terms/Terms_of_Service.md';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

Future<void> launchPrivacyURL() async {
  const String url =
      'https://github.com/yamamotokotaro/cubook/blob/master/Terms/Privacy_Policy.md';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}
