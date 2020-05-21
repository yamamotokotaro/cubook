import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class ListEffortModel extends ChangeNotifier {
  QuerySnapshot effortSnapshot;
  bool isGet = false;
  String group;

  void getSnapshot() async {
    String group_before = group;
    FirebaseAuth.instance.currentUser().then((user) {
      user.getIdToken(refresh: true).then((token) async {
        group = token.claims['group'];
        if(group != group_before) {
          notifyListeners();
        }
      });
    });
    /*FirebaseAuth.instance.currentUser().then((user) {
      user.getIdToken(refresh: true).then((token) async {
        print(token.claims);
        if (token.claims['group'] != null) {
          Firestore.instance
              .collection('effort')
              .where('group', isEqualTo: token.claims['group'])
              .orderBy('time', descending: true)
              .snapshots()
              .listen((data) {
            effortSnapshot = data;
            isGet = true;
            notifyListeners();
          });
        }
      });
    });*/
  }

  void increaseCount(String documentID) async {
    Firestore.instance
        .collection('effort')
        .document(documentID)
        .updateData(<String, dynamic>{'congrats': FieldValue.increment(1)});
  }
}
