import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class ListActivityModel extends ChangeNotifier{
  QuerySnapshot userSnapshot;
  FirebaseUser currentUser;
  bool isGet = false;
  String group;

  void getGroup() async {
    String group_before = group;
    FirebaseAuth.instance.currentUser().then((user) {
      user.getIdToken().then((token) async {
        group = token.claims['group'];
        if(group != group_before) {
          notifyListeners();
        }
      });
    });
  }
}