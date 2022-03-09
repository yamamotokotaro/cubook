import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cubook/model/task.dart';
import 'package:cubook/model/themeInfo.dart';
import 'package:cubook/userDetail/userDetail_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ListNotCititationed extends StatelessWidget {
  TaskContents task = TaskContents();
  ThemeInfo theme = ThemeInfo();
  String uid;

  ListNotCititationed(String _uid) {
    uid = _uid;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Column(
            children: <Widget>[
              Padding(
                  padding: const EdgeInsets.only(top: 20, bottom: 10),
                  child: Consumer<UserDetailModel>(
                      builder: (BuildContext context, UserDetailModel model, Widget child) {
                    if (model.group == null) {
                      model.getGroup();
                    }
                    if (model.group != null) {
                      print(uid);
                      final DateTime date = DateTime.now();
                      final DateTime newDate =
                          DateTime(date.year, date.month + 1, date.day);
                      return Column(
                        children: <Widget>[
                          StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection('challenge')
                                .where('group', isEqualTo: model.group)
                                .where('uid', isEqualTo: uid)
                                .where('isCitationed', isEqualTo: false)
                                .orderBy('page', descending: false)
                                .orderBy('end')
                                .snapshots(),
                            builder: (BuildContext context,
                                AsyncSnapshot<QuerySnapshot> snapshot) {
                              if (snapshot.hasData) {
                                if (snapshot.data.docs.isNotEmpty) {
                                  final QuerySnapshot querySnapshot = snapshot.data;
                                  return ListView.builder(
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount: querySnapshot.docs.length,
                                      shrinkWrap: true,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        final DocumentSnapshot snapshot =
                                            querySnapshot.docs[index];
                                        final Map taskInfo = task.getPartMap(
                                            'challenge', snapshot.get('page'));
                                        return Padding(
                                          padding: const EdgeInsets.all(5),
                                          child: Container(
                                            child: Card(
                                              child: InkWell(
                                                child: Padding(
                                                  padding: const EdgeInsets.all(0),
                                                  child: Column(
                                                    children: <Widget>[
                                                      Padding(
                                                          padding:
                                                              const EdgeInsets.only(
                                                                  left: 10,
                                                                  top: 10),
                                                          child: Container(
                                                              width: double
                                                                  .infinity,
                                                              child: Text(
                                                                taskInfo[
                                                                        'number'] +
                                                                    ' ' +
                                                                    taskInfo[
                                                                        'title'],
                                                                textAlign:
                                                                    TextAlign
                                                                        .left,
                                                                style: const TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        23),
                                                              ))),
                                                      Padding(
                                                          padding:
                                                              const EdgeInsets.only(
                                                                  left: 10,
                                                                  top: 6),
                                                          child: Container(
                                                              width: double
                                                                  .infinity,
                                                              child: Text(
                                                                DateFormat('yyyy/MM/dd')
                                                                        .format(
                                                                            snapshot.get('end').toDate())
                                                                        .toString() +
                                                                    ' 完修',
                                                                textAlign:
                                                                    TextAlign
                                                                        .left,
                                                                style: const TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        16),
                                                              ))),
                                                      Padding(
                                                          padding:
                                                              const EdgeInsets.only(
                                                                  left: 10,
                                                                  top: 5),
                                                          child: Align(
                                                              alignment: Alignment
                                                                  .centerLeft,
                                                              child: FlatButton(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(0),
                                                                onPressed: () {
                                                                  model.onTapCititation(
                                                                      snapshot
                                                                          .id);
                                                                },
                                                                child: const Text(
                                                                  '表彰済みにする',
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .blue,
                                                                  ),
                                                                ),
                                                              )))
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
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
                                                      EdgeInsets.only(left: 10),
                                                  child: Material(
                                                    type: MaterialType
                                                        .transparency,
                                                    child: Text(
                                                      '表彰待ちはありません',
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
      ),
    );
  }
}
