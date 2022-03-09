import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class SettingAccountModel extends ChangeNotifier {
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

  void getUser() async {
    final String uidBefore = uid;
    final String mailAddressBefore = mailAddress;
    final User user = FirebaseAuth.instance.currentUser;
    currentUser = user;
    uid = currentUser.uid;
    mailAddress = currentUser.email;
    addressController.text = currentUser.email;
    if (uid == null || uid != uidBefore || mailAddress != mailAddressBefore) {
      notifyListeners();
    }
  }

  void changeEmail(BuildContext context) async {
    if (RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(addressController.text)) {
      try {
        await currentUser.updateEmail(addressController.text);
        Scaffold.of(context).showSnackBar(const SnackBar(
          content: Text('メールアドレスを変更しました'),
        ));
      } catch (error) {
        await showDialog<int>(
            context: context,
            builder: (BuildContext context) {
              return GestureDetector(
                  onTap: () {
                    FocusScope.of(context).unfocus();
                  },
                  child: AlertDialog(
                    title: const Padding(
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
                        Consumer<SettingAccountModel>(
                            builder: (BuildContext context, SettingAccountModel model, Widget child) {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(0),
                            child: TextField(
                              maxLengthEnforcement: MaxLengthEnforcement.none, controller: model.passwordController,
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
                        child: const Text('認証'),
                        onPressed: () async {
                          FocusScope.of(context).unfocus();
                          final AuthCredential credential = EmailAuthProvider.credential(
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
      Scaffold.of(context).showSnackBar(const SnackBar(
        content: Text('送信リクエストが完了しました'),
      ));
    } catch (error) {
      Scaffold.of(context).showSnackBar(const SnackBar(
        content: Text('エラーが発生しました'),
      ));
    }
  }
}
