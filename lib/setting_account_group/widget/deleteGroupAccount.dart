import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cubook/model/task.dart';
import 'package:cubook/model/themeInfo.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../settingAccount_model.dart';

class DeleteGroupAccount extends StatelessWidget {
  TaskContents task = TaskContents();
  ThemeInfo theme = ThemeInfo();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('アカウント削除'),
        ),
        body: SafeArea(
            child: SingleChildScrollView(
                child: Center(
                    child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 600),
                        child: Consumer<SettingAccountGroupModel>(builder:
                            (BuildContext context,
                                SettingAccountGroupModel model, Widget? child) {
                          return Column(
                            children: <Widget>[
                              const Padding(
                                padding: EdgeInsets.only(top: 30, bottom: 20),
                                child: Text(
                                  '以下のアカウントを削除します',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: StreamBuilder<QuerySnapshot>(
                                      stream: FirebaseFirestore.instance
                                          .collection('user')
                                          .where('group',
                                              isEqualTo: model.group)
                                          .where('uid', isEqualTo: model.uid)
                                          .snapshots(),
                                      builder: (BuildContext context,
                                          AsyncSnapshot<QuerySnapshot>
                                              querysnapshot) {
                                        if (querysnapshot.hasData) {
                                          if (querysnapshot
                                              .data!.docs.isNotEmpty) {
                                            final DocumentSnapshot snapshot =
                                                querysnapshot.data!.docs[0];
                                            return Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: <Widget>[
                                                Container(
                                                  width: 40,
                                                  height: 40,
                                                  decoration: BoxDecoration(
                                                      color:
                                                          theme.getThemeColor(
                                                              snapshot
                                                                  .get('age')),
                                                      shape: BoxShape.circle),
                                                  child: const Icon(
                                                    Icons.person,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 10),
                                                    child: Text(
                                                      snapshot.get('name'),
                                                      style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 25),
                                                    )),
                                              ],
                                            );
                                          } else {
                                            return const Center(
                                              child: Padding(
                                                  padding: EdgeInsets.all(5),
                                                  child: Text('データがありません')),
                                            );
                                          }
                                        } else {
                                          return const Center(
                                            child: Padding(
                                                padding: EdgeInsets.all(5),
                                                child:
                                                    CircularProgressIndicator()),
                                          );
                                        }
                                      })),
                              /*Padding(
                                padding: EdgeInsets.only(top: 30, bottom: 20),
                                child: Text(
                                  '以下を確認の上、操作ください',
                                  style: TextStyle(
                                    fontSize: 23,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),*/
                              Padding(
                                padding: const EdgeInsets.all(5),
                                child: Container(
                                  child: const Card(
                                      child: Padding(
                                    padding: EdgeInsets.all(0),
                                    child: Column(
                                      children: <Widget>[
                                        Padding(
                                            padding: EdgeInsets.all(10),
                                            child: Text(
                                              'アカウントに紐づけられている個人データは、画像・動画を含めて全て消去されます',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight:
                                                      FontWeight.normal),
                                            ))
                                      ],
                                    ),
                                  )),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(5),
                                child: Container(
                                  child: const Card(
                                      child: Padding(
                                    padding: EdgeInsets.all(0),
                                    child: Column(
                                      children: <Widget>[
                                        Padding(
                                            padding: EdgeInsets.all(10),
                                            child: Text(
                                              '一度削除を実行すると、復元することはできません',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight:
                                                      FontWeight.normal),
                                            ))
                                      ],
                                    ),
                                  )),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: FilledButton(
                                    onPressed: () async {
                                      model.showDeleteSheet(context);
                                    },
                                    child: const Text(
                                      '削除を実行',
                                    )),
                              )
                            ],
                          );
                        }))))));
  }
}
