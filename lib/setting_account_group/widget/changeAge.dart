import 'package:cubook/model/task.dart';
import 'package:cubook/model/themeInfo.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChangeAgeView extends StatelessWidget {
  var task = new TaskContents();
  var theme = new ThemeInfo();
  String uid;
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

                            DropdownButton<String>(
                              hint: Text('役割を選択'),
                              items: <String>['うさぎ', 'しか', 'くま']
                                  .map((String value) {
                                return new DropdownMenuItem<String>(
                                  value: value,
                                  child: new Text(value),
                                );
                              }).toList(),
                              onChanged: (value) {
                              },
                            ),
                            RaisedButton.icon(
                              onPressed: () {
                              },
                              icon: Icon(
                                Icons.save,
                                size: 20,
                                color: Colors.white,
                              ),
                              color: Colors.green,
                              label: Text(
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
