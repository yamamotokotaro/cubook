import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class ListActivityModel extends ChangeNotifier{
  QuerySnapshot? userSnapshot;
  User? currentUser;
  bool isGet = false;
  String? group;
  String? group_claim;
  Map<String, dynamic> claims = <String, dynamic>{};

<<<<<<< HEAD
  Future<void> getGroup() async {
    final String? groupBefore = group;
    final User user = FirebaseAuth.instance.currentUser!;
      FirebaseFirestore.instance.collection('user').where('uid', isEqualTo: user.uid).get().then((QuerySnapshot<Map<String, dynamic>> snapshot) {
        group = snapshot.docs[0].get('group');
        if(group != groupBefore) {
=======
  void getGroup() async {
    String group_before = group;
    User user = await FirebaseAuth.instance.currentUser;
      FirebaseFirestore.instance.collection('user').where('uid', isEqualTo: user.uid).get().then((snapshot) {
        group = snapshot.docs[0].data()['group'];
        if(group != group_before) {
>>>>>>> develop
          notifyListeners();
        }
        user.getIdTokenResult(true).then((IdTokenResult value) {
          final String? groupClaimBefore = group_claim;
          group_claim = value.claims!['group'];
          if(groupClaimBefore != group_claim) {
            notifyListeners();
          }
        });
      });
  }
}