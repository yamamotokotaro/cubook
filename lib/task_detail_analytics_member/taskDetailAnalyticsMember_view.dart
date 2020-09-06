import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cubook/detailActivity/detailActivity_model.dart';
import 'package:cubook/model/arguments.dart';
import 'package:cubook/model/class.dart';
import 'package:cubook/model/task.dart';
import 'package:cubook/model/themeInfo.dart';
import 'package:cubook/task_detail_scout_confirm/taskDetailScoutConfirm_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TaskDetailAnalyticsMemberView extends StatelessWidget {
  var theme = new ThemeInfo();
  var task = new Task();

  @override
  Widget build(BuildContext context) {
    TaskDetailMember info = ModalRoute.of(context).settings.arguments;
    String type = info.type;
    int page = info.page;
    String phase = info.phase;
    int number = info.number;
    Color themeColor = theme.getThemeColor(type);
    List<String> contents = task.getContentList(type, page);
    var map_task = task.getPartMap(type, page);
    bool isDark;
    if (Theme.of(context).accentColor == Colors.white) {
      isDark = true;
    } else {
      isDark = false;
    }
    return Scaffold(
      appBar: AppBar(
        title:
            Text(phase == 'end' ? task.getPartMap(type, page)['title'] + ' 完修者' : task.getPartMap(type, page)['title'] + '(' + (number+1).toString() + ') サイン済み'),
        backgroundColor: themeColor,
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
                              StreamBuilder<QuerySnapshot>(
                                  stream: Firestore.instance
                                      .collection('user')
                                      .where('group', isEqualTo: model.group)
                                      .where('position', isEqualTo: 'scout')
                                      .orderBy('team')
                                      .orderBy('age_turn', descending: true)
                                      .orderBy('name')
                                      .snapshots(),
                                  builder: (BuildContext context,
                                      AsyncSnapshot<QuerySnapshot> snapshot) {
                                    String team_last = '';
                                    if (snapshot.hasData) {
                                      int userCount = 0;
                                      List<DocumentSnapshot> listSnapshot =
                                          snapshot.data.documents;
                                      List<String> listUid = new List<String>();
                                      List<String> listUid_toShow =
                                          new List<String>();
                                      if (type == 'challenge' ||
                                          type == 'gino') {
                                        userCount = listSnapshot.length;
                                      } else {
                                        for (DocumentSnapshot documentSnapshot
                                            in listSnapshot) {
                                          if (documentSnapshot['age'] == type) {
                                            userCount++;
                                            listUid
                                                .add(documentSnapshot['uid']);
                                          }
                                        }
                                      }
                                      return StreamBuilder<QuerySnapshot>(
                                        stream: Firestore.instance
                                            .collection(type)
                                            .where('group',
                                                isEqualTo: model.group)
                                            .where('page', isEqualTo: page)
                                            .snapshots(),
                                        builder: (BuildContext context,
                                            AsyncSnapshot<QuerySnapshot>
                                                snapshot_task) {
                                          if (snapshot_task.hasData) {
                                            int quant = task.getPartMap(
                                                type, page)['hasItem'];
                                            List<DocumentSnapshot>
                                                list_documentSnapshot =
                                                snapshot_task.data.documents;
                                            List<int> countItem =
                                                new List<int>.generate(
                                                    quant, (index) => 0);
                                            int countEnd = 0;
                                            for (DocumentSnapshot documentSnapshot
                                                in list_documentSnapshot) {
                                              if (phase == 'end') {
                                                if (documentSnapshot['end'] !=
                                                        null &&
                                                    (listUid.contains(
                                                            documentSnapshot[
                                                                'uid']) ||
                                                        type == 'challenge' ||
                                                        type == 'gino')) {
                                                  listUid_toShow.add(
                                                      documentSnapshot['uid']);
                                                }
                                              }
                                              if (phase == 'number') {
                                                Map<dynamic, dynamic> signed =
                                                    documentSnapshot['signed'];
                                                Map<dynamic, dynamic>
                                                    signed_part =
                                                    signed[number.toString()];
                                                if (signed_part != null) {
                                                  if (signed_part['phaze'] ==
                                                          'signed' &&
                                                      (listUid.contains(
                                                              documentSnapshot[
                                                                  'uid']) ||
                                                          type == 'challenge' ||
                                                          type == 'gino')) {
                                                    listUid_toShow.add(
                                                        documentSnapshot[
                                                            'uid']);
                                                  }
                                                }
                                              }
                                            }
                                            return Column(children: <Widget>[
                                              ListView.builder(
                                                  physics:
                                                      const NeverScrollableScrollPhysics(),
                                                  itemCount:
                                                      listSnapshot.length,
                                                  shrinkWrap: true,
                                                  itemBuilder:
                                                      (BuildContext context,
                                                          int index) {
                                                    DocumentSnapshot snapshot =
                                                        listSnapshot[index];
                                                    if (listUid_toShow.contains(
                                                        snapshot['uid'])) {
                                                      bool isFirst;
                                                      String team;
                                                      if (snapshot['team']
                                                          is int) {
                                                        team = snapshot['team']
                                                            .toString();
                                                      } else {
                                                        team = snapshot['team'];
                                                      }
                                                      if (team_last != team) {
                                                        isFirst = true;
                                                        team_last = team;
                                                      } else {
                                                        isFirst = false;
                                                      }
                                                      String grade =
                                                          snapshot['grade'];
                                                      String team_call;
                                                      if (grade == 'cub') {
                                                        team_call = '組';
                                                      } else {
                                                        team_call = '班';
                                                      }
                                                      return Column(
                                                          children: <Widget>[
                                                            isFirst &&
                                                                    team != ''
                                                                ? Padding(
                                                                    padding: EdgeInsets.only(
                                                                        top: 10,
                                                                        bottom:
                                                                            10,
                                                                        left:
                                                                            17),
                                                                    child: Container(
                                                                        width: double.infinity,
                                                                        child: Text(
                                                                          team +
                                                                              team_call,
                                                                          style:
                                                                              TextStyle(
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                            fontSize:
                                                                                23,
                                                                          ),
                                                                          textAlign:
                                                                              TextAlign.left,
                                                                        )))
                                                                : Container(),
                                                            Padding(
                                                                padding:
                                                                    EdgeInsets
                                                                        .all(5),
                                                                child:
                                                                    Container(
                                                                  child: Card(
                                                                    shape:
                                                                        RoundedRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              10),
                                                                    ),
                                                                    child:
                                                                        InkWell(
                                                                      customBorder:
                                                                          RoundedRectangleBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(10.0),
                                                                      ),
                                                                      onTap:
                                                                          () async {
                                                                        Navigator.of(context).push<dynamic>(MyPageRoute(
                                                                            page: showTaskConfirmView(
                                                                                page,
                                                                                type,
                                                                                snapshot['uid'],phase=='end'?0:number+1),
                                                                            dismissible: true));
                                                                      },
                                                                      child:
                                                                          Padding(
                                                                        padding:
                                                                            EdgeInsets.all(10),
                                                                        child:
                                                                            Row(
                                                                          children: <
                                                                              Widget>[
                                                                            Container(
                                                                              width: 40,
                                                                              height: 40,
                                                                              decoration: BoxDecoration(color: theme.getUserColor(snapshot['age']), shape: BoxShape.circle),
                                                                              child: Icon(
                                                                                Icons.person,
                                                                                color: Colors.white,
                                                                              ),
                                                                            ),
                                                                            Padding(
                                                                                padding: EdgeInsets.only(left: 10),
                                                                                child: Text(
                                                                                  snapshot['name'],
                                                                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                                                                                )),
                                                                            Spacer(),
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
                                                    } else {
                                                      return Container();
                                                    }
                                                  }),
                                            ]);
                                          } else {
                                            return const Center(
                                              child: Padding(
                                                  padding: EdgeInsets.all(5),
                                                  child:
                                                      CircularProgressIndicator()),
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
                                  }),
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
