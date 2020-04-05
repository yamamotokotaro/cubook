import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class StepModel extends ChangeNotifier{
  final FirebaseAuth _auth = FirebaseAuth.instance;
  DocumentSnapshot userSnapshot;
  QuerySnapshot effortSnapshot;
  FirebaseUser currentUser;
  StreamSubscription<FirebaseUser> _listener;
  bool isGet = false;

  void getSnapshot() async {
    currentUser = await _auth.currentUser();
    currentUser?.getIdToken(refresh: true);

    _listener = _auth.onAuthStateChanged.listen((FirebaseUser user) {
      currentUser = user;
      Firestore.instance.collection('user').where('uid', isEqualTo: currentUser.uid).snapshots().listen((data) {
        userSnapshot = data.documents[0];
        notifyListeners();
      });
      isGet = true;
      notifyListeners();
    });
  }
}