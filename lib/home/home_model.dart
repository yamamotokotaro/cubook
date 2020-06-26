import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cubook/home_leader/homeLeader_view.dart';
import 'package:cubook/home_scout/homeBS_view.dart';
import 'package:cubook/home_scout/homeScout_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_ui/firebase_auth_ui.dart' show FirebaseAuthUi;
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class HomeModel extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  GoogleAuthProvider _authProvider = GoogleAuthProvider();
  DocumentSnapshot userSnapshot;
  QuerySnapshot effortSnapshot;
  FirebaseUser currentUser;
  StreamSubscription<FirebaseUser> _listener;
  bool isGet = false;
  bool isLoaded = false;
  bool isLoading_join = false;
  bool isConsent = false;
  String position;
  Widget toShow;
  String username = '';
  String usercall = '';
  String age = '';
  Map<dynamic, dynamic> tokenMap;

  void login() async {
    isLoaded = false;
    userSnapshot = null;
    currentUser = null;
    FirebaseAuth.instance.currentUser().then((user) {
      if (user != null) {
        currentUser = user;
        currentUser.getIdToken().then((tokenMap) {
          Firestore.instance
              .collection('user')
              .where('uid', isEqualTo: currentUser.uid)
              .snapshots()
              .listen((data) {
            if (data.documents.length != 0) {
              userSnapshot = data.documents[0];
              username = userSnapshot['name'] + userSnapshot['call'];
              usercall = userSnapshot['call'];
              position = userSnapshot['position'];
              age = userSnapshot['age'];
              if (position == 'scout') {
                toShow = HomeScoutView();
                getSnapshot();
              } else if (position == 'boyscout') {
                toShow = HomeBSView();
              } else if (position == 'boyscoutGL') {
                toShow = Column(children: <Widget>[
                  HomeBSView(),
                  HomeLeaderView()
                ],);
              }  else if (position == 'leader') {
                toShow = HomeLeaderView();
              } else {
                toShow = Center(
                  child: Text('エラーが発生しました'),
                );
              }
              isLoaded = true;
              notifyListeners();
            } else {
              isLoaded = true;
            }
          });
        });
      } else {
        isLoaded = true;
      }
      notifyListeners();
    });
  }

  void logout() async {
    final result = await FirebaseAuthUi.instance().logout();
    currentUser = null;
    notifyListeners();
    login();
  }

  void getUserSnapshot() async {}

  void getSnapshot() async {
    currentUser = await _auth.currentUser();
    currentUser?.getIdToken(refresh: true);

    _listener = _auth.onAuthStateChanged.listen((FirebaseUser user) {
      currentUser = user;
      Firestore.instance
          .collection('user')
          .where('uid', isEqualTo: currentUser.uid)
          .snapshots()
          .listen((data) {
        userSnapshot = data.documents[0];
        notifyListeners();
      });
      isGet = true;
      notifyListeners();
    });
  }

  void increaseCount(String documentID) async {
    Firestore.instance
        .collection('efforts')
        .document(documentID)
        .updateData(<String, dynamic>{'congrats': FieldValue.increment(1)});
  }
}
