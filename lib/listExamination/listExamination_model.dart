import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class ListExaminationModel extends ChangeNotifier {
  QuerySnapshot? userSnapshot;
  User? currentUser;
  bool isGet = false;
  String? group;
  Map<String, dynamic> claims = <String, dynamic>{};

  void getSnapshot() async {
    final String? groupBefore = group;
    final User user = FirebaseAuth.instance.currentUser!;
    FirebaseFirestore.instance
        .collection('user')
        .where('uid', isEqualTo: user.uid)
        .get()
        .then((QuerySnapshot<Map<String, dynamic>> snapshot) {
      group = snapshot.docs[0].get('group');
      if (group != groupBefore) {
        notifyListeners();
      }
    });
  }

  void getGroup() async {
    final String? groupBefore = group;
    final User user = FirebaseAuth.instance.currentUser!;
    FirebaseFirestore.instance
        .collection('user')
        .where('uid', isEqualTo: user.uid)
        .get()
        .then((QuerySnapshot<Map<String, dynamic>> snapshot) {
      group = snapshot.docs[0].get('group');
      if (group != groupBefore) {
        notifyListeners();
      }
      /*user.getIdToken(refresh: true).then((value) {
          Map<String, dynamic> claims_before = new Map<String,dynamic>.from(value.claims);
          if(claims_before != claims) {
            notifyListeners();
          }
        });*/
    });
  }
}
