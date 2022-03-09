import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ListMigrationWaitingModel extends ChangeNotifier {
  QuerySnapshot? taskSnapshot;
  String? group;
  String? team;
  String? teamPosition;
  String? group_claim;
  bool isGet = false;
  bool isLoaded = false;

  void getSnapshot() async {
    final String? groupBefore = group;
    final String? teamPositionBefore = teamPosition;
    final User user = FirebaseAuth.instance.currentUser!;
    FirebaseFirestore.instance
        .collection('user')
        .where('uid', isEqualTo: user.uid)
        .get()
        .then((QuerySnapshot<Map<String, dynamic>> snapshot) {
      final DocumentSnapshot userSnapshot = snapshot.docs[0];
      group = userSnapshot.get('group');
      if(userSnapshot.get('position') == 'scout') {
        team = userSnapshot.get('team');
        teamPosition = userSnapshot.get('teamPosition');
      }
      if (group != groupBefore || teamPosition != teamPositionBefore) {
        notifyListeners();
      }
    });
  }
}
