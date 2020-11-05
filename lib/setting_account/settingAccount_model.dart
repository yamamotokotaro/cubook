import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingAccountModel extends ChangeNotifier {
  DocumentSnapshot userSnapshot;
  User currentUser;
  bool isGet = false;
  bool isLoading = false;
  bool passwordError = false;
  TextEditingController addressController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  String uid;
  String mailAddress;
  Map<String, dynamic> claims = new Map<String, dynamic>();

  void getUser() async {
    String uid_before = uid;
    String mailAddress_before = mailAddress;
    User user = await FirebaseAuth.instance.currentUser;
    currentUser = user;
    uid = currentUser.uid;
    mailAddress = currentUser.email;
    addressController.text = currentUser.email;
    if (uid == null || uid != uid_before || mailAddress != mailAddress_before) {
      notifyListeners();
    }
  }

  void changeEmail(BuildContext context) async {
    if (RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(addressController.text)) {
      try {
        await currentUser.updateEmail(addressController.text);
        Scaffold.of(context).showSnackBar(new SnackBar(
          content: new Text('メールアドレスを変更しました'),
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
                          "パスワードを入力してください",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        )),
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20.0))),
                    content: SingleChildScrollView(child:
                        Consumer<SettingAccountModel>(
                            builder: (context, model, child) {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.all(0),
                            child: TextField(
                              controller: model.passwordController,
                              enabled: true,
                              maxLengthEnforced: false,
                              obscureText: true,
                              decoration: InputDecoration(
                                  labelText: "パスワード",
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
                        child: Text("認証"),
                        onPressed: () async {
                          FocusScope.of(context).unfocus();
                          var credential = EmailAuthProvider.credential(
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
      Scaffold.of(context).showSnackBar(new SnackBar(
        content: new Text('送信リクエストが完了しました'),
      ));
    } catch (error) {
      Scaffold.of(context).showSnackBar(new SnackBar(
        content: new Text('エラーが発生しました'),
      ));
    }
  }
}
