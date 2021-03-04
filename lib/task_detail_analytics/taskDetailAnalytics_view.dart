import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cubook/detailActivity/detailActivity_model.dart';
import 'package:cubook/model/arguments.dart';
import 'package:cubook/model/task.dart';
import 'package:cubook/model/themeInfo.dart';
import 'package:cubook/task_detail_analytics/taskDetailAnalytics_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TaskDetailAnalyticsView extends StatelessWidget {
  var theme = new ThemeInfo();
  var task = new TaskContents();

  @override
  Widget build(BuildContext context) {
    TaskDetail info = ModalRoute.of(context).settings.arguments;
    String type = info.type;
    int page = info.page;
    Color themeColor = theme.getThemeColor(type);
    List<Map<String,dynamic>> contents = task.getContentList(type, page);
    var map_task = task.getPartMap(type, page);
    bool isDark;
    if (Theme.of(context).accentColor == Colors.white) {
      isDark = true;
    } else {
      isDark = false;
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(map_task['title']),
        backgroundColor: themeColor,
      ),
      body: SafeArea(
        child: Scrollbar(
        child:SingleChildScrollView(
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 600),
              child: Column(
                children: <Widget>[
                  Padding(
                      padding: EdgeInsets.only(top: 20, bottom: 10),
                      child: Consumer<TaskDetailAnalyticsModel>(
                          builder: (context, model, child) {
                        model.getGroup();
                        if (model.group != null) {
                          return Column(
                            children: <Widget>[
                              StreamBuilder<QuerySnapshot>(
                                  stream: model.getUserSnapshot(),
                                  builder: (BuildContext context,
                                      AsyncSnapshot<QuerySnapshot> snapshot) {
                                    if (snapshot.hasData) {
                                      int userCount = 0;
                                      List<DocumentSnapshot> listSnapshot =
                                          snapshot.data.docs;
                                      List<String> listUid = new List<String>();
                                      if (type == 'challenge' ||
                                          type == 'gino') {
                                        userCount = listSnapshot.length;
                                      } else if (type=='tukinowa') {
                                        for (DocumentSnapshot documentSnapshot
                                        in listSnapshot) {
                                          if (documentSnapshot.data()['age'] == 'kuma') {
                                            userCount++;
                                            listUid.add(documentSnapshot.data()['uid']);
                                          }
                                        }
                                      } else {
                                        for (DocumentSnapshot documentSnapshot
                                            in listSnapshot) {
                                          if (documentSnapshot.data()['age'] == type) {
                                            userCount++;
                                            listUid
                                                .add(documentSnapshot.data()['uid']);
                                          }
                                        }
                                      }
                                      return StreamBuilder<QuerySnapshot>(
                                        stream: FirebaseFirestore.instance
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
                                                snapshot_task.data.docs;
                                            List<int> countItem =
                                                new List<int>.generate(
                                                    quant, (index) => 0);
                                            int countEnd = 0;
                                            for (DocumentSnapshot documentSnapshot
                                                in list_documentSnapshot) {
                                              if (documentSnapshot.data()['end'] !=
                                                      null &&
                                                  (listUid.contains(
                                                          documentSnapshot.data()[
                                                              'uid']) ||
                                                      type == 'challenge' ||
                                                      type == 'gino')) {
                                                countEnd++;
                                              }
                                              Map<dynamic, dynamic> signed =
                                                  documentSnapshot.data()['signed'];
                                              for (int i = 0; i < quant; i++) {
                                                Map<dynamic, dynamic>
                                                    signed_part =
                                                    signed[i.toString()];
                                                if (signed_part != null) {
                                                  if (signed_part['phaze'] ==
                                                          'signed' &&
                                                      (listUid.contains(
                                                              documentSnapshot.data()[
                                                                  'uid']) ||
                                                          type == 'challenge' ||
                                                          type == 'gino')) {
                                                    countItem[i]++;
                                                  }
                                                }
                                              }
                                            }
                                            return Column(children: <Widget>[
                                              Padding(
                                                  padding: EdgeInsets.all(5),
                                                  child: Card(
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                    ),
                                                    child: InkWell(
                                                        onTap: () {
                                                          Navigator.of(context).pushNamed(
                                                              '/taskDetailAnalyticsMember',
                                                              arguments:
                                                                  TaskDetailMember(
                                                                      type:
                                                                          type,
                                                                      page:
                                                                          page,
                                                                      phase:
                                                                          'end'));
                                                        },
                                                        child: Row(
                                                          children: <Widget>[
                                                            Padding(
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        top: 15,
                                                                        bottom:
                                                                            15,
                                                                        left:
                                                                            10,
                                                                        right:
                                                                            10),
                                                                child:
                                                                    CircularProgressIndicator(
                                                                  backgroundColor: isDark
                                                                      ? Colors.grey[
                                                                          700]
                                                                      : Colors.grey[
                                                                          300],
                                                                  valueColor: new AlwaysStoppedAnimation<Color>(isDark
                                                                      ? Colors
                                                                          .white
                                                                      : theme.getThemeColor(
                                                                          type)),
                                                                  value: userCount ==
                                                                          0
                                                                      ? 0
                                                                      : countEnd /
                                                                          userCount,
                                                                )),
                                                            Padding(
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        left:
                                                                            10),
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: <
                                                                      Widget>[
                                                                    Padding(
                                                                        padding: EdgeInsets.only(
                                                                            top:
                                                                                10,
                                                                            bottom:
                                                                                10),
                                                                        child: Align(
                                                                            alignment: Alignment.centerLeft,
                                                                            child: Text(
                                                                              '完修者 ' + countEnd.toString() + '/' + userCount.toString(),
                                                                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 23),
                                                                            ))),
                                                                  ],
                                                                )),
                                                          ],
                                                        )), /*child: Text(countItem[
                                                                        index]
                                                                    .toString() +
                                                                '/' +
                                                                userCount
                                                                    .toString())*/
                                                  )),
                                              Padding(
                                                  padding: EdgeInsets.only(
                                                      top: 5, left: 17),
                                                  child: Container(
                                                      width: double.infinity,
                                                      child: Text(
                                                        '細目ごとのサイン数',
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 16,
                                                        ),
                                                        textAlign:
                                                            TextAlign.left,
                                                      ))),
                                              ListView.builder(
                                                  physics:
                                                      const NeverScrollableScrollPhysics(),
                                                  itemCount: quant,
                                                  shrinkWrap: true,
                                                  itemBuilder:
                                                      (BuildContext context,
                                                          int index) {
                                                    return Padding(
                                                        padding:
                                                            EdgeInsets.all(5),
                                                        child: Card(
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                          ),
                                                          child: InkWell(
                                                              onTap: () {
                                                                Navigator.of(context).pushNamed(
                                                                    '/taskDetailAnalyticsMember',
                                                                    arguments: TaskDetailMember(
                                                                        type:
                                                                            type,
                                                                        page:
                                                                            page,
                                                                        phase:
                                                                            'number',
                                                                        number:
                                                                            index));
                                                              },
                                                              child: Row(
                                                                children: <
                                                                    Widget>[
                                                                  Container(
                                                                      decoration: BoxDecoration(
                                                                          borderRadius: BorderRadius.only(
                                                                              topLeft: const Radius.circular(
                                                                                  10),
                                                                              bottomLeft: const Radius.circular(
                                                                                  10)),
                                                                          color:
                                                                              themeColor),
                                                                      height:
                                                                          65,
                                                                      child:
                                                                          ConstrainedBox(
                                                                        constraints:
                                                                            BoxConstraints(minWidth: 60),
                                                                        child:
                                                                            Center(
                                                                          child:
                                                                              Padding(
                                                                            padding:
                                                                                EdgeInsets.all(0),
                                                                            child:
                                                                                Text(
                                                                              (index + 1).toString(),
                                                                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30, color: Colors.white),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      )),
                                                                  Padding(
                                                                      padding: EdgeInsets.only(
                                                                          left:
                                                                              10),
                                                                      child:
                                                                          Column(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: <
                                                                            Widget>[
                                                                          Padding(
                                                                              padding: EdgeInsets.only(top: 10),
                                                                              child: Align(
                                                                                  alignment: Alignment.centerLeft,
                                                                                  child: Text(
                                                                                    'サイン済み ' + countItem[index].toString() + '/' + userCount.toString(),
                                                                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                                                                                  ))),
                                                                          Padding(
                                                                              padding: EdgeInsets.only(top: 10, bottom: 12, left: 5),
                                                                              child: Container(
                                                                                  width: 200,
                                                                                  child: LinearProgressIndicator(
                                                                                    backgroundColor: isDark ? Colors.grey[700] : Colors.grey[300],
                                                                                    valueColor: new AlwaysStoppedAnimation<Color>(isDark ? Colors.white : theme.getThemeColor(type)),
                                                                                    value: userCount == 0 ? 0 : countItem[index] / userCount,
                                                                                  )))
                                                                        ],
                                                                      )),
                                                                ],
                                                              )), /*child: Text(countItem[
                                                                        index]
                                                                    .toString() +
                                                                '/' +
                                                                userCount
                                                                    .toString())*/
                                                        ));
                                                  })
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
                              Padding(
                                  padding: EdgeInsets.only(top: 5, left: 17),
                                  child: Container(
                                      width: double.infinity,
                                      child: Text(
                                        '細目',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                        textAlign: TextAlign.left,
                                      ))),
                              Padding(
                                  padding: EdgeInsets.only(top: 10),
                                  child: ListView.builder(
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount: contents.length,
                                      shrinkWrap: true,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        String content = contents[index]['body'];
                                        Color bordercolor;
                                        if (Theme.of(context).accentColor ==
                                            Colors.white) {
                                          bordercolor = Colors.grey[700];
                                        } else {
                                          bordercolor = Colors.grey[300];
                                        }
                                        return Padding(
                                            padding: EdgeInsets.only(
                                                bottom: 10, right: 5, left: 5),
                                            child: Card(
                                                  color: Color(0x00000000),
                                                  shape: RoundedRectangleBorder(
                                                    side: BorderSide(
                                                      color: bordercolor,
                                                      width: 2.0,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0),
                                                  ),
                                                  elevation: 0,
                                                  child: InkWell(
                                                    customBorder:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10.0),
                                                    ),
                                                    child: Padding(
                                                        padding:
                                                            EdgeInsets.all(8),
                                                        child: Semantics(
                                                            label: 'さいもく' + (index+1).toString() + '、',
                                                            child: Text(content)),
                                                  )),
                                            ));
                                      })),
                              Padding(
                                  padding: EdgeInsets.only(
                                      left: 15, bottom: 10, right: 15),
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
        )),
      ),
    );
  }
}
