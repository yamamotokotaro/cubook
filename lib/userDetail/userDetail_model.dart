import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class UserDetailModel extends ChangeNotifier {
  DocumentSnapshot userSnapshot;
  FirebaseUser currentUser;
  bool isGet = false;
  String group;
  String group_before = '';

  void getSnapshot(String uid) async {
    FirebaseAuth.instance.currentUser().then((user) {
      currentUser = user;
      user.getIdToken().then((token) async {
        Firestore.instance
            .collection('user')
            .where('group', isEqualTo: token.claims['group'])
            .where('uid', isEqualTo: uid)
            .getDocuments()
            .then((data) {
          userSnapshot = data.documents[0];
          notifyListeners();
        });
        isGet = true;
      });
    });
  }

  void getGroup() async {
    if (group != group_before) {
      group_before = group;
      FirebaseAuth.instance.currentUser().then((user) {
        user.getIdToken(refresh: true).then((token) async {
          group = token.claims['group'];
          notifyListeners();
        });
      });
    }
  }

  void onTapCititation(String documentID){
    Firestore.instance.collection('challenge').document(documentID).updateData(<String, dynamic>{'isCitationed': true});
  }
}
