import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:firebase_admob/firebase_admob.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:flutter_svg/svg.dart';

class SupportModel with ChangeNotifier {
  /*RewardedVideoAd videoAd = RewardedVideoAd.instance;
  MobileAdTargetingInfo targetingInfo;*/
  bool isLoaded = false;
  String uid;
  String documentID;
  var list_type = ['red', 'yellow', 'blue', 'green'];
  var list_color = [Colors.red, Colors.yellow[700], Colors.blue, Colors.green];

  void getUser() async {
    FirebaseAuth.instance.currentUser().then((user) {
      if (uid != user.uid) {
        uid = user.uid;
        documentID = null;
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

  /*void getAdmob(BuildContext context) {
    if (!isLoaded) {
      const String testDevices = 'Mobile_id';
      targetingInfo = MobileAdTargetingInfo(
          keywords: <String>['outdoor', 'scout'],
          childDirected: false,
          testDevices: testDevices != null
              ? <String>['testDevices']
              : null // Android emulators are considered test devices
          );
      if (Platform.isAndroid) {
        FirebaseAdMob.instance.initialize(appId: 'ca-app-pub-3940256099942544/5224354917');
        // Android-specific code
      } else if (Platform.isIOS) {
        FirebaseAdMob.instance.initialize(appId: 'ca-app-pub-9318890511624941/8355992501');
        // iOS-specific code
      }
      videoAd.listener = (RewardedVideoAdEvent event,
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
    }
  }*/
}
