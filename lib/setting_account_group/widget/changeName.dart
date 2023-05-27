import 'package:cubook/model/task.dart';
import 'package:cubook/model/themeInfo.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ChangeNameView extends StatelessWidget {
  TaskContents task = TaskContents();
  ThemeInfo theme = ThemeInfo();
  String? uid;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('メンバー詳細'),
        ),
        body: SafeArea(
            child: SingleChildScrollView(
                child: Center(
                    child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 600),
                        child: Column(
                          children: <Widget>[
                            const Padding(
                              padding: EdgeInsets.only(left: 10, right: 10),
                              child: TextField(
                                decoration: InputDecoration(labelText: '姓'),
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(left: 10, right: 10),
                              child: TextField(
                                decoration: InputDecoration(labelText: '名'),
                              ),
                            ),
                            ElevatedButton.icon(
                              onPressed: () {},
                              icon: const Icon(
                                Icons.save,
                                size: 20,
                                color: Colors.white,
                              ),
                              label: const Text(
                                '変更を保存',
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
