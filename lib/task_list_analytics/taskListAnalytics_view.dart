import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cubook/model/arguments.dart';
import 'package:cubook/model/task.dart';
import 'package:cubook/model/themeInfo.dart';
import 'package:cubook/task_list_analytics/taskListAnalytics_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TaskListAnalyticsView extends StatelessWidget {
  var task = TaskContents();
  var theme = ThemeInfo();
  Color themeColor;
  String type;
  String typeFireStore;
  String title = '';

  TaskListAnalyticsView(String _type) {
    themeColor = theme.getThemeColor(_type);
    title = theme.getTitle(_type);
    if (_type == 'usagi') {
      typeFireStore = 'step';
    } else if (_type == 'challenge') {
      typeFireStore = 'challenge';
    }
    type = _type;
  }

  @override
  Widget build(BuildContext context) {
    final mapTask = task.getAllMap(type);
    bool isDark;
    if (Theme.of(context).accentColor == Colors.white) {
      isDark = true;
    } else {
      isDark = false;
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: themeColor,
        elevation: 5,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          title,
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 600),
              child: Column(children: <Widget>[
                Padding(
                    padding: EdgeInsets.only(top: 20, bottom: 10),
                    child: Consumer<TaskListAnalyticsModel>(
                        builder: (context, model, child) {
                      model.getGroup();
                      if (model.group != null) {
                        return StreamBuilder<QuerySnapshot>(
                            stream: model.getUserSnapshot(),
                            builder: (BuildContext context,
                                AsyncSnapshot<QuerySnapshot> snapshot) {
                              if (snapshot.hasData) {
                                int userCount = 0;
                                final List<DocumentSnapshot> listSnapshot =
                                    snapshot.data.docs;
                                final List<String> listUid = <String>[];
                                if (type == 'challenge' || type == 'gino' || type == 'syorei') {
                                  userCount = listSnapshot.length;
                                } else if (type=='tukinowa') {
                                  for (DocumentSnapshot documentSnapshot
                                  in listSnapshot) {
                                    if (documentSnapshot.get('age') == 'kuma') {
                                      userCount++;
                                      listUid.add(documentSnapshot.get('uid'));
                                    }
                                  }
                                } else {
                                  for (DocumentSnapshot documentSnapshot
                                      in listSnapshot) {
                                    if (documentSnapshot.get('age') == type) {
                                      userCount++;
                                      listUid.add(documentSnapshot.get('uid'));
                                    }
                                  }
                                }
                                return ListView.builder(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: mapTask.length,
                                    shrinkWrap: true,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return Padding(
                                          padding: EdgeInsets.all(5),
                                          child: Container(
                                            child: Card(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child: InkWell(
                                                customBorder:
                                                    RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                ),
                                                onTap: () {
                                                  Navigator.of(context)
                                                      .pushNamed(
                                                          '/taskDetailAnalytics',
                                                          arguments: TaskDetail(
                                                              type: type,
                                                              page: index));
                                                  /*Navigator.of(context).push<dynamic>(
                                                    MyPageRoute(
                                                        page: showTaskConfirmView(index,
                                                            type, uid),
                                                        dismissible: true));*/
                                                },
                                                child: Row(
                                                  children: <Widget>[
                                                    Container(
                                                        decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.only(
                                                                topLeft:
                                                                    const Radius
                                                                            .circular(
                                                                        10),
                                                                bottomLeft:
                                                                    const Radius
                                                                            .circular(
                                                                        10)),
                                                            color: themeColor),
                                                        height: 120,
                                                        child: ConstrainedBox(
                                                          constraints:
                                                              BoxConstraints(
                                                                  minWidth: 76),
                                                          child: Center(
                                                            child: Padding(
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(20),
                                                              child: Text(
                                                                mapTask[index]
                                                                    ['number'],
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        30,
                                                                    color: Colors
                                                                        .white),
                                                              ),
                                                            ),
                                                          ),
                                                        )),
                                                    Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 10),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: <Widget>[
                                                            Padding(
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        top:
                                                                            10),
                                                                child: Align(
                                                                    alignment:
                                                                        Alignment
                                                                            .centerLeft,
                                                                    child: Text(
                                                                      mapTask[
                                                                              index]
                                                                          [
                                                                          'title'],
                                                                      style: TextStyle(
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          fontSize:
                                                                              25),
                                                                    ))),
                                                            StreamBuilder<
                                                                    QuerySnapshot>(
                                                                stream: FirebaseFirestore
                                                                    .instance
                                                                    .collection(
                                                                        type)
                                                                    .where(
                                                                        'group',
                                                                        isEqualTo:
                                                                            model
                                                                                .group)
                                                                    .where(
                                                                        'page',
                                                                        isEqualTo:
                                                                            index)
                                                                    .orderBy(
                                                                        'end')
                                                                    .snapshots(),
                                                                builder: (BuildContext
                                                                        context,
                                                                    AsyncSnapshot<
                                                                            QuerySnapshot>
                                                                        snapshotTask) {
                                                                  if (snapshotTask
                                                                      .hasData) {
                                                                    int itemCount =
                                                                        0;
                                                                    final List<DocumentSnapshot>
                                                                        listSnapshot =
                                                                        snapshotTask
                                                                            .data
                                                                            .docs;
                                                                    for (DocumentSnapshot documentSnapshot
                                                                        in listSnapshot) {
                                                                      if (type ==
                                                                              'challenge' ||
                                                                          type ==
                                                                              'gino' ||
                                                                          type ==
                                                                              'syorei') {
                                                                        itemCount++;
                                                                      } else if (listUid
                                                                          .contains(
                                                                              documentSnapshot.get('uid'))) {
                                                                        itemCount++;
                                                                      }
                                                                    }
                                                                    return Padding(
                                                                        padding: EdgeInsets.only(
                                                                            top:
                                                                                15),
                                                                        child:
                                                                            Row(
                                                                          children: [
                                                                            Padding(
                                                                                padding: EdgeInsets.only(left: 5, right: 10),
                                                                                child: Container(
                                                                                    height: 30,
                                                                                    width: 30,
                                                                                    child: CircularProgressIndicator(
                                                                                      backgroundColor: isDark ? Colors.grey[700] : Colors.grey[300],
                                                                                      valueColor: AlwaysStoppedAnimation<Color>(isDark ? Colors.white : theme.getThemeColor(type)),
                                                                                      value: userCount == 0 ? 0 : itemCount / userCount,
                                                                                    ))),
                                                                            Text('完修者 ' + itemCount.toString() + '/' + userCount.toString(),
                                                                                style: TextStyle(fontSize: 17)),
                                                                          ],
                                                                        ));
                                                                  } else {
                                                                    return Padding(
                                                                      padding: EdgeInsets.only(left: 5, right: 10),
                                                                      child: Container(
                                                                          height: 30,
                                                                          width: 30,
                                                                          child: CircularProgressIndicator(
                                                                            backgroundColor: isDark ? Colors.grey[700] : Colors.grey[300],
                                                                            valueColor: AlwaysStoppedAnimation<Color>(isDark ? Colors.white : theme.getThemeColor(type)),)),
                                                                    );
                                                                  }
                                                                })
                                                          ],
                                                        )),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ));
                                    });
                              } else {
                                return Padding(
                                  padding: EdgeInsets.only(left: 5, right: 10),
                                  child: Container(
                                      height: 30,
                                      width: 30,
                                      child: CircularProgressIndicator(
                                        backgroundColor: isDark ? Colors.grey[700] : Colors.grey[300],
                                        valueColor: new AlwaysStoppedAnimation<Color>(isDark ? Colors.white : theme.getThemeColor(type)),)),
                                );
                              }
                            });
                      } else {
                        return Padding(
                          padding: EdgeInsets.only(left: 5, right: 10),
                          child: Container(
                              height: 30,
                              width: 30,
                              child: CircularProgressIndicator(
                                backgroundColor: isDark ? Colors.grey[700] : Colors.grey[300],
                                valueColor: new AlwaysStoppedAnimation<Color>(isDark ? Colors.white : theme.getThemeColor(type)),)),
                        );
                      }
                    }))
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
