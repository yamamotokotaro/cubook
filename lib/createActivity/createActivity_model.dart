import 'dart:io';
import 'dart:math' as math;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:intl/intl.dart';

class CreateActivityModel extends ChangeNotifier {
  QuerySnapshot userSnapshot;
  FirebaseUser currentUser;
  bool isGet = false;
  String group;
  String group_claim;
  DateTime date = DateTime.now();
  TextEditingController titleController = TextEditingController();
  bool isLoading = false;
  Map<String, bool> uid_check = new Map<String, bool>();
  bool EmptyError = false;
  Map<String, dynamic> claims = new Map<String, dynamic>();
  MobileAdTargetingInfo targetingInfo;
  bool isLoaded = false;
  InterstitialAd interstitialAd;
  var isRelease = const bool.fromEnvironment('dart.vm.product');
  dynamic itemSelected;
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
              list_selected
                  .add({'type': listCategory[i], 'page': k, 'number': l});
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
    FirebaseAuth.instance.currentUser().then((user) {
      user.getIdToken(refresh: true);
      Firestore.instance
          .collection('user')
          .where('uid', isEqualTo: user.uid)
          .getDocuments()
          .then((snapshot) {
        group = snapshot.documents[0]['group'];
        if (group != group_before) {
          group_before = group;
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

  void getAdmob(BuildContext context) {
    if (!isLoaded) {
      const String testDevices = 'Mobile_id';
      targetingInfo = MobileAdTargetingInfo(
          keywords: <String>['outdoor', 'scout'],
          childDirected: false,
          testDevices: testDevices != null
              ? <String>['testDevices']
              : null // Android emulators are considered test devices
          );
      String adunitID;
      if (isRelease) {
        if (Platform.isAndroid) {
          adunitID = 'ca-app-pub-9318890511624941/3455286517';
          // Android-specific code
        } else if (Platform.isIOS) {
          adunitID = 'ca-app-pub-9318890511624941/7202959836';
          // iOS-specific code
        }
      } else {
        adunitID = InterstitialAd.testAdUnitId;
      }
      interstitialAd = InterstitialAd(
        // Replace the testAdUnitId with an ad unit id from the AdMob dash.
        // https://developers.google.com/admob/android/test-ads
        // https://developers.google.com/admob/ios/test-ads
        adUnitId: adunitID,
        targetingInfo: targetingInfo,
        listener: (MobileAdEvent event) {
          print("InterstitialAd event is $event");
        },
      );
      interstitialAd..load().then((value) => isLoaded = true);
    }
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
    isLoading = true;
    notifyListeners();
    if (titleController.text != '') {
      var list_absent = new List<dynamic>();
      var list_uid = new List<dynamic>();
      int count = 0;
      FirebaseAuth.instance.currentUser().then((user) {
        String userUid = user.uid;
        Firestore.instance
            .collection('user')
            .where('uid', isEqualTo: user.uid)
            .getDocuments()
            .then((userDatas) async {
          {
            DocumentSnapshot userData = userDatas.documents[0];
            String userGroup = userData['group'];
            Firestore.instance
                .collection('user')
                .where('group', isEqualTo: userGroup)
                .where('position', isEqualTo: 'scout')
                .getDocuments()
                .then((user) async {
              for (int i = 0; i < user.documents.length; i++) {
                DocumentSnapshot snapshot = user.documents[i];
                if(snapshot['team'] != null) {
                  String uid_user = snapshot['uid'];
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
                  userInfo['name'] = snapshot['name'];
                  userInfo['absent'] = isCheck;
                  userInfo['age'] = snapshot['age'];
                  userInfo['age_turn'] = snapshot['age_turn'];
                  userInfo['team'] = snapshot['team'];
                  userInfo['group'] = userGroup;
                  list_absent.add(userInfo);
                }
              }
              Map<String, dynamic> activityInfo = new Map<String, dynamic>();
              activityInfo['group'] = userGroup;
              activityInfo['count_absent'] = count;
              activityInfo['count_user'] = user.documents.length;
              activityInfo['title'] = titleController.text;
              activityInfo['date'] = date;
              activityInfo['uid'] = userUid;
              activityInfo['list_item'] = list_selected;

              Firestore.instance
                  .collection('activity')
                  .add(activityInfo)
                  .then((document) async {
                String docID = document.documentID;
                for (int i = 0; i < list_absent.length; i++) {
                  Map<String, dynamic> userInfo = list_absent[i];
                  userInfo['activity'] = docID;
                  await Firestore.instance
                      .collection('activity_personal')
                      .add(userInfo);
                }

                Map<String, dynamic> data = new Map<String, dynamic>();
                data['start'] = Timestamp.now();
                data['uid'] = userUid;
                data['group'] = userGroup;
                data['family'] = userData['family'];
                data['feedback'] = '「' + titleController.text + '」で取得';
                data['activity'] = titleController.text;
                data['type'] = 'activity';
                data['activityID'] = docID;
                data['uid_toAdd'] = list_uid;
                var listCategory = ['usagi', 'sika', 'kuma', 'challenge'];
                if(itemSelected != null) {
                  for (int i = 0; i < listCategory.length; i++) {
                    List<dynamic> data_item = new List<dynamic>();
                    if (itemSelected[listCategory[i]] != null) {
                      List<dynamic> pageItem = itemSelected[listCategory[i]];
                      for (int k = 0; k < pageItem.length; k++) {
                        List<dynamic> numberItem = pageItem[k];
                        Map<String, dynamic> toAdd =
                        new Map<String, dynamic>();
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
                await Firestore.instance
                    .collection('lump')
                    .add(data)
                    .then((value) {
                  var rand = new math.Random();
                  if (rand.nextDouble() < 0.7) {
                    interstitialAd
                      ..show(
                        anchorType: AnchorType.bottom,
                        anchorOffset: 0.0,
                        horizontalCenterOffset: 0.0,
                      ).then((value) => isLoaded = false);
                  }
                  Navigator.pop(context);
                  date = DateTime.now();
                  titleController.text = '';
                  uid_check = new Map<String, bool>();
                  EmptyError = false;
                  isLoading = false;
                });
                print(data);
              });
            });
          }
        });
      });
    } else {
      EmptyError = true;
      notifyListeners();
    }
  }
}
