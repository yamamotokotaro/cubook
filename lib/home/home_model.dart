import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cubook/home/home_view_new.dart';
import 'package:cubook/home_leader/homeLeader_view.dart';
import 'package:cubook/home_scout/homeScout_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_ui/firebase_auth_ui.dart' show FirebaseAuthUi;
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart' show SystemChrome;
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
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
  String mes_join = '';
  Widget toShow;
  String username = '';
  String usercall = '';
  String age = '';
  String joinCode = '';
  Map<dynamic, dynamic> tokenMap;

  void login() async {
    isLoaded = false;
    userSnapshot = null;
    currentUser = null;
    FirebaseAuth.instance.currentUser().then((user) {
      if (user != null) {
        currentUser = user;
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
            } else if (position == 'leader') {
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

  void launchTermURL() async {
    const url = 'https://github.com/yamamotokotaro/cubook/blob/master/Terms/Terms_of_Service.md';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void onPressedCheckConsent(bool e) {
    isConsent = e;
    notifyListeners();
  }

  void joinRequest() async {
    if (isConsent && joinCode != '') {
      isLoading_join = true;
      notifyListeners();
      currentUser = await _auth.currentUser();
      currentUser?.getIdToken(refresh: true);

      FirebaseAuth.instance.currentUser().then((user) {
        if (user != null) {
          user.getIdToken().then((token) async {
            print(token.claims);
            String url =
                "https://asia-northeast1-cubook-3c960.cloudfunctions.net/joinGroup";
            Map<String, String> headers = {'content-type': 'application/json'};
            String body =
                json.encode({'idToken': token.token, 'joinCode': joinCode});

            http.Response resp =
                await http.post(url, headers: headers, body: body);
            print(resp.body);
            print(token.claims);
            Map<dynamic, dynamic> tokenMap = token.claims;
            print(tokenMap['sub']);
            isLoading_join = false;
            if (resp.body == 'success') {
              mes_join = '';
              Timer _timer;
              login();
            } else if (resp.body == 'No such document!' ||
                resp.body == 'not found') {
              isLoading_join = false;
              mes_join = 'コードが見つかりませんでした';
            } else {
              isLoading_join = false;
              mes_join = 'エラーが発生しました';
            }
            notifyListeners();
          });
        }
      });
    }
  }
}
