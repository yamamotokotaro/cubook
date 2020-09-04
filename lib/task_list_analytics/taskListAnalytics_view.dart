import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cubook/model/arguments.dart';
import 'package:cubook/model/task.dart';
import 'package:cubook/model/themeInfo.dart';
import 'package:cubook/task_detail_scout_confirm/taskDetailScoutConfirm_model.dart';
import 'package:cubook/task_detail_scout_confirm/taskDetailScoutConfirm_view.dart';
import 'package:cubook/task_list_analytics/taskListAnalytics_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TaskListAnalyticsView extends StatelessWidget {
  var task = new Task();
  var theme = new ThemeInfo();
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
    var map_task = task.getAllMap(type);
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
                      return StreamBuilder<QuerySnapshot>(
                          stream: Firestore.instance
                              .collection('user')
                              .where('group', isEqualTo: model.group)
                              .where('position', isEqualTo: 'scout')
                              .snapshots(),
                          builder: (BuildContext context,
                              AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (snapshot.hasData) {
                              int userCount = 0;
                              List<DocumentSnapshot> listSnapshot =
                                  snapshot.data.documents;
                              List<String> listUid = new List<String>();
                              if (type == 'challenge' || type == 'gino') {
                                userCount = listSnapshot.length;
                              } else {
                                for (DocumentSnapshot documentSnapshot
                                    in listSnapshot) {
                                  if (documentSnapshot['age'] == type) {
                                    userCount++;
                                    listUid.add(documentSnapshot['uid']);
                                  }
                                }
                              }
                              return ListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: map_task.length,
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
                                                    BorderRadius.circular(10.0),
                                              ),
                                              onTap: () {
                                                Navigator.of(context).pushNamed(
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
                                                              topLeft: const Radius
                                                                  .circular(10),
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
                                                                EdgeInsets.all(
                                                                    20),
                                                            child: Text(
                                                              map_task[index]
                                                                  ['number'],
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 30,
                                                                  color: Colors
                                                                      .white),
                                                            ),
                                                          ),
                                                        ),
                                                      )),
                                                  Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 10),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: <Widget>[
                                                          Padding(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      top: 10),
                                                              child: Align(
                                                                  alignment:
                                                                      Alignment
                                                                          .centerLeft,
                                                                  child: Text(
                                                                    map_task[
                                                                            index]
                                                                        [
                                                                        'title'],
                                                                    style: TextStyle(
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        fontSize:
                                                                            25),
                                                                  ))),
                                                          StreamBuilder<
                                                                  QuerySnapshot>(
                                                              stream: Firestore
                                                                  .instance
                                                                  .collection(
                                                                      type)
                                                                  .where(
                                                                      'group',
                                                                      isEqualTo:
                                                                          model
                                                                              .group)
                                                                  .where('page',
                                                                      isEqualTo:
                                                                          index)
                                                                  .orderBy(
                                                                      'end')
                                                                  .snapshots(),
                                                              builder: (BuildContext
                                                                      context,
                                                                  AsyncSnapshot<
                                                                          QuerySnapshot>
                                                                      snapshot) {
                                                                int itemCount =
                                                                    0;
                                                                List<DocumentSnapshot>
                                                                    listSnapshot =
                                                                    snapshot
                                                                        .data
                                                                        .documents;
                                                                for (DocumentSnapshot documentSnapshot
                                                                    in listSnapshot) {
                                                                  if (type ==
                                                                          'challenge' ||
                                                                      type ==
                                                                          'gino') {
                                                                    itemCount++;
                                                                  } else if (listUid
                                                                      .contains(
                                                                          documentSnapshot[
                                                                              'uid'])) {
                                                                    itemCount++;
                                                                  }
                                                                }
                                                                return Padding(
                                                                    padding: EdgeInsets
                                                                        .only(
                                                                            top:
                                                                                15),
                                                                    child: Row(
                                                                      children: [
                                                                        Padding(
                                                                            padding:
                                                                                EdgeInsets.only(left: 5, right: 10),
                                                                            child: Container(
                                                                                height: 30,
                                                                                width: 30,
                                                                                child: CircularProgressIndicator(
                                                                                  backgroundColor: Colors.grey[300],
                                                                                  valueColor: new AlwaysStoppedAnimation<Color>(themeColor),
                                                                                  value: itemCount / userCount,
                                                                                ))),
                                                                        Text(
                                                                            '完修者 ' +
                                                                                itemCount.toString() +
                                                                                '/' +
                                                                                userCount.toString(),
                                                                            style: TextStyle(fontSize: 17)),
                                                                      ],
                                                                    ));
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
                              return const Center(
                                child: Padding(
                                    padding: EdgeInsets.all(5),
                                    child: CircularProgressIndicator()),
                              );
                            }
                          });
                    }))
              ]),
            ),
          ),
        ),
      ),
    );
  }
}

class showTaskConfirmView extends StatelessWidget {
  var task = new Task();
  int currentPage = 0;
  int numberPushed;
  String type;
  String typeFirestore;
  String uid;
  bool test = false;
  List<Widget> pages = <Widget>[
    /*StepSignView(),*/
//    StepAddView()
  ];

  showTaskConfirmView(int number, String _type, String _uid) {
    numberPushed = number;
    type = _type;
    uid = _uid;
    pages.add(
      TaskScoutDetailConfirmView(type, number),
    );
    for (int i = 0; i < task.getPartMap(type, number)['hasItem']; i++) {
      pages.add(TaskScoutAddConfirmView(i, type));
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    double setHeight;
    double setFraction;
    if (height > 700.0) {
      setHeight = height - 200;
    } else {
      setHeight = height - 90;
    }
    if (width > 1000.0) {
      setFraction = 0.6;
    } else {
      setFraction = 0.8;
    }
    PageController controller =
        PageController(initialPage: 0, viewportFraction: setFraction);

    return ChangeNotifierProvider(
        create: (context) => TaskDetailScoutConfirmModel(
            numberPushed,
            task.getPartMap(type, numberPushed)['hasItem'],
            type,
            uid,
            controller),
        child: Container(
            height: setHeight,
            child: PageView(
              onPageChanged: (index) {
                FocusScope.of(context).unfocus();
              },
              controller: controller,
              scrollDirection: Axis.horizontal,
              children: pages,
            )));
  }
}
