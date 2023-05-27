import 'package:cubook/model/themeInfo.dart';
import 'package:cubook/setting_account/settingAccount_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class SettingAccountView extends StatelessWidget {
  ThemeInfo theme = ThemeInfo();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('アカウント設定'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: Column(
                children: <Widget>[
                  Padding(
                      padding: const EdgeInsets.only(top: 20, bottom: 10),
                      child: Consumer<SettingAccountModel>(builder:
                          (BuildContext context, SettingAccountModel model,
                              Widget? child) {
                        model.getUser();
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            ListTile(
                              leading: const Icon(Icons.mail_outline),
                              title: const Text('メールアドレスを変更'),
                              onTap: () {
                                Navigator.of(context)
                                    .pushNamed('/changeMailAddressView');
                              },
                            ),
                            ListTile(
                              leading: const Icon(Icons.lock_outline),
                              title: const Text('パスワードを変更'),
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
