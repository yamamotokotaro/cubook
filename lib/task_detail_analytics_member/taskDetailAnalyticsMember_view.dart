import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cubook/model/arguments.dart';
import 'package:cubook/model/class.dart';
import 'package:cubook/model/task.dart';
import 'package:cubook/model/themeInfo.dart';
import 'package:cubook/task_detail_analytics_member/taskDetailAnalyticsMember_model.dart';
import 'package:cubook/task_detail_scout_confirm/taskDetailScoutConfirm_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class _StickyTabBarDelegate extends SliverPersistentHeaderDelegate {
  const _StickyTabBarDelegate(this.tabBar);

  final TabBar tabBar;

  @override
  double get minExtent => tabBar.preferredSize.height;

  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(color: Theme.of(context).canvasColor, child: tabBar);
  }

  @override
  bool shouldRebuild(_StickyTabBarDelegate oldDelegate) {
    return tabBar != oldDelegate.tabBar;
  }
}

class TaskDetailAnalyticsMemberView extends StatelessWidget {
  var theme = ThemeInfo();
  var task = TaskContents();

  @override
  Widget build(BuildContext context) {
    final TaskDetailMember info = ModalRoute.of(context).settings.arguments;
    final String type = info.type;
    final int page = info.page;
    final String phase = info.phase;
    final int number = info.number;
    final Color themeColor = theme.getThemeColor(type);
    List<String> tabs;
    if (phase == 'end') {
      tabs = ['完修済み', '未完修'];
    } else {
      tabs = ['サイン済み', '未サイン'];
    }
    bool isDark;
    if (Theme.of(context).accentColor == Colors.white) {
      isDark = true;
    } else {
      isDark = false;
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(phase == 'end'
            ? task.getPartMap(type, page)['title']
            : task.getPartMap(type, page)['title'] +
                ' (' +
                (number + 1).toString() +
                ')'),
        backgroundColor: themeColor,
      ),
      body: SafeArea(
        child: /*SingleChildScrollView(
          child: */
            Center(
          child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 600),
              child: Consumer<TaskDetailAnalyticsMemberModel>(
                  builder: (context, model, child) {
                model.getGroup();
                if (model.group != null) {
                  return StreamBuilder<QuerySnapshot>(
                      stream: model.getUserSnapshot(type),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        String teamLast = '';
                        if (snapshot.hasData) {
                          int userCount = 0;
                          final List<DocumentSnapshot> listSnapshot =
                              snapshot.data.docs;
                          final List<String> listUid = List<String>();
                          final List<String> listUidToShow = <String>[];
                          if (type == 'challenge' || type == 'gino') {
                            userCount = listSnapshot.length;
                          } else if (type == 'tukinowa') {
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
                          return StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection(type)
                                .where('group', isEqualTo: model.group)
                                .where('page', isEqualTo: page)
                                .snapshots(),
                            builder: (BuildContext context,
                                AsyncSnapshot<QuerySnapshot> snapshotTask) {
                              if (snapshotTask.hasData) {
                                final List<DocumentSnapshot> listDocumentSnapshot =
                                    snapshotTask.data.docs;
                                for (DocumentSnapshot documentSnapshot
                                    in listDocumentSnapshot) {
                                  if (phase == 'end') {
                                    if (documentSnapshot.get('end') !=
                                            null &&
                                        (listUid.contains(documentSnapshot
                                                .get('uid')) ||
                                            type == 'challenge' ||
                                            type == 'gino' ||
                                            type == 'tukinowa')) {
                                      listUidToShow
                                          .add(documentSnapshot.get('uid'));
                                    } else if (type == 'tukinowa') {
                                      if (documentSnapshot.get('age') ==
                                          'kuma') {
                                        userCount++;
                                        listUidToShow.add(
                                            documentSnapshot.get('uid'));
                                      }
                                    }
                                  }
                                  if (phase == 'number') {
                                    final Map<dynamic, dynamic> signed =
                                        documentSnapshot.get('signed');
                                    final Map<dynamic, dynamic> signedPart =
                                        signed[number.toString()];
                                    if (signedPart != null) {
                                      if (signedPart['phaze'] == 'signed' &&
                                          (listUid.contains(documentSnapshot
                                                  .get('uid')) ||
                                              type == 'challenge' ||
                                              type == 'gino')) {
                                        listUidToShow.add(
                                            documentSnapshot.get('uid'));
                                      }
                                    }
                                  }
                                }
                                return DefaultTabController(
                                    length: 2,
                                    child: NestedScrollView(
                                      headerSliverBuilder:
                                          (BuildContext context,
                                              bool innerBoxIsScrolled) {
                                        return <Widget>[
                                          Container(
                                              child: SliverPersistentHeader(
                                            pinned: true,
                                            delegate: _StickyTabBarDelegate(
                                              TabBar(
                                                indicatorColor:
                                                    Theme.of(context)
                                                        .accentColor,
                                                labelColor: Theme.of(context)
                                                    .accentColor,
                                                isScrollable: false,
                                                tabs: <Widget>[
                                                  Tab(text: tabs[0]),
                                                  Tab(text: tabs[1])
                                                ],
                                              ),
                                            ),
                                          )),
                                        ];
                                      },
                                      body: TabBarView(children: <Widget>[
                                        ListView.builder(
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            itemCount: listSnapshot.length,
                                            shrinkWrap: true,
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              final DocumentSnapshot snapshot =
                                                  listSnapshot[index];
                                              if (listUidToShow.contains(
                                                  snapshot.get('uid'))) {
                                                bool isFirst;
                                                String team;
                                                if (snapshot.get('team')
                                                    is int) {
                                                  team = snapshot
                                                      .get('team')
                                                      .toString();
                                                } else {
                                                  team =
                                                      snapshot.get('team');
                                                }
                                                if (teamLast != team) {
                                                  isFirst = true;
                                                  teamLast = team;
                                                } else {
                                                  isFirst = false;
                                                }
                                                final String grade =
                                                    snapshot.get('grade');
                                                String teamCall;
                                                if (grade == 'cub') {
                                                  teamCall = '組';
                                                } else {
                                                  teamCall = '班';
                                                }
                                                return Column(
                                                    children: <Widget>[
                                                      isFirst && team != ''
                                                          ? Padding(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      top: 10,
                                                                      bottom:
                                                                          10,
                                                                      left: 17),
                                                              child: Container(
                                                                  width: double
                                                                      .infinity,
                                                                  child: Text(
                                                                    team +
                                                                        teamCall,
                                                                    style:
                                                                        TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          23,
                                                                    ),
                                                                    textAlign:
                                                                        TextAlign
                                                                            .left,
                                                                  )))
                                                          : Container(),
                                                      Padding(
                                                          padding:
                                                              EdgeInsets.all(5),
                                                          child: Container(
                                                            child: Card(
                                                              shape:
                                                                  RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10),
                                                              ),
                                                              child: InkWell(
                                                                customBorder:
                                                                    RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              10.0),
                                                                ),
                                                                onTap:
                                                                    () async {
                                                                  Navigator.of(context).push<dynamic>(MyPageRoute(
                                                                      page: showTaskConfirmView(
                                                                          page,
                                                                          type,
                                                                          snapshot.get(
                                                                              'uid'),
                                                                          phase == 'end'
                                                                              ? 0
                                                                              : number +
                                                                                  1),
                                                                      dismissible:
                                                                          true));
                                                                },
                                                                child: Padding(
                                                                  padding:
                                                                      EdgeInsets
                                                                          .all(
                                                                              10),
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
                                                                                theme.getUserColor(snapshot.get('age')),
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
                                                                            snapshot.get('name'),
                                                                            style:
                                                                                TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                                                                          )),
                                                                      Spacer(),
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
                                        ListView.builder(
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            itemCount: listSnapshot.length,
                                            shrinkWrap: true,
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              final DocumentSnapshot snapshot =
                                                  listSnapshot[index];
                                              if (!listUidToShow.contains(
                                                  snapshot.get('uid'))) {
                                                bool isFirst;
                                                String team;
                                                if (snapshot.get('team')
                                                    is int) {
                                                  team = snapshot
                                                      .get('team')
                                                      .toString();
                                                } else {
                                                  team =
                                                      snapshot.get('team');
                                                }
                                                if (teamLast != team) {
                                                  isFirst = true;
                                                  teamLast = team;
                                                } else {
                                                  isFirst = false;
                                                }
                                                final String grade =
                                                    snapshot.get('grade');
                                                String teamCall;
                                                if (grade == 'cub') {
                                                  teamCall = '組';
                                                } else {
                                                  teamCall = '班';
                                                }
                                                return Column(
                                                    children: <Widget>[
                                                      isFirst && team != ''
                                                          ? Padding(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      top: 10,
                                                                      bottom:
                                                                          10,
                                                                      left: 17),
                                                              child: Container(
                                                                  width: double
                                                                      .infinity,
                                                                  child: Text(
                                                                    team +
                                                                        teamCall,
                                                                    style:
                                                                        TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          23,
                                                                    ),
                                                                    textAlign:
                                                                        TextAlign
                                                                            .left,
                                                                  )))
                                                          : Container(),
                                                      Padding(
                                                          padding:
                                                              EdgeInsets.all(5),
                                                          child: Container(
                                                            child: Card(
                                                              shape:
                                                                  RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10),
                                                              ),
                                                              child: InkWell(
                                                                customBorder:
                                                                    RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              10.0),
                                                                ),
                                                                onTap:
                                                                    () async {
                                                                  Navigator.of(context).push<dynamic>(MyPageRoute(
                                                                      page: showTaskConfirmView(
                                                                          page,
                                                                          type,
                                                                          snapshot.get(
                                                                              'uid'),
                                                                          phase == 'end'
                                                                              ? 0
                                                                              : number +
                                                                                  1),
                                                                      dismissible:
                                                                          true));
                                                                },
                                                                child: Padding(
                                                                  padding:
                                                                      EdgeInsets
                                                                          .all(
                                                                              10),
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
                                                                                theme.getUserColor(snapshot.get('age')),
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
                                                                            snapshot.get('name'),
                                                                            style:
                                                                                TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                                                                          )),
                                                                      Spacer(),
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
                                      ]),
                                    ));
                                /*return Column(children: <Widget>[
                                        ]);*/
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
                      });
                } else {
                  return const Center(
                    child: Padding(
                        padding: EdgeInsets.all(5),
                        child: CircularProgressIndicator()),
                  );
                }
              }) /*Column(
                children: <Widget>[
                  Padding(
                      padding: EdgeInsets.only(top: 20, bottom: 10),
                      child: )
                ],
              ),*/
              ),
        ),
      ),
      //),
    );
  }
}
