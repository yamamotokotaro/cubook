import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DetailActivityModel extends ChangeNotifier {
  QuerySnapshot userSnapshot;
  FirebaseUser currentUser;
  bool isGet = false;
  String group;
  DateTime date = DateTime.now();
  TextEditingController titleController = TextEditingController();
  bool isLoading = false;
  Map<String, bool> uid_check = new Map<String, bool>();

  void getGroup() async {
    String group_before = group;
    FirebaseAuth.instance.currentUser().then((user) {
      currentUser = user;
      user.getIdToken().then((token) async {
        group = token.claims['group'];
        if (group != group_before) {
          notifyListeners();
        }
      });
    });
  }

  void deleteActivity(String documentID) async {
    Firestore.instance
        .collection('activity_personal')
        .where('group', isEqualTo: group)
        .where('activity', isEqualTo: documentID)
        .getDocuments()
        .then((value) {
      for (int i = 0; i < value.documents.length; i++) {
        DocumentSnapshot documentSnapshot = value.documents[i];
        Firestore.instance
            .collection('activity_personal')
            .document(documentSnapshot.documentID)
            .delete();
      }
    });
    Firestore.instance.collection('activity').document(documentID).delete();
  }
}
