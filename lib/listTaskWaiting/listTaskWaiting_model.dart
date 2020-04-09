import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ListTaskWaitingModel extends ChangeNotifier {
  QuerySnapshot taskSnapshot;
  bool isGet = false;
  bool isLoaded = false;

  Future getTaskSnapshot() async {
    FirebaseAuth.instance.currentUser().then((user) {
      user.getIdToken().then((token) async {
        isLoaded = false;
        notifyListeners();
        Firestore.instance
            .collection('task')
            .where('group', isEqualTo: token.claims['group'])
            .orderBy('date', descending: false)
            .snapshots()
            .listen((data) {
          taskSnapshot = data;
          notifyListeners();
        });
        isGet = true;
        isLoaded = true;
        notifyListeners();
      });
    });
  }
}
