import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class ListCitationWaitingModel extends ChangeNotifier{
  QuerySnapshot userSnapshot;
  FirebaseUser currentUser;
  bool isGet = false;
  String group;

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

  void getGroup() async {
    String group_before = group;
    FirebaseAuth.instance.currentUser().then((user) {
      user.getIdToken(refresh: true).then((token) async {
        group = token.claims['group'];
        if(group != group_before) {
          notifyListeners();
        }
      });
    });
  }
}