import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class AddLumpScoutListModel extends ChangeNotifier{
  List<DocumentSnapshot> userSnapshot;
  FirebaseUser currentUser;
  bool isGet = false;

  var list_isTarget = new List<bool>();

  void getSnapshot() async {
    FirebaseAuth.instance.currentUser().then((user) {
      currentUser = user;
      user.getIdToken().then((token) async {
        Firestore.instance.collection('user').where('group', isEqualTo: token.claims['group']).where('position', isEqualTo: 'scout').getDocuments().then((data) {
          userSnapshot = data.documents;
          list_isTarget = new List<bool>.generate(userSnapshot.length, (index) => false);
          isGet = true;
          notifyListeners();
        });
      });
    });
  }

  void onPressedCheck(int index) {
    list_isTarget[index] = !list_isTarget[index];
    notifyListeners();
  }
}