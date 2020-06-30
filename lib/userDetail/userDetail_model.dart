import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class UserDetailModel extends ChangeNotifier {
  DocumentSnapshot userSnapshot;
  FirebaseUser currentUser;
  bool isGet = false;
  String group;
  String group_before = '';
  Map<String, dynamic> claims = new Map<String, dynamic>();

  void getSnapshot(String uid) async {
    FirebaseAuth.instance.currentUser().then((user) {
      currentUser = user;
      Firestore.instance.collection('user').where('uid', isEqualTo: user.uid).getDocuments().then((snapshot) {
        Firestore.instance
            .collection('user')
            .where('group', isEqualTo: snapshot.documents[0]['group'])
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
    String group_before = group;
    FirebaseAuth.instance.currentUser().then((user) {
      Firestore.instance.collection('user').where('uid', isEqualTo: user.uid).getDocuments().then((snapshot) {
        group = snapshot.documents[0]['group'];
        if(group != group_before) {
          notifyListeners();
        }
        user.getIdToken(refresh: true).then((value) {
          Map<String, dynamic> claims_before = new Map<String,dynamic>.from(value.claims);
          if(claims_before != claims) {
            notifyListeners();
          }
        });
      });
    });
  }

  void onTapCititation(String documentID){
    Firestore.instance.collection('challenge').document(documentID).updateData(<String, dynamic>{'isCitationed': true});
  }
}
