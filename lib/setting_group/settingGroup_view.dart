import 'package:cubook/model/themeInfo.dart';
import 'package:cubook/setting_account/settingAccount_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingGroupView extends StatelessWidget {
  var theme = new ThemeInfo();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('グループ設定'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 600),
              child: Column(
                children: <Widget>[
                  Padding(
                      padding: EdgeInsets.only(
                          top: 20, left: 17),
                      child: Container(
                          width: double.infinity,
                          child: Text(
                            'グループID',
                            style: TextStyle(
                              fontWeight:
                              FontWeight.bold,
                              fontSize: 16,
                            ),
                            textAlign:
                            TextAlign.left,
                          ))),
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
                                  Icon(Icons.read_more),
                                  title: Text('アカウント移行の受け入れ'),
                                  onTap: () {
                                    Navigator.of(context)
                                        .pushNamed('/changeMailAddressView');
                                  },
                                ),
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
