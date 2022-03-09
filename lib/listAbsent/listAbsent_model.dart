import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class ListAbsentModel extends ChangeNotifier {
  DocumentSnapshot userSnapshot;
  User currentUser;
  bool isGet = false;
  String group;
  String position;
  String group_before = '';
  String position_before = '';
  String group_claim;
  Map<String, dynamic> claims = <String, dynamic>{};

  void getGroup() async {
    final String groupBefore = group;
    final String positionBefore = position;
    final User user = FirebaseAuth.instance.currentUser;
      FirebaseFirestore.instance.collection('user').where('uid', isEqualTo: user.uid).get().then((QuerySnapshot<Map<String, dynamic>> snapshot) {
        final DocumentSnapshot documentSnapshot = snapshot.docs[0];
        group = documentSnapshot.get('group');
        position = documentSnapshot.get('position');
        if (group != groupBefore || position != positionBefore) {
          notifyListeners();
        }
      });
      /*user.getIdToken(refresh: true).then((value) {
        String group_claim_before = group_claim;
        group_claim = value.claims['group'];
        if(group_claim_before != group_claim) {
          notifyListeners();
        }
      });*/
  }
}
