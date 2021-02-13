import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cubook/createActivity/createActivity_model.dart';
import 'package:cubook/model/task.dart';
import 'package:cubook/model/themeInfo.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CreateAssignmentView extends StatelessWidget {
  var task = new TaskContents();
  var theme = new ThemeInfo();

  @override
  Widget build(BuildContext context) {
    Color color_ring;
    if (Theme.of(context).accentColor == Colors.white) {
      color_ring = Colors.blue[900];
    } else {
      color_ring = Colors.white;
    }
    bool isDark;
    if (Theme.of(context).accentColor == Colors.white) {
      isDark = true;
    } else {
      isDark = false;
    }
    return Scaffold(
        appBar: AppBar(
          title: Text('課題を新規作成'),
        ),
        floatingActionButton:
            Consumer<CreateActivityModel>(builder: (context, model, child) {
          if (model.isLoading) {
            return FloatingActionButton(
              child: CircularProgressIndicator(
                valueColor: new AlwaysStoppedAnimation<Color>(color_ring),
              ),
            );
          } else {
            return FloatingActionButton.extended(
                onPressed: () {
                  model.onSend(context);
                },
                label: Text('作成'),
                icon: Icon(Icons.save));
          }
        }),
        body: Builder(builder: (BuildContext context_builder) {
          return GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              child: SingleChildScrollView(
                  child: Center(
                child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: 800),
                    child: Consumer<CreateActivityModel>(
                        builder: (context, model, child) {
                      model.getGroup();
                      return Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.all(10),
                            child: TextField(
                                controller: model.titleController,
                                enabled: true,
                                keyboardType: TextInputType.multiline,
                                maxLines: null,
                                maxLengthEnforced: false,
                                decoration: InputDecoration(
                                    labelText: "タイトル",
                                    // hintText: '〇〇ハイク',
                                    errorText: model.EmptyError
                                        ? 'タイトルを入力してください　'
                                        : null)),
                          ),
                          Padding(
                            padding: EdgeInsets.all(10),
                            child: TextField(
                                //controller: model.titleController,
                                enabled: true,
                                keyboardType: TextInputType.multiline,
                                maxLines: null,
                                maxLengthEnforced: false,
                                decoration: InputDecoration(
                                    labelText: "説明(省略可)",
                                    // hintText: '〇〇ハイク',
                                    )),
                          ),
                          Row(
                            children: [
                              Padding(
                                  padding: EdgeInsets.only(
                                      top: 15, bottom: 15, left: 10),
                                  child: Container(
                                      child: const Text(
                                    '対象スカウト',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 25,
                                    ),
                                    textAlign: TextAlign.left,
                                  ))),
                              Spacer(),
                            ],
                          ),
                          Padding(
                              padding: EdgeInsets.only(bottom: 70),
                              child: StreamBuilder<QuerySnapshot>(
                                stream: FirebaseFirestore.instance
                                    .collection('user')
                                    .where('group', isEqualTo: model.group)
                                    .where('position', isEqualTo: 'scout')
                                    .orderBy('team')
                                    .orderBy('age_turn', descending: true)
                                    .orderBy('name')
                                    .snapshots(),
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
                                          itemCount: querySnapshot.docs.length,
                                          shrinkWrap: true,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            String uid;
                                            DocumentSnapshot snapshot =
                                                querySnapshot.docs[index];
                                            uid = snapshot.data()['uid'];
                                            if (!model.list_notApplicable
                                                .contains(uid)) {
                                              bool isCheck = true;
                                              if (model.uid_check[uid] !=
                                                  null) {
                                                isCheck = model.uid_check[uid];
                                              }
                                              String team;
                                              if (snapshot.data()['team']
                                                  is int) {
                                                team = snapshot
                                                    .data()['team']
                                                    .toString();
                                              } else {
                                                team = snapshot.data()['team'];
                                              }
                                              bool isFirst;
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
                                                Dismissible(
                                                    key: Key(snapshot
                                                        .data()['name']),
                                                    onDismissed: (direction) {
                                                      model.dismissUser(uid);
                                                      final snackBar = SnackBar(
                                                        content: Text(
                                                            snapshot.data()[
                                                                    'name'] +
                                                                'を対象外にしました'),
                                                        action: SnackBarAction(
                                                          label: '取り消し',
                                                          textColor: isDark
                                                              ? Colors.blue[900]
                                                              : Colors
                                                                  .blue[400],
                                                          onPressed: () {
                                                            model.cancelDismiss(
                                                                uid);
                                                          },
                                                        ),
                                                        duration: Duration(
                                                            seconds: 1),
                                                      );
                                                      Scaffold.of(
                                                          context_builder)
                                                        .showSnackBar(
                                                            snackBar);
                                                    },
                                                    child: Padding(
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
                                                              onTap: () {
                                                                model
                                                                    .onCheckMember(
                                                                        uid);
                                                              },
                                                              child: Padding(
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        top: 10,
                                                                        bottom:
                                                                            10,
                                                                        right:
                                                                            10,
                                                                        left:
                                                                            10),
                                                                child: Row(
                                                                  children: <
                                                                      Widget>[
                                                                    /*IconButton(
                                                                  icon: Icon(Icons
                                                                      .clear),
                                                                  onPressed:
                                                                      () {}),*/
                                                                    Container(
                                                                      width: 40,
                                                                      height:
                                                                          40,
                                                                      decoration: BoxDecoration(
                                                                          color: theme.getUserColor(snapshot.data()[
                                                                              'age']),
                                                                          shape:
                                                                              BoxShape.circle),
                                                                      child:
                                                                          Icon(
                                                                        Icons
                                                                            .person,
                                                                        color: Colors
                                                                            .white,
                                                                      ),
                                                                    ),
                                                                    Padding(
                                                                        padding: EdgeInsets.only(
                                                                            left:
                                                                                10),
                                                                        child:
                                                                            Text(
                                                                          snapshot
                                                                              .data()['name'],
                                                                          style: TextStyle(
                                                                              fontWeight: FontWeight.bold,
                                                                              fontSize: 25),
                                                                        )),
                                                                    Spacer(),
                                                                    Checkbox(
                                                                      value:
                                                                          isCheck,
                                                                      onChanged:
                                                                          (bool
                                                                              e) {
                                                                        model.onCheckMember(
                                                                            uid);
                                                                      },
                                                                      activeColor:
                                                                          Colors
                                                                              .blue[600],
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        )))
                                              ]);
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
                              )),
                        ],
                      );
                    })),
              )));
        }));
  }
}
