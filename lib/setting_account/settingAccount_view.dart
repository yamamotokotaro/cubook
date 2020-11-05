import 'package:cubook/model/themeInfo.dart';
import 'package:cubook/setting_account/settingAccount_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingAccountView extends StatelessWidget {
  var theme = new ThemeInfo();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('アカウント設定'),
      ),
      body: SafeArea(
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
                                ListTile(
                                  leading:
                                  Icon(Icons.mail_outline),
                                  title: Text('メールアドレスを変更'),
                                  onTap: () {
                                    Navigator.of(context)
                                        .pushNamed('/changeMailAddressView');
                                  },
                                ),
                                ListTile(
                                  leading:
                                  Icon(Icons.lock_outline),
                                  title: Text('パスワードを変更'),
                                  onTap: () {
                                    Navigator.of(context)
                                        .pushNamed('/changePasswordView');
                                  },
                                )
                              ],
                            );
                      }))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
