import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class TaskListScoutModel extends ChangeNotifier {
  DocumentSnapshot userSnapshot;
  Map<String, dynamic> userData = <String, dynamic>{};
  QuerySnapshot effortSnapshot;
  User currentUser;
  bool isGet = false;

  void getSnapshot() async {
    currentUser = FirebaseAuth.instance.currentUser;

    FirebaseFirestore.instance
        .collection('user')
        .where('uid', isEqualTo: currentUser.uid)
        .snapshots()
        .listen((QuerySnapshot<Map<String, dynamic>> data) {
      userSnapshot = data.docs[0];
      userData = userSnapshot.data() as Map<String,dynamic>;
      notifyListeners();
    });
    isGet = true;
    notifyListeners();
  }
}
