import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cubook/model/task.dart';
import 'package:cubook/model/themeInfo.dart';
import 'package:cubook/select_book/selectBook_model.dart';
import 'package:cubook/task_list_scout/taskListScout_view.dart';
import 'package:cubook/task_list_scout_confirm/taskListScoutConfirm_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SelectBookView extends StatelessWidget {
  var task = new Task();
  var theme = new ThemeInfo();
  String uid;

  SelectBookView(String uid) {
    this.uid = uid;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('メンバー詳細'),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.settings,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.of(context).pushNamed(
                    '/settingAccount', arguments: uid);
              },
            )
          ],
        ),
        body: SafeArea(
            child: SingleChildScrollView(
                child: Center(
                    child: ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: 600),
                        child:
                        Column(
                          children: <Widget>[
                            Consumer<SelectBookModel>(
                                builder: (context, model, child) {
                                  model.getGroup();
                                  if (model.group != null) {
                                    return StreamBuilder<QuerySnapshot>(
                                      stream: Firestore.instance.collection(
                                          'user')
                                          .where(
                                          'group', isEqualTo: model.group)
                                          .where(
                                          'uid', isEqualTo: uid)
                                          .snapshots(),
                                      builder: (BuildContext context,
                                          AsyncSnapshot<
                                              QuerySnapshot> snapshot) {
                                        if (snapshot.hasData) {
                                          DocumentSnapshot userSnapshot = snapshot.data.documents[0];
                                          return Column(children: <Widget>[
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  top: 16, bottom: 10),
                                              child: Container(
                                                width: 80,
                                                height: 80,
                                                decoration: BoxDecoration(
                                                    color: theme.getThemeColor(userSnapshot['age']),
                                                    shape: BoxShape
                                                        .circle),
                                                child: Icon(
                                                  Icons.person,
                                                  size: 40,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                            Padding(
                                                padding:
                                                EdgeInsets.only(bottom: 10),
                                                child: Text(
                                                  userSnapshot['name'],
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontWeight:
                                                      FontWeight
                                                          .bold,
                                                      fontSize: 25),
                                                )),
                                          ],);
                                        } else {
                                          return const Center(
                                            child: Padding(
                                                padding: EdgeInsets.all(5),
                                                child: CircularProgressIndicator()),
                                          );
                                        }
                                      },
                                    );
                                  } else {
                                    return const Center(
                                      child: Padding(
                                          padding: EdgeInsets.all(5),
                                          child: CircularProgressIndicator()),
                                    );
                                  }
                                }
                            ),
                            Padding(
                                padding: EdgeInsets.all(10),
                                child: Container(
                                    height: 180,
                                    child: Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      elevation: 8,
                                      color: theme.getThemeColor(
                                          'usagi'),
                                      child: InkWell(
                                        onTap: () {
                                          Navigator.push(context,
                                              MaterialPageRoute<
                                                  TaskView>(
                                                  builder: (BuildContext
                                                  context) {
                                                    return TaskListScoutConfirmView(
                                                        'usagi', uid);
                                                  }));
                                        },
                                        child: Align(
                                            alignment: Alignment
                                                .bottomLeft,
                                            child: Column(
                                                mainAxisAlignment:
                                                MainAxisAlignment.end,
                                                children: <Widget>[
                                                  Align(
                                                      alignment: Alignment
                                                          .bottomLeft,
                                                      child: Padding(
                                                          padding: EdgeInsets
                                                              .only(
                                                              left: 13),
                                                          child: Material(
                                                            type: MaterialType
                                                                .transparency,
                                                            child: Text(
                                                              theme
                                                                  .getTitle(
                                                                  'usagi'),
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                  FontWeight
                                                                      .normal,
                                                                  fontSize:
                                                                  30,
                                                                  color: Colors
                                                                      .white),
                                                            ),
                                                          ))),
                                                  Padding(
                                                      padding:
                                                      EdgeInsets.all(
                                                          20),
                                                      child:
                                                      Consumer<SelectBookModel>(
                                                          builder: (context,
                                                              model, child) {
                                                            if (model
                                                                .userSnapshot ==
                                                                null) {
                                                              model.getSnapshot(
                                                                  uid);
                                                            } else if (model
                                                                .userSnapshot
                                                                .data['uid'] !=
                                                                uid) {
                                                              model.getSnapshot(
                                                                  uid);
                                                              model
                                                                  .userSnapshot =
                                                              null;
                                                            }
                                                            if (model
                                                                .userSnapshot !=
                                                                null) {
                                                              if (model
                                                                  .userSnapshot['usagi'] !=
                                                                  null) {
                                                                return LinearProgressIndicator(
                                                                    backgroundColor:
                                                                    theme
                                                                        .getIndicatorColor(
                                                                        'usagi'),
                                                                    valueColor:
                                                                    new AlwaysStoppedAnimation<
                                                                        Color>(
                                                                        Colors
                                                                            .white),
                                                                    value: model
                                                                        .userSnapshot['usagi']
                                                                        .length /
                                                                        task
                                                                            .getAllMap(
                                                                            'usagi')
                                                                            .length);
                                                              } else {
                                                                return Container();
                                                              }
                                                            } else {
                                                              return LinearProgressIndicator(
                                                                backgroundColor:
                                                                theme
                                                                    .getIndicatorColor(
                                                                    'usagi'),
                                                                valueColor:
                                                                new AlwaysStoppedAnimation<
                                                                    Color>(
                                                                    Colors
                                                                        .white),);
                                                            }
                                                          }))
                                                ])),
                                      ),
                                    ))),
                            Padding(
                                padding: EdgeInsets.all(10),
                                child: Container(
                                  height: 180,
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    elevation: 8,
                                    color: theme.getThemeColor(
                                        'sika'),
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.push(context,
                                            MaterialPageRoute<TaskView>(
                                                builder: (
                                                    BuildContext context) {
                                                  return TaskListScoutConfirmView(
                                                      'sika', uid);
                                                }));
                                      },
                                      child: Align(
                                        alignment: Alignment.bottomLeft,
                                        child: Column(
                                            mainAxisAlignment: MainAxisAlignment
                                                .end,
                                            children: <Widget>[
                                              Align(
                                                  alignment: Alignment
                                                      .bottomLeft,
                                                  child: Padding(
                                                    padding: EdgeInsets
                                                        .only(left: 13),
                                                    child: Material(
                                                        type: MaterialType
                                                            .transparency,
                                                        child: Text(
                                                          'しかのカブブック',
                                                          style: TextStyle(
                                                              fontWeight: FontWeight
                                                                  .normal,
                                                              fontSize: 30,
                                                              color: Colors
                                                                  .white),
                                                        )),
                                                  )),
                                              Padding(
                                                  padding: EdgeInsets.all(
                                                      20),
                                                  child: Selector<
                                                      SelectBookModel,
                                                      DocumentSnapshot>(
                                                      selector: (context,
                                                          model) =>
                                                      model.userSnapshot,
                                                      builder: (context,
                                                          snapshot,
                                                          child) =>
                                                      snapshot != null
                                                          ?
                                                      snapshot['sika'] !=
                                                          null
                                                          ? LinearProgressIndicator(
                                                          backgroundColor:
                                                          theme
                                                              .getIndicatorColor(
                                                              'sika'),
                                                          valueColor:
                                                          new AlwaysStoppedAnimation<
                                                              Color>(
                                                              Colors.white),
                                                          value: snapshot['sika']
                                                              .length /
                                                              task
                                                                  .getAllMap(
                                                                  'sika')
                                                                  .length)
                                                          : Container()
                                                          : LinearProgressIndicator(
                                                        backgroundColor:
                                                        theme
                                                            .getIndicatorColor(
                                                            'sika'),
                                                        valueColor:
                                                        new AlwaysStoppedAnimation<
                                                            Color>(
                                                            Colors
                                                                .white),))),
                                            ]),
                                      ),
                                    ),
                                  ),
                                )),
                            Padding(
                                padding: EdgeInsets.all(10),
                                child: Container(
                                  height: 180,
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    elevation: 8,
                                    color: theme.getThemeColor(
                                        'kuma'),
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.push(context,
                                            MaterialPageRoute<TaskView>(builder:
                                                (BuildContext context) {
                                              return TaskListScoutConfirmView(
                                                  'kuma', uid);
                                            }));
                                      },
                                      child: Align(
                                        alignment: Alignment.bottomLeft,
                                        child: Column(
                                            mainAxisAlignment:
                                            MainAxisAlignment.end,
                                            children: <Widget>[
                                              Align(
                                                  alignment:
                                                  Alignment.bottomLeft,
                                                  child: Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 13),
                                                    child: Material(
                                                        type: MaterialType
                                                            .transparency,
                                                        child: Text(
                                                          'くまのカブブック',
                                                          style: TextStyle(
                                                              fontWeight:
                                                              FontWeight
                                                                  .normal,
                                                              fontSize: 30,
                                                              color:
                                                              Colors.white),
                                                        )),
                                                  )),
                                              Padding(
                                                  padding: EdgeInsets.all(20),
                                                  child: Selector<
                                                      SelectBookModel,
                                                      DocumentSnapshot>(
                                                      selector: (context,
                                                          model) =>
                                                      model.userSnapshot,
                                                      builder: (context,
                                                          snapshot, child) =>
                                                      snapshot != null
                                                          ?
                                                      snapshot['kuma'] !=
                                                          null
                                                          ? LinearProgressIndicator(
                                                          backgroundColor:
                                                          theme
                                                              .getIndicatorColor(
                                                              'kuma'),
                                                          valueColor:
                                                          new AlwaysStoppedAnimation<
                                                              Color>(
                                                              Colors.white),
                                                          value: snapshot['kuma']
                                                              .length /
                                                              task
                                                                  .getAllMap(
                                                                  'kuma')
                                                                  .length)
                                                          : Container()
                                                          : LinearProgressIndicator(
                                                        backgroundColor:
                                                        theme
                                                            .getIndicatorColor(
                                                            'kuma'),
                                                        valueColor:
                                                        new AlwaysStoppedAnimation<
                                                            Color>(
                                                            Colors
                                                                .white),))),
                                            ]),
                                      ),
                                    ),
                                  ),
                                )),
                            Padding(
                                padding: EdgeInsets.all(10),
                                child: Container(
                                  height: 180,
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    elevation: 8,
                                    color: Colors.green[900],
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.push(context,
                                            MaterialPageRoute<TaskView>(builder:
                                                (BuildContext context) {
                                              return TaskListScoutConfirmView(
                                                  'challenge', uid);
                                            }));
                                      },
                                      child: Align(
                                        alignment: Alignment.bottomLeft,
                                        child: Column(
                                            mainAxisAlignment:
                                            MainAxisAlignment.end,
                                            children: <Widget>[
                                              Align(
                                                  alignment:
                                                  Alignment.bottomLeft,
                                                  child: Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 13),
                                                    child: Material(
                                                        type: MaterialType
                                                            .transparency,
                                                        child: Text(
                                                          'チャレンジ章',
                                                          style: TextStyle(
                                                              fontWeight:
                                                              FontWeight
                                                                  .normal,
                                                              fontSize: 30,
                                                              color:
                                                              Colors.white),
                                                        )),
                                                  )),
                                              Padding(
                                                  padding: EdgeInsets.all(20),
                                                  child: Selector<
                                                      SelectBookModel,
                                                      DocumentSnapshot>(
                                                      selector: (context,
                                                          model) =>
                                                      model.userSnapshot,
                                                      builder: (context,
                                                          snapshot,
                                                          child) =>
                                                      snapshot != null
                                                          ?
                                                      snapshot['challenge'] !=
                                                          null
                                                          ? LinearProgressIndicator(
                                                          backgroundColor:
                                                          theme
                                                              .getIndicatorColor(
                                                              'challenge'),
                                                          valueColor:
                                                          new AlwaysStoppedAnimation<
                                                              Color>(
                                                              Colors.white),
                                                          value: snapshot['challenge']
                                                              .length /
                                                              task
                                                                  .getAllMap(
                                                                  'challenge')
                                                                  .length)
                                                          : Container()
                                                          : LinearProgressIndicator(
                                                        backgroundColor:
                                                        theme
                                                            .getIndicatorColor(
                                                            'challenge'),
                                                        valueColor:
                                                        new AlwaysStoppedAnimation<
                                                            Color>(
                                                            Colors
                                                                .white),))),
                                            ]),
                                      ),
                                    ),
                                  ),
                                )),
                          ],
                        ))))));
  }
}
