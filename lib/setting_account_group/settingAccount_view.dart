import 'package:cubook/model/task.dart';
import 'package:cubook/model/themeInfo.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SettingAccountView extends StatelessWidget {
  var task = new Task();
  var theme = new ThemeInfo();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('メンバー詳細'),
        ),
        body: SafeArea(
            child: SingleChildScrollView(
                child: Center(
                    child: ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: 600),
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.all(10),
                              child: Container(
                                child: InkWell(
                                  onTap: () {},
                                  child: Column(
                                    children: <Widget>[
                                      Text('名前'),
                                      Text('山本虎太郎')
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              child: InkWell(
                                onTap: () {},
                                child: Column(
                                  children: <Widget>[Text('年代'), Text('しか')],
                                ),
                              ),
                            ),
                            Container(
                              child: InkWell(
                                onTap: () {},
                                child: Column(
                                  children: <Widget>[Text('組'), Text('1組')],
                                ),
                              ),
                            ),
                            Container(
                              child: InkWell(
                                onTap: () {},
                                child: Column(
                                  children: <Widget>[Text('アプリのリンクを解除'), Text('スカウトのアプリ利用を解除します')],
                                ),
                              ),
                            ),
                            Container(
                              child: InkWell(
                                onTap: () {},
                                child: Column(
                                  children: <Widget>[Text('完全に削除'), Text('このユーザーの情報を全て削除します')],
                                ),
                              ),
                            ),
                          ],
                        ))))));
  }
}
