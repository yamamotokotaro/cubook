import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cubook/detailMigrationWaiting/detailMigrationWaiting_model.dart';
import 'package:cubook/detailTaskWaiting/detailTaskWaiting_model.dart';
import 'package:cubook/model/task.dart';
import 'package:cubook/model/themeInfo.dart';
import 'package:cubook/userDetail/userDetail_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class DetailMigrationWaitingView extends StatelessWidget {

  DetailMigrationWaitingView(String _documentID, String? _name,
      String? _groupName, String? _age) {
    documentID = _documentID;
    name = _name;
    groupName = _groupName;
    age = _age;
  }
  String? documentID;
  String? name;
  String? groupName;
  String? age;
  Map<String, dynamic>? taskInfo;
  Map<String, dynamic>? content;
  TaskContents task = TaskContents();
  ThemeInfo theme = ThemeInfo();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (BuildContext context) => DetailTaskWaitingModel(),
        child: Scaffold(
          appBar: AppBar(
            title: const Text('申請詳細'), systemOverlayStyle: SystemUiOverlayStyle.light,
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
                              tag: 'detailTask' + documentID!,
                              child: SingleChildScrollView(
                                  child: Container(
                                    width: MediaQuery
                                        .of(context)
                                        .size
                                        .width,
                                    color: theme.getThemeColor(age),
                                    child: Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Column(
                                        children: <Widget>[
                                          Material(
                                            type: MaterialType.transparency,
                                            child: Text(
                                              name!,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.normal,
                                                  fontSize: 28,
                                                  color: Colors.white),
                                            ),
                                          ),
                                          Material(
                                              type: MaterialType.transparency,
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 10),
                                                child: Text(
                                                  groupName!,
                                                  style: const TextStyle(
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
                                final DocumentSnapshot? migrationSnapshot = snapshot
                                    .data;
                                if (snapshot.hasData) {
                                  final String? phase = migrationSnapshot!.get('phase');
                                  if (phase == 'wait') {
                                    return Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Column(children: <Widget>[
                                          Padding(
                                              padding: const EdgeInsets.all(10),
                                              child: Container(
                                                  width: double.infinity,
                                                  child: const Text(
                                                    '申請者',
                                                    style: TextStyle(
                                                      fontSize: 17,
                                                    ),
                                                    textAlign: TextAlign.left,
                                                  ))),
                                          Padding(
                                              padding: const EdgeInsets.all(10),
                                              child: Container(
                                                  width: double.infinity,
                                                  child: Text(
                                                    snapshot.data!
                                                        .get('operatorName'),
                                                    style: const TextStyle(
                                                      fontWeight: FontWeight
                                                          .bold,
                                                      fontSize: 22,
                                                    ),
                                                    textAlign: TextAlign.left,
                                                  ))),
                                          Padding(
                                              padding: const EdgeInsets.all(10),
                                              child: Container(
                                                  width: double.infinity,
                                                  child: const Text(
                                                    'グループID',
                                                    style: TextStyle(
                                                      fontSize: 17,
                                                    ),
                                                    textAlign: TextAlign.left,
                                                  ))),
                                          Padding(
                                              padding: const EdgeInsets.all(10),
                                              child: Container(
                                                  width: double.infinity,
                                                  child: Text(
                                                    snapshot.data!.get(
                                                        'group_from'),
                                                    style: const TextStyle(
                                                      fontWeight: FontWeight
                                                          .bold,
                                                      fontSize: 20,
                                                    ),
                                                    textAlign: TextAlign.left,
                                                  ))),
                                          Padding(
                                              padding: const EdgeInsets.all(10),
                                              child: Container(
                                                  width: double.infinity,
                                                  child: const Text(
                                                    '申請日時',
                                                    style: TextStyle(
                                                      fontSize: 17,
                                                    ),
                                                    textAlign: TextAlign.left,
                                                  ))),
                                          Padding(
                                              padding: const EdgeInsets.all(10),
                                              child: Container(
                                                  width: double.infinity,
                                                  child: Text(
                                                    DateFormat(
                                                        'yyyy年MM月dd日HH時mm分')
                                                        .format(snapshot.data!
                                                        .get('time')
                                                        .toDate())
                                                        .toString(),
                                                    style: const TextStyle(
                                                      fontWeight: FontWeight
                                                          .bold,
                                                      fontSize: 20,
                                                    ),
                                                    textAlign: TextAlign.left,
                                                  ))),
                                          Consumer<DetailMigrationWaitingModel>(
                                              builder: (BuildContext context, DetailMigrationWaitingModel model, Widget? child) {
                                                if (model.isLoading) {
                                                  return const Padding(
                                                      padding: EdgeInsets.all(
                                                          10),
                                                      child: CircularProgressIndicator());
                                                }
                                                else {
                                                  return Column(children: [
                                                    Padding(
                                                        padding: const EdgeInsets.all(
                                                            10),
                                                        child: Container(
                                                            width: double
                                                                .infinity,
                                                            child: OutlinedButton
                                                                .icon(
                                                              icon: const Icon(
                                                                Icons.check,
                                                                color: Colors
                                                                    .green,
                                                              ),
                                                              label: const Text(
                                                                  '承認する'),
                                                              onPressed: () {
                                                                model
                                                                    .migrateAccount(
                                                                    context,
                                                                    documentID);
                                                              },
                                                            ))),
                                                    Padding(
                                                        padding: const EdgeInsets.all(
                                                            10),
                                                        child: Container(
                                                            width: double
                                                                .infinity,
                                                            child: OutlinedButton
                                                                .icon(
                                                              icon: const Icon(
                                                                Icons.clear,
                                                                color: Colors
                                                                    .red,
                                                              ),
                                                              label: const Text(
                                                                  '却下する'),
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
                                        padding: const EdgeInsets.all(20),
                                        child: Column(children: <Widget>[
                                          Padding(
                                              padding: const EdgeInsets.all(10),
                                              child: Container(
                                                  child: Icon(
                                                    Icons
                                                        .account_circle_outlined,
                                                    size: 45,
                                                    color: Colors.blue[900],
                                                  ))),
                                          Padding(
                                              padding: const EdgeInsets.all(10),
                                              child: Container(
                                                  child: const Text(
                                                    'データの移行を行っています',
                                                    style: TextStyle(
                                                      fontSize: 25,
                                                    ),
                                                    textAlign: TextAlign.left,
                                                  ))),
                                          const Padding(
                                              padding: EdgeInsets.all(10),
                                              child: LinearProgressIndicator())
                                        ]));
                                  } else if (phase == 'finished') {
                                    return Padding(
                                        padding: const EdgeInsets.all(20),
                                        child: Column(children: <Widget>[
                                          Padding(
                                              padding: const EdgeInsets.all(10),
                                              child: Container(
                                                  child: Icon(
                                                    Icons.check_circle_outline,
                                                    size: 45,
                                                    color: Colors.blue[900],
                                                  ))),
                                          Padding(
                                              padding: const EdgeInsets.all(10),
                                              child: Container(
                                                  child: const Text(
                                                    'データの移行が完了しました',
                                                    style: TextStyle(
                                                      fontSize: 25,
                                                    ),
                                                    textAlign: TextAlign.left,
                                                  ))),
                                          Padding(
                                              padding: const EdgeInsets.all(10),
                                              child: Container(
                                                  child: ElevatedButton.icon(
                                                    icon: const Icon(Icons.person),
                                                    label: const Text('ユーザー詳細へ'),
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
                                        padding: const EdgeInsets.all(20),
                                        child: Column(children: <Widget>[
                                          Padding(
                                              padding: const EdgeInsets.all(10),
                                              child: Container(
                                                  child: Icon(
                                                    Icons.info_outline,
                                                    size: 45,
                                                    color: Colors.blue[900],
                                                  ))),
                                          Padding(
                                              padding: const EdgeInsets.all(10),
                                              child: Container(
                                                  child: const Text(
                                                    '申請を却下しました',
                                                    style: TextStyle(
                                                      fontSize: 25,
                                                    ),
                                                    textAlign: TextAlign.left,
                                                  ))),
                                        ]));
                                  } else {
                                    return Padding(
                                        padding: const EdgeInsets.all(20),
                                        child: Column(children: <Widget>[
                                          Padding(
                                              padding: const EdgeInsets.all(10),
                                              child: Container(
                                                  child: Icon(
                                                    Icons.info_outline,
                                                    size: 45,
                                                    color: Colors.blue[900],
                                                  ))),
                                          Padding(
                                              padding: const EdgeInsets.all(10),
                                              child: Container(
                                                  child: const Text(
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
