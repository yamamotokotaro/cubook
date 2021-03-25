import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cubook/model/task.dart';
import 'package:cubook/model/themeInfo.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:provider/provider.dart';

import '../settingAccount_model.dart';

class DeleteGroupAccount extends StatelessWidget {
  var task = new TaskContents();
  var theme = new ThemeInfo();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('アカウント削除'),
        ),
        body: SafeArea(
            child: SingleChildScrollView(
                child: Center(
                    child: ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: 600),
                        child: Consumer<SettingAccountGroupModel>(
                            builder: (context, model, child) {
                          return Column(
                            children: <Widget>[
                              Padding(
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
                                  padding: EdgeInsets.all(10),
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
                                          if (querysnapshot.data.docs.length !=
                                              0) {
                                            DocumentSnapshot snapshot =
                                                querysnapshot.data.docs[0];
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
                                                              snapshot.data()[
                                                                  'age']),
                                                      shape: BoxShape.circle),
                                                  child: Icon(
                                                    Icons.person,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 10),
                                                    child: Text(
                                                      snapshot.data()['name'],
                                                      style: TextStyle(
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
                                padding: EdgeInsets.all(5),
                                child: Container(
                                  child: Card(
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
                                padding: EdgeInsets.all(5),
                                child: Container(
                                  child: Card(
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
                                padding: EdgeInsets.only(top: 10),
                                child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      primary: Colors.blue[900], //ボタンの背景色
                                    ),
                                    onPressed: () async {
                                      //model.inviteRequest(context);
                                      model.showDeleteSheet(context);
                                    },
                                    child: Text(
                                      '削除を実行',
                                      style: TextStyle(color: Colors.white),
                                    )),
                              )
                            ],
                          );
                        }))))));
  }
}
