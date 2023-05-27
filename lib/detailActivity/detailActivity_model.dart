import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DetailActivityModel extends ChangeNotifier {
  QuerySnapshot? userSnapshot;
  User? currentUser;
  bool isGet = false;
  String? group;
  String? position;
  String? age;
  DateTime date = DateTime.now();
  TextEditingController titleController = TextEditingController();
  bool isLoading = false;
  Map<String, bool> uid_check = <String, bool>{};
  Map<String, dynamic> claims = <String, dynamic>{};
  String? group_claim;

  Future<void> getGroup() async {
    final String? groupBefore = group;
    final User user = FirebaseAuth.instance.currentUser!;
    FirebaseFirestore.instance
        .collection('user')
        .where('uid', isEqualTo: user.uid)
        .get()
        .then((QuerySnapshot<Map<String, dynamic>> snapshot) {
      final DocumentSnapshot documentSnapshot = snapshot.docs[0];
      group = documentSnapshot.get('group');
      position = documentSnapshot.get('position');
      age = documentSnapshot.get('age');
      if (group != groupBefore) {
        notifyListeners();
      }
      /*user.getIdToken(refresh: true).then((value) {
        String group_claim_before = group_claim;
        group_claim = value.claims['group'];
        if (group_claim_before != group_claim) {
          notifyListeners();
        }
      });*/
    });
  }

  Future<void> deleteActivity(String? documentID) async {
    FirebaseFirestore.instance
        .collection('activity_personal')
        .where('group', isEqualTo: group)
        .where('activity', isEqualTo: documentID)
        .get()
        .then((QuerySnapshot<Map<String, dynamic>> value) {
      for (int i = 0; i < value.docs.length; i++) {
        final DocumentSnapshot documentSnapshot = value.docs[i];
        FirebaseFirestore.instance
            .collection('activity_personal')
            .doc(documentSnapshot.id)
            .delete();
      }
    });
    FirebaseFirestore.instance.collection('activity').doc(documentID).delete();
  }
}
