import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class ListEffortModel extends ChangeNotifier {
  QuerySnapshot effortSnapshot;
  bool isGet = false;
  String group;
  String position;

  void getSnapshot() async {
    String group_before = group;
    String position_before = position;
    FirebaseAuth.instance.currentUser().then((user) {
      user.getIdToken(refresh: true).then((token) async {
        group = token.claims['group'];
        position = token.claims['position'];
        if(group != group_before || position != position_before) {
          notifyListeners();
        }
      });
    });
  }

  void increaseCount(String documentID) async {
    Firestore.instance
        .collection('effort')
        .document(documentID)
        .updateData(<String, dynamic>{'congrats': FieldValue.increment(1)});
  }

  void deleteEffort(String documentID) async {
    Firestore.instance
        .collection('effort')
        .document(documentID)
        .delete();
  }
}
