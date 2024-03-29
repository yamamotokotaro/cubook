import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class NotificationModel extends ChangeNotifier {
  String? uid;
  String? uid_before;
  String? group;
  String? group_before;

  Future<void> getUser() async {
    final User user = FirebaseAuth.instance.currentUser!;
    uid = user.uid;
    FirebaseFirestore.instance
        .collection('user')
        .where('uid', isEqualTo: uid)
        .get()
        .then((QuerySnapshot<Map<String, dynamic>> value) {
      final DocumentSnapshot documentSnapshot = value.docs[0];
      FirebaseFirestore.instance
          .collection('user')
          .doc(documentSnapshot.id)
          .update(
              <String, dynamic>{'time_notificationChecked': DateTime.now()});
    });
    if (uid != uid_before) {
      uid_before = uid;
      notifyListeners();
    }
  }
}
