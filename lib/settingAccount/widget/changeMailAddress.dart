import 'package:cubook/model/themeInfo.dart';
import 'package:cubook/settingAccount/settingAccount_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class ChangeMailAddressView extends StatelessWidget {
  ThemeInfo theme = ThemeInfo();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('メールアドレスを変更'),
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
                              padding:
                                  const EdgeInsets.only(top: 20, bottom: 10),
                              child: Consumer<SettingAccountModel>(builder:
                                  (BuildContext context,
                                      SettingAccountModel model,
                                      Widget? child) {
                                return Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: TextField(
                                        maxLengthEnforcement:
                                            MaxLengthEnforcement.none,
                                        controller: model.addressController,
                                        enabled: true,
                                        // 入力数
                                        keyboardType: TextInputType.multiline,
                                        maxLines: null,
                                        decoration: const InputDecoration(
                                          labelText: 'メールアドレス',
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
                                            child: ElevatedButton(
                                              onPressed: () {
                                                FocusScope.of(context)
                                                    .unfocus();
                                                model.changeEmail(context);
                                              },
                                              child: const Text('変更'),
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
