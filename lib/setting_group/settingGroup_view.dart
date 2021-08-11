import 'package:cubook/model/themeInfo.dart';
import 'package:cubook/setting_group/settingGroup_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class SettingGroupView extends StatelessWidget {
  var theme = ThemeInfo();

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
                      child: Consumer<SettingGroupModel>(
                          builder: (context, model, child) {
                            model.getUser();
                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                ListTile(
                                  leading:
                                  Icon(Icons.copy),
                                  title: Text(model.groupID),
                                  onTap: () async {
                                    await Clipboard.setData(ClipboardData(text: model.groupID));
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                      content: const Text('グループIDをクリップボードにコピーしました'),));
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
