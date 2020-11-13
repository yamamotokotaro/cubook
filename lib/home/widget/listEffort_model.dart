import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class ListEffortModel extends ChangeNotifier {
  QuerySnapshot effortSnapshot;
  bool isGet = false;
  String group;
  String position;
  String group_claim;
  Map<String, dynamic> claims = new Map<String, dynamic>();

  void getSnapshot() async {
    String group_before = group;
    String position_before = position;
    User user = await FirebaseAuth.instance.currentUser;
    FirebaseFirestore.instance
        .collection('user')
        .where('uid', isEqualTo: user.uid)
        .get()
        .then((snapshot) {
      DocumentSnapshot documentSnapshot = snapshot.docs[0];
      group = documentSnapshot.data()['group'];
      position = documentSnapshot.data()['position'];
      if (group != group_before || position != position_before) {
        notifyListeners();
      }
      user.getIdTokenResult(true).then((value) {
        print(value.claims);
        String group_claim_before = group_claim;
        group_claim = value.claims['group'];
        if (group_claim_before != group_claim) {
          notifyListeners();
        }
      });
    });
  }

  void increaseCount(String documentID) async {
    FirebaseFirestore.instance
        .collection('effort')
        .doc(documentID)
        .update(<String, dynamic>{'congrats': FieldValue.increment(1)});
  }

  void deleteEffort(String documentID) async {
    FirebaseFirestore.instance.collection('effort').doc(documentID).delete();
  }
}
