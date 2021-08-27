import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cubook/model/task.dart';
import 'package:cubook/model/themeInfo.dart';
import 'package:cubook/setting_account_group/settingAccount_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class AccountMigrationView extends StatelessWidget {
  var task = TaskContents();
  var theme = ThemeInfo();
  String uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('アカウントを移行'),
          brightness: Brightness.dark,
        ),
        body: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: SafeArea(
                child: SingleChildScrollView(
                    child: Center(
                        child: ConstrainedBox(
                            constraints: BoxConstraints(maxWidth: 600),
                            child: Consumer<SettingAccountGroupModel>(
                                builder: (context, model, child) {
                              return Column(
                                children: <Widget>[
                                  Padding(
                                    padding:
                                        EdgeInsets.only(top: 30, bottom: 20),
                                    child: Text(
                                      '以下のアカウントを移行します',
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
                                              .where('uid',
                                                  isEqualTo: model.uid)
                                              .snapshots(),
                                          builder: (BuildContext context,
                                              AsyncSnapshot<QuerySnapshot>
                                                  querysnapshot) {
                                            if (querysnapshot.hasData) {
                                              if (querysnapshot
                                                  .data.docs.isNotEmpty) {
                                                final DocumentSnapshot
                                                    snapshot =
                                                    querysnapshot.data.docs[0];
                                                return Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: <Widget>[
                                                    Container(
                                                      width: 40,
                                                      height: 40,
                                                      decoration: BoxDecoration(
                                                          color: theme
                                                              .getThemeColor(
                                                                  snapshot.get(
                                                                      'age')),
                                                          shape:
                                                              BoxShape.circle),
                                                      child: Icon(
                                                        Icons.person,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                    Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 10),
                                                        child: Text(
                                                          snapshot.get('name'),
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 25),
                                                        )),
                                                  ],
                                                );
                                              } else {
                                                return const Center(
                                                  child: Padding(
                                                      padding:
                                                          EdgeInsets.all(5),
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
                                  Padding(
                                    padding: EdgeInsets.only(top: 30),
                                    child: Text(
                                      '移行先のグループIDを入力してください',
                                      style: TextStyle(
                                        fontSize: 21,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(10),
                                    child: TextField(
                                      controller: model.groupIdController,
                                      enabled: true,
                                      decoration:
                                          InputDecoration(labelText: 'グループID'),
                                      onChanged: (text) {
                                        //model.joinCode = text;
                                      },
                                    ),
                                  ),
                                  model.isLoading
                                      ? Padding(
                                          padding: EdgeInsets.all(10),
                                          child: CircularProgressIndicator())
                                      : Padding(
                                          padding: EdgeInsets.all(10),
                                          child: Container(
                                              child: ElevatedButton.icon(
                                            icon: Icon(Icons.send),
                                            label: Text("移行申請を送信"),
                                            onPressed: () {
                                              model.migrateAccount(context);
                                            },
                                          ))),
                                  Padding(
                                      padding: EdgeInsets.all(10),
                                      child: Container(
                                          child: TextButton.icon(
                                            icon: Icon(Icons.info_outline),
                                            label: Text("アカウント移行の手順"),
                                            onPressed: () async {
                                              const url = 'https://sites.google.com/view/cubookinfo/%E4%BD%BF%E3%81%84%E6%96%B9/%E3%82%A2%E3%82%AB%E3%82%A6%E3%83%B3%E3%83%88%E7%A7%BB%E8%A1%8C%E3%81%AE%E6%89%8B%E9%A0%86';
                                              if (await canLaunch(url)) {
                                              await launch(url);
                                              } else {
                                              throw 'Could not launch $url';
                                              }
                                            },
                                          ))),
                                ],
                              );
                            })))))));
  }
}
