import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:cubook/model/task.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class SettingAccountGroupModel extends ChangeNotifier {
  DocumentSnapshot? userSnapshot;
  Map<String, dynamic>? userData;
  bool? isAdmin = false;
  User? currentUser;
  bool isGet = false;
  bool isFinish = false;
  bool isLoading = false;
<<<<<<< HEAD
  bool? isTeamLeader;
  String? group;
  String? group_claim;
  TextEditingController? familyController;
  TextEditingController? firstController;
  TextEditingController? teamController;
  TextEditingController? groupIdController;
  String? dropdown_text;
  String? age;
  String? call;
  String? uid;
  Map<String, dynamic> claims = <String, dynamic>{};

  Future<void> getSnapshot(String? uidToShow) async {
    final TaskContents task = TaskContents();
    if (uidToShow != uid) {
      uid = uidToShow;
      final User user = FirebaseAuth.instance.currentUser!;
=======
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
>>>>>>> develop
      currentUser = user;
      user.getIdTokenResult().then((IdTokenResult token) async {
        isAdmin = token.claims!['admin'];
        FirebaseFirestore.instance
            .collection('user')
            .where('group', isEqualTo: token.claims!['group'])
            .where('uid', isEqualTo: uid)
            .snapshots()
            .listen((QuerySnapshot<Map<String, dynamic>> data) {
          userSnapshot = data.docs[0];
<<<<<<< HEAD
          userData = userSnapshot!.data() as Map<String, dynamic>?;
          final String? family = userSnapshot!.get('family');
          group = userSnapshot!.get('group');
=======
          String family = userSnapshot.data()['family'];
          group = userSnapshot.data()['group'];
>>>>>>> develop
          familyController =
              TextEditingController(text: userSnapshot!.get('family'));
          firstController =
              TextEditingController(text: userSnapshot!.get('first'));
          groupIdController = TextEditingController();
          if (userData!['teamPosition'] != null) {
            if (userSnapshot!.get('teamPosition') == 'teamLeader') {
              isTeamLeader = true;
            } else {
              isTeamLeader = false;
            }
          } else {
            isTeamLeader = false;
          }
          String? team;
          if (userData!['team'] is int) {
            team = userSnapshot!.get('team').toString();
          } else {
            team = userData!['team'];
          }
          if (userData!['team'] != null) {
            teamController = TextEditingController(text: team);
          } else {
            teamController = TextEditingController();
          }
          switch (userSnapshot!.get('age')) {
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
          call = userSnapshot!.get('call');
          notifyListeners();
        });
        isGet = true;
      });
    }
  }

  Future<void> getGroup() async {
    final String? groupBefore = group;
    final User user = FirebaseAuth.instance.currentUser!;
    FirebaseFirestore.instance
        .collection('user')
        .where('uid', isEqualTo: user.uid)
        .get()
        .then((QuerySnapshot<Map<String, dynamic>> snapshot) {
      group = snapshot.docs[0].get('group');
      if (group != groupBefore) {
        notifyListeners();
      }
      user.getIdTokenResult().then((IdTokenResult value) {
        final String? groupClaimBefore = group_claim;
        group_claim = value.claims!['group'];
        if (groupClaimBefore != group_claim) {
          notifyListeners();
        }
      });
    });
  }

  void onCheckboxTeamLeaderChanged(bool? value) {
    isTeamLeader = value;
    notifyListeners();
  }

  void onDropdownChanged(String? value) {
    dropdown_text = value;
    notifyListeners();
  }

  void onDropdownCallChanged(String? value) {
    call = value;
    notifyListeners();
  }

<<<<<<< HEAD
  Future<void> changeRequest(BuildContext context) async {
    String? age;
    String? position;
    String? teamPosition;
    int? ageTurn;
    String? grade;
=======
  void changeRequest(BuildContext context) async {
    String age;
    String position;
    String teamPosition;
    int age_turn;
    String grade;
>>>>>>> develop
    switch (dropdown_text) {
      case 'りす':
        age = 'risu';
        position = 'scout';
        ageTurn = 4;
        grade = 'cub';
        break;
      case 'うさぎ':
        age = 'usagi';
        position = 'scout';
        ageTurn = 7;
        grade = 'cub';
        break;
      case 'しか':
        age = 'sika';
        position = 'scout';
        ageTurn = 8;
        grade = 'cub';
        break;
      case 'くま':
        age = 'kuma';
        position = 'scout';
        ageTurn = 9;
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
        ageTurn = 12;
        grade = 'boy';
        break;
      case '初級スカウト':
        age = 'nikyu';
        position = 'scout';
        ageTurn = 13;
        grade = 'boy';
        break;
      case '2級スカウト':
        age = 'ikkyu';
        position = 'scout';
        ageTurn = 14;
        grade = 'boy';
        break;
      case '1級スカウト':
        age = 'kiku';
        position = 'scout';
        ageTurn = 15;
        grade = 'boy';
        break;
      case '菊スカウト（隼を目指すスカウト）':
        age = 'hayabusa';
        position = 'scout';
        ageTurn = 16;
        grade = 'boy';
        break;
      case '隼スカウト':
        age = 'fuji';
        position = 'scout';
        ageTurn = 17;
        grade = 'boy';
        break;
    }
    if (isTeamLeader! &&
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
    if (familyController!.text != '' &&
        firstController!.text != '' &&
        dropdown_text != null &&
        call != null) {
      isLoading = true;
      notifyListeners();
      final User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
<<<<<<< HEAD
        user.getIdTokenResult().then((IdTokenResult token) async {
          const String url =
              'https://asia-northeast1-cubook-3c960.cloudfunctions.net/changeUserInfo_group';
          final Map<String, String> headers = {
            'content-type': 'application/json'
          };
          final String body = json.encode(<String, dynamic>{
=======
        user.getIdTokenResult().then((token) async {
          String url =
              "https://asia-northeast1-cubook-3c960.cloudfunctions.net/changeUserInfo_group";
          Map<String, String> headers = {'content-type': 'application/json'};
          String body = json.encode(<String, dynamic>{
>>>>>>> develop
            'idToken': token.token,
            'family': familyController!.text,
            'first': firstController!.text,
            'call': call,
            'team': teamController!.text,
            'teamPosition': teamPosition,
            'age': age,
            'age_turn': ageTurn,
            'uid': uid,
            'grade': grade
          });

<<<<<<< HEAD
          final http.Response resp =
=======
          http.Response resp =
>>>>>>> develop
              await http.post(Uri.parse(url), headers: headers, body: body);
          isLoading = false;
          if (resp.body == 'success') {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('変更を保存しました'),
            ));
          } else if (resp.body == 'No such document!' ||
              resp.body == 'not found') {
            isLoading = false;
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('ユーザーが見つかりませんでした'),
            ));
          } else {
            isLoading = false;
<<<<<<< HEAD
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('エラーが発生しました' + resp.body),
=======
            Scaffold.of(context).showSnackBar(new SnackBar(
              content: new Text('エラーが発生しました' + resp.body),
>>>>>>> develop
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

<<<<<<< HEAD
  Future<void> showDeleteSheet(BuildContext context) async {
=======
  void showDeleteSheet(BuildContext context) async {
>>>>>>> develop
    isFinish = false;
    notifyListeners();
    await showModalBottomSheet<int>(
        context: context,
        builder: (BuildContext context) {
          return Consumer<SettingAccountGroupModel>(
<<<<<<< HEAD
            builder: (BuildContext context, SettingAccountGroupModel model,
                Widget? child) {
              return Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 10),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      if (model.isFinish)
                        Column(
                          children: [
                            const Padding(
                                padding: EdgeInsets.only(top: 10, bottom: 10),
                                child: Text(
                                  '👋',
                                  style: TextStyle(
                                    fontSize: 30,
                                  ),
                                )),
                            const Text(
                              'アカウントを削除しました',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                              textAlign: TextAlign.left,
                            ),
                            Padding(
                                padding:
                                    const EdgeInsets.only(top: 10, bottom: 10),
                                child: ElevatedButton(
                                  onPressed: () {
                                    model.backToList(context);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue[900], //ボタンの背景色
                                  ),
                                  child: const Text(
                                    '一覧に戻る',
                                  ),
                                )),
                          ],
                        )
                      else
                        !model.isLoading
                            ? Column(
                                children: [
                                  Padding(
                                      padding: const EdgeInsets.only(
                                          top: 5, left: 17, bottom: 17),
                                      child: Container(
                                          width: double.infinity,
                                          child: const Text(
                                            '本当に削除しますか？',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 22,
                                            ),
                                            textAlign: TextAlign.left,
                                          ))),
                                  ListTile(
                                    leading: const Icon(Icons.delete),
                                    title: const Text('はい'),
                                    onTap: () {
                                      model.deleteAccount(context);
                                    },
                                  ),
                                  ListTile(
                                    leading: const Icon(Icons.arrow_back),
                                    title: const Text('いいえ'),
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                  )
                                ],
                              )
                            : const Center(
                                child: Padding(
                                    padding: EdgeInsets.all(15),
                                    child: CircularProgressIndicator()),
                              )
=======
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
>>>>>>> develop
                    ],
                  ));
            },
          );
        });
  }

<<<<<<< HEAD
  Future<void> deleteAccount(BuildContext context) async {
    isLoading = true;
    notifyListeners();
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      user.getIdTokenResult().then((IdTokenResult token) async {
        const String url =
            'https://asia-northeast1-cubook-3c960.cloudfunctions.net/deleteGroupAccount_https';
        final Map<String, String> headers = {
          'content-type': 'application/json'
        };
        final String body = json.encode(<String, dynamic>{
=======
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
>>>>>>> develop
          'idToken': token.token,
          'uid': uid,
        });

<<<<<<< HEAD
        final http.Response resp =
            await http.post(Uri.parse(url), headers: headers, body: body);
        isLoading = false;
=======
        http.Response resp =
            await http.post(Uri.parse(url), headers: headers, body: body);
        isLoading = false;
        print('end');
        print(resp.body);
>>>>>>> develop
        if (resp.body == 'sucess') {
          isFinish = true;
        }
        isLoading = false;
        notifyListeners();
      });
    }
  }

<<<<<<< HEAD
  Future<void> migrateAccount(BuildContext context) async {
    isLoading = true;
    notifyListeners();
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      user.getIdTokenResult().then((IdTokenResult token) async {
        const String url =
            'https://asia-northeast1-cubook-3c960.cloudfunctions.net/sendMigration';
        final Map<String, String> headers = {
          'content-type': 'application/json'
        };
        final String body = json.encode(<String, dynamic>{
          'idToken': token.token,
          'uid': uid,
          'groupID': groupIdController!.text
        });

        final http.Response resp =
            await http.post(Uri.parse(url), headers: headers, body: body);
        isLoading = false;
        if (resp.body == 'success') {
          isFinish = true;
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('申請の送信が完了しました'),
          ));
        }
        isLoading = false;
        notifyListeners();
      });
    }
  }

=======
>>>>>>> develop
  void backToList(BuildContext context) {
    Navigator.pop(context);
    Navigator.pop(context);
    Navigator.pop(context);
    isFinish = false;
    notifyListeners();
  }
}
