import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cubook/home/home_model.dart';
import 'package:cubook/model/task.dart';
import 'package:cubook/model/themeInfo.dart';
import 'package:cubook/select_book/selectBook_model.dart';
import 'package:cubook/task_list_scout/taskListScout_view.dart';
import 'package:cubook/task_list_scout_confirm/taskListScoutConfirm_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
          title: Text('確認する項目を選択'),
        ),
        body: SafeArea(
            child: SingleChildScrollView(
                child: Center(
                    child: ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: 600),
                        child: Column(
                          children: <Widget>[
                            Padding(
                                padding: EdgeInsets.all(10),
                                child: Container(
                                    height: 180,
                                    child: Card(
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
                                                          Colors.green[700],
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
                                                          Colors.green[700],
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
                                                          Colors.green[700],
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
