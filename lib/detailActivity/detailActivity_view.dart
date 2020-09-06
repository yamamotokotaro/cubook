import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cubook/detailActivity/detailActivity_model.dart';
import 'package:cubook/model/arguments.dart';
import 'package:cubook/model/task.dart';
import 'package:cubook/model/themeInfo.dart';
import 'package:cubook/task_detail_scout/taskDetailScout_view.dart';
import 'package:cubook/task_list_scout/taskListScout_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class DetailActivityView extends StatelessWidget {
  var theme = new ThemeInfo();
  var task = new Task();

  @override
  Widget build(BuildContext context) {
    String documentID = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text('記録詳細'),
        actions: <Widget>[
          Selector<DetailActivityModel, String>(
              selector: (context, model) => model.position,
              builder: (context, position, child) => position == 'leader'
                  ? IconButton(
                      icon: Icon(Icons.more_vert),
                      onPressed: () async {
                        await showModalBottomSheet<int>(
                          context: context,
                          builder: (BuildContext context) {
                            return Padding(
                                padding: EdgeInsets.only(top: 10, bottom: 10),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Consumer<DetailActivityModel>(
                                        builder: (context, model, child) {
                                      return ListTile(
                                        leading: Icon(Icons.delete),
                                        title: Text('記録を削除する'),
                                        onTap: () {
                                          model.deleteActivity(documentID);
                                          Navigator.pop(context);
                                          Navigator.pop(context);
                                        },
                                      );
                                    })
                                  ],
                                ));
                          },
                        );
                      },
                    )
                  : Container())
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 600),
              child: Column(
                children: <Widget>[
                  Padding(
                      padding: EdgeInsets.only(top: 20, bottom: 10),
                      child: Consumer<DetailActivityModel>(
                          builder: (context, model, child) {
                        model.getGroup();
                        if (model.group != null) {
                          return Column(
                            children: <Widget>[
                              StreamBuilder<DocumentSnapshot>(
                                stream: Firestore.instance
                                    .collection('activity')
                                    .document(documentID)
                                    .snapshots(),
                                builder: (BuildContext context,
                                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                                  if (snapshot.hasData) {
                                    DocumentSnapshot documentSnapshot =
                                        snapshot.data;
                                    String team_last = '';
                                    return Column(children: <Widget>[
                                      Padding(
                                          padding: EdgeInsets.all(17),
                                          child: Container(
                                              width: double.infinity,
                                              child: Text(
                                                documentSnapshot['title'],
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 32,
                                                ),
                                                textAlign: TextAlign.left,
                                              ))),
                                      Padding(
                                          padding: EdgeInsets.only(
                                              top: 0, bottom: 15, left: 17),
                                          child: Container(
                                              width: double.infinity,
                                              child: Text(
                                                DateFormat('yyyy年MM月dd日')
                                                    .format(
                                                        documentSnapshot['date']
                                                            .toDate())
                                                    .toString(),
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20,
                                                ),
                                                textAlign: TextAlign.left,
                                              ))),
                                      documentSnapshot['list_item'] != null
                                          ? documentSnapshot['list_item']
                                                      .length !=
                                                  0
                                              ? Column(
                                                  children: [
                                                    Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                top: 15,
                                                                bottom: 15,
                                                                left: 10),
                                                        child: Container(
                                                            width:
                                                                double.infinity,
                                                            child: Text(
                                                              '取得項目',
                                                              style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 25,
                                                              ),
                                                              textAlign:
                                                                  TextAlign
                                                                      .left,
                                                            ))),
                                                    ListView.builder(
                                                        physics:
                                                            const NeverScrollableScrollPhysics(),
                                                        itemCount:
                                                            documentSnapshot[
                                                                    'list_item']
                                                                .length,
                                                        shrinkWrap: true,
                                                        itemBuilder:
                                                            (BuildContext
                                                                    context,
                                                                int index) {
                                                          Map<String, dynamic>
                                                              part_selected =
                                                              documentSnapshot[
                                                                      'list_item']
                                                                  [index];
                                                          String type =
                                                              part_selected[
                                                                  'type'];
                                                          int page =
                                                              part_selected[
                                                                  'page'];
                                                          int number =
                                                              part_selected[
                                                                  'number'];
                                                          String position =
                                                              model.position;
                                                          Map<String, dynamic>
                                                              map_task =
                                                              task.getPartMap(
                                                                  type, page);
                                                          bool toShow = false;
                                                          if (position ==
                                                              'scout') {
                                                            if (type ==
                                                                    'challenge' ||
                                                                type ==
                                                                    model.age) {
                                                              toShow = true;
                                                            }
                                                          } else {
                                                            toShow = true;
                                                          }
                                                          if (toShow) {
                                                            return Padding(
                                                                padding:
                                                                    EdgeInsets
                                                                        .all(5),
                                                                child: Card(
                                                                  color: theme
                                                                      .getThemeColor(
                                                                          type),
                                                                  shape:
                                                                      RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            5.0),
                                                                  ),
                                                                  child: InkWell(
                                                                      customBorder: RoundedRectangleBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(10.0),
                                                                      ),
                                                                      onTap: () async {
                                                                        if (position ==
                                                                            'scout') {
                                                                          Navigator.of(context).push<dynamic>(MyPageRoute(
                                                                              page: showTaskView(page, type, number + 1),
                                                                              dismissible: true));
                                                                        } else {
                                                                          await showModalBottomSheet<
                                                                              int>(
                                                                            context:
                                                                                context,
                                                                            builder:
                                                                                (BuildContext context) {
                                                                              return Padding(
                                                                                  padding: EdgeInsets.all(15),
                                                                                  child: Column(
                                                                                    mainAxisSize: MainAxisSize.min,
                                                                                    children: <Widget>[
                                                                                      Padding(
                                                                                          padding: EdgeInsets.all(0),
                                                                                          child: Container(
                                                                                            width: double.infinity,
                                                                                            child: Text(
                                                                                              task.getContent(type, page, number),
                                                                                              style: TextStyle(
                                                                                                fontSize: 18,
                                                                                                fontWeight: FontWeight.bold,
                                                                                              ),
                                                                                              textAlign: TextAlign.left,
                                                                                            ),
                                                                                          )),
                                                                                      Padding(
                                                                                          padding: EdgeInsets.all(0),
                                                                                          child: Container(
                                                                                            width: double.infinity,
                                                                                            child: Text(
                                                                                              '\n公財ボーイスカウト日本連盟「令和2年版 諸規定」',
                                                                                              style: TextStyle(
                                                                                                fontSize: 13,
                                                                                                fontWeight: FontWeight.bold,
                                                                                              ),
                                                                                              textAlign: TextAlign.left,
                                                                                            ),
                                                                                          )),
                                                                                    ],
                                                                                  ));
                                                                            },
                                                                          );
                                                                        }
                                                                      },
                                                                      child: Center(
                                                                          child: Padding(
                                                                              padding: EdgeInsets.only(top: 5, bottom: 5),
                                                                              child: Column(
                                                                                children: [
                                                                                  Text(theme.getTitle(type) + ' ' + (page + 1).toString() + ' ' + map_task['title'] + ' (' + (number + 1).toString() + ')', style: TextStyle(fontWeight: FontWeight.normal, fontSize: 18, color: Colors.white))
                                                                                ],
                                                                              )))),
                                                                ));
                                                          } else {
                                                            return Container();
                                                          }
                                                        })
                                                  ],
                                                )
                                              : Container()
                                          : Container(),
                                    ]);
                                  } else {
                                    return const Center(
                                      child: Padding(
                                          padding: EdgeInsets.all(5),
                                          child: CircularProgressIndicator()),
                                    );
                                  }
                                },
                              ),
                              StreamBuilder<QuerySnapshot>(
                                stream: Firestore.instance
                                    .collection('activity_personal')
                                    .where('group', isEqualTo: model.group)
                                    .where('activity', isEqualTo: documentID)
                                    .orderBy('team')
                                    .orderBy('age_turn', descending: true)
                                    .orderBy('name')
                                    .snapshots(),
                                builder: (BuildContext context,
                                    AsyncSnapshot<QuerySnapshot> snapshot) {
                                  if (snapshot.hasData) {
                                    if (snapshot.data.documents.length != 0) {
                                      QuerySnapshot querySnapshot =
                                          snapshot.data;
                                      DocumentSnapshot documentSnapshot =
                                          querySnapshot.documents[0];
                                      String team_last = '';
                                      return Column(children: <Widget>[
                                        ListView.builder(
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            itemCount:
                                                querySnapshot.documents.length,
                                            shrinkWrap: true,
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              String uid;
                                              DocumentSnapshot snapshot =
                                                  querySnapshot
                                                      .documents[index];
                                              uid = snapshot['uid'];
                                              bool isCheck = true;
                                              if (model.uid_check[uid] !=
                                                  null) {
                                                isCheck = model.uid_check[uid];
                                              }
                                              String team = '';
                                              if (snapshot['team'] != null) {
                                                if (snapshot['team'] is int) {
                                                  team = snapshot['team']
                                                      .toString();
                                                } else {
                                                  team = snapshot['team'];
                                                }
                                              } else {
                                                team = 'null';
                                              }
                                              bool isFirst;
                                              String absence;
                                              if (team_last != team) {
                                                isFirst = true;
                                                team_last = team;
                                              } else {
                                                isFirst = false;
                                              }
                                              if (snapshot['absent']) {
                                                absence = '出席';
                                              } else {
                                                absence = '欠席';
                                              }
                                              String age = snapshot['age'];
                                              String team_call;
                                              if (age == 'usagi' ||
                                                  age == 'sika' ||
                                                  age == 'kuma') {
                                                team_call = '組';
                                              } else {
                                                team_call = '班';
                                              }
                                              print(model.uid_check);
                                              return Column(children: <Widget>[
                                                isFirst && team != ''
                                                    ? Padding(
                                                        padding:
                                                            EdgeInsets.all(10),
                                                        child: Container(
                                                            width:
                                                                double.infinity,
                                                            child: Text(
                                                              team + team_call,
                                                              style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 23,
                                                              ),
                                                              textAlign:
                                                                  TextAlign
                                                                      .left,
                                                            )))
                                                    : Container(),
                                                Padding(
                                                    padding: EdgeInsets.all(5),
                                                    child: Container(
                                                      child: Card(
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                        ),
                                                        child: InkWell(
                                                          onTap: () {},
                                                          child: Padding(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    10),
                                                            child: Row(
                                                              children: <
                                                                  Widget>[
                                                                Container(
                                                                  width: 40,
                                                                  height: 40,
                                                                  decoration: BoxDecoration(
                                                                      color: theme.getUserColor(
                                                                          snapshot[
                                                                              'age']),
                                                                      shape: BoxShape
                                                                          .circle),
                                                                  child: Icon(
                                                                    Icons
                                                                        .person,
                                                                    color: Colors
                                                                        .white,
                                                                  ),
                                                                ),
                                                                Padding(
                                                                    padding: EdgeInsets
                                                                        .only(
                                                                            left:
                                                                                10),
                                                                    child: Text(
                                                                      snapshot[
                                                                          'name'],
                                                                      style: TextStyle(
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          fontSize:
                                                                              25),
                                                                    )),
                                                                Spacer(),
                                                                Padding(
                                                                    padding: EdgeInsets
                                                                        .only(
                                                                            left:
                                                                                10),
                                                                    child: Text(
                                                                      absence,
                                                                      style: TextStyle(
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          fontSize:
                                                                              17),
                                                                    ))

                                                                /*Padding(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      left: 10),
                                                              child: Text(
                                                                snapshot['team']
                                                                        .toString() +
                                                                    '組',
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        15),
                                                              ))*/
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ))
                                              ]);
                                            })
                                      ]);
                                    } else {
                                      return Padding(
                                        padding: EdgeInsets.only(
                                            top: 5, left: 10, right: 10),
                                        child: Container(
                                            child: InkWell(
                                          onTap: () {},
                                          child: Padding(
                                            padding: EdgeInsets.all(10),
                                            child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: <Widget>[
                                                  Icon(
                                                    Icons.bubble_chart,
                                                    color: Theme.of(context)
                                                        .accentColor,
                                                    size: 35,
                                                  ),
                                                  Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 10),
                                                      child: Material(
                                                        type: MaterialType
                                                            .transparency,
                                                        child: Text(
                                                          '出欠の記録はありません',
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                            fontSize: 20,
                                                          ),
                                                        ),
                                                      )),
                                                ]),
                                          ),
                                        )),
                                      );
                                    }
                                  } else {
                                    return const Center(
                                      child: Padding(
                                          padding: EdgeInsets.all(5),
                                          child: CircularProgressIndicator()),
                                    );
                                  }
                                },
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
                      }))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
