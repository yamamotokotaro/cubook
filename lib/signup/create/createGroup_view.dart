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
    }, child: Consumer<SignupModel>(
            builder: (BuildContext context, SignupModel model, Widget? child) {
      return Center(
          child: Column(children: <Widget>[
        const Padding(
          padding: EdgeInsets.only(top: 30),
          child: Text(
            'グループを新規作成します\n以下の項目を入力してください',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
<<<<<<< HEAD
        if (model.mes_join != '')
          Padding(
            padding: const EdgeInsets.only(top: 30),
            child: Text(
              model.mes_join,
              style: const TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red),
            ),
          )
        else
          Container(),
=======
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
                padding:
                EdgeInsets.only(left: 10, right: 10),
                child: DropdownButton<String>(
                  isExpanded: true,
                  value: model.dropdown_text,
                  hint: Text('隊を選択'),
                  items: <String>[/*'ビーバー隊', */'カブ隊', 'ボーイ隊', 'ベンチャー隊']
                      .map((String value) {
                    return new DropdownMenuItem<String>(
                      value: value,
                      child: new Text(value),
                    );
                  }).toList(),
                  onChanged: (value) {
                    model.onDropdownChanged(value);
                  },
                )),
>>>>>>> develop
        Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: DropdownButton<String>(
              isExpanded: true,
              value: model.dropdown_text,
              hint: const Text('隊を選択'),
              items: <String>[/*'ビーバー隊', */ 'カブ隊', 'ボーイ隊', 'ベンチャー隊']
                  .map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? value) {
                model.onDropdownChanged(value);
              },
            )),
        Padding(
          padding: const EdgeInsets.all(10),
          child: TextField(
            maxLengthEnforcement: MaxLengthEnforcement.none,
            controller: model.groupController,
            enabled: true,
            // 入力数
            keyboardType: TextInputType.multiline,
            maxLines: null,
            decoration: const InputDecoration(
                labelText: 'グループの名前', hintText: '例）杉並〇〇団'),
            onChanged: (String text) {
              model.joinCode = text;
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10),
          child: TextField(
            maxLengthEnforcement: MaxLengthEnforcement.none,
            controller: model.familyController,
            enabled: true,
            // 入力数
            keyboardType: TextInputType.multiline,
            maxLines: null,
            decoration: const InputDecoration(labelText: 'あなたの名字'),
            onChanged: (String text) {
              model.joinCode = text;
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10),
          child: TextField(
            maxLengthEnforcement: MaxLengthEnforcement.none,
            controller: model.firstController,
            enabled: true,
            // 入力数
            keyboardType: TextInputType.multiline,
            maxLines: null,
            decoration: const InputDecoration(labelText: 'あなたの名前'),
            onChanged: (String text) {
              model.joinCode = text;
            },
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(top: 5, left: 15, right: 15),
          child: Text(
            '利用規約を確認の上、「利用規約に同意する」にチェックしてください',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
        TextButton(
          onPressed: () {
            model.launchTermURL();
          },
          child: Text(
            '利用規約',
            style: TextStyle(color: Theme.of(context).colorScheme.secondary),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Checkbox(
                activeColor: Theme.of(context).colorScheme.secondary,
                value: model.isConsent,
                onChanged: model.onPressedCheckConsent,
              ),
              const Text('利用規約に同意する')
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: model.isLoading_join
              ? const Padding(
                  padding: EdgeInsets.all(10),
                  child: CircularProgressIndicator())
              : ElevatedButton(
                  onPressed: () {
                    model.createRequest();
                  },
                  child: const Text(
                    '登録',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  )),
        )
      ]));
    })));
  }
}
