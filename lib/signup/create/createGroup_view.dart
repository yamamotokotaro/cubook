import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../signup_model.dart';

class CreateGroupView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: GestureDetector(onTap: () {
      FocusScope.of(context).unfocus();
    }, child: Consumer<SignupModel>(builder: (context, model, child) {
      return Center(
          child: Column(children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 30),
          child: Text(
            'グループを新規作成します\n以下の項目を入力してください',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
          ),
        ),
        model.mes_join != ''
            ? Padding(
                padding: EdgeInsets.only(top: 30),
                child: Text(
                  model.mes_join,
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.red),
                ),
              )
            : Container(),
        Padding(
          padding: EdgeInsets.all(10),
          child: TextField(
            controller: model.groupController,
            enabled: true,
            // 入力数
            keyboardType: TextInputType.multiline,
            maxLines: null,
            maxLengthEnforced: false,
            decoration:
                InputDecoration(labelText: "グループの名前", hintText: '例）杉並〇〇団'),
            onChanged: (text) {
              model.joinCode = text;
            },
          ),
        ),
        Padding(
          padding: EdgeInsets.all(10),
          child: TextField(
            controller: model.familyController,
            enabled: true,
            // 入力数
            keyboardType: TextInputType.multiline,
            maxLines: null,
            maxLengthEnforced: false,
            decoration: InputDecoration(labelText: "あなたの名字"),
            onChanged: (text) {
              model.joinCode = text;
            },
          ),
        ),
        Padding(
          padding: EdgeInsets.all(10),
          child: TextField(
            controller: model.firstController,
            enabled: true,
            // 入力数
            keyboardType: TextInputType.multiline,
            maxLines: null,
            maxLengthEnforced: false,
            decoration: InputDecoration(labelText: "あなたの名前"),
            onChanged: (text) {
              model.joinCode = text;
            },
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 5, left: 15, right: 15),
          child: Text(
            '利用規約を確認の上、「利用規約に同意する」にチェックしてください',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.normal,
                color: Colors.black),
          ),
        ),
        FlatButton(
          onPressed: () {
            model.launchTermURL();
          },
          child: Text(
            '利用規約',
            style: TextStyle(color: Theme.of(context).accentColor),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Checkbox(
                activeColor: Theme.of(context).accentColor,
                value: model.isConsent,
                onChanged: model.onPressedCheckConsent,
              ),
              Text('利用規約に同意する')
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 10),
          child: model.isLoading_join
              ? Padding(
                  padding: EdgeInsets.all(10),
                  child: CircularProgressIndicator())
              : RaisedButton(
                  color: Theme.of(context).accentColor,
                  onPressed: () {
                    model.createRequest();
                  },
                  child: Text(
                    '登録',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  )),
        )
      ]));
    })));
  }
}
