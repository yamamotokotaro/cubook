import 'package:cubook/home/home_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class JoinGroup extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: GestureDetector(onTap: () {
      FocusScope.of(context).unfocus();
    }, child: Consumer<HomeModel>(builder: (context, model, child) {
      return Center(
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 30),
              child: Text(
                '登録コードを入力してください',
                style: TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
            ),
            model.mes_join != ''?
            Padding(
              padding: EdgeInsets.only(top: 30),
              child: Text(
                model.mes_join,
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.red),
              ),
            ): Container(),
            Padding(
              padding: EdgeInsets.all(20),
              child: TextField(
                enabled: true,
                // 入力数
                keyboardType: TextInputType.multiline,
                maxLines: null,
                maxLengthEnforced: false,
                onChanged: (text) {model.joinCode = text;},
              ),
            ),
            model.isLoading_join?
                CircularProgressIndicator() : 
            RaisedButton(
              onPressed: () {
                model.joinRequest();
              },
              child: Text('登録'),
            )
          ],
        ),
      );
    })));
  }
}
