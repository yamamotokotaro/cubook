import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:cubook/model/task.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class SettingAccountGroupModel extends ChangeNotifier {
  DocumentSnapshot userSnapshot;
  User currentUser;
  bool isGet = false;
  bool isFinish = false;
  bool isLoading = false;
  bool isTeamLeader;
  String group;
  String group_claim;
  TextEditingController familyController;
  TextEditingController firstController;
  TextEditingController teamController;
  String dropdown_text;
  String age;
  String call;
  String uid;
  Map<String, dynamic> claims = new Map<String, dynamic>();

  void getSnapshot(String uid_toShow) async {
    var task = new TaskContents();
    if (uid_toShow != uid) {
      uid = uid_toShow;
      User user = await FirebaseAuth.instance.currentUser;
      currentUser = user;
      user.getIdTokenResult().then((token) async {
        FirebaseFirestore.instance
            .collection('user')
            .where('group', isEqualTo: token.claims['group'])
            .where('uid', isEqualTo: uid)
            .snapshots()
            .listen((data) {
          userSnapshot = data.docs[0];
          String family = userSnapshot.data()['family'];
          group = userSnapshot.data()['group'];
          familyController =
              TextEditingController(text: userSnapshot.data()['family']);
          firstController =
              TextEditingController(text: userSnapshot.data()['first']);
          if (userSnapshot.data()['teamPosition'] != null) {
            if (userSnapshot.data()['teamPosition'] == 'teamLeader') {
              isTeamLeader = true;
            } else {
              isTeamLeader = false;
            }
          } else {
            isTeamLeader = false;
          }
          String team;
          if (userSnapshot.data()['team'] is int) {
            team = userSnapshot.data()['team'].toString();
          } else {
            team = userSnapshot.data()['team'];
          }
          if (userSnapshot.data()['team'] != null) {
            teamController = TextEditingController(text: team);
          } else {
            teamController = TextEditingController();
          }
          switch (userSnapshot.data()['age']) {
            case 'risu':
              age = 'りす';
              break;
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
              age = '菊スカウト（隼を目指すスカウト）';
              break;
            case 'fuji':
              age = '隼スカウト';
              break;
          }
          dropdown_text = age;
          call = userSnapshot.data()['call'];
          notifyListeners();
        });
        isGet = true;
      });
    }
  }

  void getGroup() async {
    String group_before = group;
    User user = await FirebaseAuth.instance.currentUser;
    FirebaseFirestore.instance
        .collection('user')
        .where('uid', isEqualTo: user.uid)
        .get()
        .then((snapshot) {
      group = snapshot.docs[0].data()['group'];
      if (group != group_before) {
        notifyListeners();
      }
      user.getIdTokenResult().then((value) {
        String group_claim_before = group_claim;
        group_claim = value.claims['group'];
        if (group_claim_before != group_claim) {
          notifyListeners();
        }
      });
    });
  }

  void onCheckboxTeamLeaderChanged(bool value) {
    isTeamLeader = value;
    notifyListeners();
  }

  void onDropdownChanged(String value) {
    dropdown_text = value;
    notifyListeners();
  }

  void onDropdownCallChanged(String value) {
    call = value;
    notifyListeners();
  }

  void changeRequest(BuildContext context) async {
    String age;
    String position;
    String teamPosition;
    int age_turn;
    String grade;
    switch (dropdown_text) {
      case 'りす':
        age = 'risu';
        position = 'scout';
        age_turn = 4;
        grade = 'cub';
        break;
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
      case '菊スカウト（隼を目指すスカウト）':
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
    if (isTeamLeader &&
        (age == 'syokyu' ||
            age == 'nikyu' ||
            age == 'ikkyu' ||
            age == 'kiku' ||
            age == 'hayabusa' ||
            age == 'fuji')) {
      teamPosition = 'teamLeader';
    } else {
      teamPosition = position;
    }
    if (familyController.text != '' &&
        firstController.text != '' &&
        dropdown_text != null &&
        call != null) {
      isLoading = true;
      notifyListeners();
      User user = await FirebaseAuth.instance.currentUser;
      if (user != null) {
        user.getIdTokenResult().then((token) async {
          String url =
              "https://asia-northeast1-cubook-3c960.cloudfunctions.net/changeUserInfo_group";
          Map<String, String> headers = {'content-type': 'application/json'};
          String body = json.encode(<String, dynamic>{
            'idToken': token.token,
            'family': familyController.text,
            'first': firstController.text,
            'call': call,
            'team': teamController.text,
            'teamPosition': teamPosition,
            'age': age,
            'age_turn': age_turn,
            'uid': uid,
            'grade': grade
          });

          http.Response resp =
              await http.post(Uri.parse(url), headers: headers, body: body);
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
              content: new Text('エラーが発生しました' + resp.body),
            ));
          }
          notifyListeners();
        });
        /*user.getIdTokenResult().then((token) async {
          HttpsCallable callable = FirebaseFunctions.instanceFor(
              region: 'asia-northeast1')
              .httpsCallable('changeGroupUserInfo',
              options: HttpsCallableOptions(timeout: Duration(seconds: 5)));

          await callable(<String, dynamic>{
            'idToken': token.token,
            'family': familyController.text,
            'first': firstController.text,
            'call': call,
            'team': teamController.text,
            'teamPosition': teamPosition,
            'age': age,
            'age_turn': age_turn,
            'uid': uid,
            'grade': grade
          }).then((v) {
            ScaffoldMessenger.of(context).showSnackBar(new SnackBar(
              content: new Text('変更を保存しました¥n' + v.toString()),
            ));
          }).catchError((dynamic e) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('ERROR: $e'),
            ));
          });
          isLoading = false;
          notifyListeners();
        });*/
      }
    } else {
      notifyListeners();
    }
  }

  void showDeleteSheet(BuildContext context) async {
    isFinish = false;
    notifyListeners();
    await showModalBottomSheet<int>(
        context: context,
        builder: (BuildContext context) {
          return Consumer<SettingAccountGroupModel>(
            builder: (context, model, child) {
              return Padding(
                  padding: EdgeInsets.only(top: 10, bottom: 10),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      model.isFinish
                          ? Column(
                              children: [
                                Padding(
                                    padding:
                                        EdgeInsets.only(top: 10, bottom: 10),
                                    child: Text(
                                      '👋',
                                      style: TextStyle(
                                        fontSize: 30,
                                      ),
                                    )),
                                Text(
                                  'アカウントを削除しました',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                                Padding(
                                    padding:
                                        EdgeInsets.only(top: 10, bottom: 10),
                                    child: ElevatedButton(
                                      onPressed: () {
                                        model.backToList(context);
                                      },
                                      style: ElevatedButton.styleFrom(
                                        primary: Colors.blue[900], //ボタンの背景色
                                      ),
                                      child: Text(
                                        "一覧に戻る",
                                      ),
                                    )),
                              ],
                            )
                          : !model.isLoading
                              ? Column(
                                  children: [
                                    Padding(
                                        padding: EdgeInsets.only(
                                            top: 5, left: 17, bottom: 17),
                                        child: Container(
                                            width: double.infinity,
                                            child: Text(
                                              '本当に削除しますか？',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 22,
                                              ),
                                              textAlign: TextAlign.left,
                                            ))),
                                    ListTile(
                                      leading: Icon(Icons.delete),
                                      title: Text('はい'),
                                      onTap: () {
                                        model.deleteAccount(context);
                                      },
                                    ),
                                    ListTile(
                                      leading: Icon(Icons.arrow_back),
                                      title: Text('いいえ'),
                                      onTap: () {
                                        Navigator.pop(context);
                                      },
                                    )
                                  ],
                                )
                              : Center(
                                  child: Padding(
                                      padding: EdgeInsets.all(15),
                                      child: CircularProgressIndicator()),
                                )
                    ],
                  ));
            },
          );
        });
  }

  void deleteAccount(BuildContext context) async {
    print('start deleting...');
    isLoading = true;
    notifyListeners();
    User user = await FirebaseAuth.instance.currentUser;
    if (user != null) {
      user.getIdTokenResult().then((token) async {
        String url =
            "https://asia-northeast1-cubook-3c960.cloudfunctions.net/deleteGroupAccount_https";
        Map<String, String> headers = {'content-type': 'application/json'};
        String body = json.encode(<String, dynamic>{
          'idToken': token.token,
          'uid': uid,
        });

        http.Response resp =
            await http.post(Uri.parse(url), headers: headers, body: body);
        isLoading = false;
        print('end');
        print(resp.body);
        if (resp.body == 'sucess') {
          isFinish = true;
        }
        isLoading = false;
        notifyListeners();
      });
    }
  }

  void backToList(BuildContext context) {
    Navigator.pop(context);
    Navigator.pop(context);
    Navigator.pop(context);
    isFinish = false;
    notifyListeners();
  }
}
