import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CreateActivityModel extends ChangeNotifier {
  QuerySnapshot userSnapshot;
  FirebaseUser currentUser;
  bool isGet = false;
  String group;
  DateTime date = DateTime.now();
  TextEditingController titleController = TextEditingController();
  bool isLoading = false;
  Map<String, bool> uid_check = new Map<String, bool>();
  bool EmptyError = false;

  void getGroup() async {
    String group_before = group;
    FirebaseAuth.instance.currentUser().then((user) {
      currentUser = user;
      user.getIdToken(refresh: true).then((token) async {
        group = token.claims['group'];
        if (group != group_before) {
          notifyListeners();
        }
      });
    });
  }

  void openTimePicker(DateTime dateTime, BuildContext context) async {
    DateTime date_get = await showDatePicker(
      context: context,
      firstDate: DateTime(DateTime.now().year - 5),
      lastDate: DateTime(DateTime.now().year + 5),
      initialDate: dateTime,
    );
    if (date_get != null) {
      date = date_get;
      notifyListeners();
    }
  }

  void onCheckMember(String uid) {
    if (uid_check[uid] != null) {
      uid_check[uid] = !uid_check[uid];
    } else {
      uid_check[uid] = false;
    }
    notifyListeners();
  }

  void onSend(BuildContext context) async {
    if (titleController.text != '') {
      var list_absent = new List<dynamic>();
      int count = 0;
      FirebaseAuth.instance.currentUser().then((user) {
        String userUid = user.uid;
        user.getIdToken().then((token) async {
          print(token.claims['group']);
          String userGroup = token.claims['group'];
          Firestore.instance
              .collection('user')
              .where('group', isEqualTo: token.claims['group'])
              .where('position', isEqualTo: 'scout')
              .getDocuments()
              .then((user) async {
            for (int i = 0; i < user.documents.length; i++) {
              DocumentSnapshot snapshot = user.documents[i];
              String uid_user = snapshot['uid'];
              bool isCheck = true;
              if (uid_check[uid_user] != null) {
                isCheck = uid_check[uid_user];
              }
              if (isCheck) {
                count++;
              }
              Map<String, dynamic> userInfo = new Map<String, dynamic>();
              userInfo['title'] = titleController.text;
              userInfo['date'] = date;
              userInfo['uid'] = uid_user;
              userInfo['name'] = snapshot['name'];
              userInfo['absent'] = isCheck;
              userInfo['age'] = snapshot['age'];
              userInfo['age_turn'] = snapshot['age_turn'];
              userInfo['team'] = snapshot['team'];
              userInfo['group'] = userGroup;
              list_absent.add(userInfo);
            }
            Map<String, dynamic> activityInfo = new Map<String, dynamic>();
            activityInfo['group'] = userGroup;
            activityInfo['count_absent'] = count;
            activityInfo['count_user'] = user.documents.length;
            activityInfo['title'] = titleController.text;
            activityInfo['date'] = date;
            activityInfo['uid'] = userUid;

            Firestore.instance
                .collection('activity')
                .add(activityInfo)
                .then((documant) async {
              for (int i = 0; i < list_absent.length; i++) {
                Map<String, dynamic> userInfo = list_absent[i];
                userInfo['activity'] = documant.documentID;
                await Firestore.instance
                    .collection('activity_personal')
                    .add(userInfo);
              }
            });
            Navigator.pop(context);
            date = DateTime.now();
            titleController.text = '';
            uid_check = new Map<String, bool>();
            EmptyError = false;
          });
        });
      });
    } else {
      EmptyError = true;
      notifyListeners();
    }
  }
}
