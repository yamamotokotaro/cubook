import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cubook/model/task.dart';
import 'package:cubook/model/themeInfo.dart';
import 'package:cubook/userDetail//userDetail_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'listCitationWaiting_model.dart';

class ListCitationWaitingView extends StatelessWidget {
  var theme = new ThemeInfo();
  var task = new Task();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('メンバーリスト'),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).pushNamed('/invite');
        },
        label: Text('招待'),
        icon: Icon(Icons.person_add),
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
                      child: Consumer<ListCitationWaitingModel>(
                          builder: (context, model, child) {
                        model.getGroup();
                        if (model.group != null) {
                          return Column(
                            children: <Widget>[
                              StreamBuilder<QuerySnapshot>(
                                stream: Firestore.instance
                                    .collection('challenge')
                                    .where('group', isEqualTo: model.group)
                                    .where('isCitationed', isEqualTo: false)
                                    .orderBy('page')
                                    .orderBy('end', descending: true)
                                    .snapshots(),
                                builder: (BuildContext context,
                                    AsyncSnapshot<QuerySnapshot> snapshot) {
                                  if (snapshot.hasData) {
                                    if (snapshot.data.documents.length != 0) {
                                      QuerySnapshot querySnapshot =
                                          snapshot.data;
                                      int page_last = 0;
                                      return ListView.builder(
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          itemCount:
                                              querySnapshot.documents.length,
                                          shrinkWrap: true,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            DocumentSnapshot snapshot =
                                                querySnapshot.documents[index];
                                            bool isChange = false;
                                            Map<String, dynamic> taskMap =
                                                task.getPartMap('challenge',
                                                    snapshot['page']);
                                            if (snapshot['page'] != page_last) {
                                              isChange = true;
                                            }
                                            page_last = snapshot['page'];
                                            return Column(
                                              children: <Widget>[
                                                isChange
                                                    ? Padding(
                                                        padding:
                                                            EdgeInsets.all(17),
                                                        child: Container(
                                                            width:
                                                                double.infinity,
                                                            child: Text(
                                                              taskMap['number'] +
                                                                  ' ' +
                                                                  taskMap[
                                                                      'title'],
                                                              style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 28,
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
                                                          onTap: () {
                                                            Navigator.push(
                                                                context,
                                                                MaterialPageRoute<
                                                                        SelectBookView>(
                                                                    builder:
                                                                        (BuildContext
                                                                            context) {
                                                              return SelectBookView(
                                                                  snapshot[
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
                                                                      snapshot['team']
                                                                              .toString() +
                                                                          '組',
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
                                                    ))
                                              ],
                                            );
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
                                stream: Firestore.instance
                                    .collection('user')
                                    .where('group', isEqualTo: model.group)
                                    .where('position', isEqualTo: 'scout')
                                    .orderBy('name')
                                    .snapshots(),
                                builder: (BuildContext context,
                                    AsyncSnapshot<QuerySnapshot> snapshot) {
                                  if (snapshot.hasData) {
                                    if (snapshot.data.documents.length != 0) {
                                      QuerySnapshot querySnapshot =
                                          snapshot.data;
                                      return ListView.builder(
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          itemCount:
                                              querySnapshot.documents.length,
                                          shrinkWrap: true,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            DocumentSnapshot snapshot =
                                                querySnapshot.documents[index];
                                            if (snapshot['team'] == null) {
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
                                                                snapshot[
                                                                    'uid']);
                                                          }));
                                                        },
                                                        child: Padding(
                                                          padding:
                                                              EdgeInsets.all(
                                                                  10),
                                                          child: Row(
                                                            children: <Widget>[
                                                              Container(
                                                                width: 40,
                                                                height: 40,
                                                                decoration: BoxDecoration(
                                                                    color: theme.getThemeColor(
                                                                        snapshot[
                                                                            'age']),
                                                                    shape: BoxShape
                                                                        .circle),
                                                                child: Icon(
                                                                  Icons.person,
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
                                                                        fontWeight:
                                                                            FontWeight
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
                                                                    /*snapshot['team']
                                                                          .toString() +*/
                                                                    '組未設定',
                                                                    style: TextStyle(
                                                                        fontWeight:
                                                                            FontWeight
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
                                                      padding: EdgeInsets.only(
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
                              Padding(
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
                                      ))),
                              Padding(
                                padding: EdgeInsets.only(bottom: 55),
                                child: StreamBuilder<QuerySnapshot>(
                                  stream: Firestore.instance
                                      .collection('user')
                                      .where('group', isEqualTo: model.group)
                                      .where('position', isEqualTo: 'leader')
                                      .snapshots(),
                                  builder: (BuildContext context,
                                      AsyncSnapshot<QuerySnapshot> snapshot) {
                                    if (snapshot.hasData) {
                                      if (snapshot.data.documents.length != 0) {
                                        QuerySnapshot querySnapshot =
                                            snapshot.data;
                                        return ListView.builder(
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            itemCount:
                                                querySnapshot.documents.length,
                                            shrinkWrap: true,
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              DocumentSnapshot snapshot =
                                                  querySnapshot
                                                      .documents[index];
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
                                                        onTap: () {},
                                                        child: Padding(
                                                          padding:
                                                              EdgeInsets.all(
                                                                  10),
                                                          child: Row(
                                                            children: <Widget>[
                                                              Container(
                                                                width: 40,
                                                                height: 40,
                                                                decoration: BoxDecoration(
                                                                    color: theme
                                                                        .getThemeColor(
                                                                            'challenge'),
                                                                    shape: BoxShape
                                                                        .circle),
                                                                child: Icon(
                                                                  Icons.person,
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
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        fontSize:
                                                                            25),
                                                                  )),
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
