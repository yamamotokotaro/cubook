import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class ListScoutModel extends ChangeNotifier{
  QuerySnapshot userSnapshot;
  FirebaseUser currentUser;
  bool isGet = false;

  void getSnapshot() async {
    FirebaseAuth.instance.currentUser().then((user) {
      currentUser = user;
      user.getIdToken().then((token) async {
        Firestore.instance.collection('user').where('group', isEqualTo: token.claims['group']).where('position', isEqualTo: 'scout').getDocuments().then((data) {
          userSnapshot = data;
          notifyListeners();
        });
        isGet = true;
        notifyListeners();
      });
    });
  }
}