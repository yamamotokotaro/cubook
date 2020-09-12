import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EditActivityModel extends ChangeNotifier {
  QuerySnapshot userSnapshot;
  DocumentSnapshot activitySnapshot;
  int countSnapshot;
  FirebaseUser currentUser;
  bool isGet = false;
  String group;
  String position;
  String age;
  DateTime date;
  TextEditingController titleController = TextEditingController();
  bool isLoading = false;
  bool EmptyError = false;
  Map<String, bool> uid_check = new Map<String, bool>();
  Map<String, dynamic> claims = new Map<String, dynamic>();
  Map<String, bool> checkAbsents = new Map<String, bool>();
  String group_claim;
  String documentID;

  void getGroup() async {
    String group_before = group;
    FirebaseAuth.instance.currentUser().then((user) {
      Firestore.instance
          .collection('user')
          .where('uid', isEqualTo: user.uid)
          .getDocuments()
          .then((snapshot) {
        DocumentSnapshot documentSnapshot = snapshot.documents[0];
        group = documentSnapshot['group'];
        position = documentSnapshot['position'];
        age = documentSnapshot['age'];
        if (group != group_before) {
          notifyListeners();
        }
        user.getIdToken(refresh: true).then((value) {
          String group_claim_before = group_claim;
          group_claim = value.claims['group'];
          if (group_claim_before != group_claim) {
            notifyListeners();
          }
        });
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

  void getInfo(DocumentSnapshot documentSnapshot) {
    if (documentID != documentSnapshot.documentID) {
      activitySnapshot = documentSnapshot;
      checkAbsents.clear();
      isGet = false;
      titleController.text = documentSnapshot['title'];
      date = documentSnapshot['date'].toDate();
      isGet = true;
      documentID = documentSnapshot.documentID;
      notifyListeners();
    }
  }

  void getAbsents(QuerySnapshot querySnapshot) {
    if (checkAbsents.length == 0 ||
        querySnapshot.documents.length != countSnapshot) {
      for (int i = 0; i < querySnapshot.documents.length; i++) {
        DocumentSnapshot documentSnapshot = querySnapshot.documents[i];
        checkAbsents[documentSnapshot.documentID] = documentSnapshot['absent'];
      }
      countSnapshot = querySnapshot.documents.length;
      notifyListeners();
    }
  }

  void onCheckMember(String documentID) {
    if (checkAbsents[documentID] != null) {
      checkAbsents[documentID] = !checkAbsents[documentID];
    } else {
      checkAbsents[documentID] = false;
    }
    notifyListeners();
  }

  void onPressSend(BuildContext context) async {
    int count_user = 0;
    int count_absent = 0;
    isLoading = true;
    notifyListeners();
    checkAbsents.forEach((key, absent) async {
      count_user++;
      if (absent) {
        count_absent++;
      }
      await Firestore.instance
          .collection('activity_personal')
          .document(key)
          .updateData(<String, dynamic>{
        'absent': absent,
        'date': date,
        'title': titleController.text
      });
    });
    Firestore.instance
        .collection('activity')
        .document(documentID)
        .updateData(<String, dynamic>{
      'count_absent': count_absent,
      'count_user': count_user,
      'date': date,
      'title': titleController.text
    }).then((value) {
      Navigator.pop(context);
      EmptyError = false;
      isLoading = false;
    });
  }

  void onPressAdd(
      DocumentSnapshot userSnapshot, BuildContext context, bool isDark) {
    Firestore.instance.collection('activity_personal').add(<String, dynamic>{
      'absent': true,
      'activity': activitySnapshot.documentID,
      'age': userSnapshot['age'],
      'age_turn': userSnapshot['age_turn'],
      'date': activitySnapshot['date'],
      'group': activitySnapshot['group'],
      'name': userSnapshot['name'],
      'team': userSnapshot['team'],
      'title': activitySnapshot['title'],
      'uid': userSnapshot['uid']
    }).then((value) {
      final snackBar = SnackBar(
        content: Text('出席者リストに追加しました'),
        action: SnackBarAction(
          label: '取り消し',
          textColor: isDark ? Colors.blue[900] : Colors.blue[400],
          onPressed: () {
            Firestore.instance
                .collection('activity_personal')
                .document(value.documentID)
                .delete();
          },
        ),
        duration: Duration(seconds: 3),
      );
      Scaffold.of(context).showSnackBar(snackBar);
    });
  }
}
