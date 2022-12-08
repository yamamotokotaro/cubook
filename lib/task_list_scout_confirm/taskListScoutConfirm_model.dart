
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class TaskListScoutConfirmModel extends ChangeNotifier {
  DocumentSnapshot? userSnapshot;
  Map<String, dynamic>? userData = <String, dynamic>{};
  User? currentUser;
  bool isGet = false;

  Future<void> getSnapshot(String? uid) async {
    print(uid);
    final User user = FirebaseAuth.instance.currentUser!;
    currentUser = user;
    user.getIdTokenResult().then((IdTokenResult token) async {
      FirebaseFirestore.instance
          .collection('user')
          .where('group', isEqualTo: token.claims!['group'])
          .where('uid', isEqualTo: uid)
          .snapshots()
          .listen((QuerySnapshot<Map<String, dynamic>> data) {
        userSnapshot = data.docs[0];
        userData = userSnapshot!.data() as Map<String,dynamic>?;
        notifyListeners();
      });
      isGet = true;
    });
  }
}
