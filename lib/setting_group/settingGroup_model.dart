import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class SettingGroupModel extends ChangeNotifier {
  DocumentSnapshot userSnapshot;
  User currentUser;
  bool isGet = false;
  bool isLoading = false;
  bool passwordError = false;
  TextEditingController addressController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String uid;
  String mailAddress;
  Map<String, dynamic> claims = <String, dynamic>{};
  String groupID = "読み込み中";

  void getUser() async {
    final String groupBefore = groupID;
    final User user = FirebaseAuth.instance.currentUser;
    currentUser = user;
    uid = currentUser.uid;
    mailAddress = currentUser.email;
    addressController.text = currentUser.email;
    FirebaseFirestore.instance
        .collection('user')
        .where('uid', isEqualTo: user.uid)
        .get()
        .then((snapshot) {
      final DocumentSnapshot documentSnapshot = snapshot.docs[0];
      groupID = documentSnapshot.get('group');
      if (groupBefore != groupID) {
        notifyListeners();
      }
    });
  }

  void changeEmail(BuildContext context) async {
    if (RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(addressController.text)) {
      try {
        await currentUser.updateEmail(addressController.text);
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text('メールアドレスを変更しました'),
        ));
      } catch (error) {
        await showDialog<int>(
            context: context,
            builder: (context) {
              return GestureDetector(
                  onTap: () {
                    FocusScope.of(context).unfocus();
                  },
                  child: AlertDialog(
                    title: Padding(
                        padding: EdgeInsets.only(left: 15),
                        child: Text(
                          'パスワードを入力してください',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        )),
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20.0))),
                    content: SingleChildScrollView(child:
                        Consumer<SettingGroupModel>(
                            builder: (context, model, child) {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.all(0),
                            child: TextField(
                              maxLengthEnforcement: MaxLengthEnforcement.none,
                              controller: model.passwordController,
                              enabled: true,
                              obscureText: true,
                              decoration: InputDecoration(
                                  labelText: 'パスワード',
                                  errorText: model.passwordError
                                      ? 'パスワードが確認できません'
                                      : null),
                            ),
                          ),
                        ],
                      );
                    })),
                    actions: <Widget>[
                      FlatButton(
                        child: Text('認証'),
                        onPressed: () async {
                          FocusScope.of(context).unfocus();
                          final credential = EmailAuthProvider.credential(
                              email: mailAddress,
                              password: passwordController.text);
                          try {
                            await currentUser
                                .reauthenticateWithCredential(credential);
                            passwordError = false;
                            changeEmail(context);
                            Navigator.pop(context);
                          } catch (error) {
                            passwordError = true;
                            print('error');
                            notifyListeners();
                          }
                        },
                      ),
                    ],
                  ));
            });
      }
    }
  }

  void sendPasswordResetEmail(BuildContext context) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: mailAddress);
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text('送信リクエストが完了しました'),
      ));
    } catch (error) {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text('エラーが発生しました'),
      ));
    }
  }
}