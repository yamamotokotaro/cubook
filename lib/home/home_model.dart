import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cubook/home/home_view_new.dart';
import 'package:cubook/home_leader/homeLeader_view.dart';
import 'package:cubook/home_scout/homeScout_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:firebase_auth_ui/firebase_auth_ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class HomeModel extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  GoogleAuthProvider _authProvider = GoogleAuthProvider();
  DocumentSnapshot userSnapshot;
  QuerySnapshot effortSnapshot;
  FirebaseUser currentUser;
  StreamSubscription<FirebaseUser> _listener;
  bool isGet = false;
  bool isLoaded = false;
  String position;
  Widget toShow;
  String username = '';
  String joinCode = '';
  Map<dynamic,dynamic> tokenMap;

  void login() async {
    FirebaseAuth.instance.currentUser().then((user) {
      if (user != null) {
        currentUser = user;
        user.getIdToken().then((token) {
          tokenMap = token.claims;
          username = tokenMap['name'];
          if(tokenMap['group'] != null) {
            position = tokenMap['position'];
            if (position == 'scout') {
              toShow = HomeScoutView();
              getSnapshot();
            } else if (position == 'leader') {
              toShow = HomeLeaderView();
            } else {
              toShow = Center(child: Text('エラーが発生しました'),);
            }
          } else {
          }
          isLoaded = true;
          notifyListeners();
        });
      } else {
        isLoaded = true;
        notifyListeners();
      }
    });
  }

  void logout() async {
    final result = await FirebaseAuth.instance.signOut();
    notifyListeners();
  }

  void getUserSnapshot() async {

  }

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

  void joinRequest() async {
    currentUser = await _auth.currentUser();
    currentUser?.getIdToken(refresh: true);

    FirebaseAuth.instance.currentUser().then((user) {
      if (user != null) {
        user.getIdToken().then((token) async{
          print(token.claims);
          String url = "https://asia-northeast1-cubook-dev.cloudfunctions.net/joinGroup";
          Map<String, String> headers = {'content-type': 'application/json'};
          String body = json.encode({'idToken': token.token, 'joinCode': joinCode});

          http.Response resp = await http.post(url, headers: headers, body: body);
          if (resp.statusCode != 200) {
            print(resp.body);
            print(currentUser.getIdToken());
          }
          print(token.claims);
          Map<dynamic,dynamic> tokenMap = token.claims;
          print(tokenMap['sub']);
          notifyListeners();
        });
      }
    });

    /*_listener = _auth.onAuthStateChanged.listen((FirebaseUser user) async {
      String url =
          "https://asia-northeast1-cubook-dev.cloudfunctions.net/joinGroup";
      Map<String, String> headers = {'content-type': 'application/json'};
      String body = json.encode({'idToken': currentUser.getIdToken(), 'joinCode': joinCode});

      http.Response resp = await http.post(url, headers: headers, body: body);
      if (resp.statusCode != 200) {
        print(resp.body);
        print(currentUser.getIdToken());
      }
    });*/
  }
}
