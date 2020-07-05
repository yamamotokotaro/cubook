import 'dart:io';
import 'dart:math' as math;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
      if (Platform.isAndroid) {
        adunitID = 'ca-app-pub-9318890511624941/3455286517';
        // Android-specific code
      } else if (Platform.isIOS) {
        adunitID = 'ca-app-pub-9318890511624941/7202959836';
        // iOS-specific code
      }
      interstitialAd = InterstitialAd(
        // Replace the testAdUnitId with an ad unit id from the AdMob dash.
        // https://developers.google.com/admob/android/test-ads
        // https://developers.google.com/admob/ios/test-ads
        adUnitId: InterstitialAd.testAdUnitId,
        targetingInfo: targetingInfo,
        listener: (MobileAdEvent event) {
          print("InterstitialAd event is $event");
        },
      );
      interstitialAd..load().then((value) => isLoaded = true);
      /*videoAd.listener = (RewardedVideoAdEvent event,
          {String rewardType, int rewardAmount}) async {
        print("REWARDED VIDEO AD $event");
        isLoaded = false;
        notifyListeners();
        videoAd
            .load(
                adUnitId: RewardedVideoAd.testAdUnitId,
                targetingInfo: targetingInfo)
            .then((value) {
          isLoaded = true;
          notifyListeners();
        });
        if (event == RewardedVideoAdEvent.rewarded) {
          var random = new math.Random();
          int color = random.nextInt(4);
          increaseCount(list_type[color]);
          var result = await showModalBottomSheet<int>(
            context: context,
            builder: (BuildContext context) {
              return Container(
                  color: list_color[color],
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top: 10),
                          child: SvgPicture.asset(
                        'assets/svg/rope.svg',
                        semanticsLabel: 'shopping',
                        color: Colors.white,
                        width: 50,
                        height: 50,
                      )),
                      Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: Text(
                            '第一話',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 25,
                            ),
                          )),
                      Padding(
                          padding: EdgeInsets.only(top: 10, bottom: 20),
                          child: Text(
                            'やまもとこたろうの入団秘話',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ))
                    ],
                  ));
            },
          );
        }
      };
      videoAd
          .load(
              adUnitId: RewardedVideoAd.testAdUnitId,
              targetingInfo: targetingInfo)
          .then((value) {
        isLoaded = true;
        notifyListeners();
      });
    }*/
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
            var rand = new math.Random();
            if (rand.nextDouble() < 0.6) {
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
          });
        });
      });
    } else {
      EmptyError = true;
      notifyListeners();
    }
  }
}
