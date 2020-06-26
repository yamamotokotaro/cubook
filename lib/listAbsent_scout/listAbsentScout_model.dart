import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class ListAbsentScoutModel extends ChangeNotifier {
  DocumentSnapshot userSnapshot;
  FirebaseUser currentUser;
  bool isGet = false;
  String uid;
  String uid_before = '';

  void getUser() async {
    if (uid != uid_before) {
      uid_before = uid;
      FirebaseAuth.instance.currentUser().then((user) {
        uid = user.uid;
        notifyListeners();
      });
    }
  }
}
