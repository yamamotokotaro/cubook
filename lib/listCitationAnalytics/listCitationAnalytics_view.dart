import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cubook/listCitationAnalytics/listCitationAnalytics_model.dart';
import 'package:cubook/model/class.dart';
import 'package:cubook/model/task.dart';
import 'package:cubook/model/themeInfo.dart';
import 'package:cubook/task_detail_scout_confirm/taskDetailScoutConfirm_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ListCitationAnalyticsView extends StatelessWidget {
  var theme = ThemeInfo();
  var task = TaskContents();

  @override
  Widget build(BuildContext context) {
    bool isDark;
    if (Theme.of(context).accentColor == Colors.white) {
      isDark = true;
    } else {
      isDark = false;
    }
    return Scaffold(
        appBar: AppBar(
          title: Text('表彰待ちリスト'),
        ),
        body: Builder(builder: (BuildContext contextBuilder) {
          return SafeArea(
            child: SingleChildScrollView(
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 600),
                  child: Column(
                    children: <Widget>[
                      Padding(
                          padding: EdgeInsets.only(top: 20, bottom: 10),
                          child: Consumer<ListCitationAnalyticsModel>(
                              builder: (context, model, child) {
                            model.getGroup();
                            if (model.group != null) {
                              return Column(
                                children: <Widget>[
                                  StreamBuilder<QuerySnapshot>(
                                      stream: FirebaseFirestore.instance
                                          .collection('user')
                                          .where('group',
                                              isEqualTo: model.group)
                                          .where('position', isEqualTo: 'scout')
                                          .orderBy('team')
                                          .orderBy('age_turn', descending: true)
                                          .orderBy('name')
                                          .snapshots(),
                                      builder: (BuildContext context,
                                          AsyncSnapshot<QuerySnapshot>
                                              snapshot) {
                                        final String teamLast = '';
                                        if (snapshot.hasData) {
                                          final int userCount = 0;
                                          final List<DocumentSnapshot> listSnapshot =
                                              snapshot.data.docs;
                                          return ListView.builder(
                                              physics:
                                                  const NeverScrollableScrollPhysics(),
                                              itemCount: listSnapshot.length,
                                              shrinkWrap: true,
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int index) {
                                                final DocumentSnapshot userSnapshot =
                                                    listSnapshot[index];
                                                return StreamBuilder<
                                                    QuerySnapshot>(
                                                  stream: FirebaseFirestore
                                                      .instance
                                                      .collection('challenge')
                                                      .where('group',
                                                          isEqualTo: model
                                                              .group)
                                                      .where('uid',
                                                          isEqualTo:
                                                              userSnapshot
                                                                      .get(
                                                                  'uid'))
                                                      .where('isCitationed',
                                                          isEqualTo: false)
                                                      .orderBy('page',
                                                          descending: false)
                                                      .orderBy('end')
                                                      .snapshots(),
                                                  builder:
                                                      (BuildContext context,
                                                          AsyncSnapshot<
                                                                  QuerySnapshot>
                                                              snapshot) {
                                                    if (snapshot.hasData) {
                                                      if (snapshot
                                                              .data
                                                              .docs
                                                              .length !=
                                                          0) {
                                                        final QuerySnapshot
                                                            querySnapshot =
                                                            snapshot.data;
                                                        return Column(
                                                            children: [
                                                              Padding(
                                                                  padding: EdgeInsets
                                                                      .only(
                                                                          top:
                                                                              20,
                                                                          bottom:
                                                                              12,
                                                                          left:
                                                                              12),
                                                                  child: Row(
                                                                    children: <
                                                                        Widget>[
                                                                      Container(
                                                                        width:
                                                                            40,
                                                                        height:
                                                                            40,
                                                                        decoration: BoxDecoration(
                                                                            color:
                                                                                theme.getUserColor(userSnapshot.get('age')),
                                                                            shape: BoxShape.circle),
                                                                        child:
                                                                            Icon(
                                                                          Icons
                                                                              .person,
                                                                          color:
                                                                              Colors.white,
                                                                        ),
                                                                      ),
                                                                      Padding(
                                                                          padding: EdgeInsets.only(
                                                                              left:
                                                                                  10),
                                                                          child:
                                                                              Text(
                                                                            userSnapshot.get('name'),
                                                                            style:
                                                                                TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                                                                          )),
                                                                      Spacer(),
                                                                    ],
                                                                  )),
                                                              ListView.builder(
                                                                  physics:
                                                                      const NeverScrollableScrollPhysics(),
                                                                  itemCount:
                                                                      querySnapshot
                                                                          .docs
                                                                          .length,
                                                                  shrinkWrap:
                                                                      true,
                                                                  itemBuilder:
                                                                      (BuildContext
                                                                              context,
                                                                          int index) {
                                                                    final DocumentSnapshot
                                                                        snapshot =
                                                                        querySnapshot
                                                                            .docs[index];
                                                                    final Map taskInfo = task.getPartMap(
                                                                        'challenge',
                                                                        snapshot
                                                                            .get('page'));
                                                                    return Padding(
                                                                      padding:
                                                                          EdgeInsets.all(
                                                                              5),
                                                                      child:
                                                                          Container(
                                                                        child:
                                                                            Card(
                                                                          shape:
                                                                              RoundedRectangleBorder(
                                                                            borderRadius:
                                                                                BorderRadius.circular(10),
                                                                          ),
                                                                          child:
                                                                              InkWell(
                                                                            onTap:
                                                                                () async {
                                                                              print(snapshot.get('page'));
                                                                              Navigator.of(context).push<dynamic>(MyPageRoute(page: showTaskConfirmView(snapshot.get('page'), 'challenge', snapshot.get('uid'), 0), dismissible: true));
                                                                            },
                                                                            child:
                                                                                Padding(
                                                                              padding: EdgeInsets.all(0),
                                                                              child: Column(
                                                                                children: <Widget>[
                                                                                  Row(
                                                                                    children: <Widget>[
                                                                                      Container(
                                                                                          decoration: BoxDecoration(borderRadius: BorderRadius.only(topLeft: const Radius.circular(10), bottomLeft: const Radius.circular(10)), color: Colors.green[900]),
                                                                                          height: 65,
                                                                                          child: ConstrainedBox(
                                                                                            constraints: BoxConstraints(minWidth: 60),
                                                                                            child: Center(
                                                                                              child: Padding(
                                                                                                padding: EdgeInsets.all(0),
                                                                                                child: Text(
                                                                                                  taskInfo['number'],
                                                                                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25, color: Colors.white),
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          )),
                                                                                      Padding(
                                                                                          padding: EdgeInsets.only(left: 10),
                                                                                          child: Text(
                                                                                            taskInfo['title'],
                                                                                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                                                                                          )),
                                                                                      Spacer(),
                                                                                      Semantics(
                                                                                          label: '表彰済みにする',
                                                                                          child: IconButton(
                                                                                            onPressed: () {
                                                                                              model.onTapCititation(snapshot.id, contextBuilder, userSnapshot.get('name') + userSnapshot.get('call'), taskInfo['title'], isDark);
                                                                                            },
                                                                                            icon: Icon(
                                                                                              Icons.check,
                                                                                              color: isDark ? Colors.white : Colors.green[900],
                                                                                              size: 30,
                                                                                            ),
                                                                                          ))
                                                                                    ],
                                                                                  )
                                                                                ],
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    );
                                                                  })
                                                            ]);
                                                      } else {
                                                        return Container();
                                                      }
                                                    } else {
                                                      return const Center(
                                                        child: Padding(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    5),
                                                            child:
                                                                CircularProgressIndicator()),
                                                      );
                                                    }
                                                  },
                                                );
                                              });
                                        } else {
                                          return const Center(
                                            child: Padding(
                                                padding: EdgeInsets.all(5),
                                                child:
                                                    CircularProgressIndicator()),
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
          );
        }));
  }
}
