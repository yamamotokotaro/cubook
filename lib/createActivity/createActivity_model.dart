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
  Map<String, bool> uid_check = <String, bool>{};
  bool EmptyError = false;
  Map<String, dynamic> claims = <String, dynamic>{};
  bool isLoaded = false;
  var isRelease = const bool.fromEnvironment('dart.vm.product');
  dynamic itemSelected;
  List<String> list_notApplicable = <String>[];
  List<Map<String, dynamic>> list_selected = <Map<String, dynamic>>[];

  void onPressedSelectItem(BuildContext context) async {
    itemSelected = await Navigator.of(context).pushNamed('/addLumpSelectItem');
    if (itemSelected != null) {
      list_selected = <Map<String, dynamic>>[];
    }
    list_selected = List<Map<String, dynamic>>();
    final listCategory = ['usagi', 'sika', 'kuma', 'tukinowa', 'challenge'];
    for (int i = 0; i < listCategory.length; i++) {
      final List<dynamic> dataItem = <dynamic>[];
      print(itemSelected);
      if (itemSelected[listCategory[i]] != null) {
        final List<dynamic> pageItem = itemSelected[listCategory[i]];
        for (int k = 0; k < pageItem.length; k++) {
          final List<dynamic> numberItem = pageItem[k];
          final Map<String, dynamic> toAdd = Map<String, dynamic>();
          final List<dynamic> numbers = List<dynamic>();
          toAdd['page'] = k;
          for (int l = 0; l < numberItem.length; l++) {
            final bool isCheck = numberItem[l];
            if (isCheck) {
              numbers.add(l);
              list_selected.add(<String, dynamic>{
                'type': listCategory[i],
                'page': k,
                'number': l
              });
            }
          }
          if (numbers.isNotEmpty) {
            toAdd['numbers'] = numbers;
            dataItem.add(toAdd);
          }
        }
      }
//      data[listCategory[i]] = data_item;
    }
    print(list_selected);
    notifyListeners();
  }

  void getGroup() async {
    String groupBefore = group;
    final User user = FirebaseAuth.instance.currentUser;
    //user.getIdToken(refresh: true);
    FirebaseFirestore.instance
        .collection('user')
        .where('uid', isEqualTo: user.uid)
        .get()
        .then((snapshot) {
      group = snapshot.docs[0].get('group');
      if (group != groupBefore) {
        groupBefore = group;
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
    final DateTime dateGet = await showDatePicker(
      context: context,
      firstDate: DateTime(DateTime.now().year - 5),
      lastDate: DateTime(DateTime.now().year + 5),
      initialDate: dateTime,
    );
    if (dateGet != null) {
      date = dateGet;
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
      final listAbsent = List<dynamic>();
      final listUid = <dynamic>[];
      int count = 0;
      final User user = FirebaseAuth.instance.currentUser;
      final String userUid = user.uid;
      FirebaseFirestore.instance
          .collection('user')
          .where('uid', isEqualTo: user.uid)
          .get()
          .then((userDatas) async {
        {
          final DocumentSnapshot userData = userDatas.docs[0];
          final String userGroup = userData.get('group');
          FirebaseFirestore.instance
              .collection('user')
              .where('group', isEqualTo: userGroup)
              .where('position', isEqualTo: 'scout')
              .get()
              .then((user) async {
            for (int i = 0; i < user.docs.length; i++) {
              final DocumentSnapshot snapshot = user.docs[i];
              if (snapshot.get('team') != null) {
                final String uidUser = snapshot.get('uid');
                if (!list_notApplicable.contains(uidUser)) {
                  bool isCheck = true;
                  if (uid_check[uidUser] != null) {
                    isCheck = uid_check[uidUser];
                  }
                  if (isCheck) {
                    listUid.add(uidUser);
                    count++;
                  }
                  final Map<String, dynamic> userInfo = <String, dynamic>{};
                  userInfo['title'] = titleController.text;
                  userInfo['date'] = date;
                  userInfo['uid'] = uidUser;
                  userInfo['name'] = snapshot.get('name');
                  userInfo['absent'] = isCheck;
                  userInfo['age'] = snapshot.get('age');
                  userInfo['age_turn'] = snapshot.get('age_turn');
                  userInfo['team'] = snapshot.get('team');
                  userInfo['group'] = userGroup;
                  listAbsent.add(userInfo);
                }
              }
            }
            final Map<String, dynamic> activityInfo = Map<String, dynamic>();
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
              final String docID = document.id;
              for (int i = 0; i < listAbsent.length; i++) {
                final Map<String, dynamic> userInfo = listAbsent[i];
                userInfo['activity'] = docID;
                await FirebaseFirestore.instance
                    .collection('activity_personal')
                    .add(userInfo);
              }

              final Map<String, dynamic> data = <String, dynamic>{};
              data['start'] = Timestamp.now();
              data['uid'] = userUid;
              data['group'] = userGroup;
              data['family'] = userData.get('family');
              data['feedback'] = '「' + titleController.text + '」でサイン';
              data['activity'] = titleController.text;
              data['type'] = 'activity';
              data['activityID'] = docID;
              data['uid_toAdd'] = listUid;
              final listCategory = ['usagi', 'sika', 'kuma', 'tukinowa', 'challenge'];
              if (itemSelected != null) {
                for (int i = 0; i < listCategory.length; i++) {
                  final List<dynamic> dataItem = <dynamic>[];
                  if (itemSelected[listCategory[i]] != null) {
                    final List<dynamic> pageItem = itemSelected[listCategory[i]];
                    for (int k = 0; k < pageItem.length; k++) {
                      final List<dynamic> numberItem = pageItem[k];
                      final Map<String, dynamic> toAdd = <String, dynamic>{};
                      final List<dynamic> numbers = List<dynamic>();
                      toAdd['page'] = k;
                      for (int l = 0; l < numberItem.length; l++) {
                        final bool isCheck = numberItem[l];
                        if (isCheck) {
                          numbers.add(l);
                        }
                      }
                      if (numbers.isNotEmpty) {
                        toAdd['numbers'] = numbers;
                        dataItem.add(toAdd);
                      }
                    }
                  }
                  data[listCategory[i]] = dataItem;
                }
              }
              await FirebaseFirestore.instance
                  .collection('lump')
                  .add(data)
                  .then((value) {
                final rand = math.Random();
                Navigator.pop(context);
                date = DateTime.now();
                titleController.text = '';
                list_notApplicable.clear();
                uid_check = Map<String, bool>();
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
