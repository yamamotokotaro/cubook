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
    User user = await FirebaseAuth.instance.currentUser;
    FirebaseFirestore.instance
        .collection('user')
        .where('uid', isEqualTo: user.uid)
        .get()
        .then((snapshot) {
      userSnapshot = snapshot.docs[0];
      group = userSnapshot.data()['group'];
      teamPosition = userSnapshot.data()['teamPosition'];
      if (group != group_before || teamPosition != teamPosition_before) {
        notifyListeners();
      }
      user.getIdTokenResult().then((value) {
        String group_claim_before = group_claim;
        group_claim = value.claims['group'];
        if (group_claim_before != group_claim) {
          notifyListeners();
        }
      });
    });
  }

  void onTapCititation(String documentID) {
    FirebaseFirestore.instance
        .collection('challenge')
        .doc(documentID)
        .update(<String, dynamic>{'isCitationed': true});
  }
}
