import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DetailMigrationWaitingModel extends ChangeNotifier {
  DocumentSnapshot taskSnapshot;
  User currentUser;
  String documentID;
  String documentID_type;
  String uid_get;
  String type;
  TextEditingController feedbackController = TextEditingController();
  int page;
  int number;
  bool isGet = false;
  bool isLoaded = false;
  bool isLoading = false;
  bool taskFinished = false;
  List<dynamic> body = <dynamic>[];
  Map<dynamic, dynamic> tokenMap;
  List<dynamic> dataMap;
  bool EmptyError = false;
  bool isEmpty = false;
  bool isFinish = false;
  bool isAdmin = false;

  void migrateAccount(BuildContext context, String documentID) async {
    print('start migrating...');
    isLoading = true;
    notifyListeners();
    final User user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      user.getIdTokenResult().then((IdTokenResult token) async {
        const String url =
            'https://asia-northeast1-cubook-3c960.cloudfunctions.net/executeMigration';
        final Map<String, String> headers = {'content-type': 'application/json'};
        final String body = json.encode(<String, dynamic>{
          'idToken': token.token,
          'documentID': documentID
        });

        final http.Response resp =
        await http.post(Uri.parse(url), headers: headers, body: body);
        isLoading = false;
        print('end');
        print(resp.body);
        if (resp.body == 'sucess') {
          isFinish = true;
          print('sucess');
        } else if(resp.body == 'you are not admin'){
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('アカウントの移行は管理者のみ操作可能です'),
          ));
        }
        isLoading = false;
        notifyListeners();
      });
    }
  }

  void rejectMigrate(BuildContext context, String documentID) async {
    print('start migrating...');
    isLoading = true;
    notifyListeners();
    final User user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      user.getIdTokenResult().then((IdTokenResult token) async {
        const String url =
            'https://asia-northeast1-cubook-3c960.cloudfunctions.net/rejectMigration';
        final Map<String, String> headers = {'content-type': 'application/json'};
        final String body = json.encode(<String, dynamic>{
          'idToken': token.token,
          'documentID': documentID
        });

        final http.Response resp =
        await http.post(Uri.parse(url), headers: headers, body: body);
        isLoading = false;
        print('end');
        print(resp.body);
        if (resp.body == 'sucess') {
          isFinish = true;
          print('sucess');
        } else if(resp.body == 'you are not admin'){
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('アカウントの移行は管理者のみ操作可能です'),
          ));
        }
        isLoading = false;
        notifyListeners();
      });
    }
  }
}
