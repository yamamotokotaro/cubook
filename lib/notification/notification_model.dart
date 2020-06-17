import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class NotificationModel extends ChangeNotifier{
  String uid;
  String uid_before;
  String group;
  String group_before;

  void getUser() async {
    FirebaseAuth.instance.currentUser().then((user) {
      uid = user.uid;
      print(uid);
      if(uid != uid_before){
        uid_before = uid;
        notifyListeners();
      }
    });
  }
}