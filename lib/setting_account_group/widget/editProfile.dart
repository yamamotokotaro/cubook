import 'package:cubook/model/task.dart';
import 'package:cubook/model/themeInfo.dart';
<<<<<<< HEAD
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
=======
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
>>>>>>> develop
import 'package:provider/provider.dart';

import '../settingAccount_model.dart';

class EditProfile extends StatelessWidget {
<<<<<<< HEAD
  TaskContents task = TaskContents();
  ThemeInfo theme = ThemeInfo();
=======
  var task = new TaskContents();
  var theme = new ThemeInfo();
>>>>>>> develop

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
<<<<<<< HEAD
          title: const Text('プロフィールの編集'),
=======
          title: Text('プロフィールの編集'),
>>>>>>> develop
        ),
        body: SafeArea(
            child: SingleChildScrollView(
                child: Center(
                    child: ConstrainedBox(
<<<<<<< HEAD
                        constraints: const BoxConstraints(maxWidth: 600),
                        child: Consumer<SettingAccountGroupModel>(builder:
                            (BuildContext context,
                                SettingAccountGroupModel model, Widget? child) {
                          return Column(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(10),
                                child: TextField(
                                  controller: model.familyController,
                                  enabled: true,
                                  decoration:
                                      const InputDecoration(labelText: '姓'),
                                  onChanged: (String text) {
=======
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
                                  decoration: InputDecoration(labelText: "姓"),
                                  onChanged: (text) {
>>>>>>> develop
                                    //model.joinCode = text;
                                  },
                                ),
                              ),
                              Padding(
<<<<<<< HEAD
                                padding: const EdgeInsets.all(10),
                                child: TextField(
                                  controller: model.firstController,
                                  enabled: true,
                                  decoration:
                                      const InputDecoration(labelText: '名'),
                                  onChanged: (String text) {
=======
                                padding: EdgeInsets.all(10),
                                child: TextField(
                                  controller: model.firstController,
                                  enabled: true,
                                  decoration: InputDecoration(labelText: "名"),
                                  onChanged: (text) {
>>>>>>> develop
                                    //model.joinCode = text;
                                  },
                                ),
                              ),
                              Padding(
<<<<<<< HEAD
                                padding: const EdgeInsets.all(10),
                                child: TextField(
                                  maxLengthEnforcement:
                                      MaxLengthEnforcement.none,
=======
                                padding: EdgeInsets.all(10),
                                child: TextField(
>>>>>>> develop
                                  controller: model.teamController,
                                  enabled: true,
                                  // 入力数
                                  maxLines: null,
<<<<<<< HEAD
                                  decoration: const InputDecoration(
                                      labelText: '組・班（オプション）'),
                                  onChanged: (String text) {},
                                ),
                              ),
                              Padding(
                                  padding:
                                      const EdgeInsets.only(top: 10, left: 10),
=======
                                  maxLengthEnforced: false,
                                  decoration:
                                      InputDecoration(labelText: "組・班（オプション）"),
                                  onChanged: (text) {},
                                ),
                              ),
                              Padding(
                                  padding: EdgeInsets.only(top: 10, left: 10),
>>>>>>> develop
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
<<<<<<< HEAD
                                  padding: const EdgeInsets.only(
                                      left: 10, right: 10),
                                  child: DropdownButton<String>(
                                    isExpanded: true,
                                    hint: const Text('役割を選択'),
=======
                                  padding: EdgeInsets.only(left: 10, right: 10),
                                  child: DropdownButton<String>(
                                    isExpanded: true,
                                    hint: Text('役割を選択'),
>>>>>>> develop
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
<<<<<<< HEAD
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                    onChanged: (String? value) {
                                      model.onDropdownChanged(value);
                                    },
                                  )),
                              if (model.dropdown_text == 'ボーイスカウトバッジ' ||
                                  model.dropdown_text == '初級スカウト' ||
                                  model.dropdown_text == '2級スカウト' ||
                                  model.dropdown_text == '1級スカウト' ||
                                  model.dropdown_text == '菊スカウト（隼を目指すスカウト）' ||
                                  model.dropdown_text == '隼スカウト' ||
                                  model.dropdown_text == '富士スカウト')
                                Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Checkbox(
                                        value: model.isTeamLeader,
                                        onChanged:
                                            model.onCheckboxTeamLeaderChanged,
                                        activeColor: Colors.blue[600],
                                      ),
                                      const Text('班長')
                                    ],
                                  ),
                                )
                              else
                                Container(),
                              Padding(
                                  padding:
                                      const EdgeInsets.only(top: 10, left: 10),
=======
                                      return new DropdownMenuItem<String>(
                                        value: value,
                                        child: new Text(value),
                                      );
                                    }).toList(),
                                    onChanged: (value) {
                                      model.onDropdownChanged(value);
                                    },
                                  )),
                              model.dropdown_text == 'ボーイスカウトバッジ' ||
                                      model.dropdown_text == '初級スカウト' ||
                                      model.dropdown_text == '2級スカウト' ||
                                      model.dropdown_text == '1級スカウト' ||
                                      model.dropdown_text ==
                                          '菊スカウト（隼を目指すスカウト）' ||
                                      model.dropdown_text == '隼スカウト' ||
                                      model.dropdown_text == '富士スカウト'
                                  ? Padding(
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
                                    )
                                  : Container(),
                              Padding(
                                  padding: EdgeInsets.only(top: 10, left: 10),
>>>>>>> develop
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
<<<<<<< HEAD
                                  padding: const EdgeInsets.only(
                                      left: 10, right: 10),
                                  child: DropdownButton<String>(
                                    isExpanded: true,
                                    hint: const Text('呼称'),
                                    value: model.call,
                                    items: <String>['くん', 'さん']
                                        .map((String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                    onChanged: (String? value) {
=======
                                  padding: EdgeInsets.only(left: 10, right: 10),
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
>>>>>>> develop
                                      model.onDropdownCallChanged(value);
                                    },
                                  )),
                              Padding(
<<<<<<< HEAD
                                  padding: const EdgeInsets.only(top: 10),
                                  child: !model.isLoading
                                      ? ElevatedButton.icon(
                                          onPressed: () {
                                            model.changeRequest(context);
                                          },
                                          icon: const Icon(
                                            Icons.save,
                                            size: 20,
                                          ),
                                          label: const Text(
                                            '変更を保存',
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        )
                                      : const Center(
=======
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
>>>>>>> develop
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
