import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class TaskListScoutConfirmModel extends ChangeNotifier {
  DocumentSnapshot userSnapshot;
  User currentUser;
  bool isGet = false;

  void getSnapshot(String uid) async {
    print(uid);
    User user = await FirebaseAuth.instance.currentUser;
    currentUser = user;
    user.getIdTokenResult().then((token) async {
      FirebaseFirestore.instance
          .collection('user')
          .where('group', isEqualTo: token.claims['group'])
          .where('uid', isEqualTo: uid)
          .snapshots()
          .listen((data) {
        userSnapshot = data.docs[0];
        notifyListeners();
      });
      isGet = true;
    });
  }
}
