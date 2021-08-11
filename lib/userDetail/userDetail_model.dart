import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class UserDetailModel extends ChangeNotifier {
  DocumentSnapshot userSnapshot;
  User currentUser;
  bool isGet = false;
  String uid;
  String group;
  String group_before = '';
  String group_claim;
  String teamPosition;
  Map<String, dynamic> claims = <String, dynamic>{};
  Map<String, dynamic> userData = <String, dynamic>{};

  void getSnapshot(String uid) async {
    final User user = FirebaseAuth.instance.currentUser;
    currentUser = user;
    FirebaseFirestore.instance
        .collection('user')
        .where('uid', isEqualTo: user.uid)
        .get()
        .then((snapshot) {
      FirebaseFirestore.instance
          .collection('user')
          .where('group', isEqualTo: snapshot.docs[0].get('group'))
          .where('uid', isEqualTo: uid)
          .get()
          .then((data) {
        userSnapshot = data.docs[0];
        userData = userSnapshot.data() as Map<String, dynamic>;
        notifyListeners();
      });
      isGet = true;
    });
  }

  void getGroup() async {
    final String groupBefore = group;
    final String teamPositionBefore = teamPosition;
    final String uidBefore = uid;
    final User user = FirebaseAuth.instance.currentUser;
    FirebaseFirestore.instance
        .collection('user')
        .where('uid', isEqualTo: user.uid)
        .get()
        .then((snapshot) {
      userSnapshot = snapshot.docs[0];
      group = userSnapshot.get('group');
      uid = userSnapshot.get('uid');
      if(userSnapshot.get('position') == "scout") {
        teamPosition = userSnapshot.get('teamPosition');
      }
      if (group != groupBefore || teamPosition != teamPositionBefore || uid != uidBefore) {
        notifyListeners();
      }
      user.getIdTokenResult().then((value) {
        final String groupClaimBefore = group_claim;
        group_claim = value.claims['group'];
        if (groupClaimBefore != group_claim) {
          notifyListeners();
        }
      });
    });
  }

  void onTapCititation(String documentID) {
    FirebaseFirestore.instance
        .collection('challenge')
        .doc(documentID)
        .update(<String, dynamic>{'isCitationed': true});
  }
}
