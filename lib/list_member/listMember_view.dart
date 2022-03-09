
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cubook/model/themeInfo.dart';
import 'package:cubook/userDetail/userDetail_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'listMember_model.dart';

class ListMemberView extends StatelessWidget {
  ThemeInfo theme = ThemeInfo();
  bool isRelease = const bool.fromEnvironment('dart.vm.product');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('メンバーリスト'), systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      floatingActionButton: Selector<ListMemberModel, String?>(
          selector: (BuildContext context, ListMemberModel model) => model.position,
          builder: (BuildContext context, String? position, Widget? child) => position == 'leader'
              ? FloatingActionButton.extended(
            onPressed: () {
              Navigator.of(context).pushNamed('/invite');
            },
            label: const Text('招待'),
            icon: const Icon(Icons.person_add),
          )
              : Container()),
      body: SafeArea(
        child: Scrollbar(
          child: SingleChildScrollView(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 600),
                child: Column(
                  children: <Widget>[
                    Padding(
                        padding: const EdgeInsets.only(top: 20, bottom: 10),
                        child: Consumer<ListMemberModel>(
                            builder: (BuildContext context, ListMemberModel model, Widget? child) {
                          model.getGroup();
                          if (model.group != null) {
                            print(model.team);
                            return Column(
                              children: <Widget>[
                                if (model.position == 'leader') StreamBuilder<QuerySnapshot>(
                                    stream: FirebaseFirestore.instance
                                        .collection('migration')
                                        .where('group', isEqualTo: model.group)
                                        .where('phase', isEqualTo: 'wait')
                                        .snapshots(),
                                    builder: (BuildContext context,
                                        AsyncSnapshot<QuerySnapshot> snapshot) {
                                      if (snapshot.hasData) {
                                        if (snapshot.data!.docs.isNotEmpty) {
                                          return Padding(
                                            padding: const EdgeInsets.all(10),
                                            child: Container(
                                                child: Card(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              elevation: 8,
                                              color: Colors.blue[900],
                                              child: InkWell(
                                                customBorder:
                                                    RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                ),
                                                onTap: () {
                                                  Navigator.of(context).pushNamed(
                                                      '/listMigrationWaiting');
                                                },
                                                child: Padding(
                                                  padding: const EdgeInsets.all(15),
                                                  child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: <Widget>[
                                                        const Icon(
                                                          Icons
                                                              .emoji_people_rounded,
                                                          color: Colors.white,
                                                          size: 35,
                                                        ),
                                                        Padding(
                                                            padding:
                                                                const EdgeInsets.only(
                                                                    left: 10),
                                                            child: Material(
                                                                type: MaterialType
                                                                    .transparency,
                                                                child: Text(
                                                                  '移行申請' +
                                                                      snapshot
                                                                          .data!
                                                                          .docs
                                                                          .length
                                                                          .toString() +
                                                                      '件',
                                                                  style: const TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .normal,
                                                                      fontSize:
                                                                          30,
                                                                      color: Colors
                                                                          .white),
                                                                ))),
                                                      ]),
                                                ),
                                              ),
                                            )),
                                          );
                                        } else {
                                          return Container();
                                        }
                                      } else {
                                        return const Center(
                                          child: Padding(
                                              padding: EdgeInsets.all(5),
                                              child:
                                                  CircularProgressIndicator()),
                                        );
                                      }
                                    }) else Container(),
                                Padding(
                                    padding: const EdgeInsets.all(17),
                                    child: Container(
                                        width: double.infinity,
                                        child: const Text(
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
                                      if (snapshot.data!.docs.isNotEmpty) {
                                        final QuerySnapshot querySnapshot =
                                            snapshot.data!;
                                        String? teamLast = '';
                                        return ListView.builder(
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            itemCount:
                                                querySnapshot.docs.length,
                                            shrinkWrap: true,
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              final DocumentSnapshot snapshot =
                                                  querySnapshot.docs[index];
                                              bool isFirst;
                                              String? team;
                                              if (snapshot.get('team') is int) {
                                                team = snapshot
                                                    .get('team')
                                                    .toString();
                                              } else {
                                                team = snapshot.get('team');
                                              }
                                              if (teamLast != team) {
                                                isFirst = true;
                                                teamLast = team;
                                              } else {
                                                isFirst = false;
                                              }
                                              final String? grade =
                                                  snapshot.get('grade');
                                              String teamCall;
                                              if (grade == 'cub') {
                                                teamCall = '組';
                                              } else {
                                                teamCall = '班';
                                              }
                                              return Column(children: <Widget>[
                                                if (isFirst && team != '')
                                                  Padding(
                                                      padding: const EdgeInsets.only(
                                                          top: 10,
                                                          bottom: 10,
                                                          left: 17),
                                                      child: Container(
                                                          width:
                                                              double.infinity,
                                                          child: Text(
                                                            team! + teamCall,
                                                            style: const TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 23,
                                                            ),
                                                            textAlign:
                                                                TextAlign.left,
                                                          )))
                                                else
                                                  Container(),
                                                Padding(
                                                    padding: const EdgeInsets.all(5),
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
                                                                  snapshot.get(
                                                                      'uid'),
                                                                  'scout');
                                                            }));
                                                          },
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets.all(
                                                                    10),
                                                            child: Row(
                                                              children: <
                                                                  Widget>[
                                                                Container(
                                                                  width: 40,
                                                                  height: 40,
                                                                  decoration: BoxDecoration(
                                                                      color: theme.getUserColor(
                                                                          snapshot.get(
                                                                              'age')),
                                                                      shape: BoxShape
                                                                          .circle),
                                                                  child: const Icon(
                                                                    Icons
                                                                        .person,
                                                                    color: Colors
                                                                        .white,
                                                                  ),
                                                                ),
                                                                Padding(
                                                                    padding: const EdgeInsets
                                                                        .only(
                                                                            left:
                                                                                10),
                                                                    child: Text(
                                                                      snapshot.get(
                                                                          'name'),
                                                                      style: const TextStyle(
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
                                      if (snapshot.data!.docs.isNotEmpty) {
                                        final QuerySnapshot querySnapshot =
                                            snapshot.data!;
                                        return ListView.builder(
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            itemCount:
                                                querySnapshot.docs.length,
                                            shrinkWrap: true,
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              final DocumentSnapshot snapshot =
                                                  querySnapshot.docs[index];
                                              final Map<String, dynamic> dataSnapshot = snapshot.data() as Map<String, dynamic>;
                                              if (dataSnapshot['team'] ==
                                                  null) {
                                                return Padding(
                                                    padding: const EdgeInsets.all(5),
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
                                                                  snapshot.get(
                                                                      'uid'),
                                                                  'scout');
                                                            }));
                                                          },
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets.all(
                                                                    10),
                                                            child: Row(
                                                              children: <
                                                                  Widget>[
                                                                Container(
                                                                  width: 40,
                                                                  height: 40,
                                                                  decoration: BoxDecoration(
                                                                      color: theme.getThemeColor(
                                                                          snapshot.get(
                                                                              'age')),
                                                                      shape: BoxShape
                                                                          .circle),
                                                                  child: const Icon(
                                                                    Icons
                                                                        .person,
                                                                    color: Colors
                                                                        .white,
                                                                  ),
                                                                ),
                                                                Padding(
                                                                    padding: const EdgeInsets
                                                                        .only(
                                                                            left:
                                                                                10),
                                                                    child: Text(
                                                                      snapshot.get(
                                                                          'name'),
                                                                      style: const TextStyle(
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          fontSize:
                                                                              25),
                                                                    )),
                                                                const Spacer(),
                                                                const Padding(
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
                                          padding: const EdgeInsets.only(
                                              top: 5, left: 10, right: 10),
                                          child: Container(
                                              child: InkWell(
                                            onTap: () {},
                                            child: Padding(
                                              padding: const EdgeInsets.all(10),
                                              child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: <Widget>[
                                                    Icon(
                                                      Icons.bubble_chart,
                                                      color: Theme.of(context)
                                                          .colorScheme.secondary,
                                                      size: 35,
                                                    ),
                                                    const Padding(
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
                                if (model.position == 'leader')
                                  Padding(
                                      padding: const EdgeInsets.all(17),
                                      child: Container(
                                          width: double.infinity,
                                          child: const Text(
                                            'リーダー',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 28,
                                            ),
                                            textAlign: TextAlign.left,
                                          )))
                                else
                                  Container(),
                                if (model.position == 'leader')
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 55),
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
                                          if (snapshot.data!.docs.isNotEmpty) {
                                            final QuerySnapshot querySnapshot =
                                                snapshot.data!;
                                            return ListView.builder(
                                                physics:
                                                    const NeverScrollableScrollPhysics(),
                                                itemCount:
                                                    querySnapshot.docs.length,
                                                shrinkWrap: true,
                                                itemBuilder:
                                                    (BuildContext context,
                                                        int index) {
                                                  final DocumentSnapshot snapshot =
                                                      querySnapshot.docs[index];
                                                  final String? uid =
                                                      snapshot.get('uid');
                                                  return Padding(
                                                      padding:
                                                          const EdgeInsets.all(5),
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
                                                            onTap: () {
                                                              if (model
                                                                      .isAdmin! &&
                                                                  model.uid_user !=
                                                                      uid) {
                                                                Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute<
                                                                            SelectBookView>(
                                                                        builder:
                                                                            (BuildContext
                                                                                context) {
                                                                  return SelectBookView(
                                                                      uid,
                                                                      'leader');
                                                                }));
                                                              }
                                                            },
                                                            customBorder:
                                                                RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10.0),
                                                            ),
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(10),
                                                              child: Row(
                                                                children: <
                                                                    Widget>[
                                                                  Container(
                                                                    width: 40,
                                                                    height: 40,
                                                                    decoration: BoxDecoration(
                                                                        color: theme.getThemeColor(
                                                                            'challenge'),
                                                                        shape: BoxShape
                                                                            .circle),
                                                                    child: const Icon(
                                                                      Icons
                                                                          .person,
                                                                      color: Colors
                                                                          .white,
                                                                    ),
                                                                  ),
                                                                  Padding(
                                                                      padding: const EdgeInsets.only(
                                                                          left:
                                                                              10),
                                                                      child:
                                                                          Text(
                                                                        snapshot
                                                                            .get('name'),
                                                                        style: const TextStyle(
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                            fontSize: 25),
                                                                      )),
                                                                  const Spacer(),
                                                                  if (snapshot.get(
                                                                          'admin')) const Padding(
                                                                          padding: EdgeInsets.only(
                                                                              left:
                                                                                  10),
                                                                          child:
                                                                              Text(
                                                                            '管理者',
                                                                            style:
                                                                                TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                                                                          )) else Container()
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ));
                                                });
                                          } else {
                                            return Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 5, left: 10, right: 10),
                                              child: Container(
                                                  child: InkWell(
                                                onTap: () {},
                                                child: Padding(
                                                  padding: const EdgeInsets.all(10),
                                                  child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: <Widget>[
                                                        Icon(
                                                          Icons.bubble_chart,
                                                          color:
                                                              Theme.of(context)
                                                                  .colorScheme.secondary,
                                                          size: 35,
                                                        ),
                                                        const Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    left: 10),
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
                                                child:
                                                    CircularProgressIndicator()),
                                          );
                                        }
                                      },
                                    ),
                                  )
                                else
                                  Container(),
                              ],
                            );
                          } else {
                            return const Center(
                              child: Padding(
                                  padding: EdgeInsets.all(5),
                                  child: Text(
                                      'no data') /*CircularProgressIndicator()*/),
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
