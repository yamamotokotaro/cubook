import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class TaskListScoutModel extends ChangeNotifier {
  DocumentSnapshot userSnapshot;
  QuerySnapshot effortSnapshot;
  User currentUser;
  bool isGet = false;

  void getSnapshot() async {
    currentUser = await FirebaseAuth.instance.currentUser;

    FirebaseFirestore.instance
        .collection('user')
        .where('uid', isEqualTo: currentUser.uid)
        .snapshots()
        .listen((data) {
      userSnapshot = data.docs[0];
      notifyListeners();
    });
    isGet = true;
    notifyListeners();
  }
}
