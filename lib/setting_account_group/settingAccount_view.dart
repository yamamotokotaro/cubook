import 'package:cubook/model/task.dart';
import 'package:cubook/model/themeInfo.dart';
import 'package:cubook/setting_account_group/settingAccount_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingAccountView extends StatelessWidget {
  var task = new Task();
  var theme = new ThemeInfo();

  String uid;

  SettingAccountView(String _uid) {
    uid = _uid;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: SingleChildScrollView(
                child: Center(
                    child: ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: 600),
                        child: Consumer<SettingAccountModel>(
                            builder: (context, model, child) {
                          model.getSnapshot(uid);
                          if (model.userSnapshot != null) {
                            return Column(
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.all(10),
                                  child: TextField(
                                    controller: model.familyController,
                                    enabled: true,
                                    decoration: InputDecoration(labelText: "姓"),
                                    onChanged: (text) {
                                      //model.joinCode = text;
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(10),
                                  child: TextField(
                                    controller: model.firstController,
                                    enabled: true,
                                    decoration: InputDecoration(labelText: "名"),
                                    onChanged: (text) {
                                      //model.joinCode = text;
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(10),
                                  child: TextField(
                                    controller: model.teamController,
                                    enabled: true,
                                    // 入力数
                                    keyboardType: TextInputType.number,
                                    maxLines: null,
                                    maxLengthEnforced: false,
                                    decoration: InputDecoration(labelText: "組"),
                                    onChanged: (text) {},
                                  ),
                                ),
                                Padding(
                                    padding: EdgeInsets.only(top: 10, left: 10),
                                    child: Container(
                                        width: double.infinity,
                                        child: Text(
                                          '進歩',
                                          style: TextStyle(
                                              fontSize: 13,
                                              color:
                                                  Theme.of(context).hintColor),
                                          textAlign: TextAlign.left,
                                        ))),
                                Padding(
                                    padding:
                                        EdgeInsets.only(left: 10, right: 10),
                                    child: DropdownButton<String>(
                                      isExpanded: true,
                                      hint: Text('役割を選択'),
                                      value: model.dropdown_text,
                                      items: <String>['うさぎ', 'しか', 'くま','ボーイスカウトバッジ', '初級スカウト', '2級スカウト', '1級スカウト', '菊スカウト', '隼スカウト', '富士スカウト']
                                          .map((String value) {
                                        return new DropdownMenuItem<String>(
                                          value: value,
                                          child: new Text(value),
                                        );
                                      }).toList(),
                                      onChanged: (value) {
                                        model.onDropdownChanged(value);
                                      },
                                    )),
                                Padding(
                                    padding: EdgeInsets.only(top: 10, left: 10),
                                    child: Container(
                                        width: double.infinity,
                                        child: Text(
                                          '呼称',
                                          style: TextStyle(
                                              fontSize: 13,
                                              color:
                                                  Theme.of(context).hintColor),
                                          textAlign: TextAlign.left,
                                        ))),
                                Padding(
                                    padding:
                                        EdgeInsets.only(left: 10, right: 10),
                                    child: DropdownButton<String>(
                                      isExpanded: true,
                                      hint: Text('呼称'),
                                      value: model.call,
                                      items: <String>['くん', 'さん']
                                          .map((String value) {
                                        return new DropdownMenuItem<String>(
                                          value: value,
                                          child: new Text(value),
                                        );
                                      }).toList(),
                                      onChanged: (value) {
                                        model.onDropdownCallChanged(value);
                                      },
                                    )),
                                Padding(
                                  padding: EdgeInsets.only(top: 10),
                                    child: !model.isLoading
                                        ? RaisedButton.icon(
                                            onPressed: () {
                                              model.changeRequest(context, uid);
                                            },
                                            icon: Icon(
                                              Icons.save,
                                              size: 20,
                                              color: Colors.white,
                                            ),
                                            color: Colors.blue[900],
                                            label: Text(
                                              '変更を保存',
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white),
                                            ),
                                          )
                                        : Center(
                                            child: Padding(
                                                padding: EdgeInsets.all(5),
                                                child:
                                                    CircularProgressIndicator()),
                                          ))
                              ],
                            );
                          } else {
                            return const Center(
                              child: Padding(
                                  padding: EdgeInsets.all(5),
                                  child: CircularProgressIndicator()),
                            );
                          }
                        }))))));
  }
}
