import 'package:cubook/model/themeInfo.dart';
import 'package:cubook/settingGroup/settingGroup_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingGroupView extends StatelessWidget {
  ThemeInfo theme = ThemeInfo();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('グループ設定'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: Column(
                children: <Widget>[
                  Padding(
                      padding: const EdgeInsets.only(top: 20, left: 17),
                      child: Container(
                          width: double.infinity,
                          child: const Text(
                            'グループID',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            textAlign: TextAlign.left,
                          ))),
                  Padding(
                      padding: const EdgeInsets.only(top: 20, bottom: 10),
                      child: Consumer<SettingGroupModel>(builder:
                          (BuildContext context, SettingGroupModel model,
                              Widget? child) {
                        model.getUser();
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            ListTile(
                              leading: const Icon(Icons.copy),
                              title: Text(model.groupID!),
                              onTap: () async {
                                await Clipboard.setData(
                                    ClipboardData(text: model.groupID!));
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(
                                  content: Text('グループIDをクリップボードにコピーしました'),
                                ));
                              },
                            ),
                          ],
                        );
                      })),
                  Padding(
                      padding: const EdgeInsets.all(10),
                      child: Container(
                          child: TextButton.icon(
                        icon: const Icon(Icons.info_outline),
                        label: const Text('アカウント移行の手順'),
                        onPressed: () async {
                          const String url =
                              'https://sites.google.com/view/cubookinfo/%E4%BD%BF%E3%81%84%E6%96%B9/%E3%82%A2%E3%82%AB%E3%82%A6%E3%83%B3%E3%83%88%E7%A7%BB%E8%A1%8C%E3%81%AE%E6%89%8B%E9%A0%86';
                          if (await canLaunch(url)) {
                            await launch(url);
                          } else {
                            throw 'Could not launch $url';
                          }
                        },
                      ))),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
