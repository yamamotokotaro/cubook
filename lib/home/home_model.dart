import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cubook/home/home_view_new.dart';
import 'package:cubook/home_leader/homeLeader_view.dart';
import 'package:cubook/home_scout/homeScout_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class HomeModel extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  DocumentSnapshot userSnapshot;
  QuerySnapshot effortSnapshot;
  FirebaseUser currentUser;
  StreamSubscription<FirebaseUser> _listener;
  bool isGet = false;
  String position;
  Widget toShow;
  String username = '';

  void login() async {
    FirebaseAuth.instance.currentUser().then((user) {
      if (user != null) {
        currentUser = user;
        user.getIdToken().then((token) {
          Map<dynamic,dynamic> tokenMap = token.claims;
          username = tokenMap['name'];
          position = 'scout'/*tokenMap['position']*/;
          if(position == 'scout'){
            toShow = HomeScoutView();
          } else if(position == 'leader'){
            toShow = HomeLeaderView();
          } else {
            toShow = Center(child: Text('エラーが発生しました'),);
          }
          notifyListeners();
        });
      }
    });
  }

  void getUserSnapshot() async {

  }

  void getSnapshot() async {
    currentUser = await _auth.currentUser();
    currentUser?.getIdToken(refresh: true);

    _listener = _auth.onAuthStateChanged.listen((FirebaseUser user) {
      currentUser = user;
      Firestore.instance
          .collection('users')
          .where('uid', isEqualTo: currentUser.uid)
          .snapshots()
          .listen((data) {
        userSnapshot = data.documents[0];
        notifyListeners();
      });
      Firestore.instance.collection('efforts').snapshots().listen((data) {
        effortSnapshot = data;
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

  void request(String documentID) async {
    currentUser = await _auth.currentUser();
    currentUser?.getIdToken(refresh: true);

    _listener = _auth.onAuthStateChanged.listen((FirebaseUser user) async {
      String url =
          "https://asia-northeast1-cubook-dev.cloudfunctions.net/verifyIdToken";
      Map<String, String> headers = {'content-type': 'application/json'};
      String body = json.encode({'idToken': currentUser.getIdToken()});

      http.Response resp = await http.post(url, headers: headers, body: body);
      if (resp.statusCode != 200) {
        print(resp.body);
        print(currentUser.getIdToken());
      }
    });
  }
}
