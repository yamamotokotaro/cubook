import 'package:cubook/model/task.dart';
import 'package:cubook/model/themeInfo.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AccountMigrationView extends StatelessWidget {
  var task = new TaskContents();
  var theme = new ThemeInfo();
  String uid;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('アカウントを移行'),
        ),
        body: SafeArea(
            child: SingleChildScrollView(
                child: Center(
                    child: ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: 600),
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(top: 30),
                              child: Text(
                                '移行先のグループIDを入力してください',
                                style: TextStyle(
                                  fontSize: 21,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(10),
                              child: TextField(
                                // controller: model.familyController,
                                enabled: true,
                                decoration: InputDecoration(labelText: "グループID"),
                                onChanged: (text) {
                                  //model.joinCode = text;
                                },
                              ),
                            ),
                            RaisedButton.icon(
                              onPressed: () {
                              },
                              icon: Icon(
                                Icons.send,
                                size: 20,
                                color: Colors.white,
                              ),
                              color: Colors.blue[900],
                              label: Text(
                                '移行申請を送信',
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ),
                          ],
                        ))))));
  }
}
