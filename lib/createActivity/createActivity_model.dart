import 'dart:io';
import 'dart:math' as math;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CreateActivityModel extends ChangeNotifier {
  QuerySnapshot userSnapshot;
  User currentUser;
  bool isGet = false;
  String group;
  String group_claim;
  DateTime date = DateTime.now();
  TextEditingController titleController = TextEditingController();
  bool isLoading = false;
  Map<String, bool> uid_check = new Map<String, bool>();
  bool EmptyError = false;
  Map<String, dynamic> claims = new Map<String, dynamic>();
  bool isLoaded = false;
  var isRelease = const bool.fromEnvironment('dart.vm.product');
  dynamic itemSelected;
  List<String> list_notApplicable = new List<String>();
  List<Map<String, dynamic>> list_selected = new List<Map<String, dynamic>>();

  void onPressedSelectItem(BuildContext context) async {
    itemSelected = await Navigator.of(context).pushNamed('/addLumpSelectItem');
    if (itemSelected != null) {
      list_selected = new List<Map<String, dynamic>>();
    }
    list_selected = new List<Map<String, dynamic>>();
    var listCategory = ['usagi', 'sika', 'kuma', 'challenge'];
    for (int i = 0; i < listCategory.length; i++) {
      List<dynamic> data_item = new List<dynamic>();
      print(itemSelected);
      if (itemSelected[listCategory[i]] != null) {
        List<dynamic> pageItem = itemSelected[listCategory[i]];
        for (int k = 0; k < pageItem.length; k++) {
          List<dynamic> numberItem = pageItem[k];
          Map<String, dynamic> toAdd = new Map<String, dynamic>();
          List<dynamic> numbers = new List<dynamic>();
          toAdd['page'] = k;
          for (int l = 0; l < numberItem.length; l++) {
            bool isCheck = numberItem[l];
            if (isCheck) {
              numbers.add(l);
              list_selected.add(<String, dynamic>{
                'type': listCategory[i],
                'page': k,
                'number': l
              });
            }
          }
          if (numbers.length != 0) {
            toAdd['numbers'] = numbers;
            data_item.add(toAdd);
          }
        }
      }
//      data[listCategory[i]] = data_item;
    }
    print(list_selected);
    notifyListeners();
  }

  void getGroup() async {
    String group_before = group;
    User user = await FirebaseAuth.instance.currentUser;
    //user.getIdToken(refresh: true);
    FirebaseFirestore.instance
        .collection('user')
        .where('uid', isEqualTo: user.uid)
        .get()
        .then((snapshot) {
      group = snapshot.docs[0].data()['group'];
      if (group != group_before) {
        group_before = group;
        notifyListeners();
      }
      /*user.getIdToken(refresh: true).then((value) {
        String group_claim_before = group_claim;
        group_claim = value.claims['group'];
        if (group_claim_before != group_claim) {
          notifyListeners();
        }
      });*/
    });
  }

  void dismissUser(String uid) {
    list_notApplicable.add(uid);
    notifyListeners();
  }

  void cancelDismiss(String uid) {
    list_notApplicable.removeWhere((item) => item == uid);
    notifyListeners();
  }

  void resetUser() {
    list_notApplicable.clear();
    notifyListeners();
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
      isLoading = true;
      notifyListeners();
      var list_absent = new List<dynamic>();
      var list_uid = new List<dynamic>();
      int count = 0;
      User user = await FirebaseAuth.instance.currentUser;
      String userUid = user.uid;
      FirebaseFirestore.instance
          .collection('user')
          .where('uid', isEqualTo: user.uid)
          .get()
          .then((userDatas) async {
        {
          DocumentSnapshot userData = userDatas.docs[0];
          String userGroup = userData.data()['group'];
          FirebaseFirestore.instance
              .collection('user')
              .where('group', isEqualTo: userGroup)
              .where('position', isEqualTo: 'scout')
              .get()
              .then((user) async {
            for (int i = 0; i < user.docs.length; i++) {
              DocumentSnapshot snapshot = user.docs[i];
              if (snapshot.data()['team'] != null) {
                String uid_user = snapshot.data()['uid'];
                if (!list_notApplicable.contains(uid_user)) {
                  bool isCheck = true;
                  if (uid_check[uid_user] != null) {
                    isCheck = uid_check[uid_user];
                  }
                  if (isCheck) {
                    list_uid.add(uid_user);
                    count++;
                  }
                  Map<String, dynamic> userInfo = new Map<String, dynamic>();
                  userInfo['title'] = titleController.text;
                  userInfo['date'] = date;
                  userInfo['uid'] = uid_user;
                  userInfo['name'] = snapshot.data()['name'];
                  userInfo['absent'] = isCheck;
                  userInfo['age'] = snapshot.data()['age'];
                  userInfo['age_turn'] = snapshot.data()['age_turn'];
                  userInfo['team'] = snapshot.data()['team'];
                  userInfo['group'] = userGroup;
                  list_absent.add(userInfo);
                }
              }
            }
            Map<String, dynamic> activityInfo = new Map<String, dynamic>();
            activityInfo['group'] = userGroup;
            activityInfo['count_absent'] = count;
            activityInfo['count_user'] = user.docs.length;
            activityInfo['title'] = titleController.text;
            activityInfo['date'] = date;
            activityInfo['uid'] = userUid;
            activityInfo['list_item'] = list_selected;

            FirebaseFirestore.instance
                .collection('activity')
                .add(activityInfo)
                .then((document) async {
              String docID = document.id;
              for (int i = 0; i < list_absent.length; i++) {
                Map<String, dynamic> userInfo = list_absent[i];
                userInfo['activity'] = docID;
                await FirebaseFirestore.instance
                    .collection('activity_personal')
                    .add(userInfo);
              }

              Map<String, dynamic> data = new Map<String, dynamic>();
              data['start'] = Timestamp.now();
              data['uid'] = userUid;
              data['group'] = userGroup;
              data['family'] = userData.data()['family'];
              data['feedback'] = '「' + titleController.text + '」でサイン';
              data['activity'] = titleController.text;
              data['type'] = 'activity';
              data['activityID'] = docID;
              data['uid_toAdd'] = list_uid;
              var listCategory = ['usagi', 'sika', 'kuma', 'challenge'];
              if (itemSelected != null) {
                for (int i = 0; i < listCategory.length; i++) {
                  List<dynamic> data_item = new List<dynamic>();
                  if (itemSelected[listCategory[i]] != null) {
                    List<dynamic> pageItem = itemSelected[listCategory[i]];
                    for (int k = 0; k < pageItem.length; k++) {
                      List<dynamic> numberItem = pageItem[k];
                      Map<String, dynamic> toAdd = new Map<String, dynamic>();
                      List<dynamic> numbers = new List<dynamic>();
                      toAdd['page'] = k;
                      for (int l = 0; l < numberItem.length; l++) {
                        bool isCheck = numberItem[l];
                        if (isCheck) {
                          numbers.add(l);
                        }
                      }
                      if (numbers.length != 0) {
                        toAdd['numbers'] = numbers;
                        data_item.add(toAdd);
                      }
                    }
                  }
                  data[listCategory[i]] = data_item;
                }
              }
              await FirebaseFirestore.instance
                  .collection('lump')
                  .add(data)
                  .then((value) {
                var rand = new math.Random();
                Navigator.pop(context);
                date = DateTime.now();
                titleController.text = '';
                list_notApplicable.clear();
                uid_check = new Map<String, bool>();
                EmptyError = false;
                isLoading = false;
              });
              print(data);
            });
          });
        }
      });
    } else {
      EmptyError = true;
      notifyListeners();
    }
  }
}
