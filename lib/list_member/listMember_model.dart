import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class ListMemberModel extends ChangeNotifier {
  QuerySnapshot userSnapshot;
  FirebaseUser currentUser;
  bool isGet = false;
  String group;
  String group_claim;
  Map<String, dynamic> claims = new Map<String, dynamic>();

  void getSnapshot() async {
    String group_before = group;
    FirebaseAuth.instance.currentUser().then((user) {
      Firestore.instance
          .collection('user')
          .where('uid', isEqualTo: user.uid)
          .getDocuments()
          .then((snapshot) {
        group = snapshot.documents[0]['group'];
        if (group != group_before) {
          notifyListeners();
        }
      });
    });
  }

  void getGroup() async {
    String group_before = group;
    FirebaseAuth.instance.currentUser().then((user) {
      Firestore.instance
          .collection('user')
          .where('uid', isEqualTo: user.uid)
          .getDocuments()
          .then((snapshot) {
        group = snapshot.documents[0]['group'];
        if (group != group_before) {
          notifyListeners();
        }
      });
      user.getIdToken(refresh: true).then((value) {
        String group_claim_before = group_claim;
        group_claim = value.claims['group'];
        if(group_claim_before != group_claim) {
          notifyListeners();
        }
      });
    });
  }
}
