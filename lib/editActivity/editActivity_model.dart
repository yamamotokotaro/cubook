import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EditActivityModel extends ChangeNotifier {
  QuerySnapshot userSnapshot;
  DocumentSnapshot activitySnapshot;
  int countSnapshot;
  User currentUser;
  bool isGet = false;
  String group;
  String position;
  String age;
  DateTime date;
  TextEditingController titleController = TextEditingController();
  bool isLoading = false;
  bool EmptyError = false;
  List<Map<String, dynamic>> listMemberAbsent = new List<Map<String, dynamic>>();
  Map<String, bool> uid_check = new Map<String, bool>();
  Map<String, dynamic> claims = new Map<String, dynamic>();
  Map<String, bool> checkAbsents = new Map<String, bool>();
  String group_claim;
  String documentID;

  void getGroup() async {
    String group_before = group;
    User user = await FirebaseAuth.instance.currentUser;
    FirebaseFirestore.instance
        .collection('user')
        .where('uid', isEqualTo: user.uid)
        .get()
        .then((snapshot) {
      DocumentSnapshot documentSnapshot = snapshot.docs[0];
      group = documentSnapshot.data()['group'];
      position = documentSnapshot.data()['position'];
      age = documentSnapshot.data()['age'];
      if (group != group_before) {
        notifyListeners();
      }
      /* user.getIdToken(refresh: true).then((value) {
        String group_claim_before = group_claim;
        group_claim = value.claims['group'];
        if (group_claim_before != group_claim) {
          notifyListeners();
        }
      });*/
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
    if (documentID != documentSnapshot.id) {
      activitySnapshot = documentSnapshot;
      checkAbsents.clear();
      isGet = false;
      titleController.text = documentSnapshot.data()['title'];
      date = documentSnapshot.data()['date'].toDate();
      isGet = true;
      documentID = documentSnapshot.id;
      //notifyListeners();
    }
  }

  void getAbsents(QuerySnapshot querySnapshot) {
    if (checkAbsents.length == 0 ||
        querySnapshot.docs.length != countSnapshot) {
      for (int i = 0; i < querySnapshot.docs.length; i++) {
        DocumentSnapshot documentSnapshot = querySnapshot.docs[i];
        checkAbsents[documentSnapshot.id] = documentSnapshot.data()['absent'];
      }
      countSnapshot = querySnapshot.docs.length;
      //notifyListeners();
    }
  }

  void onCheckMember(String documentID) async {
    if (checkAbsents[documentID] != null) {
      checkAbsents[documentID] = !checkAbsents[documentID];
    } else {
      checkAbsents[documentID] = false;
    }
    notifyListeners();
    print('notifyListners');
    print(checkAbsents[documentID]);
  }

  void dismissUser(String id) async {
    await FirebaseFirestore.instance
        .collection('activity_personal')
        .doc(id)
        .delete();
    notifyListeners();
  }

  void cancelDismiss(String id, Map<String, dynamic> data) async {
    await FirebaseFirestore.instance
        .collection('activity_personal')
        .doc(id)
        .set(data);
    notifyListeners();
  }

  void onPressSend(BuildContext context) async {
    int count_user = 0;
    int count_absent = 0;
    isLoading = true;
    checkAbsents.forEach((key, absent) async {
      count_user++;
      if (absent) {
        count_absent++;
      }
      await FirebaseFirestore.instance
          .collection('activity_personal')
          .doc(key)
          .update(<String, dynamic>{
        'absent': absent,
        'date': date,
        'title': titleController.text
      });
    });
    FirebaseFirestore.instance
        .collection('activity')
        .doc(documentID)
        .update(<String, dynamic>{
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
    FirebaseFirestore.instance
        .collection('activity_personal')
        .add(<String, dynamic>{
      'absent': true,
      'activity': activitySnapshot.id,
      'age': userSnapshot.data()['age'],
      'age_turn': userSnapshot.data()['age_turn'],
      'date': activitySnapshot.data()['date'],
      'group': activitySnapshot.data()['group'],
      'name': userSnapshot.data()['name'],
      'team': userSnapshot.data()['team'],
      'title': activitySnapshot.data()['title'],
      'uid': userSnapshot.data()['uid']
    }).then((value) {
      final snackBar = SnackBar(
        content: Text('出席者リストに追加しました'),
        action: SnackBarAction(
          label: '取り消し',
          textColor: isDark ? Colors.blue[900] : Colors.blue[400],
          onPressed: () {
            FirebaseFirestore.instance
                .collection('activity_personal')
                .doc(value.id)
                .delete();
          },
        ),
        duration: Duration(seconds: 3),
      );
      Scaffold.of(context).showSnackBar(snackBar);
    });
  }
}
