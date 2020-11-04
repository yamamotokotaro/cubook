import 'package:cubook/model/themeInfo.dart';
import 'package:cubook/setting_account/settingAccount_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChangePasswordView extends StatelessWidget {
  var theme = new ThemeInfo();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('パスワードを変更'),
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
                      constraints: BoxConstraints(maxWidth: 600),
                      child: Column(
                        children: <Widget>[
                          Padding(
                              padding: EdgeInsets.only(top: 20, bottom: 10),
                              child: Consumer<SettingAccountModel>(
                                  builder: (context, model, child) {
                                model.getUser();
                                return Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Padding(
                                      padding: EdgeInsets.only(
                                          top: 10,
                                          bottom: 10,
                                          left: 15,
                                          right: 10),
                                      child: Text(
                                        model.mailAddress +
                                            ' にパスワード再設定用のメールを送ります',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 23,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                        padding: EdgeInsets.only(
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
                                              child: Text('送信'),
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
