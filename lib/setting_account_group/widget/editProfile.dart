import 'package:cubook/model/task.dart';
import 'package:cubook/model/themeInfo.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../settingAccount_model.dart';

class EditProfile extends StatelessWidget {
  var task = TaskContents();
  var theme = ThemeInfo();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('プロフィールの編集'),
        ),
        body: SafeArea(
            child: SingleChildScrollView(
                child: Center(
                    child: ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: 600),
                        child: Consumer<SettingAccountGroupModel>(
                            builder: (context, model, child) {
                          return Column(
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.all(10),
                                child: TextField(
                                  controller: model.familyController,
                                  enabled: true,
                                  decoration: InputDecoration(labelText: '姓'),
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
                                  decoration: InputDecoration(labelText: '名'),
                                  onChanged: (text) {
                                    //model.joinCode = text;
                                  },
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(10),
                                child: TextField(
                                  maxLengthEnforcement: MaxLengthEnforcement.none, controller: model.teamController,
                                  enabled: true,
                                  // 入力数
                                  maxLines: null,
                                  decoration:
                                      InputDecoration(labelText: '組・班（オプション）'),
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
                                            color: Theme.of(context).hintColor),
                                        textAlign: TextAlign.left,
                                      ))),
                              Padding(
                                  padding: EdgeInsets.only(left: 10, right: 10),
                                  child: DropdownButton<String>(
                                    isExpanded: true,
                                    hint: Text('役割を選択'),
                                    value: model.dropdown_text,
                                    items: <String>[
                                      'りす',
                                      'うさぎ',
                                      'しか',
                                      'くま',
                                      'ボーイスカウトバッジ',
                                      '初級スカウト',
                                      '2級スカウト',
                                      '1級スカウト',
                                      '菊スカウト（隼を目指すスカウト）',
                                      '隼スカウト',
                                      '富士スカウト'
                                    ].map((String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                    onChanged: (value) {
                                      model.onDropdownChanged(value);
                                    },
                                  )),
                              if (model.dropdown_text == 'ボーイスカウトバッジ' ||
                                      model.dropdown_text == '初級スカウト' ||
                                      model.dropdown_text == '2級スカウト' ||
                                      model.dropdown_text == '1級スカウト' ||
                                      model.dropdown_text ==
                                          '菊スカウト（隼を目指すスカウト）' ||
                                      model.dropdown_text == '隼スカウト' ||
                                      model.dropdown_text == '富士スカウト') Padding(
                                      padding: EdgeInsets.only(top: 10),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: <Widget>[
                                          Checkbox(
                                            value: model.isTeamLeader,
                                            onChanged: model
                                                .onCheckboxTeamLeaderChanged,
                                            activeColor: Colors.blue[600],
                                          ),
                                          Text('班長')
                                        ],
                                      ),
                                    ) else Container(),
                              Padding(
                                  padding: EdgeInsets.only(top: 10, left: 10),
                                  child: Container(
                                      width: double.infinity,
                                      child: Text(
                                        '呼称',
                                        style: TextStyle(
                                            fontSize: 13,
                                            color: Theme.of(context).hintColor),
                                        textAlign: TextAlign.left,
                                      ))),
                              Padding(
                                  padding: EdgeInsets.only(left: 10, right: 10),
                                  child: DropdownButton<String>(
                                    isExpanded: true,
                                    hint: Text('呼称'),
                                    value: model.call,
                                    items: <String>['くん', 'さん']
                                        .map((String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                    onChanged: (value) {
                                      model.onDropdownCallChanged(value);
                                    },
                                  )),
                              Padding(
                                  padding: EdgeInsets.only(top: 10),
                                  child: !model.isLoading
                                      ? ElevatedButton.icon(
                                          style: ElevatedButton.styleFrom(
                                            primary: Colors.blue[900], //ボタンの背景色
                                          ),
                                          onPressed: () {
                                            model.changeRequest(context);
                                          },
                                          icon: Icon(
                                            Icons.save,
                                            size: 20,
                                            color: Colors.white,
                                          ),
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
                                        )),
                            ],
                          );
                        }))))));
  }
}
