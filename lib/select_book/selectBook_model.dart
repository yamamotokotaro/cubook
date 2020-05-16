import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class SelectBookModel extends ChangeNotifier{
  DocumentSnapshot userSnapshot;
  FirebaseUser currentUser;
  bool isGet = false;

  void getSnapshot(String uid) async {
    FirebaseAuth.instance.currentUser().then((user) {
      currentUser = user;
      user.getIdToken().then((token) async {
        Firestore.instance.collection('user').where('group', isEqualTo: token.claims['group']).where('uid', isEqualTo: uid).getDocuments().then((data) {
          userSnapshot = data.documents[0];
          notifyListeners();
        });
        isGet = true;
      });
    });
  }
}