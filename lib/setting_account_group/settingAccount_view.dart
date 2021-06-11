import 'package:cubook/model/task.dart';
import 'package:cubook/model/themeInfo.dart';
import 'package:cubook/setting_account_group/settingAccount_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingAccountGroupView extends StatelessWidget {
  var task = TaskContents();
  var theme = ThemeInfo();

  String uid;

  SettingAccountGroupView(String _uid) {
    uid = _uid;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: SingleChildScrollView(
                child: Center(
                    child: ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: 600),
                        child: Consumer<SettingAccountGroupModel>(
                            builder: (context, model, child) {
                          model.getSnapshot(uid);
                          if (model.userSnapshot != null) {
                            return Column(
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.only(
                                      top: 25, left: 10, right: 10, bottom: 5),
                                  child: Container(
                                      width: double.infinity,
                                      child: Card(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: InkWell(
                                          customBorder: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                          onTap: () {
                                            Navigator.of(context)
                                                .pushNamed('/editProfile');
                                          },
                                          child: Padding(
                                            padding: EdgeInsets.all(10),
                                            child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: <Widget>[
                                                  Icon(
                                                    Icons.edit,
                                                    color: Theme.of(context)
                                                        .accentColor,
                                                    size: 35,
                                                  ),
                                                  Padding(
                                                      padding: EdgeInsets.only(
                                                          top: 10),
                                                      child: Material(
                                                        type: MaterialType
                                                            .transparency,
                                                        child: Text(
                                                          'プロフィールの編集',
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 21),
                                                        ),
                                                      )),
                                                  Padding(
                                                      padding: EdgeInsets.only(
                                                          top: 10),
                                                      child: Material(
                                                        type: MaterialType
                                                            .transparency,
                                                        child: Text(
                                                          '名前・組・進歩の変更',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.grey,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal,
                                                              fontSize: 15),
                                                        ),
                                                      )),
                                                ]),
                                          ),
                                        ),
                                      )),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      top: 5, left: 10, right: 10, bottom: 5),
                                  child: Container(
                                      width: double.infinity,
                                      child: Card(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: InkWell(
                                          customBorder: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                          onTap: () async {
                                            await showDialog<int>(
                                                context: context,
                                                builder: (context) {
                                                  return AlertDialog(
                                                    shape: const RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    20.0))),
                                                    content:
                                                        SingleChildScrollView(
                                                            child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: <Widget>[
                                                        Container(
                                                          width:
                                                              double.infinity,
                                                          child: Text(
                                                              '現在この機能は利用できません',
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize:
                                                                      18)),
                                                        ),
                                                        Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    top: 5),
                                                            child: Text(
                                                                '4月前半に配信のアップデートで対応予定です'))
                                                      ],
                                                    )),
                                                  );
                                                });
                                            // Navigator.of(context)
                                            //     .pushNamed('/accountMigration');
                                          },
                                          child: Padding(
                                            padding: EdgeInsets.all(10),
                                            child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: <Widget>[
                                                  Icon(
                                                    Icons.emoji_people,
                                                    color: Theme.of(context)
                                                        .accentColor,
                                                    size: 35,
                                                  ),
                                                  Padding(
                                                      padding: EdgeInsets.only(
                                                          top: 10),
                                                      child: Material(
                                                        type: MaterialType
                                                            .transparency,
                                                        child: Text(
                                                          'アカウントを移行',
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 21),
                                                        ),
                                                      )),
                                                  Padding(
                                                      padding: EdgeInsets.only(
                                                          top: 10),
                                                      child: Material(
                                                        type: MaterialType
                                                            .transparency,
                                                        child: Text(
                                                          '他グループへ移行',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.grey,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal,
                                                              fontSize: 15),
                                                        ),
                                                      )),
                                                ]),
                                          ),
                                        ),
                                      )),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      top: 5, left: 10, right: 10, bottom: 5),
                                  child: Container(
                                      width: double.infinity,
                                      child: Card(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: InkWell(
                                          customBorder: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                          onTap: () {
                                            Navigator.of(context).pushNamed(
                                                '/deleteGroupAccount');
                                          },
                                          child: Padding(
                                            padding: EdgeInsets.all(10),
                                            child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: <Widget>[
                                                  Icon(
                                                    Icons.cancel,
                                                    color: Theme.of(context)
                                                        .accentColor,
                                                    size: 35,
                                                  ),
                                                  Padding(
                                                      padding: EdgeInsets.only(
                                                          top: 10),
                                                      child: Material(
                                                        type: MaterialType
                                                            .transparency,
                                                        child: Text(
                                                          'アカウントを削除',
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 21),
                                                        ),
                                                      )),
                                                  Padding(
                                                      padding: EdgeInsets.only(
                                                          top: 10),
                                                      child: Material(
                                                        type: MaterialType
                                                            .transparency,
                                                        child: Text(
                                                          '完全削除',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.grey,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal,
                                                              fontSize: 15),
                                                        ),
                                                      )),
                                                ]),
                                          ),
                                        ),
                                      )),
                                ),
                              ],
                            );
                          } else {
                            return const Center(
                              child: Padding(
                                  padding: EdgeInsets.all(5),
                                  child: CircularProgressIndicator()),
                            );
                          }
                        }))))));
  }
}
