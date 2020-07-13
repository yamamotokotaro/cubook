import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:flutter_svg/svg.dart';

class SupportModel with ChangeNotifier {
  RewardedVideoAd videoAd = RewardedVideoAd.instance;
  MobileAdTargetingInfo targetingInfo;
  bool isLoaded = false;
  String uid;
  String documentID;
  QuerySnapshot contents_red;
  QuerySnapshot contents_yellow;
  QuerySnapshot contents_blue;
  QuerySnapshot contents_green;
  QuerySnapshot contents_red_before;
  QuerySnapshot contents_yellow_before;
  QuerySnapshot contents_blue_before;
  QuerySnapshot contents_green_before;
  var list_type = ['red', 'yellow', 'blue', 'green'];
  var list_color = [Colors.red, Colors.yellow[700], Colors.blue, Colors.green];
  var isRelease = const bool.fromEnvironment('dart.vm.product');

  void getUser() async {
    FirebaseAuth.instance.currentUser().then((user) {
      if (uid != user.uid) {
        uid = user.uid;
        documentID = null;
        notifyListeners();
      }
    });
  }

  void unlock(String type, String id) async {
    Firestore.instance
        .collection('user')
        .where('uid', isEqualTo: uid)
        .getDocuments()
        .then((snapshot) {
      documentID = snapshot.documents[0].documentID;
      Firestore.instance
          .collection('user')
          .document(documentID)
          .updateData(<String, dynamic>{type: FieldValue.increment(-1)});
    });
    Firestore.instance
        .collection('contents_unlocked')
        .where('uid', isEqualTo: uid)
        .getDocuments()
        .then((snapshot) {
      if (snapshot.documents.length != 0) {
        List<dynamic> unlock_list = new List<dynamic>();
        DocumentSnapshot unlockSnapshot = snapshot.documents[0];
        if (unlockSnapshot['unlocked'] != null) {
          unlock_list = unlockSnapshot['unlocked'];
          unlock_list.add(id);
        } else {
          unlock_list.add(id);
        }
        Firestore.instance
            .collection('contents_unlocked')
            .document(unlockSnapshot.documentID)
            .updateData(<String, dynamic>{'unlocked': unlock_list});
      } else {
        List<dynamic> unlock_list = new List<dynamic>();
        unlock_list.add(id);
        Firestore.instance
            .collection('contents_unlocked')
            .add(<String, dynamic>{'uid': uid, 'unlocked': unlock_list});
      }
    });
  }

  void getContents(String type) async {
    Firestore.instance
        .collection('specialcontents')
        .where('type', isEqualTo: type)
        .getDocuments()
        .then((snapshot) {
      bool change = false;
      switch (type) {
        case 'red':
          contents_red = snapshot;
          if (contents_red != contents_red_before) {
            change = true;
            contents_red_before = contents_red;
          }
          break;
        case 'yellow':
          contents_yellow = snapshot;
          if (contents_yellow != contents_yellow_before) {
            change = true;
            contents_yellow_before = contents_yellow;
          }
          break;
        case 'blue':
          contents_blue = snapshot;
          if (contents_blue != contents_blue_before) {
            change = true;
            contents_blue_before = contents_blue;
          }
          break;
        case 'green':
          contents_green = snapshot;
          if (contents_green != contents_green_before) {
            change = true;
            contents_green_before = contents_green;
          }
          break;
      }
      if (change) {
        notifyListeners();
      }
    });
  }

  void increaseCount(String type) async {
    if (documentID == null) {
      Firestore.instance
          .collection('user')
          .where('uid', isEqualTo: uid)
          .getDocuments()
          .then((snapshot) {
        documentID = snapshot.documents[0].documentID;
        Firestore.instance
            .collection('user')
            .document(documentID)
            .updateData(<String, dynamic>{type: FieldValue.increment(1)});
        print('ducomentIdある');
      });
    } else {
      Firestore.instance
          .collection('user')
          .document(documentID)
          .updateData(<String, dynamic>{type: FieldValue.increment(1)});
      print('ducomentIdない');
    }
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
      if(isRelease) {
        if (Platform.isAndroid) {
          adunitID = 'ca-app-pub-9318890511624941/8096138050';
          // Android-specific code
        } else if (Platform.isIOS) {
          adunitID = 'ca-app-pub-9318890511624941/8355992501';
          // iOS-specific code
        }
      } else {
        adunitID = RewardedVideoAd.testAdUnitId;
      }
      videoAd.listener = (RewardedVideoAdEvent event,
          {String rewardType, int rewardAmount}) async {
        print("REWARDED VIDEO AD $event");
        isLoaded = false;
        notifyListeners();
        videoAd
            .load(
                adUnitId: adunitID,
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
                            'おめでとうございます！',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 25,
                            ),
                          )),
                      Padding(
                          padding: EdgeInsets.only(top: 10, bottom: 20),
                          child: Text(
                            'ロープを獲得しました',
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
              adUnitId: adunitID,
              targetingInfo: targetingInfo)
          .then((value) {
        isLoaded = true;
        notifyListeners();
      });
    }
  }
}
