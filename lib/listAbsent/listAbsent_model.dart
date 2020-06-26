import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class ListAbsentModel extends ChangeNotifier {
  DocumentSnapshot userSnapshot;
  FirebaseUser currentUser;
  bool isGet = false;
  String group;
  String position;
  String group_before = '';
  String position_before = '';

  void getGroup() async {
    String group_before = group;
    String position_before = position;
    FirebaseAuth.instance.currentUser().then((user) {
      user.getIdToken().then((token) async {
        group = token.claims['group'];
        position = token.claims['position'];
        if(group != group_before || position != position_before) {
          notifyListeners();
        }
      });
    });
  }
}
