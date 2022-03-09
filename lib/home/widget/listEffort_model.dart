import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class ListEffortModel extends ChangeNotifier {
  QuerySnapshot? effortSnapshot;
  bool isGet = false;
  String? group;
  String? position;
  String? group_claim;
  Map<String, dynamic> claims = <String, dynamic>{};

  void getSnapshot() async {
    final String? groupBefore = group;
    final String? positionBefore = position;
    final User user = FirebaseAuth.instance.currentUser!;
    FirebaseFirestore.instance
        .collection('user')
        .where('uid', isEqualTo: user.uid)
        .get()
        .then((QuerySnapshot<Map<String, dynamic>> snapshot) {
      final DocumentSnapshot documentSnapshot = snapshot.docs[0];
      group = documentSnapshot.get('group');
      position = documentSnapshot.get('position');
      if (group != groupBefore || position != positionBefore) {
        notifyListeners();
      }
      user.getIdTokenResult(true).then((IdTokenResult value) {
        print(value.claims);
        final String? groupClaimBefore = group_claim;
        group_claim = value.claims!['group'];
        if (groupClaimBefore != group_claim) {
          notifyListeners();
        }
      });
    });
  }

  void increaseCount(String documentID) async {
    FirebaseFirestore.instance
        .collection('effort')
        .doc(documentID)
        .update(<String, dynamic>{'congrats': FieldValue.increment(1)});
  }

  void deleteEffort(String documentID) async {
    FirebaseFirestore.instance.collection('effort').doc(documentID).delete();
  }
}
