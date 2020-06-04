import 'package:cubook/model/task.dart';
import 'package:cubook/model/themeInfo.dart';
import 'package:cubook/setting_account_group/settingAccount_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingAccountView extends StatelessWidget {
  var task = new Task();
  var theme = new ThemeInfo();

  @override
  Widget build(BuildContext context) {
    final uid = ModalRoute.of(context).settings.arguments;
    return Scaffold(
        appBar: AppBar(
          title: Text('アカウント設定'),
        ),
        body: SafeArea(
            child: SingleChildScrollView(
                child: GestureDetector(
                    onTap: () {
                      FocusScope.of(context).unfocus();
                    },
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
                                        decoration:
                                            InputDecoration(labelText: "姓"),
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
                                        decoration:
                                            InputDecoration(labelText: "名"),
                                        onChanged: (text) {
                                          //model.joinCode = text;
                                        },
                                      ),
                                    ),
                                    DropdownButton<String>(
                                      hint: Text('役割を選択'),
                                      value: model.dropdown_text,
                                      items: <String>['うさぎ', 'しか', 'くま']
                                          .map((String value) {
                                        return new DropdownMenuItem<String>(
                                          value: value,
                                          child: new Text(value),
                                        );
                                      }).toList(),
                                      onChanged: (value) {
                                        model.onDropdownChanged(value);
                                      },
                                    ),
                                    DropdownButton<String>(
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
                                    ),
                                    !model.isLoading
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
                                          )
                                  ],
                                );
                              } else {
                                return const Center(
                                  child: Padding(
                                      padding: EdgeInsets.all(5),
                                      child: CircularProgressIndicator()),
                                );
                              }
                            })))))));
  }
}
