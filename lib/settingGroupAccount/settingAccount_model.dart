
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:cubook/model/task.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingAccountGroupModel extends ChangeNotifier {
  DocumentSnapshot? userSnapshot;
  Map<String, dynamic>? userData;
  bool? isAdmin = false;
  User? currentUser;
  bool isGet = false;
  bool isFinish = false;
  bool isLoading = false;
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
          userData = userSnapshot!.data() as Map<String, dynamic>?;
          final String? family = userSnapshot!.get('family');
          group = userSnapshot!.get('group');
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

  Future<void> changeRequest(BuildContext context) async {
    String? age;
    String? position;
    String? teamPosition;
    int? ageTurn;
    String? grade;
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

      final HttpsCallable callable =
          FirebaseFunctions.instanceFor(region: 'asia-northeast1')
              .httpsCallable(
        'changeGroupUserInfo',
        options: HttpsCallableOptions(
          timeout: const Duration(seconds: 5),
        ),
      );

      try {
        final HttpsCallableResult result =
            await callable.call<String>(<String, String>{
          'family': familyController!.text,
          'first': firstController!.text,
          'call': call!,
          'team': teamController!.text,
          'teamPosition': teamPosition!,
          'age': age!,
          'age_turn': ageTurn!.toString(),
          'uid': uid!,
          'grade': grade!
        });
        if (result.data == 'success') {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('変更を保存しました'),
          ));
        } else if (result.data == 'No such document!' ||
            result.data == 'not found') {
          isLoading = false;
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('ユーザーが見つかりませんでした'),
          ));
        } else {
          isLoading = false;
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('エラーが発生しました' + result.data),
          ));
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('エラーが発生しました' + e.toString()),
        ));
      }
      isLoading = false;
      notifyListeners();
    } else {
      notifyListeners();
    }
  }

  Future<void> showDeleteSheet(BuildContext context) async {
    isFinish = false;
    notifyListeners();
    await showModalBottomSheet<int>(
        context: context,
        builder: (BuildContext context) {
          return Consumer<SettingAccountGroupModel>(
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
                                child: FilledButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                    isFinish = false;
                                    notifyListeners();
                                  },
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
                    ],
                  ));
            },
          );
        });
  }

  Future<void> deleteAccount(BuildContext context) async {
    isLoading = true;
    notifyListeners();

    final HttpsCallable callable =
        FirebaseFunctions.instanceFor(region: 'asia-northeast1').httpsCallable(
      'deleteGroupAccount',
      options: HttpsCallableOptions(
        timeout: const Duration(seconds: 5),
      ),
    );

    try {
      final HttpsCallableResult result =
          await callable.call<String>(<String, String>{'uid': uid!});
      if (result.data == 'success') {
        isFinish = true;
      } else {
        isFinish = true;
      }
    } catch (e) {
      isFinish = true;
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> migrateAccount(BuildContext context) async {
    isLoading = true;

    final HttpsCallable callable =
        FirebaseFunctions.instanceFor(region: 'asia-northeast1').httpsCallable(
      'sendMigrationCall',
      options: HttpsCallableOptions(
        timeout: const Duration(seconds: 5),
      ),
    );

    try {
      final HttpsCallableResult result = await callable.call<String>(
          <String, String>{'uid': uid!, 'groupID': groupIdController!.text});
      if (result.data == 'success') {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('申請の送信が完了しました'),
        ));
        isFinish = true;
      } else {
        isFinish = true;
      }
    } catch (e) {
      isFinish = true;
    }
    isLoading = false;
    notifyListeners();
  }
}
