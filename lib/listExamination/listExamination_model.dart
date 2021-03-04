import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class ListExaminationModel extends ChangeNotifier {
  QuerySnapshot userSnapshot;
  User currentUser;
  bool isGet = false;
  String group;
  Map<String, dynamic> claims = new Map<String, dynamic>();

  void getSnapshot() async {
    String group_before = group;
    User user = await FirebaseAuth.instance.currentUser;
    FirebaseFirestore.instance
        .collection('user')
        .where('uid', isEqualTo: user.uid)
        .get()
        .then((snapshot) {
      group = snapshot.docs[0].data()['group'];
      if (group != group_before) {
        notifyListeners();
      }
    });
  }

  void getGroup() async {
    String group_before = group;
    User user = await FirebaseAuth.instance.currentUser;
    FirebaseFirestore.instance
        .collection('user')
        .where('uid', isEqualTo: user.uid)
        .get()
        .then((snapshot) {
      group = snapshot.docs[0].data()['group'];
      if (group != group_before) {
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
