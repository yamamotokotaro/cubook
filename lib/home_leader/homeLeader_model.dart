import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeLeaderModel extends ChangeNotifier {
  QuerySnapshot taskSnapshot;
  bool isLoaded = false;

  Future<void> getTaskSnapshot2() async {
    isLoaded = true;
    FirebaseAuth.instance.currentUser().then((user) {
      if (user != null) {
        user.getIdToken(refresh: true).then((token) async {
          Firestore.instance.collection('task').where('group', isEqualTo: token.claims['group']).snapshots().listen((data) {
            taskSnapshot = data;
            notifyListeners();
          });
        });
      }
    });
  }
}

Stream<QuerySnapshot> getTaskSnapshot() {
  FirebaseAuth.instance.currentUser().then((user) {
    if (user != null) {
      user.getIdToken().then((token) {
        return Firestore.instance.collection('task').where('group', isEqualTo: token.claims['group']).snapshots();
      });
    } else {
    }
  });
}
