import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
                fontSize: 20, fontWeight: FontWeight.bold,),
          ),
        ),
        if (model.mes_join != '') Padding(
                padding: EdgeInsets.only(top: 30),
                child: Text(
                  model.mes_join,
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.red),
                ),
              ) else Container(),
            Padding(
                padding:
                EdgeInsets.only(left: 10, right: 10),
                child: DropdownButton<String>(
                  isExpanded: true,
                  value: model.dropdown_text,
                  hint: Text('隊を選択'),
                  items: <String>[/*'ビーバー隊', */'カブ隊', 'ボーイ隊', 'ベンチャー隊']
                      .map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (value) {
                    model.onDropdownChanged(value);
                  },
                )),
        Padding(
          padding: EdgeInsets.all(10),
          child: TextField(
            maxLengthEnforcement: MaxLengthEnforcement.none, controller: model.groupController,
            enabled: true,
            // 入力数
            keyboardType: TextInputType.multiline,
            maxLines: null,
            decoration:
                InputDecoration(labelText: 'グループの名前', hintText: '例）杉並〇〇団'),
            onChanged: (text) {
              model.joinCode = text;
            },
          ),
        ),
        Padding(
          padding: EdgeInsets.all(10),
          child: TextField(
            maxLengthEnforcement: MaxLengthEnforcement.none, controller: model.familyController,
            enabled: true,
            // 入力数
            keyboardType: TextInputType.multiline,
            maxLines: null,
            decoration: InputDecoration(labelText: 'あなたの名字'),
            onChanged: (text) {
              model.joinCode = text;
            },
          ),
        ),
        Padding(
          padding: EdgeInsets.all(10),
          child: TextField(
            maxLengthEnforcement: MaxLengthEnforcement.none, controller: model.firstController,
            enabled: true,
            // 入力数
            keyboardType: TextInputType.multiline,
            maxLines: null,
            decoration: InputDecoration(labelText: 'あなたの名前'),
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
                fontWeight: FontWeight.normal,),
          ),
        ),
        FlatButton(
          onPressed: () {
            model.launchTermURL();
          },
          child: Text(
            '利用規約',
            style: TextStyle(color: Theme.of(context).colorScheme.secondary),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Checkbox(
                activeColor: Theme.of(context).colorScheme.secondary,
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
                  color: Colors.blue[900],
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
