import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cubook/detailActivity/detailActivity_model.dart';
import 'package:cubook/model/class.dart';
import 'package:cubook/model/task.dart';
import 'package:cubook/model/themeInfo.dart';
import 'package:cubook/task_detail_scout/taskDetailScout_view.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class DetailActivityView extends StatelessWidget {
  ThemeInfo theme = ThemeInfo();
  TaskContents task = TaskContents();

  @override
  Widget build(BuildContext context) {
    final String? documentID =
        ModalRoute.of(context)!.settings.arguments as String?;
    return Scaffold(
      appBar: AppBar(
        title: const Text('記録詳細'),
        actions: <Widget>[
<<<<<<< HEAD
          Selector<DetailActivityModel, String?>(
              selector: (BuildContext context, DetailActivityModel model) =>
                  model.position,
              builder:
                  (BuildContext context, String? position, Widget? child) =>
                      position == 'leader'
                          ? Semantics(
                              label: '活動記録の編集か削除操作が行えます',
                              child: IconButton(
                                icon: const Icon(Icons.more_vert),
                                onPressed: () async {
                                  await showModalBottomSheet<int>(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return Padding(
                                          padding: const EdgeInsets.only(
                                              top: 10, bottom: 10),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              Consumer<DetailActivityModel>(
                                                  builder: (BuildContext
                                                          context,
                                                      DetailActivityModel model,
                                                      Widget? child) {
                                                return Column(
                                                  children: [
                                                    ListTile(
                                                      leading: const Icon(
                                                          Icons.edit),
                                                      title: const Text('編集する'),
                                                      onTap: () {
                                                        Navigator.pop(context);
                                                        Navigator.of(context)
                                                            .pushNamed(
                                                                '/editActivity',
                                                                arguments:
                                                                    documentID);
                                                      },
                                                    ),
                                                    ListTile(
                                                      leading: const Icon(
                                                          Icons.delete),
                                                      title: const Text('削除する'),
                                                      onTap: () async {
                                                        Navigator.pop(context);
                                                        await showModalBottomSheet<
                                                            int>(
                                                          context: context,
                                                          builder: (BuildContext
                                                              context) {
=======
          Selector<DetailActivityModel, String>(
              selector: (context, model) => model.position,
              builder: (context, position, child) => position == 'leader'
                  ? Semantics(
                      label: '活動記録の編集か削除操作が行えます',
                      child: IconButton(
                        icon: Icon(Icons.more_vert),
                        onPressed: () async {
                          await showModalBottomSheet<int>(
                            context: context,
                            builder: (BuildContext context) {
                              return Padding(
                                  padding: EdgeInsets.only(top: 10, bottom: 10),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Consumer<DetailActivityModel>(
                                          builder: (context, model, child) {
                                        return Column(
                                          children: [
                                            ListTile(
                                              leading: Icon(Icons.edit),
                                              title: Text('編集する'),
                                              onTap: () {
                                                Navigator.pop(context);
                                                Navigator.of(context).pushNamed(
                                                    '/editActivity',
                                                    arguments: documentID);
                                              },
                                            ),
                                            ListTile(
                                              leading: Icon(Icons.delete),
                                              title: Text('削除する'),
                                              onTap: () async {
                                                Navigator.pop(context);
                                                await showModalBottomSheet<int>(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                top: 10,
                                                                bottom: 10),
                                                        child: Column(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: <Widget>[
                                                            Consumer<
                                                                    DetailActivityModel>(
                                                                builder:
                                                                    (context,
                                                                        model,
                                                                        child) {
                                                              return Column(
                                                                children: [
                                                                  Padding(
                                                                      padding: EdgeInsets.only(
                                                                          top:
                                                                              5,
                                                                          left:
                                                                              17,
                                                                          bottom:
                                                                              17),
                                                                      child: Container(
                                                                          width: double.infinity,
                                                                          child: Text(
                                                                            '本当に削除しますか？',
                                                                            style:
                                                                                TextStyle(
                                                                              fontWeight: FontWeight.bold,
                                                                              fontSize: 22,
                                                                            ),
                                                                            textAlign:
                                                                                TextAlign.left,
                                                                          ))),
                                                                  ListTile(
                                                                    leading: Icon(
                                                                        Icons
                                                                            .delete),
                                                                    title: Text(
                                                                        'はい'),
                                                                    onTap: () {
                                                                      model.deleteActivity(
                                                                          documentID);
                                                                      Navigator.pop(
                                                                          context);
                                                                      Navigator.pop(
                                                                          context);
                                                                    },
                                                                  ),
                                                                  ListTile(
                                                                    leading: Icon(
                                                                        Icons
                                                                            .arrow_back),
                                                                    title: Text(
                                                                        'いいえ'),
                                                                    onTap: () {
                                                                      Navigator.pop(
                                                                          context);
                                                                    },
                                                                  )
                                                                ],
                                                              );
                                                            })
                                                          ],
                                                        ));
                                                  },
                                                );
                                              },
                                            )
                                          ],
                                        );
                                      })
                                    ],
                                  ));
                            },
                          );
                        },
                      ))
                  : Container())
        ],
      ),
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
                      child: Consumer<DetailActivityModel>(
                          builder: (context, model, child) {
                        model.getGroup();
                        if (model.group != null) {
                          return Column(
                            children: <Widget>[
                              StreamBuilder<DocumentSnapshot>(
                                stream: FirebaseFirestore.instance
                                    .collection('activity')
                                    .doc(documentID)
                                    .snapshots(),
                                builder: (BuildContext context,
                                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                                  if (snapshot.hasData) {
                                    DocumentSnapshot documentSnapshot =
                                        snapshot.data;
                                    String team_last = '';
                                    return Column(children: <Widget>[
                                      Padding(
                                          padding: EdgeInsets.all(17),
                                          child: Container(
                                              width: double.infinity,
                                              child: Text(
                                                documentSnapshot
                                                    .data()['title'],
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 32,
                                                ),
                                                textAlign: TextAlign.left,
                                              ))),
                                      Padding(
                                          padding: EdgeInsets.only(
                                              top: 0, bottom: 15, left: 17),
                                          child: Container(
                                              width: double.infinity,
                                              child: Text(
                                                DateFormat('yyyy年MM月dd日')
                                                    .format(documentSnapshot
                                                        .data()['date']
                                                        .toDate())
                                                    .toString(),
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20,
                                                ),
                                                textAlign: TextAlign.left,
                                              ))),
                                      documentSnapshot.data()['list_item'] !=
                                              null
                                          ? documentSnapshot
                                                      .data()['list_item']
                                                      .length !=
                                                  0
                                              ? Column(
                                                  children: [
                                                    Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                top: 15,
                                                                bottom: 15,
                                                                left: 10),
                                                        child: Container(
                                                            width:
                                                                double.infinity,
                                                            child: Text(
                                                              '取得項目',
                                                              style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 25,
                                                              ),
                                                              textAlign:
                                                                  TextAlign
                                                                      .left,
                                                            ))),
                                                    ListView.builder(
                                                        physics:
                                                            const NeverScrollableScrollPhysics(),
                                                        itemCount:
                                                            documentSnapshot
                                                                .data()[
                                                                    'list_item']
                                                                .length,
                                                        shrinkWrap: true,
                                                        itemBuilder:
                                                            (BuildContext
                                                                    context,
                                                                int index) {
                                                          Map<String, dynamic>
                                                              part_selected =
                                                              documentSnapshot
                                                                          .data()[
                                                                      'list_item']
                                                                  [index];
                                                          String type =
                                                              part_selected[
                                                                  'type'];
                                                          int page =
                                                              part_selected[
                                                                  'page'];
                                                          int number =
                                                              part_selected[
                                                                  'number'];
                                                          String position =
                                                              model.position;
                                                          Map<String, dynamic>
                                                              map_task =
                                                              task.getPartMap(
                                                                  type, page);
                                                          bool toShow = false;
                                                          if (position ==
                                                              'scout') {
                                                            if (type ==
                                                                    'challenge' ||
                                                                type ==
                                                                    model.age) {
                                                              toShow = true;
                                                            }
                                                          } else {
                                                            toShow = true;
                                                          }
                                                          if (toShow) {
>>>>>>> develop
                                                            return Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        top: 10,
                                                                        bottom:
                                                                            10),
                                                                child: Column(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .min,
                                                                  children: <Widget>[
                                                                    Consumer<
                                                                        DetailActivityModel>(builder: (BuildContext
                                                                            context,
                                                                        DetailActivityModel
                                                                            model,
                                                                        Widget?
                                                                            child) {
                                                                      return Column(
                                                                        children: [
                                                                          Padding(
                                                                              padding: const EdgeInsets.only(top: 5, left: 17, bottom: 17),
                                                                              child: Container(
                                                                                  width: double.infinity,
                                                                                  child: const Text(
                                                                                    '本当に削除しますか？',
                                                                                    style: TextStyle(
                                                                                      fontWeight: FontWeight.bold,
                                                                                      fontSize: 22,
                                                                                    ),
                                                                                    textAlign: TextAlign.left,
                                                                                  ))),
                                                                          ListTile(
                                                                            leading:
                                                                                const Icon(Icons.delete),
                                                                            title:
                                                                                const Text('はい'),
                                                                            onTap:
                                                                                () {
                                                                              model.deleteActivity(documentID);
                                                                              Navigator.pop(context);
                                                                              Navigator.pop(context);
                                                                            },
                                                                          ),
                                                                          ListTile(
                                                                            leading:
                                                                                const Icon(Icons.arrow_back),
                                                                            title:
                                                                                const Text('いいえ'),
                                                                            onTap:
                                                                                () {
                                                                              Navigator.pop(context);
                                                                            },
                                                                          )
                                                                        ],
                                                                      );
                                                                    })
                                                                  ],
                                                                ));
                                                          },
                                                        );
                                                      },
                                                    )
                                                  ],
                                                );
                                              })
                                            ],
                                          ));
                                    },
                                  );
                                },
                              ))
                          : Container())
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Column(
              children: <Widget>[
                Padding(
                    padding: const EdgeInsets.only(top: 20, bottom: 10),
                    child: Consumer<DetailActivityModel>(builder:
                        (BuildContext context, DetailActivityModel model,
                            Widget? child) {
                      model.getGroup();
                      if (model.group != null) {
                        return Column(
                          children: <Widget>[
                            StreamBuilder<DocumentSnapshot>(
                              stream: FirebaseFirestore.instance
                                  .collection('activity')
                                  .doc(documentID)
                                  .snapshots(),
                              builder: (BuildContext context,
                                  AsyncSnapshot<DocumentSnapshot> snapshot) {
                                if (snapshot.hasData) {
                                  final DocumentSnapshot documentSnapshot =
                                      snapshot.data!;
                                  final Map<String, dynamic> documentData =
                                      documentSnapshot.data()
                                          as Map<String, dynamic>;
                                  const String teamLast = '';
                                  return Column(children: <Widget>[
                                    Padding(
                                        padding: const EdgeInsets.all(17),
                                        child: Container(
                                            width: double.infinity,
                                            child: Text(
                                              documentSnapshot.get('title'),
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 32,
                                              ),
                                              textAlign: TextAlign.left,
                                            ))),
                                    Padding(
                                        padding: const EdgeInsets.only(
                                            top: 0, bottom: 15, left: 17),
                                        child: Container(
                                            width: double.infinity,
                                            child: Text(
                                              DateFormat('yyyy年MM月dd日')
                                                  .format(documentSnapshot
                                                      .get('date')
                                                      .toDate())
                                                  .toString(),
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20,
                                              ),
                                              textAlign: TextAlign.left,
                                            ))),
                                    if (documentData['list_item'] != null)
                                      documentSnapshot
                                                  .get('list_item')
                                                  .length !=
                                              0
                                          ? Column(
                                              children: [
                                                Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 15,
                                                            bottom: 15,
                                                            left: 10),
                                                    child: Container(
                                                        width: double.infinity,
                                                        child: const Text(
                                                          '取得項目',
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
                                                    itemCount: documentSnapshot
                                                        .get('list_item')
                                                        .length,
                                                    shrinkWrap: true,
                                                    itemBuilder:
                                                        (BuildContext context,
                                                            int index) {
                                                      final Map<String, dynamic>
                                                          partSelected =
                                                          documentSnapshot.get(
                                                                  'list_item')[
                                                              index];
                                                      final String? type =
                                                          partSelected['type'];
                                                      final int? page =
                                                          partSelected['page'];
                                                      final int? number =
                                                          partSelected[
                                                              'number'];
                                                      final String? position =
                                                          model.position;
                                                      final Map<String,
                                                              dynamic>?
                                                          mapTask =
                                                          task.getPartMap(
                                                              type, page);
                                                      bool toShow = false;
                                                      if (position == 'scout') {
                                                        if (type ==
                                                                'challenge' ||
                                                            type == model.age) {
                                                          toShow = true;
                                                        }
                                                      } else {
                                                        toShow = true;
                                                      }
                                                      if (toShow) {
                                                        return Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(5),
                                                            child: Card(
                                                              color: theme
                                                                  .getThemeColor(
                                                                      type),
                                                              shape:
                                                                  RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5.0),
                                                              ),
                                                              child: InkWell(
                                                                  customBorder:
                                                                      RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10.0),
                                                                  ),
                                                                  onTap:
                                                                      () async {
                                                                    if (position ==
                                                                        'scout') {
                                                                      Navigator.of(context).push<dynamic>(MyPageRoute(
                                                                          page: showTaskView(
                                                                              page,
                                                                              type,
                                                                              number +
                                                                                  1),
                                                                          dismissible:
                                                                              true));
                                                                    } else {
                                                                      await showModalBottomSheet<
                                                                          int>(
                                                                        context:
                                                                            context,
                                                                        builder:
                                                                            (BuildContext
                                                                                context) {
                                                                          return Padding(
                                                                              padding: const EdgeInsets.all(15),
                                                                              child: Column(
                                                                                mainAxisSize: MainAxisSize.min,
                                                                                children: <Widget>[
                                                                                  Padding(
                                                                                      padding: const EdgeInsets.all(0),
                                                                                      child: Container(
                                                                                        width: double.infinity,
                                                                                        child: Text(
                                                                                          task.getContent(type, page, number)['body'],
                                                                                          style: const TextStyle(
                                                                                            fontSize: 18,
                                                                                            fontWeight: FontWeight.bold,
                                                                                          ),
                                                                                          textAlign: TextAlign.left,
                                                                                        ),
                                                                                      )),
                                                                                  Padding(
                                                                                      padding: const EdgeInsets.all(0),
                                                                                      child: Container(
                                                                                        width: double.infinity,
                                                                                        child: const Text(
                                                                                          '\n公財ボーイスカウト日本連盟「令和2年版 諸規定」',
                                                                                          style: TextStyle(
                                                                                            fontSize: 13,
                                                                                            fontWeight: FontWeight.bold,
                                                                                          ),
                                                                                          textAlign: TextAlign.left,
                                                                                        ),
                                                                                      )),
                                                                                ],
<<<<<<< HEAD
                                                                              ));
                                                                        },
                                                                      );
                                                                    }
                                                                  },
                                                                  child: Center(
                                                                      child: Padding(
                                                                          padding: const EdgeInsets.only(top: 5, bottom: 5),
                                                                          child: Column(
                                                                            children: [
                                                                              Text(theme.getTitle(type)! + ' ' + mapTask!['number'] + ' ' + mapTask['title'] + ' (' + (number! + 1).toString() + ')', style: const TextStyle(fontWeight: FontWeight.normal, fontSize: 18, color: Colors.white))
                                                                            ],
                                                                          )))),
                                                            ));
                                                      } else {
                                                        return Container();
                                                      }
                                                    })
                                              ],
                                            )
                                          : Container()
                                    else
                                      Container(),
                                  ]);
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
                              stream: FirebaseFirestore.instance
                                  .collection('activity_personal')
                                  .where('group', isEqualTo: model.group)
                                  .where('activity', isEqualTo: documentID)
                                  .orderBy('team')
                                  .orderBy('age_turn', descending: true)
                                  .orderBy('name')
                                  .snapshots(),
                              builder: (BuildContext context,
                                  AsyncSnapshot<QuerySnapshot> snapshot) {
                                if (snapshot.hasData) {
                                  if (snapshot.data!.docs.isNotEmpty) {
                                    final QuerySnapshot querySnapshot =
                                        snapshot.data!;
                                    final DocumentSnapshot documentSnapshot =
                                        querySnapshot.docs[0];
                                    String? teamLast = '';
                                    return Column(children: <Widget>[
                                      ListView.builder(
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          itemCount: querySnapshot.docs.length,
                                          shrinkWrap: true,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            String? uid;
                                            final DocumentSnapshot snapshot =
                                                querySnapshot.docs[index];
                                            uid = snapshot.get('uid');
                                            bool? isCheck = true;
                                            if (model.uid_check[uid!] != null) {
                                              isCheck = model.uid_check[uid];
                                            }
                                            String? team = '';
                                            if (snapshot.get('team') != null) {
                                              if (snapshot.get('team') is int) {
                                                team = snapshot
                                                    .get('team')
                                                    .toString();
=======
                                                                              )))),
                                                                ));
                                                          } else {
                                                            return Container();
                                                          }
                                                        })
                                                  ],
                                                )
                                              : Container()
                                          : Container(),
                                    ]);
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
                                stream: FirebaseFirestore.instance
                                    .collection('activity_personal')
                                    .where('group', isEqualTo: model.group)
                                    .where('activity', isEqualTo: documentID)
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
                                      DocumentSnapshot documentSnapshot =
                                          querySnapshot.docs[0];
                                      String team_last = '';
                                      return Column(children: <Widget>[
                                        ListView.builder(
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            itemCount:
                                                querySnapshot.docs.length,
                                            shrinkWrap: true,
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              String uid;
                                              DocumentSnapshot snapshot =
                                                  querySnapshot.docs[index];
                                              uid = snapshot.data()['uid'];
                                              bool isCheck = true;
                                              if (model.uid_check[uid] !=
                                                  null) {
                                                isCheck = model.uid_check[uid];
                                              }
                                              String team = '';
                                              if (snapshot.data()['team'] !=
                                                  null) {
                                                if (snapshot.data()['team']
                                                    is int) {
                                                  team = snapshot
                                                      .data()['team']
                                                      .toString();
                                                } else {
                                                  team =
                                                      snapshot.data()['team'];
                                                }
>>>>>>> develop
                                              } else {
                                                team = snapshot.get('team');
                                              }
<<<<<<< HEAD
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
                                            if (snapshot.get('absent')) {
                                              absence = '出席';
                                            } else {
                                              absence = '欠席';
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
                                            return Column(children: <Widget>[
                                              if (isFirst && team != '')
=======
                                              bool isFirst;
                                              String absence;
                                              if (team_last != team) {
                                                isFirst = true;
                                                team_last = team;
                                              } else {
                                                isFirst = false;
                                              }
                                              if (snapshot.data()['absent']) {
                                                absence = '出席';
                                              } else {
                                                absence = '欠席';
                                              }
                                              String age =
                                                  snapshot.data()['age'];
                                              String team_call;
                                              if (age == 'usagi' ||
                                                  age == 'sika' ||
                                                  age == 'kuma') {
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
>>>>>>> develop
                                                Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            10),
                                                    child: Container(
                                                        width: double.infinity,
                                                        child: Text(
                                                          team! + teamCall,
                                                          style:
                                                              const TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 23,
                                                          ),
                                                          textAlign:
                                                              TextAlign.left,
                                                        )))
                                              else
                                                Container(),
                                              Padding(
                                                  padding:
                                                      const EdgeInsets.all(5),
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
                                                              const EdgeInsets
                                                                  .all(10),
                                                          child: Row(
                                                            children: <Widget>[
                                                              Container(
                                                                width: 40,
                                                                height: 40,
                                                                decoration: BoxDecoration(
                                                                    color: theme.getUserColor(
                                                                        snapshot.get(
                                                                            'age')),
                                                                    shape: BoxShape
                                                                        .circle),
                                                                child:
                                                                    const Icon(
                                                                  Icons.person,
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                              ),
                                                              Padding(
                                                                  padding: const EdgeInsets
                                                                          .only(
                                                                      left: 10),
                                                                  child: Text(
                                                                    snapshot.get(
                                                                        'name'),
                                                                    style: const TextStyle(
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        fontSize:
                                                                            25),
                                                                  )),
                                                              const Spacer(),
                                                              Padding(
                                                                  padding: const EdgeInsets
                                                                          .only(
                                                                      left: 10),
                                                                  child: Text(
                                                                    absence,
                                                                    style: const TextStyle(
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        fontSize:
                                                                            17),
                                                                  ))

                                                              /*Padding(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      left: 10),
                                                              child: Text(
                                                                snapshot['team']
                                                                        .toString() +
                                                                    '組',
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        15),
                                                              ))*/
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ))
                                            ]);
                                          })
                                    ]);
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
                                                      .colorScheme
                                                      .secondary,
                                                  size: 35,
                                                ),
                                                const Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 10),
                                                    child: Material(
                                                      type: MaterialType
                                                          .transparency,
                                                      child: Text(
                                                        '出欠の記録はありません',
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.normal,
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
        )),
      ),
    );
  }
}
