import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SettingAccountGroupModel extends ChangeNotifier {
  DocumentSnapshot userSnapshot;
  FirebaseUser currentUser;
  bool isGet = false;
  bool isLoading = false;
  String group;
  String group_claim;
  TextEditingController familyController;
  TextEditingController firstController;
  TextEditingController teamController;
  String dropdown_text;
  String age;
  String call;
  String uid_before;
  Map<String, dynamic> claims = new Map<String, dynamic>();

  void getSnapshot(String uid) async {
    if (uid != uid_before) {
      uid_before = uid;
      FirebaseAuth.instance.currentUser().then((user) {
        currentUser = user;
        user.getIdToken().then((token) async {
          Firestore.instance
              .collection('user')
              .where('group', isEqualTo: token.claims['group'])
              .where('uid', isEqualTo: uid)
              .snapshots()
              .listen((data) {
            userSnapshot = data.documents[0];
            String family = userSnapshot['family'];
            familyController =
                TextEditingController(text: userSnapshot['family']);
            firstController =
                TextEditingController(text: userSnapshot['first']);
            String team;
            if(userSnapshot['team'] is int){
              team = userSnapshot['team'].toString();
            } else {
              team = userSnapshot['team'];
            }
            if(userSnapshot['team'] != null) {
              teamController =
                  TextEditingController(text: team);
            } else {
              teamController = TextEditingController();
            }
            switch (userSnapshot['age']) {
              case 'usagi':
                age = 'うさぎ';
                break;
              case 'sika':
                age = 'しか';
                break;
              case 'kuma':
                age = 'くま';
                break;
              case 'syokyu':
                age = 'ボーイスカウトバッジ';
                break;
              case 'nikyu':
                age = '初級スカウト';
                break;
              case 'ikkyu':
                age = '2級スカウト';
                break;
              case 'kiku':
                age = '1級スカウト';
                break;
              case 'hayabusa':
                age = '菊スカウト';
                break;
              case 'fuji':
                age = '隼スカウト';
                break;
            }
            dropdown_text = age;
            call = userSnapshot['call'];
            notifyListeners();
          });
          isGet = true;
        });
      });
    }
  }

  void getGroup() async {
    String group_before = group;
    FirebaseAuth.instance.currentUser().then((user) {
      Firestore.instance.collection('user').where('uid', isEqualTo: user.uid).getDocuments().then((snapshot) {
        group = snapshot.documents[0]['group'];
        if(group != group_before) {
          notifyListeners();
        }
        user.getIdToken(refresh: true).then((value) {
          String group_claim_before = group_claim;
          group_claim = value.claims['group'];
          if(group_claim_before != group_claim) {
            notifyListeners();
          }
        });
      });
    });
  }

  void onDropdownChanged(String value) {
    dropdown_text = value;
    notifyListeners();
  }

  void onDropdownCallChanged(String value) {
    call = value;
    notifyListeners();
  }

  void changeRequest(BuildContext context, String uid) async {
    String age;
    String position;
    int age_turn;
    String grade;
    switch (dropdown_text) {
      case 'うさぎ':
        age = 'usagi';
        position = 'scout';
        age_turn = 7;
        grade = 'cub';
        break;
      case 'しか':
        age = 'sika';
        position = 'scout';
        age_turn = 8;
        grade = 'cub';
        break;
      case 'くま':
        age = 'kuma';
        position = 'scout';
        age_turn = 9;
        grade = 'cub';
        break;
      case 'リーダー':
        age = 'leader';
        position = 'leader';
        grade = 'boy';
        break;
      case 'ボーイスカウトバッジ':
        age = 'syokyu';
        position = 'scout';
        age_turn = 12;
        grade = 'boy';
        break;
      case '初級スカウト':
        age = 'nikyu';
        position = 'scout';
        age_turn = 13;
        grade = 'boy';
        break;
      case '2級スカウト':
        age = 'ikkyu';
        position = 'scout';
        age_turn = 14;
        grade = 'boy';
        break;
      case '1級スカウト':
        age = 'kiku';
        position = 'scout';
        age_turn = 15;
        grade = 'boy';
        break;
      case '菊スカウト':
        age = 'hayabusa';
        position = 'scout';
        age_turn = 16;
        grade = 'boy';
        break;
      case '隼スカウト':
        age = 'fuji';
        position = 'scout';
        age_turn = 17;
        grade = 'boy';
        break;
    }
    if (familyController.text != '' &&
        firstController.text != '' &&
        dropdown_text != null &&
        call != null) {
      isLoading = true;
      notifyListeners();
      FirebaseAuth.instance.currentUser().then((user) {
        if (user != null) {
          user.getIdToken(refresh: true).then((token) async {
            String url =
                "https://asia-northeast1-cubook-3c960.cloudfunctions.net/changeUserInfo_group";
            Map<String, String> headers = {'content-type': 'application/json'};
            String body = json.encode({
              'idToken': token.token,
              'family': familyController.text,
              'first': firstController.text,
              'call': call,
              'team': teamController.text,
              'age': age,
              'age_turn': age_turn,
              'uid': uid,
              'grade': grade
            });

            http.Response resp =
                await http.post(url, headers: headers, body: body);
            isLoading = false;
            if (resp.body == 'success') {
              Scaffold.of(context).showSnackBar(new SnackBar(
                content: new Text('変更を保存しました'),
              ));
            } else if (resp.body == 'No such document!' ||
                resp.body == 'not found') {
              isLoading = false;
              Scaffold.of(context).showSnackBar(new SnackBar(
                content: new Text('ユーザーが見つかりませんでした'),
              ));
            } else {
              isLoading = false;
              Scaffold.of(context).showSnackBar(new SnackBar(
                content: new Text('エラーが発生しました'),
              ));
            }
            notifyListeners();
          });
        }
      });
    } else {
      notifyListeners();
    }
  }
}
