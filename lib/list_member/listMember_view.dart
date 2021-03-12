import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cubook/model/themeInfo.dart';
import 'package:cubook/userDetail/userDetail_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'listMember_model.dart';

class ListMemberView extends StatelessWidget {
  var theme = new ThemeInfo();
  var isRelease = const bool.fromEnvironment('dart.vm.product');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('メンバーリスト'),
      ),
      floatingActionButton: Selector<ListMemberModel, String>(
          selector: (context, model) => model.position,
          builder: (context, position, child) => position == 'leader'
              ? FloatingActionButton.extended(
                  onPressed: () {
                    Navigator.of(context).pushNamed('/invite');
                  },
                  label: Text('招待'),
                  icon: Icon(Icons.person_add),
                )
              : Container()),
      body: SafeArea(
        child: Scrollbar(
          child: SingleChildScrollView(
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 600),
                child: Column(
                  children: <Widget>[
                    Padding(
                        padding: EdgeInsets.only(top: 20, bottom: 10),
                        child: Consumer<ListMemberModel>(
                            builder: (context, model, child) {
                          model.getGroup();
                          if (model.group != null) {
                            print(model.team);
                            return Column(
                              children: <Widget>[
                                Padding(
                                    padding: EdgeInsets.all(17),
                                    child: Container(
                                        width: double.infinity,
                                        child: Text(
                                          'スカウト',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 28,
                                          ),
                                          textAlign: TextAlign.left,
                                        ))),
                                StreamBuilder<QuerySnapshot>(
                                  stream: model.getUserSnapshot(),
                                  builder: (BuildContext context,
                                      AsyncSnapshot<QuerySnapshot> snapshot) {
                                    if (snapshot.hasData) {
                                      if (snapshot.data.docs.length != 0) {
                                        QuerySnapshot querySnapshot =
                                            snapshot.data;
                                        String team_last = '';
                                        return ListView.builder(
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            itemCount:
                                                querySnapshot.docs.length,
                                            shrinkWrap: true,
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              DocumentSnapshot snapshot =
                                                  querySnapshot.docs[index];
                                              bool isFirst;
                                              String team;
                                              if (snapshot.data()['team']
                                                  is int) {
                                                team = snapshot
                                                    .data()['team']
                                                    .toString();
                                              } else {
                                                team = snapshot.data()['team'];
                                              }
                                              if (team_last != team) {
                                                isFirst = true;
                                                team_last = team;
                                              } else {
                                                isFirst = false;
                                              }
                                              String grade =
                                                  snapshot.data()['grade'];
                                              String team_call;
                                              if (grade == 'cub') {
                                                team_call = '組';
                                              } else {
                                                team_call = '班';
                                              }
                                              return Column(children: <Widget>[
                                                isFirst && team != ''
                                                    ? Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                top: 10,
                                                                bottom: 10,
                                                                left: 17),
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
                                                          customBorder:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10.0),
                                                          ),
                                                          onTap: () {
                                                            Navigator.push(
                                                                context,
                                                                MaterialPageRoute<
                                                                        SelectBookView>(
                                                                    builder:
                                                                        (BuildContext
                                                                            context) {
                                                              return SelectBookView(
                                                                  snapshot.data()[
                                                                      'uid']);
                                                            }));
                                                          },
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
                                                                          snapshot.data()[
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
                                                                      snapshot.data()[
                                                                          'name'],
                                                                      style: TextStyle(
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          fontSize:
                                                                              25),
                                                                    )),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ))
                                              ]);
                                            });
                                      } else {
                                        return Container();
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
                                StreamBuilder<QuerySnapshot>(
                                  stream: model.getUserSnapshot_less_team(),
                                  builder: (BuildContext context,
                                      AsyncSnapshot<QuerySnapshot> snapshot) {
                                    if (snapshot.hasData) {
                                      if (snapshot.data.docs.length != 0) {
                                        QuerySnapshot querySnapshot =
                                            snapshot.data;
                                        return ListView.builder(
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            itemCount:
                                                querySnapshot.docs.length,
                                            shrinkWrap: true,
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              DocumentSnapshot snapshot =
                                                  querySnapshot.docs[index];
                                              if (snapshot.data()['team'] ==
                                                  null) {
                                                return Padding(
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
                                                          onTap: () {
                                                            Navigator.push(
                                                                context,
                                                                MaterialPageRoute<
                                                                        SelectBookView>(
                                                                    builder:
                                                                        (BuildContext
                                                                            context) {
                                                              return SelectBookView(
                                                                  snapshot.data()[
                                                                      'uid']);
                                                            }));
                                                          },
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
                                                                      color: theme.getThemeColor(
                                                                          snapshot.data()[
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
                                                                      snapshot.data()[
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
                                                                      '組未設定',
                                                                      style: TextStyle(
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          fontSize:
                                                                              15),
                                                                    ))
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ));
                                              } else {
                                                return Container();
                                              }
                                            });
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
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 10),
                                                        child: Material(
                                                          type: MaterialType
                                                              .transparency,
                                                          child: Text(
                                                            'スカウトを招待しよう',
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
                                model.position == 'leader'
                                    ? Padding(
                                        padding: EdgeInsets.all(17),
                                        child: Container(
                                            width: double.infinity,
                                            child: Text(
                                              'リーダー',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 28,
                                              ),
                                              textAlign: TextAlign.left,
                                            )))
                                    : Container(),
                                model.position == 'leader'
                                    ? Padding(
                                        padding: EdgeInsets.only(bottom: 55),
                                        child: StreamBuilder<QuerySnapshot>(
                                          stream: FirebaseFirestore.instance
                                              .collection('user')
                                              .where('group',
                                                  isEqualTo: model.group)
                                              .where('position',
                                                  isEqualTo: 'leader')
                                              .orderBy('admin', descending: true)
                                              .orderBy('name')
                                              .snapshots(),
                                          builder: (BuildContext context,
                                              AsyncSnapshot<QuerySnapshot>
                                                  snapshot) {
                                            if (snapshot.hasData) {
                                              if (snapshot.data.docs.length !=
                                                  0) {
                                                QuerySnapshot querySnapshot =
                                                    snapshot.data;
                                                return ListView.builder(
                                                    physics:
                                                        const NeverScrollableScrollPhysics(),
                                                    itemCount: querySnapshot
                                                        .docs.length,
                                                    shrinkWrap: true,
                                                    itemBuilder:
                                                        (BuildContext context,
                                                            int index) {
                                                      DocumentSnapshot
                                                          snapshot =
                                                          querySnapshot
                                                              .docs[index];
                                                      return Padding(
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
                                                                onTap: () {},
                                                                customBorder:
                                                                    RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              10.0),
                                                                ),
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
                                                                                theme.getThemeColor('challenge'),
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
                                                                            snapshot.data()['name'],
                                                                            style:
                                                                                TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                                                                          )),
                                                                      Spacer(),
                                                                      snapshot.data()[
                                                                              'admin']
                                                                          ? Padding(
                                                                              padding: EdgeInsets.only(left: 10),
                                                                              child: Text(
                                                                                '管理者',
                                                                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                                                                              ))
                                                                          : Container()
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ));
                                                    });
                                              } else {
                                                return Padding(
                                                  padding: EdgeInsets.only(
                                                      top: 5,
                                                      left: 10,
                                                      right: 10),
                                                  child: Container(
                                                      child: InkWell(
                                                    onTap: () {},
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsets.all(10),
                                                      child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: <Widget>[
                                                            Icon(
                                                              Icons
                                                                  .bubble_chart,
                                                              color: Theme.of(
                                                                      context)
                                                                  .accentColor,
                                                              size: 35,
                                                            ),
                                                            Padding(
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        left:
                                                                            10),
                                                                child: Material(
                                                                  type: MaterialType
                                                                      .transparency,
                                                                  child: Text(
                                                                    'スカウトを招待しよう',
                                                                    style:
                                                                        TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .normal,
                                                                      fontSize:
                                                                          20,
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
                                                    child:
                                                        CircularProgressIndicator()),
                                              );
                                            }
                                          },
                                        ),
                                      )
                                    : Container(),
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
      ),
    );
  }
}
