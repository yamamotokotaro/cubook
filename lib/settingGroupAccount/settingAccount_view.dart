import 'package:cubook/model/task.dart';
import 'package:cubook/model/themeInfo.dart';
import 'package:cubook/settingGroupAccount/settingAccount_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingAccountGroupView extends StatelessWidget {
  SettingAccountGroupView(String? _uid) {
    uid = _uid;
  }
  TaskContents task = TaskContents();
  ThemeInfo theme = ThemeInfo();

  String? uid;

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
                        constraints: const BoxConstraints(maxWidth: 600),
                        child: Consumer<SettingAccountGroupModel>(builder:
                            (BuildContext context,
                                SettingAccountGroupModel model, Widget? child) {
                          model.getSnapshot(uid);
                          if (model.userSnapshot != null) {
                            if (model.userSnapshot!.get('position') ==
                                'scout') {
                              return Column(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 25,
                                        left: 10,
                                        right: 10,
                                        bottom: 5),
                                    child: Container(
                                        width: double.infinity,
                                        child: Card(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: InkWell(
                                            customBorder:
                                                RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                            ),
                                            onTap: () {
                                              Navigator.of(context)
                                                  .pushNamed('/editProfile');
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.all(10),
                                              child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: <Widget>[
                                                    Icon(
                                                      Icons.edit,
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .secondary,
                                                      size: 35,
                                                    ),
                                                    const Padding(
                                                        padding:
                                                            EdgeInsets.only(
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
                                                    const Padding(
                                                        padding:
                                                            EdgeInsets.only(
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
                                    padding: const EdgeInsets.only(
                                        top: 5, left: 10, right: 10, bottom: 5),
                                    child: Container(
                                        width: double.infinity,
                                        child: Card(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: InkWell(
                                            customBorder:
                                                RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                            ),
                                            onTap: () async {
                                              if (model.isAdmin!) {
                                                Navigator.of(context).pushNamed(
                                                    '/accountMigration');
                                              } else {
                                                await showDialog<int>(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
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
                                                              width: double
                                                                  .infinity,
                                                              child: const Text(
                                                                  'この操作はできません',
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          18)),
                                                            ),
                                                            const Padding(
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        top: 5),
                                                                child: Text(
                                                                    'アカウントの移行は管理者のみ操作可能です'))
                                                          ],
                                                        )),
                                                      );
                                                    });
                                              }
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.all(10),
                                              child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: <Widget>[
                                                    Icon(
                                                      Icons.emoji_people,
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .secondary,
                                                      size: 35,
                                                    ),
                                                    const Padding(
                                                        padding:
                                                            EdgeInsets.only(
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
                                                    const Padding(
                                                        padding:
                                                            EdgeInsets.only(
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
                                    padding: const EdgeInsets.only(
                                        top: 5, left: 10, right: 10, bottom: 5),
                                    child: Container(
                                        width: double.infinity,
                                        child: Card(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: InkWell(
                                            customBorder:
                                                RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                            ),
                                            onTap: () {
                                              Navigator.of(context).pushNamed(
                                                  '/deleteGroupAccount');
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.all(10),
                                              child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: <Widget>[
                                                    Icon(
                                                      Icons.cancel,
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .secondary,
                                                      size: 35,
                                                    ),
                                                    const Padding(
                                                        padding:
                                                            EdgeInsets.only(
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
                                                    const Padding(
                                                        padding:
                                                            EdgeInsets.only(
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
                              return Column(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 5, left: 10, right: 10, bottom: 5),
                                    child: Container(
                                        width: double.infinity,
                                        child: Card(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: InkWell(
                                            customBorder:
                                                RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                            ),
                                            onTap: () async {
                                              if (model.isAdmin!) {
                                                Navigator.of(context).pushNamed(
                                                    '/accountMigration');
                                              } else {
                                                await showDialog<int>(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
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
                                                              width: double
                                                                  .infinity,
                                                              child: const Text(
                                                                  'この操作はできません',
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          18)),
                                                            ),
                                                            const Padding(
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        top: 5),
                                                                child: Text(
                                                                    'アカウントの移行は管理者のみ操作可能です'))
                                                          ],
                                                        )),
                                                      );
                                                    });
                                              }
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.all(10),
                                              child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: <Widget>[
                                                    Icon(
                                                      Icons.emoji_people,
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .secondary,
                                                      size: 35,
                                                    ),
                                                    const Padding(
                                                        padding:
                                                            EdgeInsets.only(
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
                                                    const Padding(
                                                        padding:
                                                            EdgeInsets.only(
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
                                    padding: const EdgeInsets.only(
                                        top: 5, left: 10, right: 10, bottom: 5),
                                    child: Container(
                                        width: double.infinity,
                                        child: Card(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: InkWell(
                                            customBorder:
                                                RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                            ),
                                            onTap: () {
                                              Navigator.of(context).pushNamed(
                                                  '/deleteGroupAccount');
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.all(10),
                                              child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: <Widget>[
                                                    Icon(
                                                      Icons.cancel,
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .secondary,
                                                      size: 35,
                                                    ),
                                                    const Padding(
                                                        padding:
                                                            EdgeInsets.only(
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
                                                    const Padding(
                                                        padding:
                                                            EdgeInsets.only(
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
                            }
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
