import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cubook/listAbsent/listAbsent_model.dart';
import 'package:cubook/model/task.dart';
import 'package:cubook/model/themeInfo.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ListExaminationView extends StatelessWidget {
  var task = new TaskContents();
  var theme = new ThemeInfo();
  String uid;

  ListExaminationView(String _uid) {
    uid = _uid;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 600),
          child: Column(
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.only(top: 20, bottom: 10),
                  child: Consumer<ListAbsentModel>(
                      builder: (context, model, child) {
                        model.getGroup();
                        print(uid);
                        if(model.group != null) {
                          return StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection('activity_personal')
                                .where('group', isEqualTo: model.group)
                                .where('uid', isEqualTo: uid)
                                .orderBy('date', descending: true)
                                .snapshots(),
                            builder: (BuildContext context,
                                AsyncSnapshot<QuerySnapshot> snapshot) {
                              if (snapshot.hasData) {
                                if (snapshot.data.docs.length != 0) {
                                  QuerySnapshot querySnapshot = snapshot.data;
                                  return ListView.builder(
                                      physics: const NeverScrollableScrollPhysics(),
                                      itemCount: querySnapshot.docs.length,
                                      shrinkWrap: true,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        String absence;
                                        DocumentSnapshot snapshot =
                                        querySnapshot.docs[index];
                                        if (snapshot.data()['absent']) {
                                          absence = '出席';
                                        } else {
                                          absence = '欠席';
                                        }
                                        return Padding(
                                            padding: EdgeInsets.all(5),
                                            child: Container(
                                              child: Card(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                  BorderRadius.circular(10.0),
                                                ),
                                                child: InkWell(
                                                  onTap: () {
                                                    print(model.position);
                                                    if (model.position ==
                                                        'leader') {
                                                      Navigator.of(context)
                                                          .pushNamed(
                                                          '/detailActivity',
                                                          arguments: snapshot.data()[
                                                          'activity']);
                                                    }
                                                  },
                                                  child: Row(
                                                    children: <Widget>[
                                                      Container(
                                                          decoration: BoxDecoration(
                                                              borderRadius: BorderRadius
                                                                  .only(
                                                                  topLeft: const Radius
                                                                      .circular(
                                                                      10),
                                                                  bottomLeft:
                                                                  const Radius
                                                                      .circular(
                                                                      10)),
                                                              color: Colors
                                                                  .blue[900]),
                                                          height: 100,
                                                          child: ConstrainedBox(
                                                            constraints:
                                                            BoxConstraints(
                                                                minWidth: 76),
                                                            child: Center(
                                                              child: Padding(
                                                                padding:
                                                                EdgeInsets.all(
                                                                    20),
                                                                child: Text(
                                                                  absence,
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                      fontSize: 20,
                                                                      color: Colors
                                                                          .white),
                                                                ),
                                                              ),
                                                            ),
                                                          )),
                                                      Expanded(
                                                          child: Padding(
                                                              padding:
                                                              EdgeInsets.only(
                                                                  left: 0),
                                                              child: Column(
                                                                children: <
                                                                    Widget>[
                                                                  Padding(
                                                                      padding: EdgeInsets
                                                                          .only(
                                                                          left:
                                                                          10,
                                                                          top:
                                                                          10),
                                                                      child: Container(
                                                                          width: double
                                                                              .infinity,
                                                                          child: Text(
                                                                            snapshot.data()[
                                                                            'title'],
                                                                            textAlign:
                                                                            TextAlign
                                                                                .left,
                                                                            style: TextStyle(
                                                                                fontWeight:
                                                                                FontWeight
                                                                                    .bold,
                                                                                fontSize: 23),
                                                                          ))),
                                                                  Padding(
                                                                      padding: EdgeInsets
                                                                          .only(
                                                                          left:
                                                                          10,
                                                                          top:
                                                                          10,
                                                                          bottom:
                                                                          10),
                                                                      child: Container(
                                                                          width: double
                                                                              .infinity,
                                                                          child: Text(
                                                                            DateFormat(
                                                                                'yyyy/MM/dd')
                                                                                .format(
                                                                                snapshot.data()['date']
                                                                                    .toDate())
                                                                                .toString(),
                                                                            textAlign:
                                                                            TextAlign
                                                                                .left,
                                                                            style: TextStyle(
                                                                                fontWeight:
                                                                                FontWeight
                                                                                    .bold,
                                                                                fontSize: 16),
                                                                          ))),
                                                                ],
                                                              )))
                                                    ],
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
                                                    color:
                                                    Theme
                                                        .of(context)
                                                        .accentColor,
                                                    size: 35,
                                                  ),
                                                  Padding(
                                                      padding:
                                                      EdgeInsets.only(left: 10),
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
