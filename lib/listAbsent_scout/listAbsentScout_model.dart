import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class ListAbsentScoutModel extends ChangeNotifier {
  DocumentSnapshot userSnapshot;
  User currentUser;
  bool isGet = false;
  String uid;
  String uid_before = '';

  void getUser() async {
    if (uid != uid_before) {
      uid_before = uid;
      User user = await FirebaseAuth.instance.currentUser;
      uid = user.uid;
      notifyListeners();
    }
  }
}
