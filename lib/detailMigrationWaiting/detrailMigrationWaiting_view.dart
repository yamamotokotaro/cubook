import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cubook/detailMigrationWaiting/detailMigrationWaiting_model.dart';
import 'package:cubook/detailTaskWaiting/detailTaskWaiting_model.dart';
import 'package:cubook/model/task.dart';
import 'package:cubook/model/themeInfo.dart';
import 'package:cubook/userDetail/userDetail_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class DetailMigrationWaitingView extends StatelessWidget {
  String documentID;
  String name;
  String groupName;
  String age;
  Map<String, dynamic> taskInfo;
  Map<String, dynamic> content;
  var task = TaskContents();
  var theme = ThemeInfo();

  DetailMigrationWaitingView(String _documentID, String _name,
      String _groupName, String _age) {
    documentID = _documentID;
    name = _name;
    groupName = _groupName;
    age = _age;
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => DetailTaskWaitingModel(),
        child: Scaffold(
          appBar: AppBar(
            title: Text('申請詳細'),
            brightness: Brightness.dark,
          ),
          body: SafeArea(
              child: GestureDetector(
                  onTap: () {
                    FocusScope.of(context).unfocus();
                  },
                  child: SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          Hero(
                              tag: 'detailTask' + documentID,
                              child: SingleChildScrollView(
                                  child: Container(
                                    width: MediaQuery
                                        .of(context)
                                        .size
                                        .width,
                                    color: theme.getThemeColor(age),
                                    child: Padding(
                                      padding: EdgeInsets.all(10),
                                      child: Column(
                                        children: <Widget>[
                                          Material(
                                            type: MaterialType.transparency,
                                            child: Text(
                                              name,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.normal,
                                                  fontSize: 28,
                                                  color: Colors.white),
                                            ),
                                          ),
                                          Material(
                                              type: MaterialType.transparency,
                                              child: Padding(
                                                padding: EdgeInsets.only(
                                                    top: 10),
                                                child: Text(
                                                  groupName,
                                                  style: TextStyle(
                                                      fontWeight: FontWeight
                                                          .normal,
                                                      fontSize: 21,
                                                      color: Colors.white),
                                                ),
                                              ))
                                        ],
                                      ),
                                    ),
                                  ))),
                          StreamBuilder<DocumentSnapshot>(
                              stream: FirebaseFirestore.instance
                                  .collection('migration')
                                  .doc(documentID)
                                  .snapshots(),
                              builder: (BuildContext context,
                                  AsyncSnapshot<DocumentSnapshot> snapshot) {
                                DocumentSnapshot migrationSnapshot = snapshot
                                    .data;
                                if (snapshot.hasData) {
                                  String phase = migrationSnapshot.get('phase');
                                  if (phase == "wait") {
                                    return Padding(
                                        padding: EdgeInsets.all(10),
                                        child: Column(children: <Widget>[
                                          Padding(
                                              padding: EdgeInsets.all(10),
                                              child: Container(
                                                  width: double.infinity,
                                                  child: Text(
                                                    '申請者',
                                                    style: TextStyle(
                                                      fontSize: 17,
                                                    ),
                                                    textAlign: TextAlign.left,
                                                  ))),
                                          Padding(
                                              padding: EdgeInsets.all(10),
                                              child: Container(
                                                  width: double.infinity,
                                                  child: Text(
                                                    snapshot.data
                                                        .get('operatorName'),
                                                    style: TextStyle(
                                                      fontWeight: FontWeight
                                                          .bold,
                                                      fontSize: 22,
                                                    ),
                                                    textAlign: TextAlign.left,
                                                  ))),
                                          Padding(
                                              padding: EdgeInsets.all(10),
                                              child: Container(
                                                  width: double.infinity,
                                                  child: Text(
                                                    'グループID',
                                                    style: TextStyle(
                                                      fontSize: 17,
                                                    ),
                                                    textAlign: TextAlign.left,
                                                  ))),
                                          Padding(
                                              padding: EdgeInsets.all(10),
                                              child: Container(
                                                  width: double.infinity,
                                                  child: Text(
                                                    snapshot.data.get(
                                                        'group_from'),
                                                    style: TextStyle(
                                                      fontWeight: FontWeight
                                                          .bold,
                                                      fontSize: 20,
                                                    ),
                                                    textAlign: TextAlign.left,
                                                  ))),
                                          Padding(
                                              padding: EdgeInsets.all(10),
                                              child: Container(
                                                  width: double.infinity,
                                                  child: Text(
                                                    '申請日時',
                                                    style: TextStyle(
                                                      fontSize: 17,
                                                    ),
                                                    textAlign: TextAlign.left,
                                                  ))),
                                          Padding(
                                              padding: EdgeInsets.all(10),
                                              child: Container(
                                                  width: double.infinity,
                                                  child: Text(
                                                    DateFormat(
                                                        'yyyy年MM月dd日HH時mm分')
                                                        .format(snapshot.data
                                                        .get('time')
                                                        .toDate())
                                                        .toString(),
                                                    style: TextStyle(
                                                      fontWeight: FontWeight
                                                          .bold,
                                                      fontSize: 20,
                                                    ),
                                                    textAlign: TextAlign.left,
                                                  ))),
                                          Consumer<DetailMigrationWaitingModel>(
                                              builder: (context, model, child) {
                                                if (model.isLoading) {
                                                  return Padding(
                                                      padding: EdgeInsets.all(
                                                          10),
                                                      child: CircularProgressIndicator());
                                                }
                                                else {
                                                  return Column(children: [
                                                    Padding(
                                                        padding: EdgeInsets.all(
                                                            10),
                                                        child: Container(
                                                            width: double
                                                                .infinity,
                                                            child: OutlinedButton
                                                                .icon(
                                                              icon: Icon(
                                                                Icons.check,
                                                                color: Colors
                                                                    .green,
                                                              ),
                                                              label: Text(
                                                                  "承認する"),
                                                              onPressed: () {
                                                                model
                                                                    .migrateAccount(
                                                                    context,
                                                                    documentID);
                                                              },
                                                            ))),
                                                    Padding(
                                                        padding: EdgeInsets.all(
                                                            10),
                                                        child: Container(
                                                            width: double
                                                                .infinity,
                                                            child: OutlinedButton
                                                                .icon(
                                                              icon: Icon(
                                                                Icons.clear,
                                                                color: Colors
                                                                    .red,
                                                              ),
                                                              label: Text(
                                                                  "却下する"),
                                                              onPressed: () {
                                                                model
                                                                    .rejectMigrate(
                                                                    context,
                                                                    documentID);
                                                              },
                                                            ))),
                                                  ]);
                                                }
                                              }),
                                        ]));
                                  } else if (phase == 'migrating') {
                                    return Padding(
                                        padding: EdgeInsets.all(20),
                                        child: Column(children: <Widget>[
                                          Padding(
                                              padding: EdgeInsets.all(10),
                                              child: Container(
                                                  child: Icon(
                                                    Icons
                                                        .account_circle_outlined,
                                                    size: 45,
                                                    color: Colors.blue[900],
                                                  ))),
                                          Padding(
                                              padding: EdgeInsets.all(10),
                                              child: Container(
                                                  child: Text(
                                                    'データの移行を行っています',
                                                    style: TextStyle(
                                                      fontSize: 25,
                                                    ),
                                                    textAlign: TextAlign.left,
                                                  ))),
                                          Padding(
                                              padding: EdgeInsets.all(10),
                                              child: LinearProgressIndicator())
                                        ]));
                                  } else if (phase == 'finished') {
                                    return Padding(
                                        padding: EdgeInsets.all(20),
                                        child: Column(children: <Widget>[
                                          Padding(
                                              padding: EdgeInsets.all(10),
                                              child: Container(
                                                  child: Icon(
                                                    Icons.check_circle_outline,
                                                    size: 45,
                                                    color: Colors.blue[900],
                                                  ))),
                                          Padding(
                                              padding: EdgeInsets.all(10),
                                              child: Container(
                                                  child: Text(
                                                    'データの移行が完了しました',
                                                    style: TextStyle(
                                                      fontSize: 25,
                                                    ),
                                                    textAlign: TextAlign.left,
                                                  ))),
                                          Padding(
                                              padding: EdgeInsets.all(10),
                                              child: Container(
                                                  child: ElevatedButton.icon(
                                                    icon: Icon(Icons.person),
                                                    label: Text("ユーザー詳細へ"),
                                                    onPressed: () {
                                                      Navigator.push(context,
                                                          MaterialPageRoute<
                                                              SelectBookView>(
                                                              builder: (
                                                                  BuildContext
                                                                  context) {
                                                                return SelectBookView(
                                                                    migrationSnapshot
                                                                        .get(
                                                                        'uid'),'scout');
                                                              }));
                                                    },
                                                  ))),
                                        ]));
                                  } else if (phase == 'reject') {
                                    return Padding(
                                        padding: EdgeInsets.all(20),
                                        child: Column(children: <Widget>[
                                          Padding(
                                              padding: EdgeInsets.all(10),
                                              child: Container(
                                                  child: Icon(
                                                    Icons.info_outline,
                                                    size: 45,
                                                    color: Colors.blue[900],
                                                  ))),
                                          Padding(
                                              padding: EdgeInsets.all(10),
                                              child: Container(
                                                  child: Text(
                                                    '申請を却下しました',
                                                    style: TextStyle(
                                                      fontSize: 25,
                                                    ),
                                                    textAlign: TextAlign.left,
                                                  ))),
                                        ]));
                                  } else {
                                    return Padding(
                                        padding: EdgeInsets.all(20),
                                        child: Column(children: <Widget>[
                                          Padding(
                                              padding: EdgeInsets.all(10),
                                              child: Container(
                                                  child: Icon(
                                                    Icons.info_outline,
                                                    size: 45,
                                                    color: Colors.blue[900],
                                                  ))),
                                          Padding(
                                              padding: EdgeInsets.all(10),
                                              child: Container(
                                                  child: Text(
                                                    '不明なパラメータ',
                                                    style: TextStyle(
                                                      fontSize: 25,
                                                    ),
                                                    textAlign: TextAlign.left,
                                                  ))),
                                        ]));
                                  }
                                } else {
                                  return const Center(
                                    child: Padding(
                                        padding: EdgeInsets.all(5),
                                        child: CircularProgressIndicator()),
                                  );
                                }
                              })
                        ],
                      )))),
        ));
  }
}
