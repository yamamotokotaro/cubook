import 'package:cubook/model/themeInfo.dart';
import 'package:cubook/setting_account/settingAccount_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChangePasswordView extends StatelessWidget {
  ThemeInfo theme = ThemeInfo();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('パスワードを変更'),
        ),
        body: Builder(builder: (BuildContext context) {
          return GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              child: SafeArea(
                child: SingleChildScrollView(
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 600),
                      child: Column(
                        children: <Widget>[
                          Padding(
                              padding: const EdgeInsets.only(top: 20, bottom: 10),
                              child: Consumer<SettingAccountModel>(
                                  builder: (BuildContext context, SettingAccountModel model, Widget? child) {
                                model.getUser();
                                return Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 10,
                                          bottom: 10,
                                          left: 15,
                                          right: 10),
                                      child: Text(
                                        model.mailAddress! +
                                            ' にパスワード再設定用のメールを送ります',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 23,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                        padding: const EdgeInsets.only(
                                            top: 10,
                                            bottom: 10,
                                            left: 15,
                                            right: 10),
                                        child: Align(
                                            alignment: Alignment.topLeft,
                                            child: RaisedButton(
                                              onPressed: () {
                                                model.sendPasswordResetEmail(
                                                    context);
                                              },
                                              child: const Text('送信'),
                                            ))),
                                  ],
                                );
                              }))
                        ],
                      ),
                    ),
                  ),
                ),
              ));
        }));
  }
}
