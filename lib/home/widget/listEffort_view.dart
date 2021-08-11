import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cubook/home/widget/listEffort_model.dart';
import 'package:cubook/model/arguments.dart';
import 'package:cubook/model/class.dart';
import 'package:cubook/model/themeInfo.dart';
import 'package:cubook/task_detail_scout_confirm/taskDetailScoutConfirm_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class listEffort extends StatelessWidget {
  String group;
  var theme = ThemeInfo();
  var isRelease = const bool.fromEnvironment('dart.vm.product');
  DateTime now = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final DateTime date = DateTime(now.year, now.month, now.day - 28);
    return Column(
      children: <Widget>[
        Center(
            child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: 5, top: 4),
                child: Icon(
                  Icons.assignment,
                  color: Theme.of(context).accentColor,
                  size: 32,
                ),
              ),
              Text(
                'みんなの取り組み',
                style: TextStyle(
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.none),
              ),
            ])),
        Consumer<ListEffortModel>(builder: (context, model, child) {
          model.getSnapshot();
          if (model.group != null) {
            return StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('effort')
                  .where('group', isEqualTo: model.group)
                  .where('time', isGreaterThanOrEqualTo: date)
                  .orderBy('time', descending: true)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasData) {
                  final List<DocumentSnapshot> listSnapshot =
                      snapshot.data.docs;
                  if (listSnapshot.isNotEmpty) {
                    ScrollController _controller;
                    return Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: ListView.builder(
                              itemCount: listSnapshot.length,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              scrollDirection: Axis.vertical,
                              itemBuilder: (BuildContext context, int index) {
                                final DocumentSnapshot documentSnapshot =
                                    listSnapshot[index];
                                final int congrats =
                                    documentSnapshot.get('congrats');
                                final String documentID = documentSnapshot.id;
                                final int page =
                                    documentSnapshot.get('page');
                                final String type =
                                    documentSnapshot.get('type');
                                final String uid =
                                    documentSnapshot.get('uid');
                                Color color;
                                color = theme.getThemeColor(type);
                                return Column(
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Container(
                                        child: Card(
                                          color: color,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                          child: InkWell(
                                            customBorder:
                                                RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                            ),
                                            onTap: () {
                                              if (page != null &&
                                                  model.position == 'leader') {
                                                Navigator.of(context)
                                                    .push<dynamic>(MyPageRoute(
                                                        page:
                                                            showTaskConfirmView(
                                                                page,
                                                                type,
                                                                uid,
                                                                0),
                                                        dismissible: true));
                                              }
                                            },
                                            child: Column(
                                              children: <Widget>[
                                                Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 15,
                                                              left: 11,
                                                              right: 10),
                                                      child: Row(
                                                        children: <Widget>[
                                                          Icon(
                                                            Icons.person,
                                                            color: Colors.white,
                                                            size: 28,
                                                          ),
                                                          Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    left: 5,
                                                                    bottom: 3),
                                                            child: Text(
                                                              documentSnapshot
                                                                          .get(
                                                                      'family') +
                                                                  documentSnapshot
                                                                          .get(
                                                                      'first') +
                                                                  documentSnapshot
                                                                          .get(
                                                                      'call'),
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize:
                                                                      18.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  decoration:
                                                                      TextDecoration
                                                                          .none),
                                                            ),
                                                          ),
                                                          Spacer(),
                                                          Text(
                                                            DateFormat('MM/dd')
                                                                .format(documentSnapshot
                                                                    .get(
                                                                        'time')
                                                                    .toDate())
                                                                .toString(),
                                                            style: const TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 15.5,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                decoration:
                                                                    TextDecoration
                                                                        .none),
                                                          )
                                                        ],
                                                      )),
                                                ),
                                                Padding(
                                                  padding:
                                                      EdgeInsets.only(top: 5),
                                                  child: Align(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 10,
                                                              left: 10,
                                                              right: 10),
                                                      child: Text(
                                                        documentSnapshot
                                                            .get('body'),
                                                        textAlign:
                                                            TextAlign.left,
                                                        style: const TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 20.0,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            decoration:
                                                                TextDecoration
                                                                    .none),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                    padding: const EdgeInsets.only(
                                                        top: 5, bottom: 2),
                                                    child: Row(
                                                      children: <Widget>[
                                                        FlatButton.icon(
                                                            onPressed: () {
                                                              increaseCount(
                                                                  documentID);
                                                            },
                                                            icon: const Icon(
                                                              Icons
                                                                  .favorite_border,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                            label: Semantics(
                                                              hint:
                                                                  'ボタンを押すとカウントが増えます',
                                                              child: Text(
                                                                'おめでとう！' +
                                                                    congrats
                                                                        .toString(),
                                                                style: const TextStyle(
                                                                    color: Colors
                                                                        .white),
                                                              ),
                                                            )),
                                                        Spacer(),
                                                        model.position ==
                                                                'leader'
                                                            ? Semantics(
                                                                label:
                                                                    '投稿の削除を行います',
                                                                child:
                                                                    IconButton(
                                                                  onPressed:
                                                                      () async {
                                                                    final result =
                                                                        await showModalBottomSheet<
                                                                            int>(
                                                                      context:
                                                                          context,
                                                                      builder:
                                                                          (BuildContext
                                                                              context) {
                                                                        return Padding(
                                                                            padding:
                                                                                EdgeInsets.only(top: 10, bottom: 10),
                                                                            child: Column(
                                                                              mainAxisSize: MainAxisSize.min,
                                                                              children: <Widget>[
                                                                                ListTile(
                                                                                  leading: Icon(Icons.delete),
                                                                                  title: Text('投稿を削除する'),
                                                                                  onTap: () {
                                                                                    model.deleteEffort(documentID);
                                                                                    Navigator.pop(context);
                                                                                  },
                                                                                ),
                                                                              ],
                                                                            ));
                                                                      },
                                                                    );
                                                                  },
                                                                  icon: Icon(
                                                                    Icons
                                                                        .more_vert,
                                                                    color: Colors
                                                                        .white,
                                                                    size: 21,
                                                                  ),
                                                                ))
                                                            : Container()
                                                      ],
                                                    ))
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                );
                              }),
                        );
                  } else {
                    return Padding(
                      padding: EdgeInsets.only(top: 5, left: 10, right: 10),
                      child: Container(
                          child: InkWell(
                        onTap: () {},
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(
                                  Icons.bubble_chart,
                                  color: Theme.of(context).accentColor,
                                  size: 35,
                                ),
                                Padding(
                                    padding: EdgeInsets.only(left: 10),
                                    child: Material(
                                      type: MaterialType.transparency,
                                      child: Text(
                                        '4週間以内にありません',
                                        style: TextStyle(
                                          fontWeight: FontWeight.normal,
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
            );
          } else {
            return const Center(
              child: Padding(
                  padding: EdgeInsets.all(5),
                  child: CircularProgressIndicator()),
            );
          }
        }),
      ],
    );
  }

  void increaseCount(String documentID) async {
    FirebaseFirestore.instance
        .collection('effort')
        .doc(documentID)
        .update(<String, dynamic>{'congrats': FieldValue.increment(1)});
  }
}
