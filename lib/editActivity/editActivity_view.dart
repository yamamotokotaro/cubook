import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cubook/editActivity/editActivity_model.dart';
import 'package:cubook/model/task.dart';
import 'package:cubook/model/themeInfo.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class EditActivityView extends StatelessWidget {
  ThemeInfo theme = ThemeInfo();
  TaskContents task = TaskContents();

  @override
  Widget build(BuildContext context) {
    final String? documentID =
        ModalRoute.of(context)!.settings.arguments as String?;
    bool isDark;
    if (Theme.of(context).colorScheme.secondary == Colors.white) {
      isDark = true;
    } else {
      isDark = false;
    }
    return Scaffold(
        appBar: AppBar(
          title: const Text('記録を編集'),
          systemOverlayStyle: SystemUiOverlayStyle.light,
        ),
        floatingActionButton: Consumer<EditActivityModel>(builder:
            (BuildContext context, EditActivityModel model, Widget? child) {
          if (model.isLoading) {
            return FloatingActionButton(
              onPressed: null,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color?>(
                    isDark ? Colors.blue[900] : Colors.white),
              ),
            );
          } else {
            return FloatingActionButton.extended(
                onPressed: () {
                  model.onPressSend(context);
                },
                label: const Text('記録'),
                icon: const Icon(Icons.save));
          }
        }),
        body: Builder(builder: (BuildContext context) {
          return GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: SingleChildScrollView(
              child: Center(
                child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 600),
                    child: Consumer<EditActivityModel>(builder:
                        (BuildContext contextBuilder, EditActivityModel model,
                            Widget? child) {
                      print('ページ更新');
                      model.getGroup();
                      if (model.group != null) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 60),
                          child: Column(
                            children: <Widget>[
                              Padding(
                                  padding: const EdgeInsets.only(
                                      top: 20, bottom: 10),
                                  child: Column(
                                    children: <Widget>[
                                      StreamBuilder<DocumentSnapshot>(
                                        stream: FirebaseFirestore.instance
                                            .collection('activity')
                                            .doc(documentID)
                                            .snapshots(),
                                        builder: (BuildContext context,
                                            AsyncSnapshot<DocumentSnapshot>
                                                snapshot) {
                                          if (snapshot.hasData) {
                                            final DocumentSnapshot
                                                documentSnapshot =
                                                snapshot.data!;
                                            const String teamLast = '';
                                            model.getInfo(documentSnapshot);
                                            return Column(children: <Widget>[
                                              Padding(
                                                  padding:
                                                      const EdgeInsets.all(10),
                                                  child: TextField(
                                                      maxLengthEnforcement:
                                                          MaxLengthEnforcement
                                                              .none,
                                                      controller:
                                                          model.titleController,
                                                      enabled: true,
                                                      keyboardType:
                                                          TextInputType
                                                              .multiline,
                                                      maxLines: null,
                                                      decoration: InputDecoration(
                                                          labelText: '活動タイトル',
                                                          hintText: '〇〇ハイク',
                                                          errorText: model
                                                                  .EmptyError
                                                              ? 'タイトルを入力してください　'
                                                              : null))),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 5),
                                                child: Container(
                                                    width: double.infinity,
                                                    child: Align(
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        child: TextButton(
                                                          child: Text(
                                                            DateFormat(
                                                                    'yyyy/MM/dd')
                                                                .format(
                                                                    model.date!)
                                                                .toString(),
                                                            style: const TextStyle(
                                                                fontSize: 20.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                decoration:
                                                                    TextDecoration
                                                                        .none),
                                                          ),
                                                          onPressed: () {
                                                            model
                                                                .openTimePicker(
                                                                    model.date!,
                                                                    context);
                                                          },
                                                        ))),
                                              ),
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
                                      ),
                                      StreamBuilder<QuerySnapshot>(
                                        stream: FirebaseFirestore.instance
                                            .collection('activity_personal')
                                            .where('group',
                                                isEqualTo: model.group)
                                            .where('activity',
                                                isEqualTo: documentID)
                                            .orderBy('team')
                                            .orderBy('age_turn',
                                                descending: true)
                                            .orderBy('name')
                                            .snapshots(),
                                        builder: (BuildContext context,
                                            AsyncSnapshot<QuerySnapshot>
                                                snapshot) {
                                          if (snapshot.hasData) {
                                            model.getAbsents(snapshot.data);
                                            if (snapshot
                                                .data!.docs.isNotEmpty) {
                                              final QuerySnapshot
                                                  querySnapshot =
                                                  snapshot.data!;
                                              final List<DocumentSnapshot>
                                                  listDocumentSnapshot =
                                                  querySnapshot.docs;
                                              String? teamLast = '';
                                              final List<String?> listUid =
                                                  <String?>[];
                                              for (int i = 0;
                                                  i <
                                                      listDocumentSnapshot
                                                          .length;
                                                  i++) {
                                                listUid.add(
                                                    listDocumentSnapshot[i]
                                                        .get('uid'));
                                              }
                                              return Column(children: <Widget>[
                                                Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 15,
                                                            bottom: 15,
                                                            left: 10),
                                                    child: Container(
                                                        width: double.infinity,
                                                        child: const Text(
                                                          '出席者',
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 25,
                                                          ),
                                                          textAlign:
                                                              TextAlign.left,
                                                        ))),
                                                ListView.builder(
                                                    physics:
                                                        const NeverScrollableScrollPhysics(),
                                                    itemCount: querySnapshot
                                                        .docs.length,
                                                    shrinkWrap: true,
                                                    itemBuilder:
                                                        (BuildContext context,
                                                            int index) {
                                                      String? uid;
                                                      final DocumentSnapshot
                                                          snapshot =
                                                          querySnapshot
                                                              .docs[index];
                                                      final String documentID =
                                                          snapshot.id;
                                                      uid = snapshot.get('uid');
                                                      bool? isCheck = true;
                                                      if (model.uid_check[
                                                              uid!] !=
                                                          null) {
                                                        isCheck = model
                                                            .uid_check[uid];
                                                      }
                                                      String? team = '';
                                                      if (snapshot
                                                              .get('team') !=
                                                          null) {
                                                        if (snapshot.get('team')
                                                            is int) {
                                                          team = snapshot
                                                              .get('team')
                                                              .toString();
                                                        } else {
                                                          team = snapshot
                                                              .get('team');
                                                        }
                                                      } else {
                                                        team = 'null';
                                                      }
                                                      bool isFirst;
                                                      String absence;
                                                      if (teamLast != team) {
                                                        isFirst = true;
                                                        teamLast = team;
                                                      } else {
                                                        isFirst = false;
                                                      }
                                                      final String? age =
                                                          snapshot.get('age');
                                                      String teamCall;
                                                      if (age == 'usagi' ||
                                                          age == 'sika' ||
                                                          age == 'kuma') {
                                                        teamCall = '組';
                                                      } else {
                                                        teamCall = '班';
                                                      }
                                                      print(model.uid_check);
                                                      return Column(
                                                          children: <Widget>[
                                                            if (isFirst &&
                                                                team != '')
                                                              Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(10),
                                                                  child: Container(
                                                                      width: double.infinity,
                                                                      child: Text(
                                                                        team! +
                                                                            teamCall,
                                                                        style:
                                                                            const TextStyle(
                                                                          fontWeight:
                                                                              FontWeight.bold,
                                                                          fontSize:
                                                                              23,
                                                                        ),
                                                                        textAlign:
                                                                            TextAlign.left,
                                                                      )))
                                                            else
                                                              Container(),
                                                            Dismissible(
                                                                key: Key(
                                                                    snapshot.get(
                                                                        'name')),
                                                                onDismissed:
                                                                    (DismissDirection
                                                                        direction) {
                                                                  model.dismissUser(
                                                                      snapshot
                                                                          .id);
                                                                  final SnackBar
                                                                      snackBar =
                                                                      SnackBar(
                                                                    content: Text(
                                                                        snapshot.get('name') +
                                                                            'を対象外にしました'),
                                                                    action:
                                                                        SnackBarAction(
                                                                      label:
                                                                          '取り消し',
                                                                      textColor: isDark
                                                                          ? Colors.blue[
                                                                              900]
                                                                          : Colors
                                                                              .blue[400],
                                                                      onPressed:
                                                                          () {
                                                                        model.cancelDismiss(
                                                                            uid,
                                                                            snapshot.data()
                                                                                as Map<String, dynamic>);
                                                                      },
                                                                    ),
                                                                    duration: const Duration(
                                                                        seconds:
                                                                            1),
                                                                  );
                                                                  ScaffoldMessenger.of(
                                                                          context)
                                                                      .showSnackBar(
                                                                          snackBar);
                                                                },
                                                                child: Padding(
                                                                    padding:
                                                                        const EdgeInsets.all(
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
                                                                              () {
                                                                            model.onCheckMember(documentID);
                                                                          },
                                                                          child:
                                                                              Padding(
                                                                            padding:
                                                                                const EdgeInsets.all(10),
                                                                            child:
                                                                                Row(
                                                                              children: <Widget>[
                                                                                Container(
                                                                                  width: 40,
                                                                                  height: 40,
                                                                                  decoration: BoxDecoration(color: theme.getUserColor(snapshot.get('age')), shape: BoxShape.circle),
                                                                                  child: const Icon(
                                                                                    Icons.person,
                                                                                    color: Colors.white,
                                                                                  ),
                                                                                ),
                                                                                Padding(
                                                                                    padding: const EdgeInsets.only(left: 10),
                                                                                    child: Text(
                                                                                      snapshot.get('name'),
                                                                                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                                                                                    )),
                                                                                const Spacer(),
                                                                                Checkbox(
                                                                                  value: model.checkAbsents[documentID],
                                                                                  onChanged: (bool? e) {
                                                                                    model.onCheckMember(documentID);
                                                                                  },
                                                                                  activeColor: Colors.blue[600],
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    )))
                                                          ]);
                                                    }),
                                                Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 15,
                                                            bottom: 15,
                                                            left: 10),
                                                    child: Container(
                                                        width: double.infinity,
                                                        child: const Text(
                                                          '未記録者',
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 25,
                                                          ),
                                                          textAlign:
                                                              TextAlign.left,
                                                        ))),
                                                StreamBuilder<QuerySnapshot>(
                                                  stream: FirebaseFirestore
                                                      .instance
                                                      .collection('user')
                                                      .where('group',
                                                          isEqualTo:
                                                              model.group)
                                                      .where('position',
                                                          isEqualTo: 'scout')
                                                      .orderBy('team')
                                                      .orderBy('age_turn',
                                                          descending: true)
                                                      .orderBy('name')
                                                      .snapshots(),
                                                  builder:
                                                      (BuildContext context,
                                                          AsyncSnapshot<
                                                                  QuerySnapshot>
                                                              snapshot) {
                                                    if (snapshot.hasData) {
                                                      if (snapshot.data!.docs
                                                          .isNotEmpty) {
                                                        final QuerySnapshot
                                                            querySnapshot =
                                                            snapshot.data!;
                                                        String? teamLast = '';
                                                        return ListView.builder(
                                                            physics:
                                                                const NeverScrollableScrollPhysics(),
                                                            itemCount:
                                                                querySnapshot
                                                                    .docs
                                                                    .length,
                                                            shrinkWrap: true,
                                                            itemBuilder:
                                                                (BuildContext
                                                                        context,
                                                                    int index) {
                                                              final DocumentSnapshot
                                                                  snapshot =
                                                                  querySnapshot
                                                                          .docs[
                                                                      index];
                                                              if (!listUid.contains(
                                                                  snapshot.get(
                                                                      'uid'))) {
                                                                bool isFirst;
                                                                String? team;
                                                                if (snapshot.get(
                                                                        'team')
                                                                    is int) {
                                                                  team = snapshot
                                                                      .get(
                                                                          'team')
                                                                      .toString();
                                                                } else {
                                                                  team = snapshot
                                                                      .get(
                                                                          'team');
                                                                }
                                                                if (teamLast !=
                                                                    team) {
                                                                  isFirst =
                                                                      true;
                                                                  teamLast =
                                                                      team;
                                                                } else {
                                                                  isFirst =
                                                                      false;
                                                                }
                                                                final String?
                                                                    grade =
                                                                    snapshot.get(
                                                                        'grade');
                                                                String teamCall;
                                                                if (grade ==
                                                                    'cub') {
                                                                  teamCall =
                                                                      '組';
                                                                } else {
                                                                  teamCall =
                                                                      '班';
                                                                }
                                                                return Column(
                                                                    children: <
                                                                        Widget>[
                                                                      if (isFirst &&
                                                                          team !=
                                                                              '')
                                                                        Padding(
                                                                            padding: const EdgeInsets.only(
                                                                                top: 10,
                                                                                bottom: 10,
                                                                                left: 17),
                                                                            child: Container(
                                                                                width: double.infinity,
                                                                                child: Text(
                                                                                  team! + teamCall,
                                                                                  style: const TextStyle(
                                                                                    fontWeight: FontWeight.bold,
                                                                                    fontSize: 23,
                                                                                  ),
                                                                                  textAlign: TextAlign.left,
                                                                                )))
                                                                      else
                                                                        Container(),
                                                                      Padding(
                                                                          padding: const EdgeInsets.all(
                                                                              5),
                                                                          child:
                                                                              Container(
                                                                            child:
                                                                                Card(
                                                                              shape: RoundedRectangleBorder(
                                                                                borderRadius: BorderRadius.circular(10),
                                                                              ),
                                                                              child: InkWell(
                                                                                customBorder: RoundedRectangleBorder(
                                                                                  borderRadius: BorderRadius.circular(10.0),
                                                                                ),
                                                                                onTap: () {
                                                                                  /*Navigator.push(
                                                                            context,
                                                                            MaterialPageRoute<
                                                                                SelectBookView>(
                                                                                builder:
                                                                                    (BuildContext
                                                                                context) {
                                                                                  return SelectBookView(
                                                                                      snapshot[
                                                                                      'uid']);
                                                                                }));*/
                                                                                },
                                                                                child: Padding(
                                                                                  padding: const EdgeInsets.all(10),
                                                                                  child: Row(
                                                                                    children: <Widget>[
                                                                                      Container(
                                                                                        width: 40,
                                                                                        height: 40,
                                                                                        decoration: BoxDecoration(color: theme.getUserColor(snapshot.get('age')), shape: BoxShape.circle),
                                                                                        child: const Icon(
                                                                                          Icons.person,
                                                                                          color: Colors.white,
                                                                                        ),
                                                                                      ),
                                                                                      Padding(
                                                                                          padding: const EdgeInsets.only(left: 10),
                                                                                          child: Text(
                                                                                            snapshot.get('name'),
                                                                                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                                                                                          )),
                                                                                      const Spacer(),
                                                                                      IconButton(
                                                                                        onPressed: () {
                                                                                          model.onPressAdd(snapshot, contextBuilder, isDark);
                                                                                        },
                                                                                        icon: const Icon(Icons.add),
                                                                                        iconSize: 30,
                                                                                      )
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
                                                            });
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
                                                ),
                                              ]);
                                            } else {
                                              return Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 5,
                                                    left: 10,
                                                    right: 10),
                                                child: Container(
                                                    child: InkWell(
                                                  onTap: () {},
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            10),
                                                    child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: <Widget>[
                                                          Icon(
                                                            Icons.bubble_chart,
                                                            color: Theme.of(
                                                                    context)
                                                                .colorScheme
                                                                .secondary,
                                                            size: 35,
                                                          ),
                                                          const Padding(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      left: 10),
                                                              child: Material(
                                                                type: MaterialType
                                                                    .transparency,
                                                                child: Text(
                                                                  '出欠の記録はありません',
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
                                      )
                                    ],
                                  ))
                            ],
                          ),
                        );
                      } else {
                        return const Center(
                          child: Padding(
                              padding: EdgeInsets.all(5),
                              child: CircularProgressIndicator()),
                        );
                      }
                    })),
              ),
            ),
          );
        }));
  }
}
