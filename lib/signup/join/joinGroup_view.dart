import 'package:cubook/signup/signup_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class JoinGroup extends StatelessWidget {
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
                    '招待メールに記載されている登録コードを入力してください',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
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
                  padding: EdgeInsets.all(10),
                  child: TextField(
                    maxLengthEnforcement: MaxLengthEnforcement.none, enabled: true,
                    // 入力数
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    decoration: InputDecoration(labelText: '登録コード'),
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
                      color: Colors.blue[900],
                      onPressed: () {
                        model.joinRequest();
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