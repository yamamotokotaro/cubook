import 'package:cubook/invite/invite_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

final List<DataList> data = <DataList>[
  DataList(
    'カブスカウト',
    <DataList>[
      DataList('りす'),
      DataList('うさぎ'),
      DataList('しか'),
      DataList('くま'),
    ],
  ),
  DataList(
    'ボーイスカウト',
    <DataList>[
      DataList('ボーイスカウトバッジ'),
      DataList('初級スカウト'),
      DataList('2級スカウト'),
      DataList('1級スカウト'),
      DataList('菊スカウト'),
    ],
  ),
  DataList(
    'ベンチャースカウト',
    <DataList>[
      DataList('隼スカウト'),
      DataList('富士スカウト'),
    ],
  ),
];

class InviteView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('メンバーを招待'),
        ),
        body: Builder(builder: (BuildContext context) {
          return GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              child: SingleChildScrollView(
                  child: Center(
                child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 800),
                    child: Consumer<InviteModel>(builder: (BuildContext context,
                        InviteModel model, Widget? child) {
                      return Column(
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(top: 30),
                            child: Text(
                              '以下の項目を入力してください',
                              style: TextStyle(
                                fontSize: 23,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          if (model.mes_join != '')
                            Padding(
                              padding: const EdgeInsets.only(top: 30),
                              child: Text(
                                model.mes_join,
                                style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red),
                              ),
                            )
                          else
                            Container(),
                          Padding(
                              padding: const EdgeInsets.only(
                                  top: 15, left: 10, right: 10),
                              child: DropdownButton<String>(
                                isExpanded: true,
                                hint: const Text('立場を選択'),
                                value: model.dropdown_text,
                                items: <String>[
                                  'りす',
                                  'うさぎ',
                                  'しか',
                                  'くま',
                                  'ボーイスカウトバッジ',
                                  '初級スカウト',
                                  '2級スカウト',
                                  '1級スカウト',
                                  '菊スカウト',
                                  '隼スカウト',
                                  //'富士スカウト',
                                  'リーダー'
                                ].map((String value) {
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
                              controller: model.addressController,
                              enabled: true,
                              // 入力数
                              keyboardType: TextInputType.multiline,
                              maxLines: null,
                              decoration:
                                  const InputDecoration(labelText: 'メールアドレス'),
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
                              decoration: const InputDecoration(labelText: '姓'),
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
                              decoration: const InputDecoration(labelText: '名'),
                              onChanged: (String text) {
                                model.joinCode = text;
                              },
                            ),
                          ),
                          if (model.dropdown_text != 'リーダー')
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 0, left: 10, right: 10),
                              child: TextField(
                                maxLengthEnforcement: MaxLengthEnforcement.none,
                                controller: model.teamController,
                                enabled: true,
                                // 入力数
                                maxLines: null,
                                decoration: const InputDecoration(
                                    labelText: '組・班（オプション）'),
                                onChanged: (String text) {},
                              ),
                            )
                          else
                            Container(),
                          if (model.dropdown_text != 'リーダー')
                            Padding(
                                padding: const EdgeInsets.only(
                                    top: 20, left: 10, right: 10, bottom: 10),
                                child: DropdownButton<String>(
                                  isExpanded: true,
                                  hint: const Text('呼称'),
                                  value: model.dropdown_call,
                                  items:
                                      <String>['くん', 'さん'].map((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                  onChanged: (String? value) {
                                    model.onDropdownCallChanged(value);
                                  },
                                ))
                          else
                            Container(),
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: model.isLoading_join
                                ? const Padding(
                                    padding: EdgeInsets.all(10),
                                    child: CircularProgressIndicator())
                                : FilledButton(
                                    onPressed: () {
                                      model.inviteRequest(context);
                                    },
                                    child: const Text(
                                      '招待を送信',
                                    )),
                          )
                        ],
                      );
                    })),
              )));
        }));
  }
}

class DataList {
  DataList(this.title, [this.children = const <DataList>[]]);

  final String title;
  final List<DataList> children;
}

class DataPopUp extends StatelessWidget {
  const DataPopUp(this.popup);

  final DataList popup;

  Widget _buildTiles(DataList root) {
    if (root.children.isEmpty) return ListTile(title: Text(root.title));
    return ExpansionTile(
      key: PageStorageKey<DataList>(root),
      title: Text(
        root.title,
      ),
      children: root.children.map(_buildTiles).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildTiles(popup);
  }
}
