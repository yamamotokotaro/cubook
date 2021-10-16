import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeLeaderModel extends ChangeNotifier {
  QuerySnapshot taskSnapshot;
  bool isLoaded = false;
  bool isGet = false;
  String group;
  String group_claim;
  dynamic team;
  String teamPosition;
  String uid;
  Map<String, dynamic> claims = <String, dynamic>{};

  void getSnapshot(BuildContext context) async {
    final String groupBefore = group;
    final String teamPositionBefore = teamPosition;
    final User user = FirebaseAuth.instance.currentUser;
    FirebaseFirestore.instance
        .collection('user')
        .where('uid', isEqualTo: user.uid)
        .get()
        .then((snapshot) async {
      final DocumentSnapshot userSnapshot = snapshot.docs[0];
      group = userSnapshot['group'];
      if(userSnapshot.get('position') == "scout") {
        team = userSnapshot.get('team');
        teamPosition = userSnapshot.get('teamPosition');
      }
      user.getIdTokenResult(true).then((value) {
        print(value.claims);
        final String groupClaimBefore = group_claim;
        group_claim = value.claims['group'];
        if (groupClaimBefore != group_claim) {
          notifyListeners();
        }
      });
      if (group != groupBefore || teamPosition != teamPositionBefore) {
        notifyListeners();
        /*final RemoteConfig remoteConfig = await RemoteConfig.instance;
        await remoteConfig.fetch(expiration: const Duration(seconds: 1));
        await remoteConfig.activateFetched();
        print('term = ' + remoteConfig.getString('version_term'));
        await showModalBottomSheet<int>(
            context: context,
            isDismissible: false,
            enableDrag: false,
            builder: (BuildContext context) {
              return SingleChildScrollView(
                  child: Padding(
                      padding: EdgeInsets.only(top: 10, bottom: 10),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Padding(
                              padding: EdgeInsets.all(17),
                              child: Container(
                                  width: double.infinity,
                                  child: Text(
                                    '利用規約とプライバシーポリシーが改訂されました',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 24,
                                    ),
                                    textAlign: TextAlign.center,
                                  ))),
                          Padding(
                              padding: EdgeInsets.all(10),
                              child: Text(
                                '新しい利用規約とプライバシーポリシーをご確認ください',
                                style: TextStyle(),
                                textAlign: TextAlign.center,
                              )),
                          FlatButton(
                            onPressed: () {
                              launchTermURL();
                            },
                            child: Text(
                              '利用規約',
                              style: TextStyle(
                                  color: Theme.of(context).colorScheme.secondary),
                            ),
                          ),
                          FlatButton(
                            onPressed: () {
                              launchPrivacyURL();
                            },
                            child: Text(
                              'プライバシーポリシー',
                              style: TextStyle(
                                  color: Theme.of(context).colorScheme.secondary),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 10),
                            child: RaisedButton(
                                color: Colors.blue[900],
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  '同意する',
                                  style: TextStyle(color: Colors.white),
                                )),
                          )
                        ],
                      )));
            },
          );*/
      }
    });
  }

  Stream<QuerySnapshot> getTaskSnapshot(String group) {
    if (teamPosition != null) {
      if (teamPosition == 'teamLeader') {
        return FirebaseFirestore.instance
            .collection('task')
            .where('group', isEqualTo: group)
            .where('team', isEqualTo: team)
            .where('phase', isEqualTo: 'wait')
            .snapshots();
      } else {
        return FirebaseFirestore.instance
            .collection('task')
            .where('group', isEqualTo: group)
            .where('phase', isEqualTo: 'wait')
            .snapshots();
      }
    } else {
      return FirebaseFirestore.instance
          .collection('task')
          .where('group', isEqualTo: group)
          .where('phase', isEqualTo: 'wait')
          .snapshots();
    }
  }
}

void launchTermURL() async {
  const url =
      'https://github.com/yamamotokotaro/cubook/blob/master/Terms/Terms_of_Service.md';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

void launchPrivacyURL() async {
  const url =
      'https://github.com/yamamotokotaro/cubook/blob/master/Terms/Privacy_Policy.md';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}
