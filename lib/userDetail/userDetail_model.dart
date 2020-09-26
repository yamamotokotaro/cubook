import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class UserDetailModel extends ChangeNotifier {
  DocumentSnapshot userSnapshot;
  FirebaseUser currentUser;
  bool isGet = false;
  String group;
  String group_before = '';
  String group_claim;
  String teamPosition;
  Map<String, dynamic> claims = new Map<String, dynamic>();

  void getGroup() async {
    String group_before = group;
    String teamPosition_before = teamPosition;
    FirebaseAuth.instance.currentUser().then((user) {
      Firestore.instance
          .collection('user')
          .where('uid', isEqualTo: user.uid)
          .getDocuments()
          .then((snapshot) {
        userSnapshot = snapshot.documents[0];
        group = userSnapshot['group'];
        teamPosition = userSnapshot['teamPosition'];
        if (group != group_before || teamPosition != teamPosition_before) {
          notifyListeners();
        }
        user.getIdToken(refresh: true).then((value) {
          String group_claim_before = group_claim;
          group_claim = value.claims['group'];
          if (group_claim_before != group_claim) {
            notifyListeners();
          }
        });
      });
    });
  }

  void onTapCititation(String documentID) {
    Firestore.instance
        .collection('challenge')
        .document(documentID)
        .updateData(<String, dynamic>{'isCitationed': true});
  }
}
