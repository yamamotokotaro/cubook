import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class ListEffortModel extends ChangeNotifier {
  QuerySnapshot effortSnapshot;
  bool isGet = false;

  void getSnapshot() async {
    FirebaseAuth.instance.currentUser().then((user) {
      Firestore.instance.collection('efforts').snapshots().listen((data) {
        effortSnapshot = data;
        isGet = true;
        notifyListeners();
      });
    });
  }

  void increaseCount(String documentID) async {
    Firestore.instance
        .collection('efforts')
        .document(documentID)
        .updateData(<String, dynamic>{'congrats': FieldValue.increment(1)});
  }
}
